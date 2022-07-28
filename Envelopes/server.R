library(shiny)
library(shinyalert)
library(DT)
library(sortable)

Sys.setenv(TZ = 'US/Eastern') # Time zone


shinyServer(function(input, output, session) {
  
  ##########################################
  ## "Submit" button actions
  ##########################################
  observeEvent(input$submit, {
    ans <- substr(input$rank_list_1, 1, 1) # User answers
    n <- 7
    key <- LETTERS[sample(n, n, replace = FALSE)]  # Answer keys
    result <- rep(0, n)              # Initiate a score chart
    result[which(key == ans)] <- 1   # Grade submitted answers.
    new <- rbind(c(sum(result), result))
    write.table(new, 'report.csv', append = T,
                col.names = FALSE, row.names = FALSE,
                quote = FALSE, sep = ",")
    shinyalert(html = TRUE, title = paste('Wow, you scored ', new[1], "!\n"), 
                             paste("You answered ", paste(ans, collapse = ""), 
                             "<br>The key was ", paste(key, collapse = '')), type = "success")
  })
  
  
  ##########################################
  ## "Class Report" button actions
  ##########################################
  userdata <- eventReactive(input$graph, {
    x <- read.csv('report.csv' ,strip.white = TRUE, header = TRUE)
    x <- na.omit(x)
    return(x)
  })
  
  
  ####################################################
  ## Distribution of total # of correct matches
  ## Plot a dot plot if max frequency is no more than 15
  ## Plot a barplot if max frequency is larger than 15
  ####################################################
  output$graph1 <- renderPlot({
    tab <- table(userdata()[1])
    if (max(tab) <= 15) {
        stripchart(userdata()[1], method = "stack", offset = .5, at = .15, pch = 20, 
               xlim = c(0,7), xlab = "Scores", cex.lab = 1.5, axes = FALSE,
               family = "mono")
        axis(side = 1, at = 0:7)
        text(5, 1, family = "mono", 
             sprintf('Average: %.2f', tab %*% seq(0, length(tab) - 1) / sum(tab)))
    }else if (max(tab) > 15) {
        par(mar = c(5, 4, 2, 4))
        pic <- barplot(tab / sum(tab), family = "mono", col = '#DDEAF6',
              xlab = 'Number of Correct Matches', ylab = 'Relative Frequence',
              yaxt = 'n', ylim = c(0, 0.5))
        axis(side = 2, las = 2, mgp = c(3, 0.75, 0), family = "mono")
        par(new = T)
        barplot(tab, family = "mono", col = '#DDEAF6',
                       yaxt = 'n', ylim = c(0, 0.5 * sum(tab)))
        axis(side = 4, las = 2, mgp = c(3,0.75, 0), family = "mono", at = tab, cex.axis = 0.8)
        mtext("Frequency", side = 4, line = 2.5, las = 3, family = "mono")
        text(4, max(tab), family = "mono", 
             sprintf('Average: %.2f', tab %*% seq(0, length(tab) - 1) / sum(tab)))
    }else {
      plot.new()
    }
    title(main = HTML("The Distibution of \nthe Number of Correct Matches"), cex.main = 1, family = "mono")
  })
  
  
  ####################################################
  ## Correct matches by envelopes
  ## Plot a dot plot if max frequency is no more than 15
  ## Plot a barplot if max frequency is larger than 15
  ####################################################
  output$graph2 <- renderPlot({
    s <- colSums(userdata()[2:8])
    y <- rep(1:7, s)
    tab.y <- table(y)
    if (max(s) <= 15) {
      stripchart(y, method = 'stack', offset = .5, at = .15, pch = 20, 
                 xlim = c(1,7), xlab = 'Envelopes', cex.lab = 1.5, axes = FALSE,
                 family = "mono")
      axis(side = 1, at = 1:7, family = "mono",
           labels = c('1st', '2nd', '3rd', '4th', '5th', '6th', '7th'))
    }else if (max(s) > 15) {
      par(mar = c(5, 4, 3, 4))
      barplot(tab.y / sum(tab.y), family = "mono", col = '#DDEAF6',
              xlab = 'Envelopes', ylab = 'Relative Frequence',
              yaxt = 'n', ylim = c(0, 0.5), 
              names.arg = c('1st', '2nd', '3rd', '4th', '5th', '6th', '7th'))
      axis(side = 2, las = 2, mgp = c(3, 0.75, 0), family = "mono")
      abline(h = 1/7, lty = 'dashed', lwd = 3, col = '#448aff')
      par(new = T)
      barplot(tab.y, family = "mono", col = '#DDEAF6',
              yaxt = 'n', ylim = c(0, 0.5 * sum(tab.y)), 
              names.arg = c('1st', '2nd', '3rd', '4th', '5th', '6th', '7th'))
      axis(side = 4, las = 2, mgp = c(3,0.75, 0), family = "mono")
      mtext("Frequency", side = 4, line = 2.5, las = 3, family = "mono")
    }else {
      plot.new()
    }
    title(main = HTML("The Distribution of\nCorrect Matches\nby Envelopes"), cex.main = 1, family = "mono")
  })
  
  
  ##########################################
  ## "Reset" button actions
  ##########################################
  observeEvent(input$reset, {
    msg_new_game <- HTML("This will erase the current class report. Type the admin code to proceed.")
    shinyalert(
      msg_new_game, type = "input", html = TRUE,
      callbackR = function(x) { if(x == 'JSDSE') {
          close( file( 'report.csv', open="w" ) )
          nothing <- data.frame(matrix(ncol = 8, nrow = 0))
          colnames(nothing) <- c('Score', 1:7)
          write.table(nothing, 'report.csv', row.names = FALSE, col.names = TRUE, 
                quote = FALSE, sep = ",")}
        })
    })
})
