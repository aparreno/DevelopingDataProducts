library(shiny)
library(rCharts)

shinyUI(
    navbarPage("Unemployment in Europe Explorer",
               tabPanel("Plot",
                        h4("Unemployment rates by sex, age and educational attainment level (%)", align = "center"),
                        sidebarPanel(
                            uiOutput("countrySL"),
                            uiOutput("sexCB"),
                            uiOutput("educationCB")
                             ),
                            
                        mainPanel(
                             h4('Unemployment rate by year', align = "center"),
                             chartOutput("unemploymentByYear", lib = "nvd3"),
                             h4('Table with filtered dataset', align = "center"),
                             verbatimTextOutput("outp")
                                
                            )
                        ),
               
               tabPanel("About",
                        mainPanel(
                            includeMarkdown("about.md")
                        )
               )
    )
)