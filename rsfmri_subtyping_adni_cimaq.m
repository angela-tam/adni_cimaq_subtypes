% script to subtype rsfmri of cimaq and adni2 combined

clear all

path_adni = '/data/cisl/preprocessed_data/adni/connectome_mist7_20180808/rmap_seeds/';
path_cimaq = '/data/cisl/eloi/CIMAQ/7_networks/Niak_connectome7_outputs_CIMAQ/rmap_seeds/';
path_mask = '/data/cisl/preprocessed_data/masks/mask.mnc';
path_model = '/data/cisl/adni_cimaq_subtypes/adni_cimaq_info_niak.csv';

path_out = '/data/cisl/adni_cimaq_subtypes/';

% make a list of subjects to exclude (those who didn't pass QC)
[tabd,sid,ly,~] = niak_read_csv(path_model);
mask_pass = logical(tabd(:,7));
fail_sub = sid(~mask_pass);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set up files_in structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% grab the adni subjects
% set up files_in structure

a_files = dir(fullfile(path_adni, 'rmap*'));
a_files = {a_files.name};

for aa = 1:length(a_files)
    asub_file = a_files{aa};
    tmp = strsplit(asub_file,'_');
    a_id = tmp{2};
        if strcmp(tmp{3},'VATT')
            net = tmp{3};
        else
            net = tmp{3}(1:end-7);
        end
    files_in.data.(net).(a_id) = [path_adni filesep asub_file];
end

%% grab the cimaq subjects
c_files = dir(fullfile(path_cimaq, 'rmap*'));
c_files = {c_files.name};

for cc = 1:length(c_files)
    csub_file = c_files{cc};
    tmp = strsplit(csub_file,'_');
    s_id = tmp{2};
        if strcmp(tmp{3},'VATT')
            net = tmp{3};
        else
            net = tmp{3}(1:end-4);
        end
    files_in.data.(net).(s_id) = [path_cimaq filesep csub_file];
end

% remove the failed subjects (just in case)
nets = {'CER','DMN','FP','LIM','MOT','VATT','VIS'};
for ss = 1:length(nets)
    net = net{ss};
    files_in.data.(net) = rmfield(files_in.data.(net),fail_sub);
end

files_in.mask = path_mask;
files_in.model = path_model;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% options
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% General
%opt.folder_out = '/data/cisl/adni_cimaq_subtypes/';     % where to store the results

%% Stack
opt.stack.flag_conf = true;                    % turn on/off regression of confounds during stacking (true: apply / false: don't apply)
opt.stack.regress_conf = {'age','FD_scrubbed','Female','adni_achieva','adni_gemini',...
    'adni_ingenia','adni_ingenuity','adni_intera','cimaq_siemens','cimaq_cinq'};     % a list of variable names to be regressed out

%% Subtyping
%opt.subtype.nb_subtype = 3;       % the number of subtypes to extract
opt.subtype.sub_map_type = 'mean';        % the model for the subtype maps (options are 'mean' or 'median')
opt.flag_test = true;

num_clus = [3 4 5 6 7];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get the pipeline structure for all number of subtypes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ss = 1:length(num_clus)
    nb_sub = num_clus(ss);
    temp = strcat('sub',num2str(nb_sub));
    opt.subtype.nb_subtype = nb_sub;
    opt.folder_out = [path_out filesep num2str(nb_sub) 'clus'];
    [pipe.(temp), opt] = niak_pipeline_subtype(files_in,opt);
    clear opt.subtype.nb_subtype opt.folder_out
end

%% join the pipeline
bpipe = struct;
for ff = 1:length(fieldnames(pipe))
    sub = fieldnames(pipe){ff};
    pref = strcat(sub,'_');
    bpipe = psom_merge_pipeline(bpipe,pipe.(sub),pref);
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%
%% run the pipeline
%%%%%%%%%%%%%%%%%%%%%%%%%%
opt_n = [];
opt_n.path_logs = [path_out 'logs'];

psom_run_pipeline(bpipe,opt_n);




