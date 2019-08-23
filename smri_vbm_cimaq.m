%% template script to run segmentation and dartel on T1-weighted images

% after loading niak boss

clear all

%%%%%% adding paths to software

% adding path to spm12
addpath(genpath('/data/cisl/spm12'))

% adding path to octave friendly spm functions
addpath(genpath('/data/cisl/spm_container'))

%%%%%% defining variables

% defining path to pre-defined templates
path_temp = '/data/cisl/raw_data/adni/templates';

% defining path to output folder
path_out = '/mnt/home_sq/eprevost/Desktop/Niak_vbm_outputs_CIMAQ';

%%%%%% make files in structure

% add individual subject data to files_in structure (example for two persons)
subjects={'sub-108391', 'sub-120839', 'sub-122922', 'sub-127228', 'sub-139593', 'sub-146090', 'sub-147863', 'sub-150649', 'sub-164965', 'sub-175295', 'sub-178101', 'sub-187625', 'sub-189005', 'sub-195016', 'sub-195287', 'sub-197192', 'sub-199158', 'sub-199801', 'sub-219637', 'sub-229301', 'sub-237951', 'sub-247659', 'sub-254402', 'sub-254530', 'sub-255499', 'sub-258618', 'sub-258912', 'sub-267168', 'sub-270218', 'sub-271596', 'sub-272829', 'sub-287981', 'sub-288654', 'sub-314409', 'sub-318809', 'sub-324734', 'sub-326073', 'sub-327986', 'sub-336665', 'sub-337021', 'sub-350555', 'sub-370092', 'sub-373285', 'sub-380445', 'sub-385370', 'sub-386333', 'sub-388174', 'sub-396250', 'sub-401205', 'sub-402979', 'sub-403131', 'sub-408506', 'sub-413474', 'sub-414656', 'sub-421163', 'sub-427357', 'sub-430653', 'sub-437101', 'sub-439776', 'sub-441008', 'sub-444580', 'sub-458807', 'sub-459801', 'sub-462345', 'sub-463105', 'sub-467954', 'sub-484204', 'sub-490035', 'sub-502616', 'sub-517070', 'sub-517404', 'sub-520377', 'sub-543589', 'sub-548404', 'sub-549994', 'sub-555537', 'sub-560180', 'sub-562245', 'sub-567214', 'sub-584267', 'sub-587006', 'sub-597569', 'sub-608044', 'sub-611208', 'sub-619278', 'sub-628299', 'sub-628513', 'sub-630120', 'sub-637798', 'sub-640283', 'sub-651050', 'sub-652850', 'sub-658178', 'sub-659068', 'sub-662209', 'sub-668786', 'sub-677561', 'sub-700293', 'sub-711830', 'sub-729722', 'sub-739694', 'sub-748676', 'sub-754026', 'sub-763590', 'sub-778749', 'sub-783781', 'sub-785217', 'sub-785245', 'sub-804743', 'sub-810098', 'sub-818307', 'sub-827863', 'sub-834694', 'sub-845675', 'sub-851050', 'sub-853115', 'sub-856107', 'sub-866812', 'sub-878354', 'sub-878652', 'sub-881008', 'sub-884343', 'sub-886007', 'sub-893639', 'sub-893978', 'sub-896890', 'sub-901551', 'sub-906145', 'sub-912255', 'sub-914042', 'sub-915022', 'sub-917530', 'sub-920050', 'sub-920577', 'sub-923391', 'sub-924191', 'sub-932933', 'sub-936730', 'sub-938001', 'sub-944698', 'sub-946901', 'sub-955548', 'sub-956049', 'sub-956130', 'sub-968913', 'sub-974246', 'sub-979001', 'sub-983291', 'sub-988602', 'sub-996599', 'sub-998166'}

for r = 1:length(subjects)
	gunzip "/mnt/home_sq/eprevost/Desktop/CIMAQ_BIDS_151/",(subjects{r}),"/anat/",(subjects{r}),"T1w.nii.gz"
    files_in.anat.(subjects{r}) = strcat("/mnt/home_sq/eprevost/Desktop/CIMAQ_BIDS_151/",(subjects{r}),"/anat/",(subjects{r}),"_T1w.nii")
end


% add the templates to files_in structure
files_in.dartel_template.temp_1 = [path_temp filesep 'template_1.nii'];
files_in.dartel_template.temp_2 = [path_temp filesep 'template_2.nii'];
files_in.dartel_template.temp_3 = [path_temp filesep 'template_3.nii'];
files_in.dartel_template.temp_4 = [path_temp filesep 'template_4.nii'];
files_in.dartel_template.temp_5 = [path_temp filesep 'template_5.nii'];
files_in.dartel_template.temp_6 = [path_temp filesep 'template_6.nii'];

%%%%%% options

%opt_g.exclude_subject={"sub-403131"}

% option for output folder
opt.folder_out = path_out;

% option to test
opt.flag_test = false; % If FLAG_TEST is true, the pipeline will just produce a pipeline structure, and will not actually process the data.

%%%%%% running pipeline
[pipe,opt] = niak_spm_pipeline_vbm(files_in,opt);