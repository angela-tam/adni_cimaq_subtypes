# use only 83 workers
opt.psom.max_queued = 30;
# first run
opt.slice_timing.type_scanner = '';
opt.slice_timing.delay_in_tr = 0;
opt.slice_timing.flag_skip = 1;
opt.folder_out='/home/eloipre/scratch/Niak_preprocessing_outputs_CIMAQ';
grab_opt.anat_hint ='T1w'
grab_opt.max_subjects = 160
a = niak_grab_bids('/home/eloipre/scratch/CIMAQ_BIDS_151',grab_opt);
to_remove= {'sub804743'};
a=rmfield(a,to_remove)

opt.tune(1).subject = 'sub146090';
opt.tune(1).param.t1_preprocess.nu_correct.arg = '-distance 50';

opt.tune(2).subject = 'sub164965';
opt.tune(2).param.t1_preprocess.nu_correct.arg = '-distance 50';

opt.tune(3).subject = 'sub327986';
opt.tune(3).param.t1_preprocess.nu_correct.arg = '-distance 50';

opt.tune(4).subject = 'sub380445';
opt.tune(4).param.t1_preprocess.nu_correct.arg = '-distance 50';

opt.tune(5).subject = 'sub401205';
opt.tune(5).param.t1_preprocess.nu_correct.arg = '-distance 50';

opt.tune(6).subject = 'sub421163';
opt.tune(6).param.t1_preprocess.nu_correct.arg = '-distance 50';

opt.tune(7).subject = 'sub463105';
opt.tune(7).param.t1_preprocess.nu_correct.arg = '-distance 50';

opt.tune(8).subject = 'sub467954';
opt.tune(8).param.t1_preprocess.nu_correct.arg = '-distance 50';

opt.tune(9).subject = 'sub548404';
opt.tune(9).param.t1_preprocess.nu_correct.arg = '-distance 50';

opt.tune(10).subject = 'sub597569';
opt.tune(10).param.t1_preprocess.nu_correct.arg = '-distance 50';

opt.tune(11).subject = 'sub668786';
opt.tune(11).param.t1_preprocess.nu_correct.arg = '-distance 50';

opt.tune(12).subject = 'sub818307';
opt.tune(12).param.t1_preprocess.nu_correct.arg = '-distance 50';

opt.tune(13).subject = 'sub886007';
opt.tune(13).param.t1_preprocess.nu_correct.arg = '-distance 50';

opt.tune(14).subject = 'sub893639';
opt.tune(14).param.t1_preprocess.nu_correct.arg = '-distance 50';

opt.tune(15).subject = 'sub896890';
opt.tune(15).param.t1_preprocess.nu_correct.arg = '-distance 50';

opt.tune(16).subject = 'sub834694';
opt.tune(16).param.t1_preprocess.crop_neck = 0.25;

opt.tune(17).subject = 'sub237951';
opt.tune(17).param.t1_preprocess.crop_neck = 0.20;

opt.tune(18).subject = 'sub662209';
opt.tune(18).param.t1_preprocess.crop_neck = 0.20;

opt.tune(19).subject = 'sub611208';
opt.tune(19).param.t1_preprocess.crop_neck = 0.25;

opt.psom.flag_update = true
opt.t1_preprocess.nu_correct.arg = '-distance 75';

opt.resample_vol.interpolation = 'trilinear';
opt.resample_vol.voxel_size = [3 3 3];

opt.smooth_vol.fwhm = 3;
opt.smooth_vol.flag_skip = 0;

p = niak_pipeline_fmri_preprocess(a,opt);
