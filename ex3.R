# Third example!! 
library(shiny)
library(shinydashboard)
library(tidyverse)

#create ui
ui <- dashboardPage(
  dashboardHeader(title="STAR WARS"),
  dashboardSidebar(
     sidebarMenu(
       menuItem("H0mew0rld", tabName="homes", icon=icon("jedi")),
       menuItem("Spec!es", tabName="species", icon=icon("pastafarianism"))
     )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName="homes",
        fluidRow(
          box(title="Homeworld Graph",
              selectInput("sw_species", "Choose species", choices=c(unique(starwars$species)))), #use unique() because starwars$species is a character, not a factor with levels
          box(plotOutput(outputId = "sw_plot"))
        )
      )
    )
  )
)

#create server
server <- function(input, output){
  
  species_df <- reactive({
    starwars %>% 
      filter(species == input$sw_species)
  })
  
  output$sw_plot <- renderPlot({
    ggplot(data=species_df(), aes(x=homeworld)) +
      geom_bar() +
      coord_flip()
  })
  
}

shinyApp(ui=ui, server=server)