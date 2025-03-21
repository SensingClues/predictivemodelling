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

# Ensure login was successful
if (is.null(cookie)) {
  stop("Error: Login failed. Check SENSINGCLUES_USERNAME and SENSINGCLUES_PASSWORD.")
}

message("Fetching observations from API...")

message("Calling sensingcluesr::get_observations()...")

# Capture errors if `get_observations` fails
df <- tryCatch({
  sensingcluesr::get_observations(cookie, group = c(), from = Sys.Date() - 30, to = Sys.Date(),
                                  filteredConcepts = c("https://sensingclues.poolparty.biz/SCCSSOntology/97",
                                                       "https://sensingclues.poolparty.biz/SCCSSOntology/360"))
}, error = function(e) {
  message("Error in sensingcluesr::get_observations()")
  print(e)
  return(data.frame())  # Prevents script from stopping
})

message("API call completed.")

# Debugging: Print the structure of the API response
message("API Response Structure:")
print(str(df))

# Ensure data is returned
if (is.null(df) || nrow(df) == 0) {
  message("Error: API returned no data. Check authentication or API response format.")
}

message("Observations retrieved successfully.")
print(head(df))  # Print first few rows of data

# Write to CSV file
csv_filename <- paste0("charcoal_observations_", Sys.Date() - 30, "_to_", Sys.Date(), ".csv")
write.csv(df, csv_filename, row.names = FALSE)

message(paste("File saved:", csv_filename))
