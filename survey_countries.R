library(dplyr)        # For magic dataframe manipulation
library(tidyr)        # For more magic dataframe manipulation
library(countrycode)  # Standardize countries
library(rvest)        # Scrape stuff from the web

# World Bank countries
wb.countries.raw <- read_html("https://web.archive.org/web/20160422022535/http://data.worldbank.org/country/") %>%
  html_nodes(xpath='//*[@id="block-views-countries-block_1"]/div/div/div/table') %>%
  html_table() %>% bind_rows() %>% as_tibble()
wb.countries.raw

# Clean up list of countries and add standard codes
wb.countries.clean <- wb.countries.raw %>%
  # The table from their website uses four columns; gather those into one
  gather(key, `Country name`, everything()) %>%
  select(-key) %>%
  mutate(ISO3 = countrycode(`Country name`, "country.name", "iso3c"),
         `COW code` = countrycode(ISO3, "iso3c", "cown")) %>%
  filter(!is.na(ISO3)) %>%
  mutate(`Qualtrics ID` = 1:n())
wb.countries.clean

saveRDS(wb.countries.clean,
        here::here("data", "data_processed",
                   "survey_countries.rds"))
