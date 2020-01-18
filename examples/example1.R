##################################################
## Project: CUAHSI Shiny Examples
## Script purpose: Show local data access
## Date: 2020-01-17
## Author: Mike Johnson
##################################################

library(shiny)
library(ggplot2)
library(dplyr)
source("../wheres_the_flood/R/app_support_functions.R")

t = Sys.time()

history = extract_retro(comid = 101,
                        archive = '/Volumes/GIS_Johnson/nwm_thredds_retro/')
vals = history %>%
  group_by(year, month, day) %>%
  summarise(flow = max(flow)) %>%
  ungroup() %>%
  mutate(date = as.Date(paste(year, month, day, sep = "-")))

ui <- fluidPage(plotOutput('plot'))

server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(data = vals, aes(x = date, y = flow)) +
      geom_line() +
      labs(title = paste0(
        "From local archive:\n",
        nrow(history),
        " values read in: ",
        round(Sys.time() - t, 2),
        ' seconds'
      )) +
      theme_classic()
  })
}

shinyApp(ui, server)
