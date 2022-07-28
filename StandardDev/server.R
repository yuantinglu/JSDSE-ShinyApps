library(shiny)
library(shinyalert)
library(DT)


shinyServer(function(input, output, session) {
  
  
  #################################
  # "Submit" button actions
  #################################
  observeEvent(input$submit, {
    
    a <- data.frame(input$temp, input$rate, input$hours)
    if (anyNA(a)) {
    shinyalert(title = "Please fill all cells", 
               type = "error")}
    else {
      write.table(a, 'report.csv', append = T, row.names = FALSE, quote = FALSE, sep = ',', 
                col.names = FALSE)
      shinyalert(title = "Your data has been submitted.", 
                 type = "success")
      updateNumericInput(session, "temp", "Body temperature:", value = NA)
      updateNumericInput(session, "rate", "Heart rate:", value = NA)
      updateNumericInput(session, "hours", "Semester credit hours:", value = NA)
    }
      
  })
  
  
  #################################
  # "Report" button actions
  #################################
  userdata <- eventReactive(input$report, {
    x <- read.csv('report.csv' ,strip.white = TRUE, header = TRUE)
    x <- na.omit(x)
    return(x)
  })
  
  
  #################################
  # Text display of survey results
  #################################
  output$text <- renderText({
    out <- paste0("<ul>", 
                  "<li><strong>Body temperature:</strong> ", 
                  paste(userdata()[, 1], collapse = ", "), "</li>",
                  "<li><strong>Heart rates</strong>: ", 
                  paste(userdata()[, 2], collapse = ", "), "</li>",
                  "<li><strong>Credit hours</strong>: ", 
                  paste(userdata()[, 3], collapse = ", "), "</li>",
                  "</ul>")
    out
  })
  
  
  #################################
  # Visualization of survey results
  #################################
  output$graph <- renderPlot({
    if (nrow(userdata()) > 0) {
      boxplot(userdata(), 
              at = c(1, 3, 5), names = c("Body\nTemp", "Heart\nRates", "Credit\nHours"), 
              las = 2, horizontal = TRUE, xaxt = 'n')
      axis(1, las = 1)
    } else {
      plot.new()
    }
    title(main = "Class Survey Results")
  })
  
  
  #################################
  # "Reset" button actions
  #################################
  observeEvent(input$reset, {
    msg_new_game <- HTML("This will erase the current class report. Type the admin code to proceed.")
    shinyalert(
      msg_new_game, type = "input", html = TRUE,
      callbackR = function(x) { if(x == 'JSDSE') {
          close( file( 'report.csv', open="w" ) )
          write.table(data.frame(BodyTemp = NA, HeartRate = NA, CreditHours = NA),
                      'report.csv', row.names = F, quote = F, sep = ',')}
        })
    })
  
})
