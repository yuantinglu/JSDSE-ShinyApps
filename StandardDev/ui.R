library(shiny)
library(DT)
library(shinyalert)

shinyUI(fluidPage(

  # Optional HTML codes for app appearance
  tags$head(
    tags$style(HTML("
                    * {
                    font-family: Palatino,garamond,serif;
                    font-weight: 500;
                    line-height: 1.2;
                    #color: #000000;
                    }
                    "))
  ), 
  
  
  # Application title
  titlePanel("Class Survey"),
  
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      numericInput("temp", "Body temperature:", value = NULL),
      numericInput("rate", "Heart rate:", value = NULL),
      numericInput("hours", "Semester credit hours:", value = NULL),
      
      useShinyalert(),
      actionButton("submit", "Submit"),
      actionButton("report", "Class Report"), hr(),
      actionButton("reset", "Reset")
    ),
  
    
    # Show a plot of the generated distribution
    mainPanel(
      htmlOutput("text"),
      plotOutput("graph")
        )#end of mainPanel
)#end of sidebar layout
)#end of fluidpage
)#end of shinyUI
