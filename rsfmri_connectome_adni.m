%% script to run the connectome pipeline on adni2 on pin

%% Specify to the grabber to prepare the files for the connectome pipeline
opt_g.min_nb_vol = 50; % This option is useful when scrubbing is used, and the resulting time series may be too short.
opt_g.type_files = "glm_connectome";

[tabd,sid,ly,~] = niak_read_csv('/data/cisl/preprocessed_data/adni/csvs/adni2_demog_niak.csv');
% get list of subjects who didn't pass QC
mask_pass = logical(tabd(:,9));
fail_sub = sid(~mask_pass);
opt_g.exclude_subject = fail_sub;
files_in.fmri = niak_grab_fmri_preprocess('/data/cisl/preprocessed_data/adni/rsfmri_20180721',opt_g).fmri;

%Specify the template
files_in.network = '/data/cisl/preprocessed_data/mist_parcellations/Release/Parcellations/MIST_7.nii.gz';

%Specify seeds (ROI)
files_in.seeds = '/data/cisl/preprocessed_data/adni/connectome_mist7_20180808/list_seeds_mist7.csv';

%% set options
opt_csv.labels_x = {'CER','LIM','MOT','VIS','DMN','FP','VATT_SAL'}; % The labels for the network
opt_csv.labels_y = { 'index' };
tab = [1;2;3;4;5;6;7];
niak_write_csv(files_in.seeds,tab,opt_csv);


%% Pipeline options
opt.folder_out = '/data/cisl/preprocessed_data/adni/connectome_mist7_20180808';
opt.flag_p2p = false; % No parcel-to-parcel correlation values
opt.flag_global_prop = false; % No global graph properties
opt.flag_local_prop  = false; % No local graph properties
opt.flag_rmap = true; % Generate correlation maps

%% Running the pipeline
opt.flag_test = false;
[pipeline,opt] = niak_pipeline_connectome(files_in,opt);
