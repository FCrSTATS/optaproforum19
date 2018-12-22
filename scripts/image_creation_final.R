# plot the sequences 

# 1. Setup ----------------------------------------------------------------

require(tidyverse)
require(RColorBrewer)

plot_baseplate <- function(){
  
    p <- ggplot() + 
    xlim(0,100) +
    ylim(0,100) +
    coord_flip() + 
    theme_void() + 
      theme(legend.position = "none") + 
      sc + 
      theme(panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_rect(fill = "black"),
            plot.background = element_rect(fill = "black"),
            plot.margin=grid::unit(c(-0.49,-0.49,-0.49,-0.49), "line"))
    return(p)

}


# create the list of files to process
seq.list <- paste0("Data/sequence_lines_per_game/", list.files("Data/sequence_lines_per_game/"))

for (f in seq.list) {
      
      # load the data 
      dat <- read_csv(f)
      
      # create a color palatte from the R colours 
      dat$time_bucket = case_when(
        dat$seq_time <2~2,
        dat$seq_time <4~4,
        dat$seq_time <6~6,
        dat$seq_time <8~8,
        dat$seq_time <10~10,
        dat$seq_time <12~12,
        dat$seq_time <14~14,
        dat$seq_time <16~16,
        dat$seq_time <18~18,
        dat$seq_time <20~20,
        dat$seq_time <22~22,
        dat$seq_time <24~24,
        dat$seq_time <26~26,
        dat$seq_time <28~28,
        dat$seq_time <30~30,
        dat$seq_time <32~32,
        dat$seq_time <34~34,
        dat$seq_time <36~36,
        dat$seq_time <38~38,
        dat$seq_time <40~40,
        dat$seq_time <42~42,
        dat$seq_time <44~44,
        dat$seq_time <46~46,
        dat$seq_time <48~48,
        dat$seq_time <50~50,
        dat$seq_time <52~52,
        dat$seq_time <54~54,
        dat$seq_time <56~56,
        dat$seq_time <58~58,
        dat$seq_time <60~60,
        dat$seq_time <62~62,
        dat$seq_time <64~64,
        dat$seq_time <66~66,
        dat$seq_time <68~68,
        dat$seq_time <70~70,
        dat$seq_time <72~72,
        dat$seq_time <74~74,
        dat$seq_time <76~76,
        dat$seq_time <78~78,
        dat$seq_time <80~80,
        dat$seq_time <82~82,
        dat$seq_time <84~84,
        dat$seq_time <86~86,
        dat$seq_time <88~88,
        dat$seq_time <90~90,
        dat$seq_time <92~92,
        dat$seq_time <94~94,
        dat$seq_time <96~96,
        dat$seq_time <98~98,
        TRUE ~ 100)
      
      # define the colour scale 
      my.colours <- colors()[c(340, 231, 337, 228, 335, 226, 332, 223, 329, 220, 327, 218, 324, 215, 321, 212, 318, 209, 315, 206, 312, 203, 309, 200, 306, 197, 303, 194, 301, 192, 298, 189, 295, 186, 292, 183, 289, 180, 286, 177, 283, 174, 280, 171, 277, 168, 167, 273, 164, 270)]
      length(my.colours)
      sc <- scale_colour_gradientn(colours = my.colours, limits=c(2, 100))
        
      # 2. Create the lists of sequences ----------------------------------------
      seq_range <- seq(1,length(unique(dat$sequence_id)))
      
      for (seq_select in seq_range) {
            
            seq_clip <- dat %>% filter(sequence_id == seq_select)
            
            if(nrow(seq_clip)>3){
              
            # create the basic plot 
            p <- plot_baseplate() + geom_path(data = seq_clip, aes(x = x, y = y, colour = time_bucket, group = 1), size = 1) 

            image.filename <- paste0("Images/dpi64/", unique(seq_clip$sequence_id), "_", unique(seq_clip$game_id), ".jpeg")
            jpeg(image.filename, width = 2, height = 2, units = 'in', res = 64)
            plot(p)
            dev.off()
            cat(".")}else{cat("_")}
      }
      
      # 5. Save to Image --------------------------------------------------------
    cat(unique(seq_clip$game_id)[1])
} 



      

