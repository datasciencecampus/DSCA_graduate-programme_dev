#Function of script - import data, functions, execute joins

library(tidyverse)
# library(gapminder)
# 
# # import_data -------------------------------------------------------------
# 
# gapminder_full <- gapminder
# 
# #filter to a subset
# gapminder_africa <- gapminder_full %>%
#   filter(continent == "Africa") %>%
#   select(country, continent, year)
# 
# #cache both for future use
# 
# saveRDS(gapminder_full, "cache/gapminder.rds")
# 
# saveRDS(gapminder_africa, "cache/gapminder_africa.rds")

#comment out above for future runs and use the cached versions

gapminder_full <- readRDS("cache/gapminder.rds")

gapminder_africa <- readRDS("cache/gapminder_africa.rds")



left_join(gapminder_africa, gapminder_full)


# join_function -----------------------------------------------------------

# function_no key_specified mvm -------------------------------------------



execute_join <- function(df_a, df_b, join_type) {
  
  
  data_joined <-  join_type(df_a, df_b)
  return(data_joined)
  
}

object_A <- execute_join(gapminder_africa, gapminder_full, join_type = left_join)



object_B <- execute_join(gapminder_full, gapminder_africa, join_type = anti_join)



# function specfying key --------------------------------------------------



execute_join <- function(df_a, df_b, join_type, key_columns) {
  data_joined <-  join_type(df_a, df_b,
                                 by = key_columns)
  return(data_joined)
}

#the below works well
execute_join(gapminder_africa, gapminder_full,
             join_type = left_join,
             key_columns = c('country' = 'country',
                             'year' = 'year'
                             )
             )






#now need to test whether we can map columns with select()
key_a <- names(select(gapminder_africa, country))

key_b <- names(select(gapminder_full, country))

#first time unique key error received
execute_join(gapminder_africa, gapminder_full,
             join_type = left_join,
             key_columns = c(key_a = key_b))
#not picking up name of column for key...

names(gapminder_africa) == key_a
names(gapminder_full) == key_b









