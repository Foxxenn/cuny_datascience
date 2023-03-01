

url <- 'https://www.psychologytoday.com/us/therapists/ca/los-angeles?category=african-american'

web_data <- rvest::read_html(url)
  
results <- web_data %>% html_elements(".results-row")
  
info_row <- results[1] %>% html_elements(".results-row-info")
    
    
name <- info_row %>% html_elements("a") %>% html_text()

if(length(name)==0) {
  name <- NA
} else {
  name <- str_replace_all(name, "\n", "")
}

title <- info_row %>% html_elements(".profile-subtitle-credentials") %>% html_text()
if(length(title)==0) {
  title <- NA
}

statement <- info_row %>% html_elements(".statements") %>% html_text()
if(length(statement)==0) {
  statement <- NA
}
    
contact_row <- results[1] %>% html_elements(".results-row-contact")

phone <- contact_row %>% html_elements(".results-row-mob") %>% html_text()

if(length(phone)==0) {
  phone <- NA
}
contact_info <- contact_row %>% html_elements(".profile-location") %>% html_elements("span")
city <- contact_info[1] %>% html_text()

if(length(city)==0) {
  city <- NA
}

state <- contact_info[2] %>% html_text()
if(length(state)==0) {
  state <- NA
}


zip <- contact_info[3] %>% html_text()
if(length(zip)==0) {
  zip <- NA
}


teletherapy <- contact_row %>% html_elements(".profile-teletherapy") %>% html_text()

if(length(teletherapy) == 0) {
  teletherapy = NA
}

new_appointments <- contact_row %>% html_elements(".accepting-appointments") %>% html_text()

if(length(new_appointments) == 0) {
  new_appointments = NA
}
    
    