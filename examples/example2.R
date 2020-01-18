##################################################
## Project: CUAHSI Shiny Examples
## Script purpose: Show remote data access (from USGS THREDDS)
## Date: 2020-01-17
## Author: Mike Johnson
##################################################

library(shiny)
library(ggplot2)
library(RNetCDF)
source("../wheres_the_flood/R/app_support_functions.R")

t = Sys.time()

# Have to hide web address from public

paste0(web_address,'nwm_retro.nc?streamflow[0:1:219143][1:1:1]' %>%
  RNetCDF::open.nc() %>% 
  RNetCDF::var.get.nc("streamflow") -> out

df = data.frame(index = 1:length(out), out = out)

ui <- fluidPage( plotOutput('plot'))

server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(data = df, aes(x = index, y = out)) + 
      geom_line() + 
      labs(title = paste0("From the Web:\n", length(out), " values read in: ", round(Sys.time() - t, 2), ' seconds')) +
      theme_classic()
  })
}

shinyApp(ui, server)
