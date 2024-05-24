# script to run surveyISS variants to compared with model-based ISS

# load packages ----
# devtools::unload('surveyISS')
# devtools::install_github("BenWilliams-NOAA/surveyISS", force = TRUE)
# devtools::install_github("afsc-assessments/afscdata", force = TRUE)
library(surveyISS)

# set iterations ----
# set number of desired bootstrap iterations (suggested here: 10 for testing, 500 for running)
# iters = 500
iters = 10

# get data ----
# if query = TRUE then will run data queries, if FALSE will read previously run data
# set = TRUE if first time running, or if data has changed
query = FALSE

region = 'nebs'
yrs = 1979
species = c(10210, 21720, 21740)
survey = c(98, 143)

if(isTRUE(query)){
  data <- surveyISS::query_data(survey = survey,
                                region = region,
                                species = species,
                                yrs = yrs)
  
  saveRDS(data, file = here::here('data', region, 'data.RDS'))
} else{
  data <- readRDS(file = here::here('data', region, 'data.RDS'))
}

# for testing run time
if(iters < 100){
  st <- Sys.time()
}

# hauls only ----
surveyISS::srvy_iss(iters = iters, 
                    lfreq_data = data$lfreq,
                    specimen_data = data$specimen, 
                    cpue_data = data$cpue, 
                    strata_data = data$strata,  
                    yrs = 1979,
                    boot_hauls = TRUE, 
                    boot_lengths = FALSE, 
                    boot_ages = FALSE, 
                    al_var = FALSE, 
                    al_var_ann = FALSE, 
                    age_err = FALSE,
                    region = 'nebs',  
                    save = 'haul')

# lengths only ----
surveyISS::srvy_iss(iters = iters, 
                    lfreq_data = data$lfreq,
                    specimen_data = data$specimen, 
                    cpue_data = data$cpue, 
                    strata_data = data$strata,  
                    yrs = 1979,
                    boot_hauls = FALSE, 
                    boot_lengths = TRUE, 
                    boot_ages = FALSE, 
                    al_var = FALSE, 
                    al_var_ann = FALSE, 
                    age_err = FALSE,
                    region = 'nebs',  
                    save = 'length')

# ages only ----
surveyISS::srvy_iss(iters = iters, 
                    lfreq_data = data$lfreq,
                    specimen_data = data$specimen, 
                    cpue_data = data$cpue, 
                    strata_data = data$strata,  
                    yrs = 1979,
                    boot_hauls = FALSE, 
                    boot_lengths = FALSE, 
                    boot_ages = TRUE, 
                    al_var = FALSE, 
                    al_var_ann = FALSE, 
                    age_err = FALSE,
                    region = 'nebs',  
                    save = 'age')

# hauls and length only ----
surveyISS::srvy_iss(iters = iters, 
                    lfreq_data = data$lfreq,
                    specimen_data = data$specimen, 
                    cpue_data = data$cpue, 
                    strata_data = data$strata,  
                    yrs = 1979,
                    boot_hauls = TRUE, 
                    boot_lengths = TRUE, 
                    boot_ages = FALSE, 
                    al_var = FALSE, 
                    al_var_ann = FALSE, 
                    age_err = FALSE,
                    region = 'nebs',  
                    save = 'haul_length')

# hauls and age only ----
surveyISS::srvy_iss(iters = iters, 
                    lfreq_data = data$lfreq,
                    specimen_data = data$specimen, 
                    cpue_data = data$cpue, 
                    strata_data = data$strata,  
                    yrs = 1979,
                    boot_hauls = TRUE, 
                    boot_lengths = FALSE, 
                    boot_ages = TRUE, 
                    al_var = FALSE, 
                    al_var_ann = FALSE, 
                    age_err = FALSE,
                    region = 'nebs',  
                    save = 'haul_age')

# all ----
surveyISS::srvy_iss(iters = iters, 
                    lfreq_data = data$lfreq,
                    specimen_data = data$specimen, 
                    cpue_data = data$cpue, 
                    strata_data = data$strata,  
                    yrs = 1979,
                    boot_hauls = TRUE, 
                    boot_lengths = TRUE, 
                    boot_ages = TRUE, 
                    al_var = TRUE, 
                    al_var_ann = TRUE, 
                    age_err = TRUE,
                    region = 'nebs',  
                    save = 'all')

# For testing run time of 500 iterations ----
if(iters < 500){
  end <- Sys.time()
  runtime <- (end - st) / iters * 500 / 60
  runtime
}
