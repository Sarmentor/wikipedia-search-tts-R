library(shiny)
options(warn=-1)
library(shinythemes)
library(Rtts)
library(htm2txt)

my.dir <- getwd()
setwd(dir=my.dir)

my.OS <- Sys.info()['sysname']

ui <- fluidPage( shinythemes::themeSelector(), sidebarPanel(
                selectInput(inputId="lang", label="Select Language:",choices= c("en","pt-pt"), selected="en"),
                textInput("n", "Input Search:"),
                sliderInput(inputId="speed","Choose Voice Speed",100,160,135,10),
                actionButton("Run", "Click Me")),
                mainPanel(verbatimTextOutput("nText"))
                
)

server <- function(input, output, session){
  
  my.new.text <- "Welcome to Wikipedia Search and Reader. Select your language, input some keywords and hit Click Me button. Enjoy!"
  
 
  showModal(modalDialog(my.new.text, title ="Reading Text/Lendo o Texto...", footer = modalButton("Dismiss Window"),
                        size = "l", easyClose = TRUE, fade = TRUE))
  
  
  tts.espeak <- function(lang="en", speed=140){
    
   
    
    text <- my.new.text
    
    if(is.null(text)){return()}
    
    phrases.to.read <- strsplit(text, "[\r\n]")[[1]]
    
    for (i in 1:length(phrases.to.read)){
      showModal(modalDialog(phrases.to.read[i], title ="Reading Text/Lendo o Texto...", footer = modalButton("Close/Sair"),
                  size = "l", easyClose = TRUE, fade = TRUE))
      if(grepl("win",tolower(my.OS))){
        system("cmd.exe", input = paste('espeak -s ',paste(speed),' -v ',lang,' -k -20 "',phrases.to.read[i],'"', sep=""))
      }
      if(grepl("lin",tolower(my.OS))){
        system(command= paste('espeak -s ',paste(speed),' -v ',lang,' -k -20 "',phrases.to.read[i],'"', sep=""))
      }
      if(grepl("mac",tolower(my.OS))){
        system(command=paste('espeak -s ',paste(speed),' -v ',lang,' -k -20 "',phrases.to.read[i],'"', sep=""))
      }
    }
  }
  
  tts.espeak("en","140")

  ntext <- eventReactive(input$Run, {
    inp <- input$n
    lang <- input$lang
    speed <- input$speed
    
    if(lang=="en"){
      url1.en <- 'https://en.wikipedia.org/wiki'
      urlNew.en = paste(url1.en, inp,sep = '/')
      my.new.text <- gettxt(urlNew.en)
    }
    
    if(input$lang=="pt-pt"){
      url1.pt <- 'https://pt.wikipedia.org/wiki'
      urlNew.pt = paste(url1.pt, inp,sep = '/')
      my.new.text <- gettxt(urlNew.pt)
    }
    
    
    my.new.text <<- my.new.text
    
    output$nText <- renderText({
      my.new.text
    })
    tts.espeak(lang,speed)
  })
  
  
    
  observeEvent(input$Run,{
      ntext()
  })
  
}

shinyApp(ui, server)
