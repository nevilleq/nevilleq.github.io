#Libraries
library(shiny)
library(tidyverse)
library(plotly)

#Source data
source("./src/data_read.R")

server <- function(input, output) {

  #Reactive data filter based on ui input
  dataFilter <- reactive({
  #Filter the original data and return as reactive output below
  nyc.df %>%
    filter(
      price > input[["price"]][1],
      price < input[["price"]][2],
      room_type %in% input[["room"]],
      borough %in% input[["borough"]], 
    )
  })
  
  
  #Price geospatial scatterplot
  #Store the plotly as an element in the output list
  output[["price_plotly"]] <- renderPlotly({
  dataFilter() %>% #Reactive function to call filtered data 
    plot_ly(
      x      = ~lat, 
      y      = ~long,
      type   = "scatter",
      mode   = "markers",
      color  = ~price, 
      alpha  = 0.5, #Color pallete
      colors = viridis::viridis_pal(option = "C")(4),
      text   = ~text_label,
      hoverinfo = "text", #Hover label
      marker = list(size = 10)
    ) %>%
    layout(
      title  = "Spatial Scatterplot of Airbnbs by Price",
      xaxis  = list(title = "", showticklabels = FALSE),
      yaxis  = list(title = "", showticklabels = FALSE),
      legend = list(title = "Price") #Not working?
    )
})
    
  #Do the same for distribution of price by neighborhood
  output[["price_dist_plotly"]] <- renderPlotly({
  #Store to grab unique neighborhoos for pallete
  nyc.df  <- dataFilter()
  n_hoods <- nyc.df$neighbourhood %>% unique() %>% length() 
  
  #Render plotly
  nyc.df %>%
  mutate(
    neighbourhood = fct_reorder(neighbourhood, price, median, .desc = FALSE)
  ) %>%
  plot_ly(
    y      = ~price,
    color  = ~neighbourhood,
    type   = "box",
    colors = viridis::viridis_pal(option = "C")(n_hoods) 
  ) %>%
  layout(
    title  = "Distribution of Airbnb Price by Neighbourhood",
    xaxis  = list(title = "Price")
  )
})

  #Do the same for number of reviews by neighborhood
  output[["reviews_plotly"]] <- renderPlotly({
  #Call reactive filtered data
  nyc.df  <- dataFilter()
  n_hoods <- nyc.df$neighbourhood %>% unique() %>% length()
  
  #Render plot
  nyc.df %>%
  group_by(neighbourhood) %>%
  summarise(
    N = n()
  ) %>%
  mutate(
    neighbourhood = fct_reorder(neighbourhood, N, .desc = FALSE)
  ) %>%
  plot_ly(
    y = ~neighbourhood,
    x = ~N,
    color  = ~neighbourhood,
    type   = "bar",
    colors = viridis::viridis_pal(option = "C")(n_hoods) 
  ) %>%
  layout(
    title  = "Number of Listings by Neighbourhood",
    xaxis  = list(title = "Neighbourhood"),
    yaxis  = list(title = "Number of Listings")
  )
})
  
  
}