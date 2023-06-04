shinyServer(function(input, output) {
  
  
  # ==========================
  #   PAGE 1 - Netflix
  # ==========================
  
  # Number and Percentage Content
  n_movies <- top_type[top_type$type == "Movie",]$n_type
  n_movies_pc <- top_type[top_type$type == "Movie",]$percent*100
  
  n_tvshows <- top_type[top_type$type == "TV Show",]$n_type
  n_tvshows_pc <- top_type[top_type$type == "TV Show",]$percent*100
  
  # Distribution Movies vs TV Shows - Static
  output$type_plot1 <- renderPlot({
    type_plot <- top_type %>% 
      ggplot(aes(x="", y=percent, fill=type)) +
      geom_bar(width = 1, stat = "identity") + 
      coord_polar("y", start=0) + 
      scale_fill_manual(values=c("firebrick", "grey16")) +
      theme_minimal() +
      theme(
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.border = element_blank(),
        panel.grid=element_blank(),
        axis.ticks = element_blank(),
        plot.title=element_text(size=14, face="bold")
      ) +
      theme(axis.text.x=element_blank()) +
      geom_text(aes(y = percent/3 + c(0, cumsum(percent)[-length(percent)]), 
                    label = percent(percent)), size=5, color="white")
    
    type_plot
    
  })
  
  # Distribution Movies vs TV Shows - Dynamic
  output$type_plot2 <- renderHighchart({
    type_plot <- top_type %>%
      hchart("pie", hcaes(x = type, y = percent, color = setNames(c("#b22222","#292929"),levels(top_type$type))), name = "Content Distribution") %>%
      hc_title(
        text = "<b>Content type Distribution</b>",
        margin = 0,
        align = "left",
        style = list(useHTML = TRUE)
      )
    
    type_plot
  })
  
  
  # Top 10 Genres
  output$genre_plot <- renderPlotly({
    genre_plot <- df_netflix %>%
      filter(year_added %>% between(input$year_added[1], input$year_added[2])) %>%
      group_by(genre) %>%
      summarise(num_of_contents = n()) %>%
      ungroup() %>%
      arrange(desc(num_of_contents)) %>%
      head(10) %>%
      ggplot(aes(x = num_of_contents, y = fct_reorder(genre, num_of_contents))) +
      geom_col(fill = "grey16", alpha = .9, aes(
        text = paste0(genre, "<br>",
                      "Num. of Contents: ",
                      num_of_contents)
      )) +
      scale_y_discrete(
        label = function(x)
          stringr::str_trunc(x, 12)
      ) +
      labs(
        title = NULL,
        x = "Number of Contents",
        y = "",
        color = "",
      ) +
      theme_minimal() +
      theme(
        title = element_text(face = "bold"),
        text = element_text(family = "lato"),
        panel.grid = element_blank(),
        panel.grid.major.x = element_line(color = "grey88"),
        axis.text.y = element_text(angle = 45)
      )
    
    ggplotly(genre_plot, tooltip = "text") %>%
      config(displayModeBar = F)
    
  })
  
  # Top cast for value box
  output$pop_cast <- renderValueBox({
    req(input$country_input, cancelOutput = T)
    req(input$movie_tv, cancelOutput = T)
    
    top_cast <- df_netflix %>%
      filter(
        main_cast != "Unknown",
        type %in% input$movie_tv,
        country %in% input$country_input
      ) %>%
      group_by(main_cast) %>%
      summarise(num_of_content = n()) %>%
      ungroup() %>%
      arrange(desc(num_of_content)) %>%
      head(1)
    
    
    valueBox(
      value = top_cast$main_cast,
      subtitle = "Top Main Cast by Content Counts",
      color = "red",
      icon = icon("star")
    )
  })
  
  # Top Content with Number of Cast
  output$no_cast <- renderPlotly({
    req(input$country_input, cancelOutput = T)
    req(input$movie_tv, cancelOutput = T)
    
    fig_no_cast <- df_netflix %>%
      select(title, cast, country, genre, target_age, type) %>%
      mutate(cast_count = lengths(str_split(cast, ", "))) %>%
      filter(type %in% input$movie_tv,
             country %in% input$country_input) %>%
      arrange(desc(cast_count)) %>%
      head(10) %>%
      ggplot(aes(x = cast_count, y = fct_reorder(title, cast_count))) +
      geom_col(alpha = 0.9, fill = "firebrick", aes(
        text = paste0(
          title,
          "<br>",
          "Country: ",
          str_trunc(country, 22),
          "<br>",
          "Num. of Casts: ",
          cast_count
        )
      )) +
      scale_y_discrete(
        label = function(x)
          stringr::str_trunc(x, 12)
      ) +
      labs(
        title = NULL,
        x = "Number of Casts",
        y = "Title of The Contents",
        color = "",
      ) +
      theme_minimal() +
      theme(
        title = element_text(face = "bold"),
        text = element_text(family = "lato"),
        panel.grid = element_blank(),
        panel.grid.major.x = element_line(color = "grey88"),
        axis.text.y = element_text(angle = 45)
      )
    
    ggplotly(fig_no_cast, tooltip = "text") %>%
      config(displayModeBar = F)
  })
  
  
  # Top Directors for value box
  
  output$pop_dir <- renderValueBox({
    req(input$country_input, cancelOutput = T)
    req(input$movie_tv, cancelOutput = T)
    
    top_dir <- df_netflix %>%
      filter(
        director != "Unknown",
        type %in% input$movie_tv,
        country %in% input$country_input
      ) %>%
      group_by(director) %>%
      summarise(num_of_content = n()) %>%
      ungroup() %>%
      arrange(desc(num_of_content)) %>%
      head(1)
    
    valueBox(
      value = top_dir$director,
      subtitle = "Top Director by Content Counts",
      color = "red",
      icon = icon("video")
    )
  })
  
  # Top 10 Directors
  output$director_plot <- renderPlotly({
    director_plot <- df_netflix %>%
      filter(director != "Unknown") %>%
      filter(year_added %>% between(input$year_added2[1], input$year_added2[2])) %>%
      group_by(director) %>%
      summarise(num_of_contents = n()) %>%
      ungroup() %>%
      arrange(desc(num_of_contents)) %>%
      head(10) %>%
      ggplot(aes(x = num_of_contents, y = fct_reorder(director, num_of_contents))) +
      geom_col(fill = "#FEDF00", alpha = .9, aes(
        text = paste0(director, "<br>",
                      "Num. of Contents: ",
                      num_of_contents)
      )) +
      scale_y_discrete(
        label = function(x)
          stringr::str_trunc(x, 12)
      ) +
      labs(
        title = NULL,
        x = "Number of Contents",
        y = "",
        color = "",
      ) +
      theme_minimal() +
      theme(
        title = element_text(face = "bold"),
        text = element_text(family = "lato"),
        panel.grid = element_blank(),
        panel.grid.major.x = element_line(color = "grey88"),
        axis.text.y = element_text(angle = 45)
      )
    
    ggplotly(director_plot, tooltip = "text") %>%
      config(displayModeBar = F)
  })
  
  
  # Boxplot Age by Movies and TV Shows
  
  output$age_dist <- renderPlotly({
    box_plot <- df_netflix %>%
      mutate(age_dist = (max(df_netflix$date_added) - date_added) / 365) %>%
      filter(
        target_age %in% input$viewers_cat,
        release_year %>%  between(input$release_year[1], input$release_year[2])
      ) %>%
      ggplot(aes(x = type, y = age_dist)) +
      geom_boxplot(width = 0.05, aes(fill = type), alpha = 0.8) + #add stat_summary next time
      scale_fill_manual(values = c("firebrick", "grey16")) +
      labs(x = "",
           y = "Num. of Years", ) +
      theme_minimal() +
      theme(
        legend.position = "none",
        text = element_text(family = "lato"),
        panel.grid.major.x = element_blank()
      )
    
    ggplotly(box_plot) %>%
      config(displayModeBar = F)
  })
  
  
  # World Map for Movies or TV Shows
  output$map_dist <- renderPlotly({
    count_country <- netflix_for_map %>%
      filter(type %in% input$mtv_map) %>%
      group_by(main_country) %>%
      summarise(content_count = n()) %>%
      ungroup() %>%
      arrange(desc(content_count))
    
    map_join <- mapdata %>%
      left_join(. , count_country, by = c("region" = "main_country")) %>%
      mutate(content_count = replace_na(content_count, 0))
    
    
    temp <- ggplot() +
      geom_polygon(
        data = map_join,
        aes(
          fill = content_count,
          x = long,
          y = lat,
          group = group,
          text = paste0(region, "<br>",
                        "Netflix Contents: ", content_count)
        ),
        size = 0,
        alpha = .9,
        color = "black"
      ) +
      theme_void() +
      scale_fill_gradient(
        name = "Content Count",
        trans = "pseudo_log",
        breaks = c(0, 7, 56, 403, 3000),
        labels = c(0, 7, 56, 403, 3000),
        low =  "bisque2",
        high = "#b20710"
      ) +
      theme(
        panel.grid.major = element_blank(),
        axis.line = element_blank(),
        text = element_text(family = "lato")
      )
    
    
    ggplotly(temp, tooltip = "text") %>%
      config(displayModeBar = F)
    
  })
  
  # Network Casting and Directors
  output$dir_cast <- renderSimpleNetwork({
    
    req(input$dir_cast_net1, cancelOutput = T)
    
    dir_cast_network <- for_network %>% 
      filter(director != "Unknown",
             cast != "Unknown",
             cast %in% input$dir_cast_net1)
    
    simpleNetwork(dir_cast_network, height = "50%", width = "100%",
                  Source = 1,
                  Target = 2,
                  zoom = T,
                  linkDistance = 100,
                  fontSize = 14,
                  charge = -100,
                  fontFamily = "Candara",
                  nodeColour = "#A93226")
  })
  
  
  # TV Shows vs Movies in Years
  output$mtv_growth <- renderPlotly({
    accumulate_by <- function(dat, var) {
      var <- lazyeval::f_eval(var, dat)
      lvls <- plotly:::getLevels(var)
      dats <- lapply(seq_along(lvls), function(x) {
        cbind(dat[var %in% lvls[seq(1, x)],], frame = lvls[[x]])
      })
      dplyr::bind_rows(dats)
    }
    
    mtv_growth <- df_netflix %>%
      group_by(year_added, type) %>%
      summarise(movie_count = n()) %>%
      ungroup() %>%
      mutate(cumulative_count = ave(movie_count, type, FUN = cumsum)) %>%
      accumulate_by( ~ year_added) %>%
      ggplot(aes(
        x = year_added,
        y = cumulative_count,
        color = type,
        frame = frame
      )) +
      geom_line(size = 1.5, alpha = 0.8) +
      geom_point(
        size = 3.5,
        shape = 21,
        fill = "white",
        aes(
          text = paste0(
            "Year: ",
            year_added,
            "<br>",
            "Content Count: ",
            cumulative_count
          )
        )
      ) +
      scale_color_manual(values = c("firebrick", "grey16")) +
      scale_y_continuous(labels = scales::comma) +
      labs(
        title = "Growth Numbers of Netflix Contents by Year",
        x = "",
        y = "Num. of Contents",
        color = "",
      ) +
      theme_minimal() +
      theme(title = element_text(face = "bold"),
            text = element_text(family = "lato"))
    
    
    ggplotly(mtv_growth, tooltip = c("text", "frame")) %>%
      animation_slider(currentvalue = list(prefix = "Year: ", font = list(color = "grey16"))) %>%
      config(displayModeBar = F)
  })
  
  
  # ==========================
  #   PAGE 2 - Spotify
  # ==========================
  
  # Wordcloud Genre based on counts
  output$wordcloud2 <- renderWordcloud2({
    spotify_by_genre <- spotify_genre %>% 
      select(genres, counts) %>% 
      arrange(desc(counts)) %>% 
      head(300)
    
    wordcloud2(spotify_by_genre, color = "random-dark", backgroundColor = "transparent")
  })
  
  
  # Trending Music Taste in Year
  output$plot1 <- renderPlotly({
    plot_time <- ggplot(data_year, aes(x = year, y = value)) + 
      geom_line(aes(color = variable)) + 
      scale_color_manual(values = c("red", "green", "orange", "purple")) + 
      guides(color = "none") + 
      labs(x = "Year", y = "Value", title = "Music Taste in the Past Century") + 
      scale_x_continuous(limits = c(1920, 2020), breaks = seq(1920, 2020, 20)) +
      theme_minimal()
    
    ggplotly(plot_time)
  })
  
  
  # Top Artists Popularity
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
  
  # Song of the Year
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

  # Popularity Score Song of The Year
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
  
   
  # EXPLICIT : Plot Correlation Between Feature Music Characteristics
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
   
  # MODE : Plot Correlation Between Feature Music Characteristics
  output$plot_corr_mode <- renderPlotly({
     data_agg_4 <- spotify_clean %>%
       filter(year == input$year2) %>%
       arrange(desc(popularity)) %>%
       head(input$head)
     
     plot_dist <- ggplot(data_agg_4, 
                         aes_string(x = input$xlabel, y = input$ylabel)) +
       geom_jitter(aes(col = as.factor(mode),
                       text = glue("{str_to_upper(mode)}
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
   

   
   # Show Datasets Spotify
   output$data <- renderDataTable({
     DT::datatable(data = spotify, options = list(scrollX=T))
   })
   
   
})

 