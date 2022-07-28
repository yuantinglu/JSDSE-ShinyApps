library(shiny)
library(DT)

server <- function(input, output){
  
  ###########################################
  ## Question 14 (Numeric variable)
  ###########################################
  
  # Set the mean for numerical data
  mu <- reactive({
    if (is.na(input$id)){
      return(NULL)
    }else{
      mu <- 12
      return(mu)
    }})
  
  
  # Creating numerical data
  numData <- reactive({
    
    if (is.na(input$id)){
      userdata <- data.frame(Can=NA, Volume=NA, Notes=NA)
      return(userdata)
    }else{
      set.seed(input$id) # Plant the random number seed
      n <- 60
      
      A_one <- 1:n                   # First column data
      A_two <- rnorm(n, mu(), 0.05)  # Second column data
      A_three <- A_one %% 2          # Third column data (only used for coloring rows)
      
      userdata <- data.frame(A_one, A_two, A_three)
      colnames(userdata) <- c('Can', 'Volume', 'Notes')
      return(userdata)
    }
  }) # end reactive
  
  
  # Download button action
  output$downloadnum <- downloadHandler(
    filename = function() {
      paste('Num', input$id, '.csv', sep='')
    },
    content = function(file) {
      write.csv(data.frame(numData()[,1:2]), file, row.names = FALSE)
    }
  )
  
  
  # Output: Sample data table ----
  output$numTable <- DT::renderDT({
    datatable(numData(), rownames = FALSE, options = list(
      pageLength = 100,
      dom = "t",
      columnDefs = list(list(className ='dt-center', targets = 0:1), 
                        list(visible=FALSE, targets=2))))%>%
      formatStyle("Notes", backgroundColor=styleEqual(c(1,0),c('white','lightgray')), target = "row")%>%
      formatRound(columns=c('Volume'), digits=2)
  },striped = TRUE,colnames = TRUE)
  
  
  # Output results ----
  output$textblocknum <- renderText({
    out <- paste("<ul>",
                 "<li>Five number summary</li>"
    )
    if(!is.na(input$id)){
      out <- paste(out, "<li>",
                   sprintf('%.2f, %.2f, %.2f, %.2f, %.2f', 
                           quantile(numData()$Volume, 0),
                           quantile(numData()$Volume, 0.25),
                           quantile(numData()$Volume, 0.5),
                           quantile(numData()$Volume, 0.75),
                           quantile(numData()$Volume, 1) ),
                   "</li>", 
                   "<li>Mean:", sprintf('%.3f', mean(numData()$Volume) ), "</li>",
                   "<li>Sd:", sprintf('%.3f', sd(numData()$Volume) ), "</li>",
                   "<li>Test statistic:", sprintf('%.3f', (mean(numData()$Volume) - mu()) / sd(numData()$Volume) * sqrt(max(numData()$Can)) ), "</li>",
                   "<li>P-value (two-sided):", sprintf('%.3f', t.test(numData()$Volume, mu=mu())$p.value, alternative = "two.sided"), "</li>"
      )}
    
    out <- paste(out, "</ul>")
    out
  })
  
  
  ###########################################
  ## Question 18 (Categorical variable)
  ###########################################
  
  # Creating categorical data
  catData <- reactive({
    if (is.na(input$id)){
      userdata <- data.frame(CancerSample=NA, Detection=NA)
      return(userdata)
    }else{
      set.seed(input$id) # Plant the random number seed
      n <- sample(60:70, 1)
      
      A_one <- 1:n
      group_one <- rep(c('Correct'), times = 80)
      group_two <- rep(c('Incorrect'), times = 20)
      population <- c(group_one, group_two)  
      A_two <- sample(population, n, replace = TRUE)
      
      userdata <- data.frame(A_one, A_two)
      names(userdata) <- c('CancerSample', 'Detection')
      return(userdata)
    }
  }) # end reactive
  
  # Hypothesis test calculation
  catCalc <- reactive({
    userdata <- catData()
    A <- userdata$Detection
    A <- as.data.frame(table(A))
    names(A) <- c('Detection', 'freq')
    x <- with(A[which(A$Detection == 'Correct'),], freq)
    n <- length(userdata$Detection)
    report <- prop.test(x, n, p = 0.7, alternative = "greater", correct = FALSE)
    return(c(x,n, sqrt(report$statistic), report$p.value))
  })
  
  
  # Download button action
  output$downloadcat <- downloadHandler(
    filename = function() {
      paste('Cat', input$id, '.csv', sep='')
    },
    content = function(file) {
      write.csv(data.frame(catData()), file, row.names = FALSE)
    }
  )
  
  
  # Output: Sample data table ----
  output$catTable <- DT::renderDT({
    datatable(catData(), rownames = FALSE, options = list(
      pageLength = 200,
      dom = "t",
      autoWidth = TRUE,
      columnDefs = list(list(className = 'dt-center', targets = 0:1))))%>%
      formatStyle("Detection", backgroundColor=styleEqual(c("Correct","Incorrect"),c('orange','gray')))
  },striped = TRUE,colnames = TRUE)
  

  # Output results ----
  output$textblockcat <- renderText({
    out <- paste("<ul>",
                 "<li>Each row represents one detection.</li>",
                 "<li>The second column shows the detection results.</li>",
                 "<li><q>Correct</q> means a medical detection dog accurately identified the cancer urine sample.</li>",
                 "<li><q>Incorrect</q> means a medical detection dog failed to identify the cancer urine sample.</li>"
                 )
    if( !is.na(input$id) ){
      out <- paste(out,
         "<li>", sprintf('%.0f / %.0f = %.3f', 
                         catCalc()[1], 
                         catCalc()[2], 
                         catCalc()[1]/catCalc()[2]), "</li>",
         "<li>Test statistic", sprintf('%.3f', catCalc()[3]), "</li>",
         "<li>P-value: ", sprintf('%.5f', catCalc()[4]), "</li>"
      )
    }
    out <- paste(out, "</ul>")
  })
  
  
} #end server
