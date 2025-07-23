# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)

# Set target options:
tar_option_set(
  packages = c("tidyverse"),
  memory = "transient",
  garbage_collection = TRUE,
  seed = 1
)

# Run the R scripts with custom functions:
tar_source(
  files = c(
    "src/",
    "create_bookdown.R")
)

# Replace the target list below with your own:
config_targets <- list(
  
  # Grab configuration information for the workflow run (config.yml)
  tar_target(
    name = p0_harmonization_config,
    # The config package does not like to be used with library()
    command = config::get(config = "admin_update"),
    cue = tar_cue("always")
  ),
  
  # Google Drive IDs
  # More manual interaction with these datasets is required, so not designed to
  # be locally passed from pipeline to pipeline
  
  # tar_file_read(
  #   name = p2_general_drive_ids,
  #   command = paste0(p0_AquaMatch_download_WQP_directory,
  #                    "2_download/out/general_drive_ids.csv"),
  #   cue = tar_cue("always"),
  #   read = read_csv(file = !!.x)
  # ),
  
  # tar_target(
  #   name = p2_chl_drive_ids,
  #   command = tribble(
  #     ~name, ~id,
  #     
  #   ),
  #   read = read_csv(file = !!.x)
  # ),
  
  # tar_file_read(
  #   name = p2_doc_drive_ids,
  #   command = paste0(p0_AquaMatch_download_WQP_directory,
  #                    "2_download/out/doc_drive_ids.csv"),
  #   cue = tar_cue("always"),
  #   read = read_csv(file = !!.x)
  # ),
  # 
  # tar_file_read(
  #   name = p2_sdd_drive_ids,
  #   command = paste0(p0_AquaMatch_download_WQP_directory,
  #                    "2_download/out/sdd_drive_ids.csv"),
  #   cue = tar_cue("always"),
  #   read = read_csv(file = !!.x)
  # ),
  
  tar_target(
    name = p2_tss_drive_ids,
    command = tribble(
      ~name, ~id,
      "p1_wqp_params_tss_20250430.rds", "1tI5lF80-dTvUgaOWD7SVubI9yV1f4nB2",
      "p2_site_counts_tss_20250430.rds","1oRZzRHhaTk09lExlk4q63EF7viiya2uv"
    ),
    cue = tar_cue("always")
  ),
  
  # tar_file_read(
  #   name = p2_cdom_drive_ids,
  #   command = paste0(p0_AquaMatch_download_WQP_directory,
  #                    "2_download/out/cdom_drive_ids.csv"),
  #   cue = tar_cue("always"),
  #   read = read_csv(file = !!.x)
  # ),
  
  # Site counts
  # TSS
  tar_target(
    name = p2_site_counts_tss,
    command = retrieve_data(target = "p2_site_counts_tss",
                            id_df = p2_tss_drive_ids,
                            local_folder = "in/tss",
                            google_email = p0_harmonization_config$google_email,
                            stable_date = p0_harmonization_config$tss_stable_date),
    packages = c("tidyverse", "googledrive")
  )
)

# Full targets list
c(config_targets,
  bookdown_targets_list)