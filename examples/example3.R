##################################################
## Project: CUAHSI Shiny Examples
## Script purpose: Show remote data access (raster)
## Date: 2020-01-17
## Author: Mike Johnson
##################################################

library(shiny)
library(raster)
library(sf)
library(climateR)

t = Sys.time()
c = AOI::aoi_get(state = 'nc', county = 'all')
out = getGridMET(AOI = st_as_sf(st_union(c)),
                          param = "prcp",
                          startDate = "2019-10-29")

ui <- fluidPage(plotOutput('plot'))

server <- function(input, output, session) {
  output$plot <- renderPlot({
    plot(
      out$prcp,
      axes = F,
      box = FALSE,
      main = paste0(
        ncell(out$prcp),
        " cells read in: ",
        round(Sys.time() - t, 2),
        ' seconds'
      )
    )
    plot(st_transform(c$geometry, out$prcp@crs), add = T)
  })
}

shinyApp(ui, server)
