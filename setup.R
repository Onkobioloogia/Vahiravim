library(slidify)
library(slidifyLibraries)
# setwd("~/Dropbox/Onkobioloogia")
# author("Vähiravim")
setwd("~/Dropbox/Onkobioloogia/Vähiravim/")

slidify("index.Rmd")
browseURL("index.html")

publish("Vahiravim","tpall")
