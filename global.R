# Import Library Dashboard
library(shiny)
library(shinydashboard)
library(shinyWidgets)

# Import Library Visualization
library(tidyverse)
library(dplyr) # untuk transformasi data
library(plotly) # untuk membuat plot menjadi interaktif
library(glue) # untuk custom informasi saat plot interaktif
library(scales) # untuk custom keterangan axis atau lainnya
library(tidyr) # untuk custom keterangan axis atau lainnya
library(stringr)# untuk melakuan kustom teks pada tooltip
library(DT) # untuk menampilkan dataset
library(wordcloud2)
library(lubridate)
library(igraph)
library(networkD3)
library(highcharter)
library(visdat)

# Setting Agar tidak muncul numeric value
options(scipen = 99)


# SPOTIFY ALL
spotify <-
  read_csv("datasets/spotify/data.csv", show_col_types = FALSE)
spotify$artists <-
  str_replace_all(spotify$artists, c("\\[" = "", "\\]" = "", "'" = ""))

chr_cols <- c("artists", "name", "id", "release_date")
fct_cols <- c("explicit", "mode")
num_cols <-
  c(
    "valence",
    "acousticness",
    "danceability",
    "energy",
    "instrumentalness",
    "liveness",
    "loudness",
    "speechiness",
    "tempo"
  )
int_cols <- c("year", "duration_ms", "key", "popularity")

spotify_clean <- spotify %>%
  mutate(across(all_of(fct_cols), as.factor)) %>%
  mutate(across(all_of(num_cols), as.numeric)) %>%
  mutate(across(all_of(int_cols), as.integer)) %>%
  mutate(release_date = ifelse(
    nchar(release_date) == 4,
    paste(release_date, "-01-01", sep = ""),
    release_date
  )) %>%
  mutate(release_date = as.Date(release_date)) %>%
  arrange(spotify$year)


# SPOTIFY BY GENRE
spotify_genre <-
  read_csv("datasets/spotify/data_by_genres.csv", show_col_types = FALSE)

fct_cols <- c("mode", "genres")
num_cols <-
  c(
    "valence",
    "acousticness",
    "danceability",
    "energy",
    "instrumentalness",
    "liveness",
    "loudness",
    "speechiness",
    "tempo"
  )
int_cols <- c("duration_ms", "key", "popularity")

spotify_genre_clean <- spotify_genre %>%
  mutate(across(all_of(fct_cols), as.factor)) %>%
  mutate(across(all_of(num_cols), as.numeric)) %>%
  mutate(across(all_of(int_cols), as.integer))


# SPOTIFY BY YEAR
spotify_year <-
  read_csv("datasets/spotify/data_by_year.csv", show_col_types = FALSE)

data_year <- spotify_year %>%
  select(year, acousticness, energy, instrumentalness, liveness) %>%
  gather(key = "variable", value = "value", -year)




# NETFLIX ALL
df_netflix <- read.csv("datasets/netflix/netflix_titles.csv")
df_netflix[is_empty(df_netflix) | df_netflix == ""] <- NA


# Handling Missing Values
mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

df_netflix <- df_netflix %>%
  replace_na(
    list(
      director = "Unknown",
      cast = "Unknown",
      country = mode(df_netflix$country),
      date_added = mode(df_netflix$date_added),
      rating = mode(df_netflix$rating)
    )
  )


# Handling Feature extraction
df_netflix <- df_netflix %>%
  mutate(
    main_country = map(str_split(country, ", "), 1),
    main_cast = map(str_split(cast, ", "), 1),
    genre = map(str_split(listed_in, ", "), 1)
  ) %>%
  unnest(cols = c(main_country, main_cast, genre)) %>%
  mutate(
    type = as.factor(type),
    date_added = mdy(date_added),
    year_added = year(date_added),
    main_country = str_remove(main_country, ","),
    target_age = factor(
      sapply(
        rating,
        switch,
        'TV-PG' = 'Older Kids',
        'TV-MA' = 'Adults',
        'TV-Y7-FV' = 'Older Kids',
        'TV-Y7' = 'Older Kids',
        'TV-14' = 'Teens',
        'R' = 'Adults',
        'TV-Y' = 'Kids',
        'NR' = 'Adults',
        'PG-13' = 'Teens',
        'TV-G' = 'Kids',
        'PG' = 'Older Kids',
        'G' = 'Kids',
        'UR' = 'Adults',
        'NC-17' = 'Adults'
      ),
      level = c("Kids", "Older Kids", "Teens", "Adults")
    )
  )


# Split Data based on Type
movie_df <- df_netflix %>%
  filter(type == "Movie")

tv_df <- df_netflix %>%
  filter(type == "TV Show")

top_type <- df_netflix %>%
  group_by(type) %>%
  summarise(n_type = n()) %>%
  ungroup() %>%
  arrange(desc(n_type)) %>%
  mutate(percent = round(n_type / sum(n_type), 2))


# For World Map
mapdata <- map_data("world")

netflix_for_map <- df_netflix %>%
  mutate(main_country = str_replace_all(
    main_country,
    c(
      "United States" = "USA",
      "United Kingdom" = "UK",
      "Hong Kong" = "China",
      "Soviet Union" = "Russia",
      "West Germany" = "Germany"
    )
  ))


# Network director vs cast
for_network <- df_netflix %>%
  select(director, cast) %>%
  mutate(director = str_split(director, ", ")) %>%
  unnest(cols = c(director)) %>%
  mutate(cast = str_split(cast, ", ")) %>%
  unnest(c(cast))
