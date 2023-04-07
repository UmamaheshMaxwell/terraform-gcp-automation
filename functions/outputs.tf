
/*
    ? Numeric Functions
*/
# Max Value
output "max_value" {
  value = max(5,12,9) // 12
}

# Min Value
output "min_value" {
  value = min(5,12,9) // 5
}

# Floor Value
output "floor_value" {
  value = floor(4.5) // 4
}

# Ceil Value
output "ceil_value" {
  value = ceil(4.5) // 5
}

/*
    ? String Functions
*/

# format
# The format function produces a string by formatting 
# a number of other values according to a specification string.
output "format_value_one" {
  value = format("Hello, %s!", "Uma")
}

output "format_value_two" {
  value = format("There are %d lights", 4)
}

# join
output "join_value_one" {
  value = join(",", ["uma", "siva", "scott"])
}

output "join_value_two" {
  value = join("-", ["terraform", "join", "function"])
}

# lower
output "lower_value" {
  value = lower("UMA")
}

# upper
output "upper_value" {
  value = upper("uma")
}

# replace
output "replace_value" {
  value = replace("Welcome to the world of terraform", "world", "universe")
}

