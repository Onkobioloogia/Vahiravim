library(magrittr)
library(reshape2)
library(plyr);library(dplyr)
library(ggplot2)
library(ggthemes)
library(scales)
read.file <- . %>% read.csv(.,sep=" ")
kogu <- . %>% melt(.,"year")
d <- list.files("data") %>% grep(".csv",.) %>% 
  list.files("data")[.] %>% file.path("data",.) %>% {
    l <- lapply(.,read.file)
    site <- gsub("(?:data/)([a-zäõ]{4,9})(?:.csv)","\\1",.)
    set_names(l, site)
    } %>%
  lapply(kogu) %>% ldply

d$sex[grep(".f$", d$variable)] <- "Female"
d$sex[-grep(".f$", d$variable)] <- "Male"
d$variable %<>% as.character
d$variable[grepl("number", d$variable)] <- "number"
d$variable[grepl("rate70", d$variable)] <- "rate70"
d$variable[grepl("rate00", d$variable)] <- "rate00"
d$variable[grepl("crude", d$variable)] <- "crude"
d$variable %<>% as.factor
d$sex %<>% as.factor
d$.id %<>% as.factor
head(d)
summary(d)


pd <- d %>% filter(variable%in%c("rate00")) %>% 
  group_by(year,.id,variable) %>% summarise(value=mean(value)) 

pd %>%
  ggplot(.,aes(x=year,y=value,color=.id)) + geom_line(size=2) +
  ylab("Kasvajate suremuskordajad 100 000 elaniku kohta, USA 2000") +
  xlab("Aasta") + scale_color_tableau(palette = "tableau10") +
  geom_text(data = pd[pd$year =="1998"&!pd$.id%in%c("magu","maks","emakas"), ], 
            aes(label = .id), 
            hjust = 0,vjust = 0.5) + theme(legend.position="none") +
  geom_text(data = pd[pd$year =="1930"&pd$.id%in%c("magu","maks","emakas"), ], 
            aes(label = .id), 
            hjust = 1,vjust = 0.5) + theme(legend.position="none") +
  xlim(1924,2006)
