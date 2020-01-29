# My first app example!
# Amelia

library(shiny)
library(tidyverse)

# Read in data
penguins <- read_csv("penguins.csv")

# Create ui ("user interface")
ui <- fluidPage( #fluidPage allows you to open in a browser of varying sizes
  titlePanel("this is a title"),
  sidebarLayout(
    sidebarPanel("widgets go here!", 
                 radioButtons(inputId = "species",
                              label = "pick a species:",
                              choices = c("Adelie", "Gentoo", "Awesome Chinstrap pengoons"="Chinstrap")), #format choices in same exact format as they show up in sp_short column, add = if you want to change what it looks like to user versus R
                 selectInput(inputId = "pt_color", 
                             label = "pick a point color",
                             choices = c("favorite RED!!"="red", "pretty purple!"="purple", "ORAAAANGE!!!"="orange"))),
    mainPanel("graph goes here!",
              plotOutput(outputId = "penguin_plot"))
  )
)

# Create server
server <- function(input,output) {
  #create a reactive ({}) data frame
  penguin_select <- reactive({
    penguins %>% 
      filter(sp_short==input$species) #where selection in species widget matches sp_short column entry
  })
  
  #create a reactive ({}) output using a reactive data frame()
  output$penguin_plot <- renderPlot({
    ggplot(data=penguin_select(), aes(x=flipper_length_mm, y=body_mass_g)) +
      geom_point(color=input$pt_color)
  })
}

# Let R know you want to combine ui and server into an app
shinyApp(ui=ui, server=server)