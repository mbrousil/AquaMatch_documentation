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
  
  tar_target(
    name = p2_general_drive_ids,
    command = tribble(
      ~name, ~id,
      # Respond to user date choices
      "p1_global_grid_20240701.rds", "1Aiyd1hFyJXAdSOk8Q-BQBaHrnsIX4_96"
    ),
    cue = tar_cue("always")
  ),
  
  tar_target(
    name = p2_chl_drive_ids,
    command = tribble(
      ~name, ~id,
      # Respond to user date choices
      "p1_wqp_params_chl_20240701.rds", "1MtHbroy3d1wZgfiu1rxCTSdhMIO6lar8",
      "p2_site_counts_chl_20240701.rds","1xkmY74scyQtxopimGEC_aMMD5XZo0IZy",
      "p3_documented_drops_chla_20240701.rds", "1s2VAH4Z1BQxLtVC6O__SKyicBwK3ZsQJ"
    ),
    cue = tar_cue("always")
  ),
  
  tar_target(
    name = p2_doc_drive_ids,
    command = tribble(
      ~name, ~id,
      # Respond to user date choices
      "p1_wqp_params_doc_20240701.rds", "1Zg4I4UVovzAoZlldX2PVYgrl-Jp8WDtU",
      "p2_site_counts_doc_20240701.rds","1SOvg5D4-vNB8B_U95kbwq9I7jmk2iLhH",
      "p3_documented_drops_doc_20240701.rds", "1qP5hvr3vu4BbRu1SAhiCdW-fvgHjlLzT"
    ),
    cue = tar_cue("always")
  ),
  
  
  tar_target(
    name = p2_sdd_drive_ids,
    command = tribble(
      ~name, ~id,
      # Respond to user date choices
      "p1_wqp_params_sdd_20240701.rds", "1ha9C8_LJlOzCottstGaZCrjSmrswL-JJ",
      "p2_site_counts_sdd_20240701.rds","1uu60NG_L2a5sUKCzCA8N64KzgxXHGwWJ",
      "p3_documented_drops_sdd_20240701.rds", "1PvtQC-ehT-2s3iXH_GPQA3Y32k6oLKDS"
    ),
    cue = tar_cue("always")
  ),  
  
  tar_target(
    name = p2_tss_drive_ids,
    command = tribble(
      ~name, ~id,
      # Respond to user date choices
      "p1_wqp_params_tss_20250430.rds", "1tI5lF80-dTvUgaOWD7SVubI9yV1f4nB2",
      "p2_site_counts_tss_20250430.rds","1oRZzRHhaTk09lExlk4q63EF7viiya2uv",
      "p3_documented_drops_tss_20250430.rds", "1S6tse63RUetc8Y_ipXkpcNGi9kQxZHge"
    ),
    cue = tar_cue("always")
  ),
  
  
  # AOI grid
  tar_target(
    name = p1_global_grid,
    command = retrieve_data(target = "p1_global_grid",
                            id_df = p2_general_drive_ids,
                            local_folder = "in/general",
                            stable = p0_harmonization_config$general_use_stable, 
                            google_email = p0_harmonization_config$google_email,
                            stable_date = p0_harmonization_config$general_stable_date),
    packages = c("tidyverse", "googledrive")
  ), 
  
  
  # CharacteristicNames by param
  # Chl
  tar_target(
    name = p1_wqp_params_chl,
    command = retrieve_data(target = "p1_wqp_params_chl",
                            id_df = p2_chl_drive_ids,
                            local_folder = "in/chla",
                            google_email = p0_harmonization_config$google_email,
                            stable_date = p0_harmonization_config$chl_stable_date),
    packages = c("tidyverse", "googledrive")
  ),  
  
  # DOC
  tar_target(
    name = p1_wqp_params_doc,
    command = retrieve_data(target = "p1_wqp_params_doc",
                            id_df = p2_doc_drive_ids,
                            local_folder = "in/doc",
                            google_email = p0_harmonization_config$google_email,
                            stable_date = p0_harmonization_config$doc_stable_date),
    packages = c("tidyverse", "googledrive")
  ),  
  
  # SDD
  tar_target(
    name = p1_wqp_params_sdd,
    command = retrieve_data(target = "p1_wqp_params_sdd",
                            id_df = p2_sdd_drive_ids,
                            local_folder = "in/sdd",
                            google_email = p0_harmonization_config$google_email,
                            stable_date = p0_harmonization_config$sdd_stable_date),
    packages = c("tidyverse", "googledrive")
  ),  
  
  # TSS
  tar_target(
    name = p1_wqp_params_tss,
    command = retrieve_data(target = "p1_wqp_params_tss",
                            id_df = p2_tss_drive_ids,
                            local_folder = "in/tss",
                            google_email = p0_harmonization_config$google_email,
                            stable_date = p0_harmonization_config$tss_stable_date),
    packages = c("tidyverse", "googledrive")
  ),  
  
  
  # Site counts
  # Chl
  tar_target(
    name = p2_site_counts_chl,
    command = retrieve_data(target = "p2_site_counts_chl",
                            id_df = p2_chl_drive_ids,
                            local_folder = "in/chla",
                            google_email = p0_harmonization_config$google_email,
                            stable_date = p0_harmonization_config$chl_stable_date),
    packages = c("tidyverse", "googledrive")
  ),
  
  # DOC
  tar_target(
    name = p2_site_counts_doc,
    command = retrieve_data(target = "p2_site_counts_doc",
                            id_df = p2_doc_drive_ids,
                            local_folder = "in/doc",
                            google_email = p0_harmonization_config$google_email,
                            stable_date = p0_harmonization_config$doc_stable_date),
    packages = c("tidyverse", "googledrive")
  ),
  
  # SDD
  tar_target(
    name = p2_site_counts_sdd,
    command = retrieve_data(target = "p2_site_counts_sdd",
                            id_df = p2_sdd_drive_ids,
                            local_folder = "in/sdd",
                            google_email = p0_harmonization_config$google_email,
                            stable_date = p0_harmonization_config$sdd_stable_date),
    packages = c("tidyverse", "googledrive")
  ),
  
  # TSS
  tar_target(
    name = p2_site_counts_tss,
    command = retrieve_data(target = "p2_site_counts_tss",
                            id_df = p2_tss_drive_ids,
                            local_folder = "in/tss",
                            google_email = p0_harmonization_config$google_email,
                            stable_date = p0_harmonization_config$tss_stable_date),
    packages = c("tidyverse", "googledrive")
  ),
  
  # Documentation of dropped rows
  # Chl
  tar_target(
    name = p3_documented_drops_chla,
    command = retrieve_data(target = "p3_documented_drops_chla",
                            id_df = p2_chl_drive_ids,
                            local_folder = "in/chla",
                            google_email = p0_harmonization_config$google_email,
                            stable_date = p0_harmonization_config$chl_stable_date),
    packages = c("tidyverse", "googledrive")
  ),
  
  # DOC
  tar_target(
    name = p3_documented_drops_doc,
    command = retrieve_data(target = "p3_documented_drops_doc",
                            id_df = p2_doc_drive_ids,
                            local_folder = "in/doc",
                            google_email = p0_harmonization_config$google_email,
                            stable_date = p0_harmonization_config$doc_stable_date),
    packages = c("tidyverse", "googledrive")
  ),
  
  # SDD
  tar_target(
    name = p3_documented_drops_sdd,
    command = retrieve_data(target = "p3_documented_drops_sdd",
                            id_df = p2_sdd_drive_ids,
                            local_folder = "in/sdd",
                            google_email = p0_harmonization_config$google_email,
                            stable_date = p0_harmonization_config$sdd_stable_date),
    packages = c("tidyverse", "googledrive")
  ),
  
  # TSS
  tar_target(
    name = p3_documented_drops_tss,
    command = retrieve_data(target = "p3_documented_drops_tss",
                            id_df = p2_tss_drive_ids,
                            local_folder = "in/tss",
                            google_email = p0_harmonization_config$google_email,
                            stable_date = p0_harmonization_config$tss_stable_date),
    packages = c("tidyverse", "googledrive")
  ),
  
  # Unit tables
  # Chla
  tar_file_read(
    name = chla_unit_table,
    command = "in/chla/chla_unit_table.csv",
    cue = tar_cue("always"),
    read = read_csv(file = !!.x)
  ),
  
  # DOC
  tar_file_read(
    name = doc_unit_table,
    command = "in/doc/doc_unit_table.csv",
    cue = tar_cue("always"),
    read = read_csv(file = !!.x)
  ),
  
  # SDD
  tar_file_read(
    name = sdd_unit_table,
    command = "in/sdd/sdd_unit_table.csv",
    cue = tar_cue("always"),
    read = read_csv(file = !!.x)
  ),
  
  # TSS
  tar_file_read(
    name = tss_unit_table,
    command = "in/tss/tss_unit_table.csv",
    cue = tar_cue("always"),
    read = read_csv(file = !!.x)
  )
)

# Full targets list
c(config_targets,
  bookdown_targets_list)