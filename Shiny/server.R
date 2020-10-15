#

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



df_stats <- read_csv("data/academatica_video_stats.csv")
df_stats <- df_stats[!duplicated(df_stats$id), ]
df_stats <- df_stats %>%
    rename(
        Vistas = viewCount,
        Likes = likeCount,
        'No me gusta' = dislikeCount,
        Favoritos = favoriteCount,
        Comentarios = commentCount
    )
df_metadata <- read_csv("data/academatica_videos_metadata.csv") 
df_metadata <- df_metadata %>%
    rename(
        id = video_id,
        'Título' = title,
        'Descripción' = description,
        'Código' = iframe,
        Enlace = link
    )
df_metadata <- df_metadata[!duplicated(df_metadata$id), ]
df_stats$id <- substr(df_stats$id, 1, 10) 
df_metadata$id <- substr(df_metadata$id, 1, 10) 
df_videos <- merge(df_metadata, df_stats, by ="id")
cols <- c(1, 2, 5, 6, 7, 8, 9, 10)
print("Se preprocesó todo")



getTermMatrix <- memoise(function(campo) {
    if (campo == "Títulos"){
        text <- df_videos$Título
    } else {
        text <- df_videos$Descripción
    }
     
    
    myCorpus = Corpus(VectorSource(text))
    myCorpus = tm_map(myCorpus, content_transformer(tolower))
    myCorpus = tm_map(myCorpus, removePunctuation)
    myCorpus = tm_map(myCorpus, removeNumbers)
    myDTM = TermDocumentMatrix(myCorpus,
                               control = list(minWordLength = 1))
    
    m = as.matrix(myDTM)
    
    sort(rowSums(m), decreasing = TRUE)
})




# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- df_videos[, 6]
        bins <- seq(min(x), max(x), length.out = 20)
        
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white', main="Distribución de vistas en el dataset", xlab="Vistas (agrupadas)")
    })
    
    output$stats <- DT::renderDataTable({
        #link <- as.character(input$search_link)
        #titulos <- as.character(input$search_title)
        #dislike_input <- as.integer(input$dislike_input)
        #like_input <- as.integer(input$like_input)
        #com_input <- as.integer(input$com_input)
        #vistas_input <- as.integer(input$vistas_input)
        #resultado_busqueda <- df_videos %>% filter(str_detect(Enlace,link))
        #resultado_busqueda <- resultado_busqueda %>% filter(str_detect(`Descripción`,titulos) | str_detect(`Título`,titulos))
        #resultado_busqueda <- resultado_busqueda %>% filter(`Likes` <= like_input & `No me gusta` <=like_input & Comentarios <= com_input & Vistas <= vistas_input )
        DT::datatable(df_videos[,cols],
                      filter = 'top',
                      options = list(
                          pageLength = 5,
                          lengthMenu = c(5, 10, 5)
                      )
                      
        ) }, selection = 'single', server = TRUE)
    
    
    output$vacio <- renderText({
         if(length(input$stats_rows_selected) < 1 || length(input$stats_rows_selected) > 1){
             if(length(input$stats_rows_selected) < 1){
                 "
                 En la pestaña anterior seleccione un vídeo para desplegarlo aquí mismo."
             } else {
                 "ERROR DE CAPA 8. Seleccione SOLO un vídeo de la lista por favor"
             }
             
         } else {
             ""
         }
    })
    
    output$codigo <- renderText({
        if(length(input$stats_rows_selected) == 1) {
            df_videos[input$stats_rows_selected, 3]
        } 
        
    })
    
    output$titulo_video <- renderText({
        if(length(input$stats_rows_selected) == 1){
            df_videos[input$stats_rows_selected, 2]
        } 
        
        
        
    })
    
    output$video <- renderUI({
        if(length(input$stats_rows_selected) == 1){
            HTML(df_videos[input$stats_rows_selected, 4])
        }
    })
    
    
    output$caja <- renderValueBox({
        valueBox(
            value = max(df_videos$Vistas),
            subtitle = "Mayor cantidad de vistas",
            icon = icon("eye"),
            color = "red"
        )
    })
    
    output$caja_likes <- renderValueBox({
        valueBox(
            value = max(df_videos$Likes),
            subtitle = "Mayor cantidad de likes",
            icon = icon("heart"),
            color = "red"
        )
    })
    
    output$caja_dislikes <- renderValueBox({
        valueBox(
            value = max(df_videos$`No me gusta`),
            subtitle = "Mayor cantidad de 'No me gusta'",
            icon = icon("hand"),
            color = "red"
        )
    })
    
    output$caja_favoritos <- renderValueBox({
        valueBox(
            value = max(df_videos$Favoritos),
            subtitle = "Mayor cantidad de favoritos",
            icon = icon("star"),
            color = "red"
        )
    })
    
    output$plotVisLik <- renderPlot({
        plot(df_videos$Vistas, df_videos$Likes,xlab="Vistas",ylab="Likes") #, col=c("gray", "green", "black", "black", "red")[mtcars_click$color])
    })
    
    output$plot_table <- DT::renderDataTable({
        if(!is.null(input$brush$xmin)){
            filtrado <- df_videos %>% filter(Vistas > round(input$brush$xmin, 2), Vistas < round(input$brush$xmax, 2), Likes > round(input$brush$ymin, 2),  Likes < round(input$brush$ymax, 2)) 
            print(input$brush$xmin)
            print(input$brush$xmax)
            print(filtrado)
            DT::datatable(filtrado[,cols])
        }
        
        })
    
    output$plotComLik <- renderPlot({
        plot(df_videos$Comentarios, df_videos$Likes,xlab="Comentarios",ylab="Likes") #, col=c("gray", "green", "black", "black", "red")[mtcars_click$color])
    })
    
    output$plot_table2 <- DT::renderDataTable({
        if(!is.null(input$brush2$xmin)){
            filtrado2 <- df_videos %>% filter(Comentarios > round(input$brush2$xmin, 2), Comentarios < round(input$brush2$xmax, 2), Likes > round(input$brush2$ymin, 2),  Likes < round(input$brush2$ymax, 2)) 
            DT::datatable(filtrado2[,cols])
        }
        
    })
    
    terms <- reactive({
        input$update
        isolate({
            withProgress({
                setProgress(message = "Procesando el texto")
                getTermMatrix(input$selection)
            })
        })
    })
    

    wordcloud_rep <- repeatable(wordcloud)
    
    output$plot_wordcloud <- renderPlot({
        v <- terms()
        wordcloud_rep(names(v), v, scale=c(4,0.5),
                      min.freq = input$freq, max.words=input$max,
                      colors=brewer.pal(8, "Dark2"))
    })
    
    
    observe({
        query <- parseQueryString(session$clientData$url_search)
        if(!is.null(query[['min_freq']])) {
            updateSliderInput(session, 'freq', min = max(1, min(30, strtoi(query[['min_freq']]))  )) 
        }
        if(!is.null(query[['max_freq']])) {
            updateSliderInput(session, 'freq', max = min(100, max(strtoi(query[['max_freq']]), 10) )) 
        }
        if(!is.null(query[['min_word']])) {
            updateSliderInput(session, 'max', min = max(1, min(30, strtoi(query[['min_word']])) )) 
        }
        if(!is.null(query[['max_word']])) {
            updateSliderInput(session, 'max', max = min(100, max(strtoi(query[['max_word']]), 10) )) 
        }
        
    })

})
