%% script to run vbm on preventad t1 images

clear all

addpath(genpath('/data/cisl/spm12'))
addpath(genpath('/data/cisl/spm_container'))
path_temp = '/data/cisl/raw_data/adni/templates';
path_data = '/data/cisl/raw_data/preventad/t1_nii';

path_out = '/data/cisl/preprocessed_data/preventad/vbm/';

% make files in structure
files_in = struct;
list_scan = dir(path_data);
list_scan = {list_scan.name};
list_scan = list_scan(~ismember(list_scan,{'.','..'}));

for ss = 1:length(list_scan)
    tmp = strsplit(list_scan{ss},'.');
    scan = tmp{1};
    files_in.anat.(scan) = [path_data filesep scan '.nii'];
end

% exclude the phantoms
exc = {'PreventAD_424640_lego_phantom_MTL_20130123_adniT1_001','PreventAD_424640_lego_phantom_MTL_20130123_adniT1_002',...
    'PreventAD_424640_lego_phantom_MTL_20130220_adniT1_001','PreventAD_424640_lego_phantom_MTL_20130220_adniT1_002',...
    'PreventAD_424640_living_phantom_MTL_MS_20140717_adniT1_001'};
files_in.anat = rmfield(files_in.anat,exc);

% exclude failed scans
fails = {'PreventAD_211391_NAPFU24_adniT1_001','PreventAD_211391_NAPFU24_adniT1_002','PreventAD_303995_PREBL00_adniT1_001',...
    'PreventAD_672207_NAPFU03_adniT1_001','PreventAD_693999_NAPBL00_adniT1_001','PreventAD_748634_NAPFU24_adniT1_002',...
    'PreventAD_758921_NAPFU48_adniT1_002','PreventAD_787460_PREFU48_adniT1_001','PreventAD_966786_NAPFU48_adniT1_001'};
files_in.anat = rmfield(files_in.anat,fails);

opt.folder_out = path_out;
%opt.psom.qsub_options = '--mem=8G  --account rrg-pbellec --time=00-30:00 --ntasks=1 --cpus-per-task=1  ';

%[pipe,opt] = niak_spm_pipeline_vbm(files_in,opt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Run the fmri_preprocess pipeline  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_batch = 4;
list_scan = fieldnames(files_in.anat);
opt.flag_test = true;
list_batch = ceil(linspace(1,length(list_scan),n_batch+1));
list_batch(1) = 0;
opt_p = struct();
for bb = 1:n_batch
    name_batch = sprintf('batch%i',bb); 
    files_batch = struct;
    for ss = (list_batch(bb)+1):list_batch(bb+1)
      files_batch.anat.(list_scan{ss}) = files_in.anat.(list_scan{ss});
    end
    files_batch.dartel_template.temp_1 = [path_temp filesep 'template_1.nii'];
    files_batch.dartel_template.temp_2 = [path_temp filesep 'template_2.nii'];
    files_batch.dartel_template.temp_3 = [path_temp filesep 'template_3.nii'];
    files_batch.dartel_template.temp_4 = [path_temp filesep 'template_4.nii'];
    files_batch.dartel_template.temp_5 = [path_temp filesep 'template_5.nii'];
    files_batch.dartel_template.temp_6 = [path_temp filesep 'template_6.nii'];
    opt.folder_out = [path_out name_batch filesep];
    [pipe.(name_batch),opt_p.(name_batch)] = niak_spm_pipeline_vbm(files_batch,opt);
end


psom_run_pipeline(pipe.batch1,opt_p.batch1.psom);
psom_run_pipeline(pipe.batch2,opt_p.batch2.psom);
psom_run_pipeline(pipe.batch3,opt_p.batch3.psom);
psom_run_pipeline(pipe.batch4,opt_p.batch4.psom);

