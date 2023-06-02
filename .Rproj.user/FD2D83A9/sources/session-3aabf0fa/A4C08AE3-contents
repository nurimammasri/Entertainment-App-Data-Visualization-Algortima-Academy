dashboardPage(
  
  skin = "green",
  
  # HEADER
  dashboardHeader(title = "Spotify Analysis"),
  
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
                h2(tags$b("Spotify: Listening is Everything")),
                div(style = "text-align:justify",
                    p("Spotify is a digital music streaming service. Spotify transformed music listening forever when it launched in 2008.
                       It gives you instant access to its vast online library of music and podcasts, 
                       allowing you to listen to any content of your choice at any time. 
                       It is both legal and easy to use. Spotify is available across a range of devices, 
                       including computers, phones, tablets, speakers, TVs, and cars, and you can easily transition 
                       from one to another with Spotify Connect. Our Mission is to unlock the potential 
                       of human creativity—by giving a million creative artists the opportunity to live 
                       off their art and billions of fans the opportunity to enjoy and be inspired by it."),
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
              
              plotlyOutput("plot1"),
              br(),
              
              fluidPage( 
                h2(tags$b("Genre based on Popularity on Spotify")),
                wordcloud2Output("wordcloud2"),
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
                                choices = sort(unique(spotify_clean$year), decreasing=TRUE),)
                ),
                
                valueBoxOutput("SOTY", width = 4),
                valueBoxOutput("Popularity",width = 4),
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
                                choices = unique(spotify_clean$year))
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





