#Libraries
library(shiny)
library(plotly)

#Source static variables/data
source("./src/data_read.R")

# Define UI for application that embeds a leaflet & plotly
#for NYC Airbnb prices, ratings, etc.
ui <- fluidPage(

# Application title
titlePanel("NYC Airbnb Prices & Distribution by Neighborhood"),

#Inputs
sliderInput(
  inputId = "price",
  label   = h3("Price Range"),
  min     = price_range[1],
  max     = price_range[2],
  value   = c(100, 500), #starting range
  ticks   = FALSE
),

#Define a radio button for different room choices
radioButtons(
  inputId  = "room",
  label    = h3("Accommodation Type"),
  choices  = room_choices,
  selected = room_choices[2] #Entire home/apt
),

#Define a drop down menu for borough
selectInput(
  inputId  = "borough",
  label    = h3("Select Borough"),
  choices  = boro_choices,
  selected = boro_choices[5] #Manhattan
),

#Main output panel
mainPanel(
  #Draw Price Scatter
  plotlyOutput("price_plotly"),
  
  #Draw Price Distribution
  plotlyOutput("price_dist_plotly"),

  #Draw Reviews Bar
  plotlyOutput("reviews_plotly")

)

)