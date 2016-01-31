# libraries 
library(rCharts)
library(ggvis)
library(stringr)
library(markdown)
library(reshape2)
library(dplyr)

#load data from tsv files
#data <- read.table("tps00066.tsv", header=TRUE, sep="\t", fileEncoding="windows-1252", stringsAsFactors = FALSE )
data <- read.csv("lfsa_urgaed_1_Data.csv")

#data clean and processing
data <- data[, -c(4,6,8)]
data$Value <- as.numeric(gsub("[^0-9|.]","",as.character(data$Value)))

countries <- sort(unique(levels(data$GEO)))
sex <- sort(unique(levels(data$SEX)), decreasing = TRUE)
education <- sort(unique(levels(data$ISCED11)))

filterData <- function(data, countries, sex, education){
    data %>% filter(GEO %in% countries, SEX %in% sex, ISCED11 %in% education) %>%
        group_by(GEO)
}

shinyServer(function(input, output, session) {
    
    values <- reactiveValues()
    values$sex <- sex
    
    output$countrySL <- renderUI({
        selectInput("country", "Geographic area", multiple = TRUE, choices = countries, selected = "European Union (28 countries)")
    })
    
    output$sexCB <- renderUI({
        radioButtons('sex', 'Sex', sex, selected="Total")
    })
    output$educationCB <- renderUI({
        radioButtons('education', 'Education', education, selected="All ISCED 2011 levels ")
    })
    
    dataSelected <- reactive({
         filterData(data, input$country, input$sex, input$education)
    })
    
    output$outp <- renderPrint({dataSelected()})
    output$filterSex <- renderPrint({input$sex})
    output$filterEdu <- renderPrint({input$education})
    # Events by year
    output$unemploymentByYear <- renderChart2({
        data$TIME <- as.character(data$TIME)
        m1 <- nPlot(Value~TIME, type = "lineChart", group = "GEO", data = dataSelected(), width = 650)
        m1$chart(margin = list(left = 100))
        m1$yAxis( axisLabel = "Unemployment Rate (%)", width = 80)
        m1$xAxis( axisLabel = "Year", width = 70)
        m1$set(dom= "plot")
        m1
    })
})
