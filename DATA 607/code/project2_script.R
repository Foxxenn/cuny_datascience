### Retrieve Data and create .csv

```{r}
num_pages = 40
per_page = 20

base_url <- 'https://www.psychologytoday.com/us/therapists/ca/los-angeles?category=african-american&page='

therapist_info = c()
info_array = array(dim=c(4,3,num_pages*per_page))

index_count = 1

for(page_num in 1:num_pages) {
  
  url = paste0(base_url,page_num)
  #print(url)
  
  web_data <- rvest::read_html(url)
  
  results <- web_data %>% html_elements(".results-row")
  
  
  
  for(i in 1:per_page) {
    
    info_row <- results[i] %>% html_elements(".results-row-info")
    
    
    name <- info_row %>% html_elements("a") %>% html_text()
    
    if(length(name)==0) {
      name <- NA
    } else {
      name <- str_replace_all(name, "\n", "")
    }
    
    title <- info_row %>% html_elements(".profile-subtitle-credentials") %>% html_text()
    
    if(length(title)==0) {
      title <- NA
    } else {
      title <- str_replace_all(title, "\n", "")
    }
    
    statement <- info_row %>% html_elements(".statements") %>% html_text()
    if(length(statement)==0) {
      statement <- NA
    }
    
    contact_row <- results[i] %>% html_elements(".results-row-contact")
    
    phone <- contact_row %>% html_elements(".results-row-mob") %>% html_text()
    
    if(length(phone)==0) {
      phone <- NA
    }
    contact_info <- contact_row %>% html_elements(".profile-location") %>% html_elements("span") 
    
    city_state_zip <- contact_info %>% html_text()
    
    if(length(city_state_zip)==0) {
      city_state_zip <- NA
    } else {
      city_state_zip = paste(city_state_zip, collapse = " ")  
    }
    
    
    teletherapy <- contact_row %>% html_elements(".profile-teletherapy") %>% html_text()
    
    if(length(teletherapy) == 0) {
      teletherapy = NA
    }
    
    new_appointments <- contact_row %>% html_elements(".accepting-appointments") %>% html_text()
    
    if(length(new_appointments) == 0) {
      new_appointments = NA
    }
    
    #info <- c(name, title, statement, phone, city, state, zip, teletherapy)
    
    info_matrix <- matrix(nrow=4,ncol=3)
    
    
    
    info_matrix[1,1] <- name
    info_matrix[2,1] <- ""
    info_matrix[3,1] <- ""
    info_matrix[4,1] <- ""
    info_matrix[1,2] <- title
    info_matrix[2,2] <- statement
    info_matrix[3,2] <- phone
    info_matrix[4,2] <- ""
    info_matrix[1,3] <- city_state_zip
    info_matrix[2,3] <- teletherapy
    info_matrix[3,3] <- new_appointments
    info_matrix[4,3] <- ""
    
    therapist_info <- rbind(therapist_info, info_matrix)
    
    cat(name, new_appointments)
    
    #index_count = index_count+1
  }
  
  
}


info_df <- data.frame(therapist_info)

write_csv(info_df,'../input/unclean_aatherapist_info.csv')
