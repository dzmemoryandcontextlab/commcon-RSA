# commcon-RSA

This repository contains code used to analyze data published in:

> Gurguryan, L., Olivier, J. M., & Dimsdale-Zucker, H. R. (2026). The role of contextual similarity on brain activity patterns for associated events (p. 2026.10.19.760268). bioRxiv. https://doi.org/10.64898/2026.10.19.760268

## Data access

fMRI data are publically accessible on [OpenNeuro](https://openneuro.org/datasets/ds004663). Raw behavioral data can be found on [OSF](https://osf.io/8pg7x/overview). 

## MODEL INFO

### Model 3

For each commercial segment, 3 separate GLMs are modeled (i.e., (1) segment of interest for commercial, (2) remaining 2 segments of the commercial, (3) all other commercial segments), for a total of 72 GLMs per participant.

Data locations:
- PRE data: /Volumes/Chi/Model3_PRE
- POST data: /Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_POST
- Difference (POST-PRE): /Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_POST-PRE
   
### Model 4 

> [!WARNING] 
> The section describing model 4 was cut from the final manuscript. Do not include in public repo!

One GLM is modeled per participant with three regressors of interest: (1) segment 1 for all commercials, (2) segment 2 for all commercials, (3) segment 3 for all commercials. This is used only for the repetition suppression analysis in footnote.

Data locations:
- PRE data: /Volumes/Poodle/Model4_REPSUP

## ROI SCRIPTS

| Script | Location | Description |
|---|---|---|
| `extract-ashs-labels.sh` | `/Volumes/Poodle/ashs_output` | extracts/creates ROIs using the outputs from ASHS | 
| `normalize-ashsROIs.sh` | `/Volumes/Poodle/ashs_output` | normalizes the ASHS ROIs to MNI space (same space as funcs for analysis) |
| `resample_pmc.sh` | `/Volumes/Poodle/Baldassano_ROIs` | resample/binarize Baldassano mask to match data |
| `resample_vmpfc.sh` | `/Volumes/Poodle/VmPFC_symmetric_20141024` | resample/binarize to match data |
| `combine-vmpfc-mni-bic.sh` | `/Volumes/Poodle/VmPFC_symmetric_20141024` | combines the MNI ROIs to build the vmPFC |
| `create-a1.sh` | `/Volumes/Chi/HCPex_v1.1/ROIs` | creates A1 from Human Connectome Project |

## SETUP SCRIPTS

### STEP 01: these scripts will generate the files you need to set up the 1st level scripts 

| Script | Location | Description |
|---|---|---|
| `create-onset-files-M3.R` | `/Users/yorkie/Documents/CommCon/data/raw_behavioral` | extract/create onset files for model 3 (Pre and Post separate; 1 regressor per commercial segment of interest, the remaining segments of the commercial of interest, and all other commercials) |
| `create-onset-files-M4.R` | `/Users/yorkie/Documents/CommCon/data/raw_behavioral` | extract/create onset files for model 4 (PRE only, with 3 regressors (seg-0, seg-1, and seg-2) for all commercials together; used for footnote analysis) |
| `create_confound_files.R` | `/Volumes/BrusselsGriffon/CommCon` | creates confounds file for nuisance regressors |
| `create_mat_files_for_job_M3.m` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | Take timing txt file and convert to .mat file needed for 1st levels |
| `create_mat_files_for_job_M4.m` | `/Volumes/Poodle/Model4_REPSUP/Model4_scripts` | Take timing txt file and convert to .mat file needed for 1st levels |

### STEP 02: these scripts will run/estimate the 1st level models 

| Script | Location | Description |
|---|---|---|
| `Run_1stLevels_PRE_M3.m` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | run script to create 1st levels for model 3 for PRE run |
| `Run_1stLevels_POST_M3.m` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | run script to create 1st levels for model 3 for POST run |
| `REPSUP_1stLevels_M4.m` | `/Volumes/Poodle/Model4_REPSUP/Model4_scripts` | run script to create 1st levels for model 4 for PRE run |
| `batch_estimate_PRE_job.m` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | run script to estimate 1st levels for model 3 for PRE run |
| `batch_estimate_POST_job.m` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | run script to estimate 1st levels for model 3 for POST run |
| `batch_estimate_REPSUP_M4_job` | `/Volumes/Poodle/Model4_REPSUP/Model4_scripts` | script to estimate the 1st levels for model 4 PRE | 

### STEP 03: these scripts will extract the betas and compute the correlation matrices needed for RSA analyses 

| Script | Location | Description |
|---|---|---|
| `extract_beta_descrip.m` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | Extracts beta-map descriptions for each subject and commercial from the Model 3 PRE and POST for each subject |
| `Com-Beta_mappings.R` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | identifies the beta maps for each commercial seg for every participant and creates separate PRE and POST files |
| `extract_beta_descrip_M4.m` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | extracts descriptions of all beta images for each subject from the PRE Model 4 |
| `Seg-Beta_mappings.R` | `/Volumes/Poodle/Model4_REPSUP/Model4_scripts` | combines beta-map info from all subjects into a file, identifying the beta maps corresponding to the 3 task regressors (seg-0, seg-1, and seg-2); model 4 |
| `extract_beta_values_from_MULTIPLE_ROIs_PRE.m` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | model 3; extract PRE betas + correlation matrix from vmPFC, PMC, A1 |
| `extract_beta_values_from_MULTIPLE_ROIs_POST.m` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | model 3; extract POST betas + correlation matrix from vmPFC, PMC, A1 |
| `extract_beta_values_from_MULTIPLE_ROIs_POST_minus_PRE.m` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | model 3; compute difference score betas + correlation matrix from vmPFC, PMC, A1 |
| `extract_beta_values_from_ASHS_ROIs_PRE.m` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | model 3; extract PRE betas + correlation matrix from hippocampus, PHC, PRC |
| `extract_beta_values_from_ASHS_ROIs_POST.m` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | model 3; extract POST betas + correlation matrix from hippocampus, PHC, PRC |
| `extract_beta_values_from_ASHS_ROIs_POST_minus_PRE.m` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | model 3; compute difference score betas + correlation matrix from hippocampus, PHC, PRC |
| `extract_beta_values_from_ROIs_REPSUP_M4.m` | `/Volumes/Poodle/Model4_REPSUP/Model4_scripts` | extract PRE betas for model 4 (for footnote repsup analysis) from vmPFC, PMC, and A1 |
| `extract_beta_values_from_ROIs_ashs_REPSUP_M4.m` | `/Volumes/Poodle/Model4_REPSUP/Model4_scripts` | extract PRE betas for model 4 (for footnote repsup analysis) from hippocampus, PHC, PRC |

### STEP 04: These scripts clean/prep the corr matrices for the RSA analyses

| Script | Location | Description |
|---|---|---|
| `extract_beta_values_from_ASHS_ROIs_POST.m` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | model 3; extract POST betas + correlation matrix from hippocampus, PHC, PRC |
| `extract_beta_values_from_ASHS_ROIs_POST_minus_PRE.m` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | model 3; compute difference score betas + correlation matrix from hippocampus, PHC, PRC |
| `extract_beta_values_from_ROIs_REPSUP_M4.m` | `/Volumes/Poodle/Model4_REPSUP/Model4_scripts` | extract PRE betas for model 4 (for footnote repsup analysis) from vmPFC, PMC, and A1 |
| `extract_beta_values_from_ROIs_ashs_REPSUP_M4.m` | `/Volumes/Poodle/Model4_REPSUP/Model4_scripts` | extract PRE betas for model 4 (for footnote repsup analysis) from hippocampus, PHC, PRC |

### STEP 04: These scripts clean/prep the corr matrices for the RSA analyses

| Script | Location | Description |
|---|---|---|
| `pick_pairs_M3.R` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | creates txt files for the pairs of commercials that we care about for RSA analysis |
| `order_rows_for_corr_plots_MULTIPLE_ROI.R` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | reorders corr matrices according to the participant's actual viewing sequence; model 3, all ROIs |
| `save_corr_mat_with_commercial_labels_MULTIPLE_ROI.R` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | adds commercial names to matrices; model 3, all ROIs |
| `select_corrs_for_pairs_MULTIPLE_ROI.R` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | picks out the commercial pairs we care about for RSA |
    
## ANALYSIS SCRIPTS

| Script | Location | Description |
|---|---|---|
| `common-demo.R` | `/Users/yorkie/Documents/CommCon` | demographics info |
| `behavioural_MemTest_data.R` | `/Users/yorkie/Documents/CommCon/data` | computes averages for post-scan source memory test |
| `lme_ashs.R` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | RSA analysis in the ASHS ROIs (hippocampus, PHC, PRC) |
| `lme.R` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | RSA analysis in the vmPFC, PMC, A1 |
| `brain-behaviour-model3-lme.R` | `/Users/yorkie/Documents/CommCon/data` | analysis examining relationship between source memory accuracy and pattern similarity |
| `REPSUP_conceptual-rep.R` | `/Volumes/BrusselsGriffon/CommCon/SPM_results/Model3_scripts` | conceptual repetition suppression analysis (seg1-seg3) using model3 (segment level GLMS) PRE |
| `REPSUP_M4.R` | `/Volumes/Poodle/Model4_REPSUP/Model4_scripts` | conceptual repetition suppression analysis using model 4 (i.e., 1 GLM per participant) PRE |

