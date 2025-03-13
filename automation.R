library(jsonlite)
library(devtools)

# Install the sensingcluesr package from GitHub
devtools::install_github("sensingclues/sensingcluesr@v1.0.5", upgrade = "never")

# Retrieve credentials from environment variables (GitHub Secrets)
username <- Sys.getenv("SENSINGCLUES_USERNAME")
password <- Sys.getenv("SENSINGCLUES_PASSWORD")

# Ensure credentials exist
if (username == "" || password == "") {
  stop("Error: Missing credentials. Ensure SENSINGCLUES_USERNAME and SENSINGCLUES_PASSWORD are set.")
}

# Login to Cluey platform
cookie <- sensingcluesr::login_cluey(username = username, password = password)

# Load charcoal data
df <- sensingcluesr::get_observations(cookie, group = c(), from = Sys.Date() - 30, to = Sys.Date(),
                                      filteredConcepts = c("https://sensingclues.poolparty.biz/SCCSSOntology/97",
                                                           "https://sensingclues.poolparty.biz/SCCSSOntology/360"))

# Write to CSV file
csv_filename <- paste0("charcoal_observations_", Sys.Date() - 30, "_to_", Sys.Date(), ".csv")
write.csv(df, csv_filename, row.names = FALSE)

print(paste("File saved:", csv_filename))
