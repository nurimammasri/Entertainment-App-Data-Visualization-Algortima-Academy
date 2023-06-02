options(shiny.maxRequestSize = 10*1024^2)

function(input, output){
  
  #===============#
  #     Tab 1     #
  #===============#
  
  output$wordcloud2 <- renderWordcloud2({
    data_agg1 <- genre %>% 
      select(genres, counts) %>% 
      arrange(desc(counts)) %>% 
      head(300)
    
    wordcloud2(data_agg1, color = "random-dark", backgroundColor = "transparent")
  })
  
  #===============#
  #     Tab 2     #
  #===============#
  
  # upper plot
  
  output$bar_plot <- renderPlotly({
    data_agg2 <- data_2010s %>% 
      filter(Year == input$year1) %>% 
      select(Name, Popularity, Artists) %>% 
      arrange(desc(Popularity)) %>% 
      mutate(text = glue("Popularity: {Popularity}
                          Artists: {Artists}")) %>% 
      head(10)

    plot_rank <- ggplot(data_agg2, 
                        aes(x = Popularity, y = reorder(Name, Popularity), 
                            text = text)) +
      geom_col(aes(fill = Popularity)) +
      scale_y_discrete(labels = wrap_format(30)) + 
      scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, 10)) +
      scale_fill_gradient(low = "#00bfff", high = "#104e8b") + 
      labs(x = "Popularity (0-100)", y = NULL, 
           title = glue("Top 10 Most Popular Songs {input$year1}")) +
      my_theme
    
    ggplotly(plot_rank, tooltip = "text")
  })
  
  output$SOTY <- renderValueBox({
    
    data_agg3 <- data_2010s %>%
      filter(Year == input$year1) %>% 
      arrange(desc(Popularity)) %>% 
      head(1)
    
    valueBox(value = "Song of the Year", 
             subtitle = glue("{data_agg3$Name} --- {data_agg3$Artists}"), 
             color = "green", 
             icon = icon("trophy"))
  })
  
  output$Popularity <- renderValueBox({
    
    data_agg3 <- data_2010s %>%
      filter(Year == input$year1) %>% 
      arrange(desc(Popularity)) %>% 
      head(1)
    
    valueBox(value = "Popularity Score", 
             subtitle = glue("{data_agg3$Popularity} / 100"), 
             color = "green", 
             icon = icon("spotify"))
  })
  
  # middle plot
  
  output$plot_corr_explicit <- renderPlotly({
    data_agg_4 <- data_2010s %>%
      filter(Year == input$year2) %>%
      arrange(desc(Popularity)) %>% 
      head(input$head)
    
    plot_dist <- ggplot(data_agg_4, 
                        aes_string(x = input$xlabel, y = input$ylabel)) +
      geom_jitter(aes(col = as.factor(Explicit),
                      text = glue("{str_to_upper(Explicit)}
                                  Title: {Name}
                                  Artists: {Artists}
                                  Popularity: {Popularity}"))) +
      labs(x = input$xlabel, y = input$ylabel, 
           title = glue("Distribution of Songs {input$year2}")) +
      guides(color = FALSE) + 
      my_theme

    if (input$trend == TRUE) {
      plot_dist <- plot_dist + geom_smooth()
    }
    
    ggplotly(plot_dist, tooltip = "text")
  })
  
  output$plot_corr_mode <- renderPlotly({
    data_agg_4 <- data_2010s %>%
      filter(Year == input$year2) %>%
      arrange(desc(Popularity)) %>% 
      head(input$head)
    
    plot_dist <- ggplot(data_agg_4, 
                        aes_string(x = input$xlabel, y = input$ylabel)) +
      geom_jitter(aes(col = as.factor(Mode),
                      text = glue("{str_to_upper(Mode)}
                                  Title: {Name}
                                  Artists: {Artists}
                                  Popularity: {Popularity}"))) +
      labs(x = input$xlabel, y = input$ylabel, 
           title = glue("Distribution of Songs {input$year2}")) +
      guides(color = FALSE) + 
      my_theme
    
    if (input$trend == TRUE) {
      plot_dist <- plot_dist + geom_smooth()
    }
    
    ggplotly(plot_dist, tooltip = "text")
  })

  # lower plot  
  
  output$time_series <- renderPlotly({
    data_agg2 <- year %>% 
      select(Year, Acousticness, Energy, Instrumentalness, Liveness) %>% 
      gather(key = "Variable", value = "Value", -Year)
    
    plot_time <- ggplot(data_agg2, aes(x = Year, y = Value)) + 
      geom_line(aes(color = Variable)) + 
      scale_color_manual(values = c("red", "green", "orange", "purple")) + 
      guides(color = FALSE) + 
      labs(x = "Year", y = "Value", title = "Music Taste in the Past Century") + 
      scale_x_continuous(limits = c(1920, 2020), breaks = seq(1920, 2020, 20)) +
      my_theme
    
    ggplotly(plot_time)
  })
  
  #===============#
  #     Tab 3     #
  #===============#
  
  output$data <- renderDataTable({
    DT::datatable(data = data_2010s, options = list(scrollX=T))
  })
    
}