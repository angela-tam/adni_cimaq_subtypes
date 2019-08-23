% This option is useful when scrubbing is used, and the resulting time series may be too short.
opt_g.min_nb_vol = 100;

% Specify to the grabber to prepare the files for the connectome pipeline
opt_g.type_files = "glm_connectome";
opt_g.exclude_subject={"sub146090","sub147863","sub164965","sub178101","sub187625","sub189005","sub199158","sub237951","sub327986","sub380445","sub401205","sub408506","sub463105","sub467954","sub517404","sub548404","sub597569","sub630120","sub662209","sub668786","sub729722","sub739694","sub804743","sub818307","sub827863","sub834694","sub893639","sub896890"};
files_in.fmri = niak_grab_fmri_preprocess("/home/eloipre/scratch/Niak_preprocessing_outputs_CIMAQ",opt_g).fmri

%Specify the template
files_in.network = "/home/eloipre/scratch/MIST_Parcellation/Parcellations/MIST_12.nii.gz";

%Specify seeds (ROI)
files_in.seeds = ["/home/eloipre/scratch/MIST_Parcellation/list_seeds.csv"];
opt_csv.labels_x = { 'BG_THAL','AUD_PINS','LIM','DMN_l','VIS','DMN_pm','MOT','DMN_am','VVIS_DVIS','FP','VATT_SAL','CER'}; % The labels for the network
opt_csv.labels_y = { 'index' };
tab = [1;2;3;4;5;6;7;8;9;10;11;12];
niak_write_csv(files_in.seeds,tab,opt_csv);

opt.folder_out="/home/eloipre/scratch/Niak_connectome_outputs_CIMAQ"

%Pipeline options
opt.flag_p2p = false; % No parcel-to-parcel correlation values
opt.flag_global_prop = false; % No global graph properties
opt.flag_local_prop  = false; % No local graph properties
opt.flag_rmap = true; % Generate correlation maps

%Running the pipeline
opt.flag_test = false;
[pipeline,opt] = niak_pipeline_connectome(files_in,opt);
