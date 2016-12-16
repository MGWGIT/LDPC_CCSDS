clear

tstart = tic;

cf_data = load('cf_fix_data_cf1_v2.mat','cfi','db','lnm');
cf = cf_data.cfi(5,11);
cf = 1;

n = 1024*4;

m = 100;
d = 8;
ST = 1/16;
db0 = 3.0;
its = 13;
nrm = 3.25;

lnm = 'data_cf.mat';
nm = 'dec_ms_llrn';

fhndl = @decoder_ms_fchk_0123_00_mod_fix_cf_opt_16_8;

F_berr__chk_swf_fr_fhndl(n,m,d,ST,db0,its,nm,lnm,fhndl,cf,nrm);

t = toc(tstart);
v = n*m*d*1024/t

clear functions