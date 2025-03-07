
library(jsonlite)

# load the sensincluesr package
library(devtools)
devtools::install_github("sensingclues/sensingcluesr@v1.0.5", upgrade = "never")

# retrieve credentials from json file
credentials <- jsonlite::fromJSON("credentials-sensingclues.json")

# login to Sensing Clues platform
cookie <- sensingcluesr::login_cluey(
  username = credentials$username,
  password = credentials$password
)

# load charcoal data
df <- sensingcluesr::get_observations(cookie, group = c(), from = Sys.Date() - 30, to = Sys.Date(),
                                      filteredConcepts = c("https://sensingclues.poolparty.biz/SCCSSOntology/97", # charcoaling
                                                           "https://sensingclues.poolparty.biz/SCCSSOntology/360")) # kiln

# write to file
write.csv(df, paste0("charcoal_observations_", Sys.Date() - 30, "_", to = Sys.Date(), ".csv"))
