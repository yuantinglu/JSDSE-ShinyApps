library(shiny)
library(shinyalert)
library(DT)


shinyServer(function(input, output, session) {
  
  ############################
  ## "Submit" button action
  ############################
  observeEvent(input$submit, {
    
    # Initialize the score variable
    score <- 0 
    
    # Set up the answer keys
    key <- c("F", "T", "F", "F", "F", 
             "T", "F", "T", "T", "T")
    
    # Add up scores
    if (input$q1 == key[1]) {score <- score + 1}
    if (input$q2 == key[2]) {score <- score + 1}
    if (input$q3 == key[3]) {score <- score + 1}
    if (input$q4 == key[4]) {score <- score + 1}
    if (input$q5 == key[5]) {score <- score + 1}
    if (input$q6 == key[6]) {score <- score + 1}
    if (input$q7 == key[7]) {score <- score + 1}
    if (input$q8 == key[8]) {score <- score + 1}
    if (input$q9 == key[9]) {score <- score + 1}
    if (input$q10 == key[10]) {score <- score + 1}
    
    # Prevent incomplete submissions
    if (input$q1 == '' | input$q2 == '' | input$q3 == '' | input$q4 == ''| input$q5 == '' 
        | input$q6 == '' | input$q7 == '' | input$q8 == '' | input$q9 == '' | input$q10 == ''){
        shinyalert(title = "Please complete all questions before submission.")  
    }
    else {
      
        # Record scores for a successful submission
        write.table(score, 'report.csv', append = TRUE,
                col.names = FALSE, row.names = FALSE,
                quote = FALSE, sep = "")
    
        # Display the score to the user
        shinyalert(title = paste('Wow, you scored ', score, "!"), type = "success")
        
        # Clear the submitted answers
        for (i in 1:10) {
          id <- paste0("q", i)
          tag <- paste0("Question ", i)
          updateSelectInput(session, id, tag, c('Select T/F' = "", 'True' = "T", 'False' = "F"))
        } # End of for-loop
      } # End of else
  }) # End of observeEvent
  
  
  #################################
  ## "Class Report" button action
  #################################
  # Fetch the data from report.csv when the Class Report button is clicked
  userdata <- eventReactive(input$graph, {
    x <- read.csv('report.csv' ,strip.white = TRUE, header = TRUE)
    x <- na.omit(x$Quiz)
    return(x)
  })
  
  
  ####################################################
  ## Distribution of grades
  ## Plot a dot plot if max frequency is no more than 10
  ## Plot a barplot if max frequency is larger than 10
  ####################################################
  output$graph <- renderPlot({
    scores <- table(userdata())
    if (max(scores) <= 10) {
      stripchart(scores, method = "stack", offset = .5, at = .15, pch = 20, 
               xlim = c(0,10), xlab = "Grades", cex.lab = 1.5, axes = FALSE,
               family = "mono")
      axis(side = 1, at = 0:10)
    }else if (max(scores) > 10){
      par(mar = c(5, 4, 2, 4))
      pic <- barplot(scores / sum(scores), family = "mono", col = '#DDEAF6',
                     xlab = 'Grades', ylab = 'Relative Frequence',
                     cex.lab = 1.5,
                     yaxt = 'n', ylim = c(0, 0.5))
      axis(side = 2, las = 2, mgp = c(3, 0.75, 0), family = "mono")
      par(new = T)
      barplot(scores, family = "mono", col = '#DDEAF6',
              yaxt = 'n', ylim = c(0, 0.5 * sum(scores)))
      axis(side = 4, las = 2, mgp = c(3,0.75, 0), family = "mono", at = scores, cex.axis = 0.8)
      mtext("Frequency", side = 4, line = 2.5, las = 3, family = "mono", cex = 1.5)
    }
    else {
      plot.new()
    }
    title(main = "Distibution of Quiz Grades", cex.main = 2, family = "mono")
  })
  
  
  #################################
  ## "Reset" button action
  #################################
  # Clear the data in the report.csv file.
  observeEvent(input$reset, {
    msg_new_game <- HTML("This will erase the current class report. Type the admin code to proceed.")
    shinyalert(
      msg_new_game, type = "input", html = TRUE,
      callbackR = function(x) { if(x == 'JSDSE') {
          close( file( 'report.csv', open="w" ) )
          write.table("", 'report.csv', row.names = FALSE, col.names = 'Quiz', 
                quote = FALSE, sep = ",")}
        })
    })
  
})
