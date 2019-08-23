% preprocessing the adni2 resting state dataset with niak cog 1.1.4 on pin

path_data = '/data/cisl/raw_data/adni/adni2_rsfmri';

path_out = '/data/cisl/preprocessed_data/adni/rsfmri_20180721';

%% set up files_in structure

files = dir(path_data);
files = {files.name};
files = files(~ismember(files,{'.','..','adni2_demographic_XXXXX.csv','fmri_preprocess_nofwhm','octave-workspace'}));


for ss = 1:length(files)
  % from file name, grab subject ID
  sub_file = files{ss};
  tmp = strsplit(sub_file,'_');
  rid = tmp{1};
  sid = strcat('s',rid);
  
  % identify the t1
  t1_files = dir([path_data filesep rid '*_1_1.mnc.gz']);
  t1_files = {t1_files.name};
  t1_files = t1_files(~ismember(t1_files,{'.','..'}));
  % if multiple files exist, take the first one
  if ~isempty(t1_files)
    t1_bl = t1_files{1};
    files_in.(sid).anat = [path_data filesep t1_bl];
  end
  
  % identify the resting-state scan
  rs_files = dir([path_data filesep rid '*_2_1*.mnc.gz']);
  rs_files = {rs_files.name};
  rs_files = rs_files(~ismember(rs_files,{'.','..'}));
   % if multiple files exist, take the first one
  if ~isempty(rs_files)
    rs_bl = rs_files{1};
    files_in.(sid).fmri.session1.rest = [path_data filesep rs_bl];
  end
end

fails = {'s0413','s2391','s2402','s2403','s4012','s4369','s4849','s4987','s4094','s4128','s4135','s4149',...
    's4237','s4264','s4270'};
files_in = rmfield(files_in,fails);
  

%% options
opt.folder_out = path_out;
opt.size_output = 'quality_control';

%% Slice timing correction (niak_brick_slice_timing)
opt.slice_timing.type_acquisition = 'interleaved ascending'; % Slice timing order (available options : 'sequential ascending', 'sequential descending', 'interleaved ascending', 'interleaved descending')
opt.slice_timing.type_scanner     = 'Philips';                % Scanner manufacturer. Only the value 'Siemens' will actually have an impact
opt.slice_timing.delay_in_tr      = 0;                       % The delay in TR ("blank" time between two volumes)
opt.slice_timing.suppress_vol     = 0;                       % Number of dummy scans to suppress.
opt.slice_timing.flag_nu_correct  = 0;                       % Apply a correction for non-uniformities on the EPI volumes (1: on, 0: of). This is particularly important for 32-channels coil.
opt.slice_timing.arg_nu_correct   = '-distance 200';         % The distance between control points for non-uniformity correction (in mm, lower values can capture faster varying slow spatial drifts).
opt.slice_timing.flag_center      = 0;                       % Set the origin of the volume at the center of mass of a brain mask. This is useful only if the voxel-to-world transformation from the DICOM header has somehow been damaged. This needs to be assessed on the raw images.
opt.slice_timing.flag_skip        = 0;                       % Skip the slice timing (0: don't skip, 1 : skip). Note that only the slice timing corretion portion is skipped, not all other effects such as FLAG_CENTER or FLAG_NU_CORRECT

%% Motion estimation (niak_pipeline_motion)
opt.motion.session_ref  = 'session1';

%% resampling in stereotaxic space
opt.resample_vol.interpolation = 'trilinear'; % The resampling scheme. The fastest and most robust method is trilinear. 
opt.resample_vol.voxel_size    = [3 3 3];     % The voxel size to use in the stereotaxic space
opt.resample_vol.flag_skip     = 0;           % Skip resampling (data will stay in native functional space after slice timing/motion correction) (0: don't skip, 1 : skip)

%% Linear and non-linear fit of the anatomical image in the stereotaxic
% space (niak_brick_t1_preprocess)
opt.t1_preprocess.nu_correct.arg = '-distance 75'; % Parameter for non-uniformity correction. 200 is a suggested value for 1.5T images, 75 for 3T images. If you find that this stage did not work well, this parameter is usually critical to improve the results.

%% Temporal filtering (niak_brick_time_filter)
opt.time_filter.hp = 0.01; % Cut-off frequency for high-pass filtering, or removal of low frequencies (in Hz). A cut-off of -Inf will result in no high-pass filtering.
opt.time_filter.lp = Inf;  % Cut-off frequency for low-pass filtering, or removal of high frequencies (in Hz). A cut-off of Inf will result in no low-pass filtering.

%% Regression of confounds and scrubbing (niak_brick_regress_confounds)
opt.regress_confounds.flag_wm = true;            % Turn on/off the regression of the average white matter signal (true: apply / false : don't apply)
opt.regress_confounds.flag_vent = true;          % Turn on/off the regression of the average of the ventricles (true: apply / false : don't apply)
opt.regress_confounds.flag_motion_params = true; % Turn on/off the regression of the motion parameters (true: apply / false : don't apply)
opt.regress_confounds.flag_gsc = false;          % Turn on/off the regression of the PCA-based estimation of the global signal (true: apply / false : don't apply)
opt.regress_confounds.flag_scrubbing = true;     % Turn on/off the scrubbing of time frames with excessive motion (true: apply / false : don't apply)
opt.regress_confounds.thre_fd = 0.2;             % The threshold on frame displacement that is used to determine frames with excessive motion in the scrubbing procedure

%% Correction of physiological noise (niak_pipeline_corsica)
opt.corsica.sica.nb_comp             = 60;    % Number of components estimated during the ICA. 20 is a minimal number, 60 was used in the validation of CORSICA.
opt.corsica.threshold                = 0.15;  % This threshold has been calibrated on a validation database as providing good sensitivity with excellent specificity.
opt.corsica.flag_skip                = 1;     % Skip CORSICA (0: don't skip, 1 : skip). Even if it is skipped, ICA results will be generated for quality-control purposes. The method is not currently considered to be stable enough for production unless it is manually supervised.

%% Spatial smoothing (niak_brick_smooth_vol)
opt.smooth_vol.fwhm      = 6;  % Full-width at maximum (FWHM) of the Gaussian blurring kernel, in mm.
opt.smooth_vol.flag_skip = 0;  % Skip spatial smoothing (0: don't skip, 1 : skip)

%% individual parameters
% Flag center
opt.tune(1).subject = 'subject4021';
opt.tune(1).param.slice_timing = opt.slice_timing;
opt.tune(1).param.slice_timing.flag_center = true;

opt.tune(2).subject = 'subject4042';
opt.tune(2).param.slice_timing = opt.slice_timing;
opt.tune(2).param.slice_timing.flag_center = true;

opt.tune(3).subject = 'subject4194';
opt.tune(3).param.slice_timing = opt.slice_timing;
opt.tune(3).param.slice_timing.flag_center = true;

opt.tune(4).subject = 'subject4269';
opt.tune(4).param.t1_preprocess.nu_correct.arg = '-distance 50'; % param tested 75,50

opt.tune(5).subject = 'subject4511';
opt.tune(5).param.slice_timing = opt.slice_timing;
opt.tune(5).param.slice_timing.flag_center = true;

opt.tune(6).subject = 'subject4713';
opt.tune(6).param.slice_timing = opt.slice_timing;
opt.tune(6).param.slice_timing.flag_center = true; % Anything that usually goes in opt can go in param. What's specified in opt applies by default, but is overridden by tune.param

opt.tune(7).subject = 'subject4192';
opt.tune(7).param.t1_preprocess.nu_correct.arg = '-distance 50'; % param tested 75,50

opt.tune(8).subject = 'subject4218';
opt.tune(8).param.slice_timing = opt.slice_timing;
opt.tune(8).param.slice_timing.flag_center = true;

opt.tune(9).subject = 'subject4473';
opt.tune(9).param.t1_preprocess.nu_correct.arg = '-distance 50'; % param tested 75,50

opt.tune(10).subject = 'subject5070';
opt.tune(10).param.t1_preprocess.nu_correct.arg = '-distance 50'; % param tested 75,50

opt.tune(11).subject = 'subject4713';
opt.tune(11).param.slice_timing = opt.slice_timing;
opt.tune(11).param.slice_timing.flag_center = true;

opt.tune(12).subject = 'subject4546';
opt.tune(12).param.slice_timing = opt.slice_timing;
opt.tune(12).param.slice_timing.flag_center = true;

opt.tune(13).subject = 'subject4171';
opt.tune(13).param.slice_timing = opt.slice_timing;
opt.tune(13).param.slice_timing.flag_center = true;

opt.tune(14).subject = 'subject4094';
opt.tune(14).param.slice_timing = opt.slice_timing;
opt.tune(14).param.slice_timing.flag_center = true;

opt.tune(15).subject = 'subject4251';
opt.tune(15).param.slice_timing = opt.slice_timing;
opt.tune(15).param.slice_timing.flag_center = true;

opt.tune(16).subject = 'subject4128';
opt.tune(16).param.slice_timing = opt.slice_timing;
opt.tune(16).param.slice_timing.flag_center = true;

opt.tune(17).subject = 'subject2373';
opt.tune(17).param.slice_timing = opt.slice_timing;
opt.tune(17).param.slice_timing.flag_center = true;

opt.tune(18).subject = 'subject4188';
opt.tune(18).param.slice_timing = opt.slice_timing;
opt.tune(18).param.slice_timing.flag_center = true;

opt.tune(19).subject = 'subject4422';
opt.tune(19).param.slice_timing = opt.slice_timing;
opt.tune(19).param.slice_timing.flag_center = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Run the fmri_preprocess pipeline  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[pipeline,opt] = niak_pipeline_fmri_preprocess(files_in,opt);