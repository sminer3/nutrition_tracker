library(httr)
library(readr)
options(scipen=999)
api_key = '62dNL6NiTagPRqbDVqaPn0UESAgiVH06kc6SKqwz'
url = paste("https://api.nal.usda.gov/ndb/list?format=json&lt=f&sort=n&max=500&api_key=",api_key,sep="")
r <- GET(url)
results = content(r)[[1]]$item
length(results)

offset=500
status_code = 200
while(status_code == 200) {
  url = paste("https://api.nal.usda.gov/ndb/list?format=json&lt=f&sort=n&max=500&offset=",offset,"&api_key=",api_key,sep="")
  r <- GET(url)
  status_code = status_code(r)
  if(status_code==200) {
    results = c(results,content(r)[[1]]$item)
    print(results[[offset]]$name)
    offset = offset + 500
  } else {
    paste("Length of list:",length(results))
  }
}
ids =as.integer(lapply(results,function(x) x$id))
name = as.character(lapply(results,function(x) x$name))
remove(results,r)
key_pairs = data.frame(ids,name)
remove(ids,name)
write_csv(key_pairs,"key_pairs.csv")
