# Process minutes played
setwd("~/OPF19")

# load libraries 
library(tidyverse)

list.of.files = paste0("Data/f73_processed/", list.files("Data/f73_processed/"))

i = list.of.files[1]

Minutes.Played = data.frame(stringsAsFactors = F)

for (f in list.of.files) {
    
    dat = read_csv(f)     
    
    lineups = dat %>% filter(period_id == 16 & type_id == 34)
    subs.on = dat %>% filter(type_id == 19) %>% select(player_id, min)
    subs.off = dat %>% filter(type_id == 18) %>% select(player_id, min)
    
    player_id = trimws(c(unlist(str_split(lineups$'30'[1], ",")), unlist(str_split(lineups$'30'[2], ","))))
    pos.ids = trimws(c(unlist(str_split(lineups$'131'[1], ",")), unlist(str_split(lineups$'131'[2], ","))))
    pos.types = trimws(c(unlist(str_split(lineups$'44'[1], ",")), unlist(str_split(lineups$'44'[2], ","))))
    jersey.nos = trimws(c(unlist(str_split(lineups$'59'[1], ",")), unlist(str_split(lineups$'59'[2], ","))))
    
    player.data = data.frame(player_id, pos.ids, pos.types, jersey.nos, stringsAsFactors = F)
    player.data$MatchLength = ifelse(player.data$pos.ids == "0", 0, max(dat$min))
    player.data
    
    subs.on
    subs.off
    
    
    for (i in 1:nrow(player.data)) {
      row = player.data[i,]
      if(row$player_id %in% subs.on$player_id){
        temp <- subs.on %>% filter(player_id == row$player_id)
        player.data[i,]$MatchLength <- max(dat$min) - temp$min
      }else{}
    }
    
    
    for (i in 1:nrow(player.data)) {
      row = player.data[i,]
      if(row$player_id %in% subs.off$player_id){
        temp <- subs.off %>% filter(player_id == row$player_id)
        player.data[i,]$MatchLength <- temp$min
      }else{}
    }
    
    player.data <- player.data %>% filter(MatchLength != 0)
    player.data$game_id <- unique(dat$game_id)
    Minutes.Played <- bind_rows(Minutes.Played, player.data)
}

Results.Total <- Minutes.Played %>% group_by(player_id) %>% summarise(Total.Minutes.Played = sum(MatchLength))
write.csv(Results.Total, "Data/minutes_played_per_player.csv")
write.csv(Minutes.Played, "Data/minutes_played_per_game.csv")

