# Second example!!
library(shiny)
library(tidyverse)
library(shinythemes)

ui <- navbarPage("Amelia's navigation bar", #create page with navigation bar on top
                 theme = shinytheme("cyborg"),
                 tabPanel("First tab is the best tab",
                          h1("some GIANT header"),
                          p("here's some regular text"),
                          plotOutput(outputId="diamond_plot")),
                 tabPanel("Second tab is the second tab",
                          sidebarLayout(
                            sidebarPanel("some text is here",
                                         checkboxGroupInput(inputId="diamondclarity",
                                                            label="choose some!",
                                                            choices=unique(diamonds$clarity))), #c(levels(diamonds$clarity)) also works
                            mainPanel("some more text is here",
                                      plotOutput(outputId="diamond_plot2"))
                          )))

server <- function(input, output){
  
  output$diamond_plot <- renderPlot({
    ggplot(data=diamonds, aes(x=carat, y=price)) +
      geom_point(aes(color=clarity))
  })
  
  diamond_clarity <- reactive({ #create reactive data frame
    diamonds %>% 
      filter(clarity %in% input$diamondclarity) #only rows that match clarity column for user selections in diamondclarity widget
  })
  
  output$diamond_plot2 <- renderPlot({
    ggplot(data=diamond_clarity(), aes(x=clarity, y=price)) +
      geom_violin(aes(fill=clarity))
  })
}

shinyApp(ui=ui, server=server)