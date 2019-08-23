% Template to write a script for the NIAK subtyping pipeline

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setting input/output files %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clear the workspace
clear all

%%%%%% make files in structure

% add individual subject data to files_in structure (example for two persons)
subjects={'sub108391', 'sub120839', 'sub122922', 'sub127228', 'sub139593', 'sub150649', 'sub175295', 'sub195016', 'sub195287', 'sub197192', 'sub199801', 'sub219637', 'sub229301', 'sub247659', 'sub254402', 'sub254530', 'sub255499', 'sub258618', 'sub258912', 'sub267168', 'sub270218', 'sub271596', 'sub272829', 'sub287981', 'sub288654', 'sub314409', 'sub318809', 'sub324734', 'sub326073', 'sub336665', 'sub337021', 'sub350555', 'sub370092', 'sub373285', 'sub385370', 'sub386333', 'sub388174', 'sub396250', 'sub402979', 'sub403131', 'sub413474', 'sub414656', 'sub421163', 'sub427357', 'sub430653', 'sub437101', 'sub439776', 'sub441008', 'sub444580', 'sub458807', 'sub459801', 'sub462345', 'sub484204', 'sub490035', 'sub502616', 'sub517070', 'sub520377', 'sub543589', 'sub549994', 'sub555537', 'sub560180', 'sub562245', 'sub567214', 'sub584267', 'sub587006', 'sub608044', 'sub611208', 'sub619278', 'sub628299', 'sub628513', 'sub637798', 'sub640283', 'sub651050', 'sub652850', 'sub658178', 'sub659068', 'sub677561', 'sub700293', 'sub711830', 'sub748676', 'sub754026', 'sub763590', 'sub778749', 'sub783781', 'sub785217', 'sub785245', 'sub810098', 'sub845675', 'sub851050', 'sub853115', 'sub856107', 'sub866812', 'sub878354', 'sub878652', 'sub881008', 'sub884343', 'sub886007', 'sub893978', 'sub901551', 'sub906145', 'sub912255', 'sub914042', 'sub915022', 'sub917530', 'sub920050', 'sub920577', 'sub923391', 'sub924191', 'sub932933', 'sub936730', 'sub938001', 'sub944698', 'sub946901', 'sub955548', 'sub956049', 'sub956130', 'sub968913', 'sub974246', 'sub979001', 'sub983291'}
networks = {"BG_THAL", "AUD_PINS", "LIM", "DMN_l", "VIS", "DMN_pm", "MOT", "DMN_am","VVIS_DVIS", "FP", "VATT_SAL", "CER"}

for r = 1:length(subjects)
  for n = 1:length(networks)
    files_in.data.(networks{n}).(subjects{r}) = strcat("/data/cisl/eloi/CIMAQ/Niak_connectome_outputs_CIMAQ/rmap_seeds/rmap_",(subjects{r}),"_",(networks{n}),".mnc")
  end
end

% Mask
files_in.mask = '/data/cisl/eloi/CIMAQ/Niak_preprocessing_outputs_CIMAQ/quality_control/group_coregistration/func_mask_group_stereonl.mnc';     % a 3D binary mask
files_in.model = '/mnt/home_sq/eprevost/Desktop/CIMAQ_infos.csv'

%%%%%%%%%%%%%%%%%%%%%%%
%% Pipeline options  %%
%%%%%%%%%%%%%%%%%%%%%%%

%% General
opt.folder_out = '/mnt/home_sq/eprevost/Desktop/Niak_subtyping_connectome_outputs_CIMAQ';     % where to store the results

%% Stack
opt.stack.flag_conf = true;                    % turn on/off regression of confounds during stacking (true: apply / false: don't apply)
opt.stack.regress_conf = {'Age_Loris', 'FD_scrubbed', 'Male', 'Female', 'SIEMENS_site', 'CINQ' };     % a list of variable names to be regressed out

%% Subtyping
opt.subtype.nb_subtype = 3;       % the number of subtypes to extract
opt.subtype.sub_map_type = 'mean';        % the model for the subtype maps (options are 'mean' or 'median')
opt.scale = 1




%%%%%%%%%%%%%%%%%%%%%%%
%% Run the pipeline  %%
%%%%%%%%%%%%%%%%%%%%%%%

opt.flag_test = false;  % Put this flag to true to just generate the pipeline without running it.
[pipeline,opt] = niak_pipeline_subtype(files_in,opt);