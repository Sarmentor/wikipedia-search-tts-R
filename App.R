library(shiny)
options(warn=-1)
library(shinythemes)
library(Rtts)
library(htm2txt)

my.dir <- getwd()
setwd(dir=my.dir)

ui <- fluidPage(theme = shinytheme("slate"),
                selectInput(inputId="lang", label="Select Language:",choices= c("EN","PT"), selected="EN"),
                textInput("n", "Input Search:"),
                actionButton("Run", "Click Me"),
                verbatimTextOutput("nText")
                
)

server <- function(input, output, session){
  ntext <- eventReactive(input$Run, {
    inp = input$n
    lang = input$lang
    
    if(lang=="EN"){
      url1.en <- 'https://en.wikipedia.org/wiki'
      urlNew.en = paste(url1.en, inp,sep = '/')
      text.en <- gettxt(urlNew.en)
      text.en
      
      phrases.to.read <- strsplit(text.en, "[\r\n]")[[1]]
      for (i in 1:length(phrases.to.read)){
        
        system("cmd.exe", input = paste('espeak -s150 -ven "',phrases.to.read[i],'"', sep=""))
        
      } 
      
      
    }
    
    if(input$lang=="PT"){
      url1.pt <- 'https://pt.wikipedia.org/wiki'
      urlNew.pt = paste(url1.pt, inp,sep = '/')
      text.pt <- gettxt(urlNew.pt)
      text.pt
      
      phrases.to.read <- strsplit(text.pt, "[\r\n]")[[1]]
      
      for (i in 1:length(phrases.to.read)){
        
        system("cmd.exe", input = paste('espeak -s140 -vpt-pt -k -20 "',phrases.to.read[i],'"', sep=""))
        
      } 
      
    }
    
        #com tts_ITRI
    #text.new <- gsub("[\r\n]", ". ", text)
    #browser()
    #text.new = substr(text.new, start = 1, stop = 1000)
    
    #tts_ITRI(new_text, speaker = "ENG_Bob",destfile="temp.mp3")
    #tts_ITRI(text, speaker = "ENG_Bob",destfile="temp.mp3")
    
  })
  
  #observeEvent(input$Run, {
  #  insertUI(selector = "#Run",
  #           where = "afterEnd",
  #           ui = tags$audio(src = "temp.mp3", type = "audio/mp3", autoplay = NA, controls = NA, style="display:none;"),
  #           immediate = FALSE
  #  )
  #})
  
  
  output$nText <- renderText({
    ntext()
  })
  
}

shinyApp(ui, server)
