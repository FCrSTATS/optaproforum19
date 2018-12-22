# process the possesion seqence data

require(tidyverse)


oldw <- getOption("warn")
options(warn = -1)


files.list <- paste0("Data/f73_processed/", list.files("Data/f73_processed/"))

seq_database = data.frame(stringsAsFactors = F)

for (f in files.list) {
    
    dat = read_csv(f)
    
    sequence_ids <- unique(dat$sequence_id)
    sequence_ids <- sequence_ids[!is.na(sequence_ids)]

    sequence.database <- dat %>% 
      group_by(sequence_id) %>% 
      summarise(total.actions = n(), 
                players.involved = paste(unique(player_id), collapse=", "),
                team_id = names(which.max(table(team_id)))
                )
    sequence.database$game_id <- unique(dat$game_id)
    seq_database <- bind_rows(seq_database, sequence.database)
    cat(".")

}


write.csv(seq_database, "Data/sequence_database.csv")


options(warn = oldw)


