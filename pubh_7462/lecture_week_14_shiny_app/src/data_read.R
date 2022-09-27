#Libraries
library(tidyverse, quietly = TRUE)

#Read in the nyc airbnb data set
nyc.df <- read_csv("./data/nyc_airbnb.csv", show_col_types = FALSE) %>%
  mutate(rating  = review_scores_location / 2) %>%
  filter(price <= 1000) %>%
  rename(borough = neighbourhood_group) %>%
  dplyr::select(borough, neighbourhood, rating, price,
                room_type, lat, long, contains("review")) %>%
  drop_na(rating) %>%
  mutate(
    text_label = str_c(neighbourhood, 
                       "\nPrice: "  ,  scales::dollar(price),
                       "\nRating: ",    rating, "/5",
                       "\nReviews/Month: ", reviews_per_month)
  )

#Create static variables to be called in the definition of the ui
#Pull all the different boro names (5)
boro_choices <- nyc.df %>%
  distinct(borough) %>%
  pull()

#Price range (vector length 2 w/ min max)
price_range <- nyc.df %>% 
  pull(price) %>%
  range()

#Pull all the different room choices
room_choices <- nyc.df %>%
  distinct(room_type) %>%
  pull()