library(shiny)
library(DT)
library(shinyalert)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Decorative codes in HTML
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
  titlePanel("A Quiz with 10 T/F Questions"),
  
  hr(), 
  
  fluidRow(
    column(2,
      selectInput(inputId = "q1", "Question 1",
                   choices = c("Select T/F" = '',
                               "True" = 'T',
                               "False" = 'F')
      ),
      selectInput(inputId = "q6", "Question 6",
                  choices = c("Select T/F" = '',
                              "True" = 'T',
                              "False" = 'F')
      )
    ), # End of column 1
    
    column(2,
           selectInput(inputId = "q2", "Question 2",
                       choices = c("Select T/F" = '',
                                   "True" = 'T',
                                   "False" = 'F')
           ),
           selectInput(inputId = "q7", "Question 7",
                       choices = c("Select T/F" = '',
                                   "True" = 'T',
                                   "False" = 'F')
           )
    ), # End of column 2
    
    column(2,
           selectInput(inputId = "q3", "Question 3",
                       choices = c("Select T/F" = '',
                                   "True" = 'T',
                                   "False" = 'F')
           ),
           selectInput(inputId = "q8", "Question 8",
                       choices = c("Select T/F" = '',
                                   "True" = 'T',
                                   "False" = 'F')
           )
    ), # End of column 3
    
    column(2,
           selectInput(inputId = "q4", "Question 4",
                       choices = c("Select T/F" = '',
                                   "True" = 'T',
                                   "False" = 'F')
           ),
           selectInput(inputId = "q9", "Question 9",
                       choices = c("Select T/F" = '',
                                   "True" = 'T',
                                   "False" = 'F')
           )
    ), # End of column 4
    
    column(2,
           selectInput(inputId = "q5", "Question 5",
                       choices = c("Select T/F" = '',
                                   "True" = 'T',
                                   "False" = 'F')
           ),
           selectInput(inputId = "q10", "Question 10",
                       choices = c("Select T/F" = '',
                                   "True" = 'T',
                                   "False" = 'F')
           )
    ),# End of column 5
    
    column(2,
           HTML("<p style='margin-bottom:18px;'></p>"),
           useShinyalert(),
           actionButton("submit", "Submit Quiz"),
           HTML("<p style='margin-bottom:5px;'></p>"),
           actionButton("graph", "Class Report"),
           HTML("<p style='margin-bottom:5px;'></p>"),
           actionButton("reset", "Reset Report")
    )# End of column 6
  ),# End of fluidRow
    
      hr(), plotOutput("graph")
    
  )# End of fluidpage
)# End of shinyUI
