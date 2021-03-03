library(shiny)
library(gapminder)
library(tidyverse)

dataPanel <- tabPanel("Data",
                      selectInput(
                        inputId = "selYear",
                        label = "Select the Year",
                        multiple = TRUE,
                        choices = gapminder %>% select(year) %>% unique #eliminate the repetition
                        %>% arrange,
                        selected = gapminder %>% select(year) %>% head(1)
                      ),
                      tableOutput("data")
)

# Define UI for application that draws a histogram
ui <- navbarPage("shiny App",
                 dataPanel
)
# Define server logic required to draw a histogram
server <- function(input, output) { 
  output$data <- renderTable(gapminder %>% filter(year %in% input$selYear))
  }
# Run the application 
shinyApp(ui = ui, server = server)