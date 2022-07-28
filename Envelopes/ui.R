library(shiny)
library(DT)
library(shinyalert)
library(sortable)

shinyUI(fluidPage(
  
  #################################
  ## Optional
  ## HTML codes for app appearance
  #################################
  tags$head(
    tags$style(HTML("
                    * {
                    font-family: Palatino,garamond,serif;
                    font-weight: 500;
                    line-height: 1.2;
                    }
                    
                    .rank-list-container.custom-sortable-1 {
                      background-color: white;
                      border-radius: 0px;
                      border-color: white;
                      margin-right: 0px;
                      padding-right: 0px;
                    }
                    
                    .rank-list-container.custom-sortable-2 {
                      background-color: white;
                      border-radius: 0px;
                      border-color: white;
                      margin-left: 0px;
                      padding-left: 0px;
                    }
                    
                    .custom-sortable-1 .rank-list-item {
                      text-align: center;
                      color: white;
                      font-weight: bold;
                      pointer-events: none;
                      background-color: #448aff;
                    }
                      
                    .custom-sortable-2 .rank-list-item {
                      border-radius: 2px;
                      border-left-width: 7px;
                      border-left-color: #448aff;
                      text-align: center;
                    }
                    
                    "))
  ), 

  #################################
  # Application title
  #################################
  titlePanel("Match Letters with Envelopes"),
  
  hr(), # A blank line
  
  #################################
  ## Instructions
  #################################
  HTML('<ul><li>Seven letters are to be put into seven envelopes. 
  The n-th row represents the n-th envelope.</li>
  <li>Each letter has a unique envelope that matches with it.</li>
  <li>Vertically drag and drop the letters to shuffle them.</li>
  <li>Click the submit button to compare your rearrangement to an answer key,<br> 
  so that you know how many letter(s) have been correctly enveloped.</li> 
  <li>Each new round has a new answer key.</li></ul>'),
  
  
  fluidRow(
    
    ##########################################
    ## A rank list to show envelope labels
    ## Sorting was disabled for this rank list
    ##########################################
    column(2, offset = 0, style='padding:0px;',
           rank_list(
             text = "",
             labels = c("Envelope 1:",
                        "Envelope 2:",
                        "Envelope 3:",
                        "Envelope 4:",
                        "Envelope 5:",
                        "Envelope 6:",
                        "Envelope 7:"),
             input_id = "rank_list_2",
             class = c("default-sortable", "custom-sortable-1"),
             options = sortable_options(sort = FALSE)
           )
    ),
    
    
    ##########################################
    ## A rank list to shuffle letters
    ##########################################
    column(6, offset = 0, style='padding:0px;',
           rank_list(
             text = "",
             labels = c("A good friend asks only for your time not your money.",
                        "Believe in yourself and others will too.",
                        "Competence like yours is underrated.",
                        "Don’t dream. Act.",
                        "Expect much of yourself and little of others.",
                        "Failure is the beginning to do better next time.",
                        "Goodness is the only investment that never fails."),
             input_id = "rank_list_1",
             class = c("default-sortable", "custom-sortable-2")
           )
    ), #end of column
    
    
    ##########################################
    ## Buttons
    ##########################################
    column(2,
           HTML("<p style='margin-bottom:18px;'></p>"),
           useShinyalert(),
           actionButton("submit", "Submit", width = 100),
           HTML("<p style='margin-bottom:5px;'></p>"),
           actionButton("graph", "Class Report", width = 100),
           HTML("<p style='margin-bottom:5px;'></p>"),
           actionButton("reset", "Reset Report", width = 100)
    )#end of column
  ),#end of fluidRow
    
  
  ##########################################
  ## Layout of the graphs
  ##########################################
      hr(), plotOutput("graph1"),
      hr(), plotOutput("graph2"),
      hr(),

    
)#end of fluidpage
)#end of shinyUI
