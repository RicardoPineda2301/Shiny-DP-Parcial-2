#
## Cargando las librerías
library(shiny)
library(readr)
library(dplyr)
library(RMySQL)
library(DT)
library(pool)
library(lubridate)
library(stringr)
library(shinyWidgets)
library(shinydashboard)
library(shinythemes)
library(tm)
library(wordcloud)
library(memoise)

# Define UI for application that draws a histogram
shinyUI(
    navbarPage("Academática Dashboard",
               theme= shinytheme("flatly"),
               #shinythemes::themeSelector(),
               tabPanel("Estadísticas de los datos", 
                        fluidRow(     
                            column(width = 8, 
                                   plotOutput("distPlot")
                            ),
                            column(width = 4, 
                                   valueBoxOutput("caja")
                            )
                        ),
                        fluidRow(     
                            column(width = 4, 
                                   valueBoxOutput("caja_likes")
                            ),
                            column(width = 4, 
                                   valueBoxOutput("caja_dislikes")
                            ),
                            column(width = 4, 
                                   valueBoxOutput("caja_favoritos")
                            )
                        )
               ),
               tabPanel("Filtrar la data por parámetros",
                        fluidRow(
                            column(width = 12,
                                   
                                   DT::dataTableOutput("stats")
                                   
                            )
                        )
                        #)
                        
               ),
               tabPanel("Vídeo seleccionado", 
                        
                        mainPanel(
                            #plotOutput("distPlot"),
                            h3("Vídeo seleccionado"),
                            h4(textOutput("vacio")),
                            h1(textOutput("titulo_video")),
                            textOutput("codigo"),
                            uiOutput("video")
                        )
                        
               ),
               tabPanel("Likes VS Vistas", 
                        
                        fluidRow(
                          column(width = 12,
                          h5("Marque el área de los vídeos que desea desplegar. Hacer clic limpiará la tabla. "),
                          plotOutput("plotVisLik",
                                     click = 'clk',
                                     dblclick = 'dblclick',
                                     hover = 'hover',
                                     brush = 'brush'   )
                          )
                        ),
                        fluidRow(
                          column(width = 12,
                          DT::dataTableOutput("plot_table")
                          )
                        )
                        
               ),
               tabPanel("Likes VS Comentarios", 
                        
                        fluidRow(
                          column(width = 12,
                                 h5("Marque el área de los vídeos que desea desplegar. Hacer clic limpiará la tabla."),
                                 plotOutput("plotComLik",
                                            click = 'clk2',
                                            dblclick = 'dblclick2',
                                            hover = 'hover2',
                                            brush = 'brush2'   )
                          )
                        ),
                        fluidRow(
                          column(width = 12,
                                 DT::dataTableOutput("plot_table2")
                          )
                        )
                        
               ),
               tabPanel("Parámetros de la URL",
                        
                        sidebarPanel(
                          tags$div(
                            tags$h1("Parámetros URL"),
                            tags$p("Los parámetros para la URL son:"),
                            tags$ol(
                              tags$li("min_freq: Frecuencia mínima de palabras a ser incluidas. Número mínimo: 1"), 
                              tags$li("max_freq: Frecuencia máxima de palabras a ser incluidas. Número máximo: 100."), 
                              tags$li("min_word: Número mínimo de palabras. Número mínimo: 1"),
                              tags$li("max_word: Número máximo de palabras. Número máximo: 100.")
                            )
                          ),
                          selectInput("selection", "Escoja un campo:",
                                      choices = c("Títulos", "Descripción")),
                          actionButton("update", "Cambiar campo"),
                          hr(),
                          sliderInput("freq",
                                      "Frecuencia:",
                                      min = 1,  max = 50, value = 15),
                          sliderInput("max",
                                      "Número de palabras:",
                                      min = 1,  max = 75,  value = 15)
                        ),
                        
                        # Show Word Cloud
                        mainPanel(
                          plotOutput("plot_wordcloud")
                        )
                       
                        
               )
               #)
               
               # Sidebar with a slider input for number of bins 
               
    )
)
