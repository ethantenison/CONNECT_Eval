library("rmarkdown")
library(readr)
library(tidyverse)
library(janitor)

raw_projects = read_csv("data/raw/project_summaries_summer2021.csv")

raw_projects <- raw_projects %>% janitor::row_to_names(row_number = 1) %>% clean_names() %>% select(-c(1:17)) 

raw_projects <- raw_projects[-1,]

slices = unique(raw_projects$organization_name)[!is.na(unique(raw_projects$organization_name))]


for(v in slices){
  render("notebooks/summer2021_project_summaries.Rmd",
         output_file=paste0("C:/Users/tenis/Desktop/Data_Projects/CONNECT_Eval/reports/project_summaries/summer2021/", v, ".pdf")#,
         #params=list(new_title=paste(v))
         )
}



raw_students <- read_csv("data/raw/student_summaries_summer2021.csv")

raw_students <- raw_students %>% janitor::row_to_names(row_number = 1) %>% clean_names() %>% select(-c(1:17)) 

raw_students <- raw_students[-1,]

raw_students <- raw_students %>% mutate(name = paste0(first_name," ", last_name))

raw_students$linked_in_preferred_but_not_required[is.na(raw_students$linked_in_preferred_but_not_required)] <- "UNAVAILABLE"

raw_students$do_you_have_access_to_transportation[raw_students$do_you_have_access_to_transportation == "No"] <- "DOES NOT HAVE ACCESS TO TRANSPORTATION"
raw_students$do_you_have_access_to_transportation[raw_students$do_you_have_access_to_transportation == "Yes"] <- "HAS ACCESS TO TRANSPORTATION"
raw_students$do_you_need_flexible_work_hours[raw_students$do_you_need_flexible_work_hours == "No"] <- ""
raw_students$do_you_need_flexible_work_hours[raw_students$do_you_need_flexible_work_hours == "Yes"] <- "REQUIRES FLEXIBLE WORK HOURS"
raw_students$do_you_need_the_ability_to_work_remotely[raw_students$do_you_need_the_ability_to_work_remotely == "No"] <- "CAN WORK IN PERSON OR REMOTELY"
raw_students$do_you_need_the_ability_to_work_remotely[raw_students$do_you_need_the_ability_to_work_remotely == "Yes"] <- "REQUIRES ABILITY TO WORK REMOTELY"


previous_connect <- grepl("previously participated", raw_students$please_select_each_of_the_following_that_applies_to_you)
raw_students$previous_connect <- previous_connect

raw_students$connect <- ""

for (i in 1:length(raw_students$previous_connect)){
  if (raw_students$previous_connect[i] == TRUE){
    raw_students$connect[i] <- "PEVIOUS CONNECT FELLOW"
  }
  else if (raw_students$previous_connect[i] == FALSE) {
    raw_students$connect[i] <- "NEW TO CONNECT"
  }
}

raw_students$please_select_each_of_the_following_that_applies_to_you[raw_students$please_select_each_of_the_following_that_applies_to_you == "I am pursuing a doctoral degree."] <- "DOCTORAL CANDIDATE"

raw_students$please_select_each_of_the_following_that_applies_to_you[raw_students$please_select_each_of_the_following_that_applies_to_you == "I am pursuing a doctoral degree.,I have previously participated in the CONNECT Program."] <- "DOCTORAL CANDIDATE"

raw_students$please_select_each_of_the_following_that_applies_to_you[raw_students$please_select_each_of_the_following_that_applies_to_you == "I am pursuing a Master's degree."] <- "MASTER CANDIDATE"

raw_students$please_select_each_of_the_following_that_applies_to_you[raw_students$please_select_each_of_the_following_that_applies_to_you == "I am pursuing a Master's degree.,I am in the Nonprofit Portfolio Studies Program.,I have previously participated in the CONNECT Program."] <- "MASTER CANDIDATE"

raw_students$please_select_each_of_the_following_that_applies_to_you[raw_students$please_select_each_of_the_following_that_applies_to_you == "I am pursuing a Master's degree.,I have previously participated in the CONNECT Program."] <- "MASTER CANDIDATE"

raw_students$please_select_each_of_the_following_that_applies_to_you[raw_students$please_select_each_of_the_following_that_applies_to_you == "I am pursuing a Master's degree.,I am pursuing a doctoral degree."] <- "DOCTORAL CANDIDATE"

raw_students$please_select_each_of_the_following_that_applies_to_you[raw_students$please_select_each_of_the_following_that_applies_to_you == "I am pursuing a Master's degree.,I am pursuing a doctoral degree.,I am in the Nonprofit Portfolio Studies Program.,I have previously participated in the CONNECT Program."] <- "DOCTORAL CANDIDATE"

raw_students$please_select_each_of_the_following_that_applies_to_you[raw_students$please_select_each_of_the_following_that_applies_to_you == "I am pursuing a Master's degree.,I am in the Nonprofit Portfolio Studies Program."] <- "MASTER CANDIDATE"


#Fixing school information 
for (i in 1:length(
  raw_students$which_ut_schools_colleges_are_you_affiliated_with_check_all_that_apply_selected_choice
)) {
  if (raw_students$which_ut_schools_colleges_are_you_affiliated_with_check_all_that_apply_selected_choice[i] == "Other:") {
    raw_students$which_ut_schools_colleges_are_you_affiliated_with_check_all_that_apply_selected_choice[i] <-
      raw_students$which_ut_schools_colleges_are_you_affiliated_with_check_all_that_apply_other_text[i]
  }
}

raw_students$why_are_you_interested_in_working_on_a_project_check_all_that_apply <- toupper(
  raw_students$why_are_you_interested_in_working_on_a_project_check_all_that_apply)

raw_students$which_ut_schools_colleges_are_you_affiliated_with_check_all_that_apply_selected_choice <- toupper(
  raw_students$which_ut_schools_colleges_are_you_affiliated_with_check_all_that_apply_selected_choice)

slices = unique(raw_students$name)[!is.na(unique(raw_students$name))]


for(v in slices){
  render("notebooks/summer2021_student_summaries.Rmd",
         output_file=paste0("C:/Users/tenis/Desktop/Data_Projects/CONNECT_Eval/reports/student_summaries/summer2021/", v, ".pdf")#,
         #params=list(new_title=paste(v))
  )
}
