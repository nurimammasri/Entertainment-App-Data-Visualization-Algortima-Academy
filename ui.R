dashboardPage(
  
  skin = "green",
  
  # HEADER
  dashboardHeader(title = "Entertainment App - Spotify & Netflix"),
  
  # SIDEBAR
  dashboardSidebar(
    sidebarMenu(
      menuItem("Trending Overview", tabName = "Trending", icon = icon("music")),
      menuItem(text = "Statistics", tabName = "stats", icon = icon("chart-line")),
      menuItem("Data", tabName = "tab_data", icon = icon("table")),
      menuItem("Info", tabName = "User_Profile", icon = icon("eye"))
    )
  ),
  
   # BODY
   dashboardBody(
     tabItems(
       
       # PAGE 1 #
       
       tabItem(tabName = "Trending",
               fluidPage(
                 h2(tags$b("Spotify ✨")),
                 div(style = "text-align:justify",
                     p("Spotify adalah layanan streaming musik digital. Spotify mengubah mendengarkan musik selamanya ketika diluncurkan pada tahun 2008. Ini memberi Anda akses instan ke perpustakaan musik dan podcast online yang luas, memungkinkan Anda mendengarkan konten apa pun pilihan Anda kapan saja.
                        Oleh karena itu, Saya ingin menunjukkan bagaimana setiap kontent di kedua platform tersebut dan karakteristiknya, agar beberapa orang yang baru atau sedang ingin menerima hiburan bisa mendapatkan rekomendasi dari dashboard ini :
                      "),
                     p(" - Meningkatkan kesadaran masyarakat terhadap entertainments apps"),
                     p(" - Memberikan informasi mengenai konten di kedua aplikasi (track listening/watching, taste, genre, dll)"),
                     p(" - Memperlihatkan trending data konten di kedua aplikasi"),
                     br()
                     )
               ),
               
               fluidRow(
                 valueBox("80 Million", "Tracks", icon = icon("music"), color = "red"),
                 valueBox("4.7 Million", "Podcasts", icon = icon("headphones"), color = "purple"),
                 valueBox("183 Millions" , "Markets", icon = icon("globe-asia"), color = "blue"),
                 valueBox("456 Million", "Active Users", icon = icon("play-circle"), color = "green"),
                 valueBox("195 Million", "Subscribers", icon = icon("user"), color = "orange"),
                 valueBox("4 Billion+", "Playlists", icon = icon("record-vinyl"), color = "fuchsia")
               ),
               
               fluidRow( 
                 plotlyOutput("plot1"),
                 br()
               )
       ),
       
       
       # PAGE 2 #
       
       tabItem(tabName = "stats",
               
               fluidPage(
                 
                 box(width = 8,
                     solidHeader = T,
                     title = tags$b("Trending Music in a year"),
                     plotlyOutput("plot_rank")),
                 box(width = 4,
                     solidHeader = T,
                     height = 150,
                     background = "purple",
                     selectInput(inputId = "year1",
                                 label = "Select Year",
                                 choices = sort(unique(spotify_clean$year), decreasing = TRUE),)
                 ),
                 
                 valueBoxOutput("SOTY", width = 4),
                 valueBoxOutput("Popularity",width = 4),
                 br()
               ),
               
               fluidPage(
                 h2(tags$b("Genre based on Popularity on Spotify")),
                 wordcloud2Output("wordcloud2"),
                 br()
               ),
               
               
               #correlation plot
               fluidPage(
                 tabBox(width = 9,
                        title = tags$b("Songs Correlation on Spotify"),
                        side = "right",
                        tabPanel(tags$b("by Mode"),
                                 plotlyOutput("plot_corr_mode", height=480)
                        ),
                        tabPanel(tags$b("by Explicitness"),
                                 plotlyOutput("plot_corr_explicit", height=480)
                        )
                 ),
                 box(width = 3,
                     solidHeader = T,
                     background = "purple",
                     selectInput(inputId = "year2",
                                 label = "Select Year",
                                 choices = sort(unique(spotify_clean$year), decreasing = TRUE))
                 ),
                 box(width = 3,
                     solidHeader = T,
                     background = "green",
                     selectInput(inputId = "xlabel",
                                 label = "Select X Axis",
                                 choices = spotify_clean %>%
                                   select('energy', 'valence', 'acousticness', 'danceability',
                                          'instrumentalness', 'liveness', 'loudness', 'speechiness', 'tempo') %>%
                                   names()),
                     selectInput(inputId = "ylabel",
                                 label = "Select Y Axis",
                                 choices = spotify_clean %>%
                                   select('loudness', 'valence', 'acousticness', 'danceability',
                                          'instrumentalness', 'liveness', 'energy', 'speechiness', 'tempo') %>%
                                   names())
                 ),
                 box(tags$b("Choose whether to display trend"),
                     width = 3,
                     solidHeader = T,
                     background = "green",
                     checkboxInput("trend", "Display trend", FALSE)
                 ),
                 box(width = 3,
                     solidHeader = T,
                     background = "purple",
                     sliderInput("head", "Number of data", min = 100, max = nrow(spotify_clean), value = 1000)
                 )
               )
       ),
       
       # PAGE 3
       
       tabItem(tabName = "tab_data", 
               fluidPage(
                 h2(tags$b("Understanding the Data")),
                 br(),
                 dataTableOutput(outputId = "data"),
                 br(),
                 div(style = "text-align:justify", 
                     p("This dashboard uses a dataset from ", tags$a(href="https://www.kaggle.com/datasets/vatsalmavani/spotify-dataset", "kaggle"), " which is cleaned"),
                     
                     br()
                 )
               )
       ),
       
       # PAGE 3
       
       tabItem(tabName = "User_Profile", 
               fluidPage(
                 h2(tags$b("Profile User")),
                 br(),
                 br(),
                 div(style = "text-align:justify",
                     p("This project is made by Nur Imam Masri as Capstone Project for completing Data Visualization Specialist in Algoritma Data Science School. You can connect me through ", 
                       tags$a(href="https://www.linkedin.com/in/nurimammasri/", "linkedin"), 
                       " and please feel free to hit me up"))))
       
     )
   )
)





