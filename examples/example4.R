##################################################
## Project: CUAHSI Shiny Examples
## Script purpose: Show remote data access 
## (from personal HydroShare resource)
## Date: 2020-01-17
## Author: Mike Johnson
##################################################

library(shiny)
library(ggplot2)
library(RNetCDF)


t = Sys.time()

resource_id = '49a53c2f0606458e90b0e219232fa424'

paste0('http://hyrax.hydroshare.org:80/opendap/',
resource_id,
'/data/contents/nwm_retro_182.nc?streamflow[1:1:1][0:1:219143]') %>%
  RNetCDF::open.nc() %>% 
  RNetCDF::var.get.nc("streamflow") -> out

df = data.frame(index = 1:(length(out)), 
                out = out) 

ui <- fluidPage( plotOutput('plot') )

server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(data = df, aes(x = index, y = out)) + 
      geom_line() + 
      labs(title = paste0("From Hydroshare personal resource:\n", length(out), " values read in: ", round(Sys.time() - t, 2), ' seconds')) +
      theme_classic()
  })
}

shinyApp(ui, server)

