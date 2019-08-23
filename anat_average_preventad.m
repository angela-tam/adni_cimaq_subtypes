% script to create average individual T1 templates

path_anat = '/data/cisl/raw_data/preventad/t1/';

path_out = '/data/cisl/preprocessed_data/preventad/t1_averages/';

% make files in structure
files_in = struct;

% list of all anat files
list_anat = dir(path_anat);
list_anat = {list_anat.name};
list_anat = list_anat(~ismember(list_anat,{'.','..'}));

% cell for list of subjects
list_sub = {};

% get a list of unique subjects in the folder
cc = 1;
for ss = 1:length(list_anat)
    tmp = strsplit(list_anat{ss},'_');
    rid = tmp{2};
    sub_name = strcat('s', rid);
    if ~any(strcmp(list_sub,sub_name))
      list_sub{cc} = sub_name;
    else
      continue
    end
    cc = cc + 1;
    %files_in.(sub_name).anat = [path_rest filesep list_anat{ss}];
end

opt = [];
opt.nb_iter = 4;
opt.flag_test = true;
opt.folder_out = path_out;
for dd = 1:length(list_sub)
    sub = list_sub{dd};
    rid = list_sub{dd}(2:end);
    sub_anat = dir(strcat(path_anat,'*',rid,'*'));
    sub_anat = {sub_anat.name};
    opt.(sub).folder_out = [path_out rid];
    opt.(sub).flag_test = true;
    [pipe.(sub),opt.(sub)] = niak_pipeline_t1_average(sub_anat,opt.(sub));
end


bpipe = struct;
for ff = 1:length(fieldnames(pipe))
    sub = fieldnames(pipe){ff};
    pref = strcat(sub,'_');
    bpipe = psom_merge_pipeline(bpipe,pipe.(sub),pref);
end

opt_n = [];
opt_n.path_logs = [path_out 'logs'];

psom_run_pipeline(bpipe,opt_n);






