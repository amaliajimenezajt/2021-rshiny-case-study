library(shiny)
library(gapminder)
library(tidyverse)
library(magrittr)

gapminder %<>% mutate_at("year", as.factor) # mutate a year as a factor, and put the result in the gapminder

gapminder_years = gapminder %>% select(year) %>% unique %>% arrange

dataPanel <- tabPanel("Data",
                      selectInput(
                        inputId = "selYear",
                        label = "Select the Year",
                        multiple = TRUE,
                        choices = gapminder_years,
                        selected="1952"),
                      # verbatimTextOutput("info"),
                      tableOutput("data")
)

plotPanel <- tabPanel("Plot",
                      plotOutput("plot")
)
# Define UI for application that draws a histogram
ui <- navbarPage("shiny App",
                 dataPanel,
                 plotPanel
)
# Define server logic required to draw a histogram
server <- function(input, output) { 
  gapminder_year <- reactive({gapminder %>% filter(year %in% input$selYear)}) # this is a function (reactive)
   output$data <- renderTable(gapminder_year())
   output$info <- renderPrint(toString(gapminder_years))
   output$plot <- renderPlot(
     ggplot(data=head(gapminder_year()), aes(x=country, y=pop, fill=year))
     + geom_bar(stat="identity", position=position_dodge())
     )
}
# Run the application 
shinyApp(ui = ui, server = server)