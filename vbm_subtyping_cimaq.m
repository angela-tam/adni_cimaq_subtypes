% Template to write a script for the NIAK subtyping pipeline

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setting input/output files %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clear the workspace
clear all

%%%%%% make files in structure

% add individual subject data to files_in structure (example for two persons)
subjects={'sub-108391', 'sub-120839', 'sub-122922', 'sub-127228', 'sub-139593', 'sub-146090', 'sub-147863', 'sub-150649', 'sub-164965', 'sub-175295', 'sub-187625', 'sub-189005', 'sub-195016', 'sub-195287', 'sub-197192', 'sub-199158', 'sub-199801', 'sub-229301', 'sub-247659', 'sub-254530', 'sub-255499', 'sub-258618', 'sub-258912', 'sub-267168', 'sub-270218', 'sub-271596', 'sub-272829', 'sub-287981', 'sub-288654', 'sub-314409', 'sub-318809', 'sub-324734', 'sub-326073', 'sub-327986', 'sub-336665', 'sub-337021', 'sub-350555', 'sub-370092', 'sub-373285', 'sub-385370', 'sub-386333', 'sub-388174', 'sub-396250', 'sub-401205', 'sub-402979', 'sub-408506', 'sub-413474', 'sub-414656', 'sub-421163', 'sub-427357', 'sub-430653', 'sub-437101', 'sub-439776', 'sub-441008', 'sub-444580', 'sub-458807', 'sub-459801', 'sub-462345', 'sub-463105', 'sub-467954', 'sub-490035', 'sub-502616', 'sub-517404', 'sub-520377', 'sub-543589', 'sub-555537', 'sub-560180', 'sub-562245', 'sub-567214', 'sub-584267', 'sub-587006', 'sub-608044', 'sub-619278', 'sub-628299', 'sub-628513', 'sub-630120', 'sub-640283', 'sub-651050', 'sub-652850', 'sub-658178', 'sub-659068', 'sub-662209', 'sub-700293', 'sub-711830', 'sub-729722', 'sub-739694', 'sub-748676', 'sub-754026', 'sub-763590', 'sub-778749', 'sub-783781', 'sub-785217', 'sub-804743', 'sub-818307', 'sub-827863', 'sub-834694', 'sub-853115', 'sub-856107', 'sub-866812', 'sub-878354', 'sub-878652', 'sub-881008', 'sub-886007', 'sub-893639', 'sub-893978', 'sub-896890', 'sub-901551', 'sub-906145', 'sub-914042', 'sub-915022', 'sub-917530', 'sub-920577', 'sub-923391', 'sub-924191', 'sub-932933', 'sub-936730', 'sub-938001', 'sub-946901', 'sub-955548', 'sub-956049', 'sub-956130', 'sub-968913', 'sub-974246', 'sub-983291', 'sub-988602', 'sub-996599', 'sub-998166'};


for r = 1:length(subjects)
    files_in.data.network1.(subjects{r}) = strcat("/mnt/home_sq/eprevost/Desktop/Niak_vbm_outputs_CIMAQ/",(subjects{r}),"/smwrc1acpc_",(subjects{r}),"_T1w_stereolin.nii")
end

% Mask
files_in.mask = '/data/cisl/preprocessed_data/adni/vbm/yasser_templates/rc1mni_icbm152_t1_tal_nlin_asym_09c_6.nii';     % a 3D binary mask
files_in.model = '/mnt/home_sq/eprevost/Desktop/CIMAQ_infos_sub-.csv'

%%%%%%%%%%%%%%%%%%%%%%%
%% Pipeline options  %%
%%%%%%%%%%%%%%%%%%%%%%%

%% General
opt.folder_out = '/mnt/home_sq/eprevost/Desktop/Niak_subtyping_vbm_outputs_CIMAQ';     % where to store the results

%% Stack
opt.stack.flag_conf = true;                    % turn on/off regression of confounds during stacking (true: apply / false: don't apply)
opt.stack.regress_conf = {'Age_Loris', 'Male', 'Female', 'SIEMENS_site', 'CINQ', 'mean_gm', 'tiv' };     % a list of varaible names to be regressed out

%% Subtyping
opt.subtype.nb_subtype = 3;       % the number of subtypes to extract
opt.subtype.sub_map_type = 'mean';        % the model for the subtype maps (options are 'mean' or 'median')
opt.scale = 1




%%%%%%%%%%%%%%%%%%%%%%%
%% Run the pipeline  %%
%%%%%%%%%%%%%%%%%%%%%%%

opt.flag_test = false;  % Put this flag to true to just generate the pipeline without running it.
[pipeline,opt] = niak_pipeline_subtype(files_in,opt);