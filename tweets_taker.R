# Twitter Credentials ####
setwd("~/Desktop/R Studio Project/Tweet Analysis")

library(twitteR) # scraping tweets
library(dplyr) # data manipulation
library(tmap) #  geocoding
library(tmaptools) # geocoding

consumerKey = '3jmA1BqasLHfItBXj3KnAIGFB'
consumerSecret = 'imyEeVTctFZuK62QHmL1I0AUAMudg5HKJDfkx0oR7oFbFinbvA'

accessToken = '265857263-pF1DRxgIcxUbxEEFtLwLODPzD3aMl6d4zOKlMnme'
accessTokenSecret = 'uUFoOOGeNJfOYD3atlcmPtaxxniXxQzAU4ESJLopA1lbC'

setup_twitter_oauth(consumerKey,consumerSecret,accessToken,accessTokenSecret)

# Twitter Scraper ####

# Query Search & # of Tweets
search_term <- "$SPY"
n_tweets <- 20000

# Geocode if you want to localize tweets

#geocode <- geocode_OSM('Nola')$coords
#geocode  <- paste0(geocode[2],',',geocode[1],",",'1km')


# Last 7 days
today_since <- as.Date(Sys.Date())
yesterday_since <- as.Date(Sys.Date())-6
since_times <- seq.Date(from = yesterday_since, to = today_since, by =  1)

today_until  <-  as.Date(Sys.Date()) + 1
yesterday_until <- as.Date(Sys.Date()) - 5
until_times <- seq.Date(from=yesterday_until,to=today_until,by=1)

#  Scraper Loop
df_tweets <- data.frame()
for (i in seq_along(since_times)) {
  for(j in seq_along(until_times)){
    
    df_temp <- searchTwitter(search_term,
                             n=n_tweets,
                             lang="en",
                  since=as.character(since_times[i]),
                  until=as.character(until_times[j])) %>% twListToDF()
    
    df_tweets <- rbind(df_tweets, df_temp)
    print(paste(nrow(df_tweets),"Tweets Scraped"))
  }
}

# Remove ALL & Save as csv
rm(since_times,df_temp,i,j,today_since,today_until,until_times,yesterday_since,yesterday_until,geocode)
rm(consumerKey,consumerSecret,accessToken,accessTokenSecret)
write.csv(df_tweets,paste0(search_term,'.csv'))



