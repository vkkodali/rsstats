#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)

rsstats <- read.csv('RefSeq_Stats.tsv', header = TRUE, sep = '\t')
rownames(rsstats) <- rsstats[,1] # set rownames to release number
rsstats <- rsstats[order(as.numeric(row.names(rsstats))), ] # sort dataframe by release number as a number
rsstats <- rsstats[-1] # remove release number column from the table

ui <- fluidPage(
  titlePanel("RefSeq release species counts"),
  
  # sidebarLayout(      
    sidebarPanel(
      selectInput("taxgroup", "Taxonomic Group:",
                  choices=colnames(rsstats)),
      hr(),
      helpText("RefSeq species broad taxonomic groups")
    ),
    
    mainPanel(
      plotOutput("taxbarplot")
    ),
  # ),
  
  sidebarPanel(
    # selectInput('xcol', 'X Variable', choices = rownames(rsstats)),
    selectInput('ycol', 'Y Variable', choices = colnames(rsstats), multiple = FALSE, selected = 'vertebrate_mammalian')
  ),
  
  mainPanel(
    plotOutput('taxxyplot')
  )
)

server <- function(input, output) {
  output$taxbarplot <- renderPlot({
    barplot(rsstats[,input$taxgroup],
            names.arg = rownames(rsstats),
            col = "#75AADB",
            border = "white",
            main=input$taxgroup,
            ylab="Number of species",
            xlab="RefSeq release")
  })
  output$taxxyplot <- renderPlot({
    plot(rownames(rsstats), rsstats[,input$ycol], 
         main=input$taxgroup,
         ylab="Number of species",
         xlab="RefSeq release")
  })
}

shinyApp(ui = ui, server = server)


