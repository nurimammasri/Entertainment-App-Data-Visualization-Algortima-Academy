shinyServer(function(input, output) {
  
  #OUTPUT PAGE 1
  spotify_by_year <- spotify_clean %>% 
    group_by(year) %>%
    summarise(across(c(-artists, -duration_ms, -explicit, -mode, -name, -release_date, -tempo, -id, -loudness, -popularity), \(x) mean(x, na.rm = TRUE)))
  
  #plot
  output$plot1 <- renderPlotly({
    data_agg1 <- spotify_by_year %>% 
      select(-key) %>% 
      gather(key = "Variable", value = "Value", -year)
    
    
    plot1<- ggplot(data_agg1, aes(x = year, y = Value)) + 
      geom_line(aes(color = Variable))  + 
      guides(scale = "none") + 
      labs(x = "Year", y = "Value", title = "Preference Music Taste in the Past Century on Spotify") + 
      scale_x_continuous(limits = c(1921, 2020), breaks = seq(1921, 2020, 10)) +
      theme_minimal()
    
    
    ggplotly(plot1)
  })
  
  #WORDCLOUD
  output$wordcloud2 <- renderWordcloud2({
    spotify_by_genre <- spotify_genre %>% 
      group_by(genres) %>%
      summarise(mean_popularity = mean(popularity)) %>% 
      ungroup()
    spotify_by_genre$mean_popularity <-round(spotify_by_genre$mean_popularity, digits=2)
    
    wordcloud2(data= spotify_by_genre, color = "random-dark", size=0.3, backgroundColor = "white")
  })
  
  #OUTPUT PAGE 2
  output$plot_rank <- renderPlotly({
    data_agg2 <- spotify_clean %>%
      filter(year == input$year1) %>%
      select(name, popularity, artists) %>%
      arrange(desc(popularity)) %>%
      mutate(text = glue("popularity: {popularity}
                          artists: {artists}")) %>%
      head(15)
    
    plot_rank <- ggplot(data_agg2,
                        aes(x = popularity, y = reorder(name, popularity),
                            text = text)) +
      geom_col(aes(fill = popularity)) +
      scale_y_discrete(labels = wrap_format(30)) +
      scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, 10)) +
      scale_fill_gradient(low = "light blue", high = "dark blue") +
      labs(x = "Popularity (0-100)", y = NULL,
           title = glue("Top 15 Popular Songs {input$year1}")) +
      theme_minimal()
    
    ggplotly(plot_rank, tooltip = "text")
  })
  
  output$SOTY <- renderValueBox({
    
    data_agg2 <- spotify_clean %>%
      filter(year == input$year1) %>%
      arrange(desc(popularity)) %>%
      head(1)
    
    valueBox(value = "Song of the Year",
             subtitle = glue("{data_agg2$name} --- {data_agg2$artists}"),
             color = "green",
             icon = icon("trophy"))
  })
  
  output$Popularity <- renderValueBox({
    
    data_agg2 <- spotify_clean %>%
      filter(year == input$year1) %>%
      arrange(desc(popularity)) %>%
      head(1)
    
    valueBox(value = "Popularity Score",
             subtitle = glue("{data_agg2$popularity} / 100"),
             color = "green",
             icon = icon("spotify"))
  })
  
  
  ## CORRELATION PLOT
  output$plot_corr_explicit <- renderPlotly({
    data_agg_4 <- spotify_clean %>%
      filter(year == input$year2) %>%
      arrange(desc(popularity)) %>%
      head(input$head)
    
    plot_dist <- ggplot(data_agg_4,
                        aes_string(x = input$xlabel, y = input$ylabel)) +
      geom_jitter(aes(col = as.factor(explicit),
                      text = glue("{str_to_upper(explicit)}
                                  Title: {name}
                                  Artists: {artists}
                                  Popularity: {popularity}"))) +
      labs(x = input$xlabel, y = input$ylabel,
           title = glue("Distribution of Songs {input$year2}")) +
      guides(color = FALSE) +
      theme_minimal()
    
    if (input$trend == TRUE) {
      plot_dist <- plot_dist + geom_smooth()
    }
    
    ggplotly(plot_dist, tooltip = "text")
  })
  
  output$plot_corr_mode <- renderPlotly({
    data_agg_4 <- spotify_clean %>%
      filter(year == input$year2) %>%
      arrange(desc(popularity)) %>%
      head(input$head)
    
    plot_dist <- ggplot(data_agg_4, 
                        aes_string(x = input$xlabel, y = input$ylabel)) +
      geom_jitter(aes(col = as.factor(mode)), text = glue("{mode}
                                  Title: {name}
                                  Artists: {artists}
                                  Popularity: {popularity}")) +
      labs(x = input$xlabel, y = input$ylabel, 
           title = glue("Distribution of Songs {input$year2}")) +
      guides(color = FALSE) + 
      theme_minimal()
    
    if (input$trend == TRUE) {
      plot_dist <- plot_dist + geom_smooth()
    }
    
    ggplotly(plot_dist, tooltip = "text")
  })
  
  
  
  
  #OUTPUT PAGE 3
  output$data <- renderDataTable({
    DT::datatable(data = spotify, options = list(scrollX=T))
  })
  
  
})

