# Function specification that extracts the right n characters from a string
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}


# Function specification that extracts the left n characters from a string
substrLeft <- function(x, n){
  substr(x, 1, n)
}
