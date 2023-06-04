dashboardPage(
  skin = "red",
  
  # HEADER
  dashboardHeader(title = tags$b(span(
    tagList(icon = icon("chart-line"), "Entertainment App"),
    style = "font-size: 19px"
  ))),
  
  # SIDEBAR
  dashboardSidebar(sidebarMenu(
    menuItem("Netflix", tabName = "Netflix", icon = icon("film")),
    menuItem("Spotify", tabName = "Spotify", icon = icon("spotify")),
    menuItem("Data", tabName = "tab_data", icon = icon("table")),
    menuItem("Info", tabName = "User_Profile", icon = icon("eye"))
  )),
  
  # BODY
  dashboardBody(
    tags$head(tags$style(
      HTML(
        '/* logo */
                            .skin-blue .main-header .logo {
                            background-color: #080200 ;
                            font-family: "Corbel";
                            font-weight: bold;
                            font-size: 24px;
                            }
                            /* logo when hovered */
                            .skin-blue .main-header .logo:hover {
                            background-color: #080200;
                            font-family: "Corbel";
                            font-weight: bold;
                            font-size: 24px;
                            }
                            /* navbar (rest of the header) */
                            .skin-blue .main-header .navbar {
                            background-color: #080200;
                            }
                            /* main sidebar */
                            .skin-blue .main-sidebar {
                            background-color: #A93226;
                            font-family: "Corbel";
                            }
                            /* active selected tab in the sidebarmenu */
                            .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                            background-color: #CD6155;
                            color: white;
                            font-family: "Corbel";
                            }
                            /* other links in the sidebarmenu */
                            .skin-blue .main-sidebar .sidebar .sidebar-menu a{
                            background-color: #A93226;
                            color: white;
                            font-family: "Corbel";
                            }
                            /* other links in the sidebarmenu when hovered */
                            .skin-blue .main-sidebar .sidebar .sidebar-menu a:hover{
                            background-color: #CD6155;
                            color: white;
                            font-family: "Corbel";
                            }
                            /* toggle button when hovered  */
                            .skin-blue .main-header .navbar .sidebar-toggle:hover{
                            background-color: #CD6155;
                            }
                            /* body */
                            .content-wrapper, .right-side {
                            background-color: #ffffff;
                            font-family: "Corbel";
                            }
                            /* icon */
                            .fa {
                            color: #ffffff;
                            opacity: 0.29;
                            }
                            /* header fonts */
                            h1,h2,h3,h4,h5,h6,.h1,.h2,.h3,.h4,.h5,.h6 {
                            font-family: "Candara";
                            }
                            /*icon coloring gray*/
                            .ic_gray {color:#808080}'
      )
    )),
    
    tabItems(
      # ==========================
      #   PAGE 1 - Netflix
      # ==========================
      
      tabItem(
        tabName = "Netflix",
        
        fluidPage(
          h2(tags$b("🎬 Netflix Dashboard 🎬")),
          div(
            style = "text-align:justify",
            
            
            p(
              tags$b("Aplikasi hiburan"),
              "adalah salah satu hal yang harus ada didalam smartphone
                     Android yang kita miliki. Bagaimana tidak, sehari-hari kita bekerja menggunakan ponsel.
                     Bahkan tidak jarang kita bosan melihat aplikasi yang ada di smartphone.Salah satu cara untuk mengusir penat ketika weekday masih berlangsung adalah
                     menggunakan smartphone dengan lebih bermanfaat untuk kesenangan kita. Kita bisa
                     memiliki satu bahkan beberapa aplikasi hiburan untuk membuat pikiranmu relax kembali.
                     Aplikasi hiburan ini dapat menyertakan konten video, teks, atau audio."
            ),
            
            p(
              tags$b("Netflix"),
              "adalah layanan streaming yang menawarkan berbagai acara TV pemenang
                              penghargaan, film, anime, dokumenter, dan banyak lagi di ribuan perangkat yang
                              terhubung ke Internet. Kita bisa menonton sepuasnya, kapan pun dengan satu
                              harga bulanan yang murah. Netflix adalah layanan streaming yang hadir dengan
                              koleksi acara populer, film terbaik sepanjang masa, dan juga acara asli Netflix."
            ),
            
            p(
              "Oleh karena itu, Saya ingin menunjukkan bagaimana setiap kontent di kedua platform
                       tersebut dan karakteristiknya, agar beberapa orang yang baru atau sedang ingin menerima
                       hiburan bisa mendapatkan rekomendasi dari dashboard ini :"
            ),
            
            p(
              " - Meningkatkan kesadaran masyarakat terhadap entertainments apps"
            ),
            p(
              " - Memberikan informasi mengenai konten di kedua aplikasi (track listening/watching, taste, genre, dll)"
            ),
            p(" - Memperlihatkan trending data konten di kedua aplikasi"),
            br()
          )
        ),
        
        fluidRow(
          column(
            width = 12,
            offset = 0,
            div(
              style = "width:100%;0",
              valueBox(
                number(nrow(df_netflix), big.mark = ","),
                "Total Movies & TV Shows",
                icon = icon("star"),
                color = "orange"
              ),
              valueBox(
                paste(round(nrow(movie_df) / nrow(df_netflix), 2) * 100, "%"),
                "Percentage of Movies",
                icon = icon("film", class = "ic_gray"),
                color = "black"
              ),
              valueBox(
                paste(round(nrow(tv_df) / nrow(df_netflix), 2) * 100, "%"),
                "Percentage of TV Shows",
                icon = icon("tv"),
                color = "red"
              )
              
            )
          ),
          box(
            width = 4,
            height = 370,
            solidHeader = T,
            highchartOutput("type_plot2"),
            br()
          ),
          column(width = 8, box(
            solidHeader = T,
            width = 12,
            plotlyOutput("mtv_growth", height = 350)
          ))
        ),
        
        
        
        fluidRow(
          column(
            width = 9,
            box(solidHeader = T,
                h3(tags$b("Most Common Genres")),
                plotlyOutput("genre_plot")),
            box(solidHeader = T,
                h3(tags$b(
                  "Most Common Directors"
                )),
                plotlyOutput("director_plot"))
          ),
          br(),
          br(),
          column(
            width = 3,
            valueBoxOutput(width = 16, "pop_cast"),
            valueBoxOutput(width = 16, "pop_dir"),
            box(
              width = 16,
              background = "black",
              sliderInput(
                inputId = "year_added",
                label = h4(tags$b("Year Range of Content Added in Platform: ")),
                min = min(df_netflix$year_added),
                max = max(df_netflix$year_added),
                value = c(min(df_netflix$year_added), max(df_netflix$year_added)),
                width = "100%",
                sep = ""
              )
            ),
            
          )
        ),
        
        
        fluidRow(column(
          width = 9,
          box(
            width = 16,
            solidHeader = T,
            h3(tags$b("Number of Casts by Countries")),
            plotlyOutput("no_cast")
          )
        ),
        column(
          width = 3,
          box(
            solidHeader = T,
            width = 16,
            height = 475,
            background = "black",
            pickerInput(
              inputId = "country_input",
              label = h4(tags$b("Select Country:")),
              choices = unique(df_netflix$main_country),
              options = list(`actions-box` = TRUE, `live-search` = TRUE),
              multiple = T,
              selected = unique(df_netflix$country)
            ),
            checkboxGroupInput(
              inputId = "movie_tv",
              label = h4(tags$b("Movies/TV Shows Categories:")),
              choices = unique(df_netflix$type),
              selected = unique(df_netflix$type)
            )
          ),
        )),
        
        
        fluidRow(column(
          width = 9,
          box(
            width = 16,
            solidHeader = T,
            h3(tags$b("Distribution of Age of Contents")),
            h5(tags$b("By Time Difference to The Latest Content")),
            plotlyOutput("age_dist")
          )
        ),
        column(
          width = 3,
          box(
            width = 16,
            height = 500,
            solidHeader = T,
            background = "black",
            checkboxGroupInput(
              inputId = "viewers_cat",
              label = h4(tags$b("Select Viewers Category: ")),
              choices = unique(df_netflix$target_age),
              selected = unique(df_netflix$target_age)
            ),
            chooseSliderSkin("Nice"),
            sliderInput(
              inputId = "release_year",
              label = h4(tags$b("Year Range of Content Release:")),
              min = min(df_netflix$release_year),
              max = max(df_netflix$release_year),
              value = c(min(df_netflix$release_year), max(df_netflix$release_year)),
              width = "100%",
              sep = ""
            )
          )
        )),
        
        
        
        fluidRow(
          box(
            width = 12,
            solidHeader = T,
            background = "red",
            column(width = 9,
                   h3(
                     tags$b("Netflix Content Distribution by Country")
                   )),
            column(
              width = 3,
              checkboxGroupInput(
                inputId = "mtv_map",
                label = h4(tags$b("Movie/TV Show: ")),
                choices = unique(df_netflix$type),
                selected = unique(df_netflix$type),
                inline = T
              )
            )
          )
        ),
        fluidRow(box(
          width = 12,
          solidHeader = T,
          plotlyOutput("map_dist", height = 580)
        )),
        
        
        
        box(
          width = 12,
          solidHeader = T,
          background = "red",
          column(width = 9,
                 h3(tags$b(
                   "Director and Casts Network"
                 ))),
          column(
            width = 3,
            selectizeInput(
              inputId = "dir_cast_net1",
              label = h4(tags$b("Select Casts :")),
              choices = unique(for_network$cast),
              selected = c("Adam Sandler", "Drew Barrymore",
                           "Rob Schneider"),
              multiple = T,
              options = list(maxItems = 3, placeholder = "Select up to 3")
            )
          )
        ),
        fluidRow(box(
          width = 12,
          solidHeader = T,
          simpleNetworkOutput("dir_cast", height = 350)
        ))
        
        
        
      ),
      
      # ==========================
      #   PAGE 1 - Spotify
      # ==========================
      
      tabItem(
        tabName = "Spotify",
        fluidPage(h2(tags$b("🎵 Spotify 🎵")),
                  div(
                    style = "text-align:justify",
                    p(
                      "Selain di insdustri per-film-an, juga Musik selalu mengambil bagian besar dari kehidupan kita sehari-hari,
                       mulai dari mandi, mengemudi ke tempat kerja, belajar, atau menunggu seseorang. Percaya atau tidak, musik
                       terus-menerus membentuk kembali (dan dibentuk kembali oleh) budaya kita yang beragam. Pergeseran selera musik
                       dapat dialami secara global dengan maraknya teknologi digital dalam beberapa dekade terakhir.
                       Saat ini, ",
                      tags$b("Spotify"),
                      "sendiri - sebagai layanan langganan streaming audio terpopuler di dunia

                       ",
                      tags$b("Spotify"),
                      " adalah layanan streaming musik digital. Spotify mengubah mendengarkan musik selamanya ketika
                       diluncurkan pada tahun 2008. Ini memberi Anda akses instan ke perpustakaan musik dan podcast online yang
                       luas, memungkinkan Anda mendengarkan konten apa pun pilihan Anda kapan saja."
                    ),
                    br()
                  )),
        
        fluidRow(column(
          width = 12,
          offset = 0,
          div(
            style = "width:100%;0",
            valueBox(
              "80 Million",
              "Tracks",
              icon = icon("music"),
              color = "red"
            ),
            valueBox(
              "4.7 Million",
              "Podcasts",
              icon = icon("headphones"),
              color = "purple"
            ),
            valueBox(
              "183 Millions" ,
              "Markets",
              icon = icon("globe-asia"),
              color = "blue"
            ),
            valueBox(
              "456 Million",
              "Active Users",
              icon = icon("play-circle"),
              color = "green"
            ),
            valueBox(
              "195 Million",
              "Subscribers",
              icon = icon("user"),
              color = "orange"
            ),
            valueBox(
              "4 Billion+",
              "Playlists",
              icon = icon("record-vinyl"),
              color = "fuchsia"
            )
          )
        ), ),
        
        
        fluidPage(
          box(
            width = 8,
            solidHeader = T,
            title = tags$b("Trending Music in a year"),
            plotlyOutput("plot_rank")
          ),
          box(
            width = 4,
            solidHeader = T,
            height = 150,
            background = "purple",
            selectInput(
              inputId = "year1",
              label = "Select Year",
              choices = sort(unique(spotify_clean$year), decreasing = TRUE),
            )
          ),
          
          valueBoxOutput("SOTY", width = 4),
          valueBoxOutput("Popularity", width = 4),
          br()
        ),
        
        fluidPage(
          box(
            width = 8,
            solidHeader = T,
            title = tags$b("Preference Shifts in Music"),
            plotlyOutput("plot1"),
          ),
          box(
            width = 4,
            height = 460,
            background = "navy",
            h3("It's changing!"),
            div(
              style = "text-align:justify",
              p(
                "Music has been less acoustic and instrumental for the last 7 decades.
                        This means that many tracks nowadays were made through electric or electronic means (less acoustic)
                        and contains more vocal content like spoken words (less instrumental). The year 2020 marks their lowest points."
              ),
              p(
                "As the acousticness and instrumentalness plummeted down, the energy went up,
                        meaning that many tracks are getting more perceptual measure of intensity and activity within."
              ),
              p(
                "Liveness (presence of an audience in the recording) has been relatively stable throughout the years."
              ),
              p(tags$b("What will the future music sound like?"))
            )
          )
        ),
        
        fluidPage(
          box(
            width = 12,
            solidHeader = T,
            title = tags$b("Genre based on Popularity on Spotify"),
            wordcloud2Output("wordcloud2"),
            br()
          ),
          
        ),
        
        
        #correlation plot
        fluidRow(
          tabBox(
            width = 9,
            title = tags$b("Songs Correlation on Spotify"),
            side = "right",
            tabPanel(tags$b("by Mode"),
                     plotlyOutput("plot_corr_mode", height =
                                    480)),
            tabPanel(
              tags$b("by Explicitness"),
              plotlyOutput("plot_corr_explicit", height =
                             480)
            )
          ),
          box(
            width = 3,
            solidHeader = T,
            background = "purple",
            selectInput(
              inputId = "year2",
              label = "Select Year",
              choices = sort(unique(spotify_clean$year), decreasing = TRUE)
            )
          ),
          box(
            width = 3,
            solidHeader = T,
            background = "green",
            selectInput(
              inputId = "xlabel",
              label = "Select X Axis",
              choices = spotify_clean %>%
                select(
                  'energy',
                  'valence',
                  'acousticness',
                  'danceability',
                  'instrumentalness',
                  'liveness',
                  'loudness',
                  'speechiness',
                  'tempo'
                ) %>%
                names()
            ),
            selectInput(
              inputId = "ylabel",
              label = "Select Y Axis",
              choices = spotify_clean %>%
                select(
                  'loudness',
                  'valence',
                  'acousticness',
                  'danceability',
                  'instrumentalness',
                  'liveness',
                  'energy',
                  'speechiness',
                  'tempo'
                ) %>%
                names()
            )
          ),
          box(
            tags$b("Choose whether to display trend"),
            width = 3,
            solidHeader = T,
            background = "green",
            checkboxInput("trend", "Display trend", FALSE)
          ),
          box(
            width = 3,
            solidHeader = T,
            background = "purple",
            sliderInput(
              "head",
              "Number of data",
              min = 100,
              max = nrow(spotify_clean),
              value = 1000
            )
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
                div(
                  style = "text-align:justify",
                  p(
                    "This dashboard uses a dataset from ",
                    tags$a(href = "https://www.kaggle.com/datasets/vatsalmavani/spotify-dataset", "kaggle"),
                    " which is cleaned"
                  ),
                  
                  br()
                )
              )),
      
      # PAGE 3
      
      tabItem(tabName = "User_Profile",
              fluidPage(
                h2(tags$b("Profile User")),
                br(),
                br(),
                div(
                  style = "text-align:justify",
                  p(
                    "This project is made by Nur Imam Masri as Capstone Project for completing Data Visualization Specialist in Algoritma Data Science School. You can connect me through ",
                    tags$a(href = "https://www.linkedin.com/in/nurimammasri/", "linkedin"),
                    " and please feel free to hit me up"
                  )
                )
              ))
      
    )
  )
)
