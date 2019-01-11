library(shiny)
options(warn=-1)
library(shinythemes)
library(Rtts)
library(htm2txt)

ui <- fluidPage(theme = shinytheme("slate"),
                textInput("n", "Input:"),
                actionButton("Run", "Click Me"),
                verbatimTextOutput("nText")
                
)

server <- function(input, output, session){
  ntext <- eventReactive(input$Run, {
    inp = input$n
    url1 <- 'https://en.wikipedia.org/wiki'
    urlNew = paste(url1, inp,sep = '/')
    text <- gettxt(urlNew)
    new_text = substr(text, start = 1, stop = 100)
    tts_ITRI(new_text, speaker = "ENG_Bob",destfile="www/temp.mp3")
    text
  })
  
  observeEvent(input$Run, {
    insertUI(selector = "#Run",
             where = "afterEnd",
             ui = tags$audio(src = "temp.mp3", type = "audio/mp3", autoplay = NA, controls = NA, style="display:none;"),
             immediate = FALSE
    )
  })
  
  
  output$nText <- renderText({
    ntext()
  })
  
}

shinyApp(ui, server)