# Import Library Dashboard
library(shiny)
library(shinydashboard)

# Import Library Visualization
library(tidyverse)
library(ggplot2)
library(dplyr) # untuk transformasi data
library(plotly) # untuk membuat plot menjadi interaktif
library(glue) # untuk custom informasi saat plot interaktif
library(scales) # untuk custom keterangan axis atau lainnya
library(tidyr) # untuk custom keterangan axis atau lainnya
library(stringr)# untuk melakuan kustom teks pada tooltip
library(wordcloud2)
library(readr)

# Import Library Read Table
library(DT) # untuk menampilkan dataset

# Setting Agar tidak muncul numeric value
options(scipen = 99)


spotify <- read_csv("datasets/data.csv", show_col_types = FALSE)
spotify$artists <- str_replace_all(spotify$artists, c("\\[" = "", "\\]" = "", "'"=""))

chr_cols <- c("artists", "name", "id", "release_date")
fct_cols <- c("explicit", "mode")
num_cols <- c("valence", "acousticness", "danceability", "energy", "instrumentalness", "liveness", "loudness", "speechiness", "tempo")
int_cols <- c("year", "duration_ms", "key", "popularity")

spotify_clean <- spotify %>% 
  mutate(across(all_of(fct_cols), as.factor)) %>%
  mutate(across(all_of(num_cols), as.numeric)) %>% 
  mutate(across(all_of(int_cols), as.integer)) %>% 
  mutate(release_date = ifelse(nchar(release_date) == 4, paste(release_date,"-01-01", sep=""), release_date)) %>% 
  mutate(release_date = as.Date(release_date)) %>% 
  arrange(spotify$year)


spotify_genre <- read_csv("datasets/data_by_genres.csv", show_col_types = FALSE)

fct_cols <- c("mode", "genres")
num_cols <- c("valence", "acousticness", "danceability", "energy", "instrumentalness", "liveness", "loudness", "speechiness", "tempo")
int_cols <- c("duration_ms", "key", "popularity")

spotify_genre_clean <- spotify_genre %>% 
  mutate(across(all_of(fct_cols), as.factor)) %>%
  mutate(across(all_of(num_cols), as.numeric)) %>% 
  mutate(across(all_of(int_cols), as.integer))


