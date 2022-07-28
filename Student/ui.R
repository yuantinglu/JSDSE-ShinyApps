library(shiny)
library(DT)


ui <- fluidPage(
  

  ## Optional
  ## HTML codes for app appearance
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
  
  
  # App title 
  titlePanel(title="Final Exam Data Generator (Spring 2020)"),
  
  
  # Sidebar layout 
  sidebarLayout(
    
    # Sidebar objects
    sidebarPanel(
      
      numericInput(inputId = "id",
                   "Enter your Student ID", 
                   value=NULL),  
      
      # Download
      downloadButton(outputId = "downloadnum", label = "Download Question 14 Data", class = NULL, width = '155px'),
      
      # Download
      downloadButton(outputId = "downloadcat", label = "Download Question 18 Data", class = NULL, width = '155px'),
      
      # Sidebar width can not exceed 12, default 4.
      width = 4
      
    ), # end of sidebar panel
    
    
    # Main panel----
    mainPanel(
      
      tabsetPanel(
        
        tabPanel("Question 14", 
                 fluidRow(column(12, htmlOutput("textblocknum"))),
                 fluidRow(column(12, DT::dataTableOutput("numTable"))
                 )),
        
        tabPanel("Question 18",
                 fluidRow(column(12, htmlOutput("textblockcat"))),
                 fluidRow(column(12, DT::dataTableOutput("catTable"))
                 )
        ))
      
    ) #end of mainPanel
    
  ) #end of sidebarlayout
  
) #end of fluidpage
