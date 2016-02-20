# Yelp API v2.0 code sample.
# 
# This program demonstrates the capability of the Yelp API version 2.0
# by using the Search API to query for businesses by a search term and location.
# 
# Please refer to http://www.yelp.com/developers/documentation for the API documentation.
# 
# This program requires some R libraries including "httr", which you can install via:
# `packages.install("httr")`
# `packages.install("httpuv")`
# etc.
# 
# Sample usage of the program:
# `> source("sample.R")`
# (output to the screen)
# or
# `R CMD BATCH sample.R`
# (output to sample.Rout)

# Required packages
require(httr)
require(httpuv)
require(jsonlite)
require(base64enc)

# Your credentials, from https://www.yelp.com/developers/manage_api_keys
consumerKey = "ADeD_W6gmnDhW2ziX_LOOg"
consumerSecret = "SvNhVv1yHG6La1_LfITM5ufHriM"
token = "OR9JjyGUS5a43oaJ3pESvKZh4KoaV0cH"
token_secret = "vzc00ze2nwngnfLYay20iTPjs9A"

yelp_query <- function(path, query_args) {
  # Use OAuth to authorize your request.
  myapp <- oauth_app("YELP", key=consumerKey, secret=consumerSecret)
  sig <- sign_oauth1.0(myapp, token=token, token_secret=token_secret)

  # Build Yelp API URL.
  scheme <- "https"
  host <- "api.yelp.com"
  yelpurl <- paste0(scheme, "://", host, path)

  # Make request.
  results <- GET(yelpurl, sig, query=query_args)

  # If status is not success, print some debugging output.
  HTTP_SUCCESS <- 200
  if (results$status != HTTP_SUCCESS) {
      print(results)
  }
  return(results)
}

yelp_search <- function(term, location, limit=10) {
  # Search term and location go in the query string.
  path <- "/v2/search/"
  query_args <- list(term=term, location=location, limit=limit)

  # Make request.
  results <- yelp_query(path, query_args)
  return(results)
}

######################
a<-yelp_search('POLLOS MARIO RESTAURANT AND SPORTS BAR','37TH AVE 11372',1)
#######################

yelp_business <- function(business_id) {
  # Business ID goes in the path.
  path <- paste0("/v2/business/", business_id)
  query_args <- list()

  # Make request.
  results <- yelp_query(path, query_args)
  return(results)
}

print_search_results <- function(yelp_search_result) {
  print("=== Search Results ===")
  # Load data.  Flip it around to get an easy-to-handle list.
  locationdataContent = content(yelp_search_result)
  locationdataList=jsonlite::fromJSON(toJSON(locationdataContent))

  # Print output.
  return(data.frame(locationdataList))
}

###################
b<-print_search_results(a)
b[7]# rating
b[10] #review count
b[11]#name
b[19]#phone
b[17]#image
b[[23]][2]#address
b[3]#latitude
b[4]#longitude
####################

print_business_results <- function(yelp_business_result) {
  print("=== Business ===")
  print(content(yelp_business_result))
}

demo <- function() {
  # Query Yelp API, print results.
  yelp_search_result <- yelp_search(term="dinner", location="Boston, MA", limit=3)
  print_search_results(yelp_search_result)

  # Pick the top search result, get more info about it.
  # Find Yelp business ID, such as "giacomos-ristorante-boston".
  business_id = content(yelp_search_result)$businesses[[1]]$id
  yelp_business_result <- yelp_business(business_id)
  print_business_results(yelp_business_result)
}

demo()
