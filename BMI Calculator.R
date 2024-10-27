#load libaries
library(shiny)
library(shinythemes)
library(randomForest)
library(data.table)

#ui interface
ui<- fluidPage(theme = shinytheme("superhero"),
               navbarPage("BMI Calculator:",
                          tabPanel("Home",
                                   #input
                                   sidebarPanel(
                                     HTML("<h3>Input parameters</h3>"),
                                     sliderInput("height",
                                                 label = "Height(cm)",
                                                 value = 175,
                                                 min = 40,
                                                 max = 250),
                                     sliderInput("Weight",
                                                 label = "weight(kg)",
                                                 value = 70,
                                                 min = 20,
                                                 max = 150),
                                     actionButton("submitbutton",
                                                  "Submit",
                                                  class="btn btn-primary")
                                   ),
                                   
                                   mainPanel(
                                     tags$label(h3("Status/Output")),
                                     verbatimTextOutput("contents"),
                                     tableOutput("tabledata")#result
                                     
                                   )
                                   ),
                                    tabPanel("About",
                                             titlePanel("About"),
                                             div(includeMarkdown("about.md"),
                                                 align="justify")
                                             )
                          ))  
#server 

server<-function(input,output,session){
  #input
  datasetInput <- reactive({
    req(input$submitbutton) 
    bmi <- input$Weight / ((input$height / 100) ^ 2)
    bmi <- data.frame(BMI = round(bmi, 2))
    bmi
  })
  #status/output
  output$contents<-renderPrint({
    if (input$submitbutton>0){
      isolate("Calculation complete.")
    }else{
      return("Server is ready for calculation.")
    }
  })
  #prediction
  output$tabledata<-renderTable({
    if (input$submitbutton>0){
      isolate(datasetInput())
    }
  })
}

#create shiny app
shinyApp(ui=ui,server=server)