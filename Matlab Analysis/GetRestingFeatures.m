function features = GetRestingFeatures( sig,prm )

features =[];
% sampling rate of our EEG
fs = prm.SamplingRate.NumericValue;
% first, let's common average re-reference? (maybe try spatial laplacian
% instead?)
sig = sig - repmat( mean(sig,2),1,size(sig,2) );
% then filter between 1 and 30Hz with 8th order butterworth
h  = design( fdesign.bandpass('N,F3dB1,F3dB2', 8, 1, 30, fs), 'butter' );
sig= filter(h,sig);
% ignore first and last 3 seconds of EEG clip (to drowsy at end, and the
% signal is sometimes not stabilized at the beginning from amplifiers)
ignore = 3;
sig = sig( (ignore*fs+1):(end-ignore*fs),: );

% let's look at average band-power over {frontal}, {frontalLeft},
% {frontalRight}, {central and central-parietal}, {parietal and occipital}
% regions for delta, theta, alpha, beta power band changes

% groupings are based on eloc32.txt
% frontal =      [1 2 3 17 18 19 20 21 22 23 24];
% frontalLeft =  [1 2 17 19 21 22]; % maybe ignore 2, which is Fz???
% frontalRight = [2 3 18 20 23 24]; % maybe ignore 2, which is Fz???
% CentCPar =     [5 6 7 9 10 25];
% ParOcc =       [12 13 14 15 16 26 27 28 29 30 31 32];
groupings = [{[1 2 3 17 18 19 20 21 22 23 24]};
             {[1 17 19 21 22]};
             {[3 18 20 23 24]};
             {[5 6 7 9 10 25]};
             {[12 13 14 15 16 26 27 28 29 30 31 32]}];

% frequency bands that we care about
bands = [1 4; 4 8; 8 14; 14 30];

% bandpower initializations
bp=zeros(size(groupings,1),size(bands,1));
bpTotal=zeros( size(groupings,1),1 );
for i = 1:size(groupings,1)
   for j = 1:size(bands,1)
       bp(i,j)= mean( bandpower(sig(:,groupings{i}),fs,bands(j,:)) );
   end
   bpTotal(i)=mean( bandpower(sig(:,groupings{i}),fs,[bands(1) bands(end)]) );
end

bpAsPercentageOfRegion = bp./ repmat(bpTotal,1,size(bp,2));


%  features consist of band power over 5 regions using 4 bands, and then
% those band powers as a fraction of total bandpower for those regions
features = [features bp bpAsPercentageOfRegion];
% make this into a single vector
features = features';
features = features(:);
features = features';

%suck a bag of dicks


% calculate correlation between frontal hemispheres? and use as a feature
sigFLeft = mean(sig(:,groupings{2}),2);
sigFRight = mean(sig(:,groupings{3}),2);
r = corr(sigFLeft,sigFRight);
features = [features r];

% calculate mutual information (like correlation)
sigFLeft = mean(sig(:,groupings{2}),2);
sigFRight = mean(sig(:,groupings{3}),2);
% change into that directory, just adding to path doesn't work with
% executables???
cd('.\MutualInformationICA\');
mi = MIhigherdim( [sigFLeft'; sigFRight'] );
cd('..\');
features = [features mi];

% maybe normalize the mutual information (see
% https://en.wikipedia.org/wiki/Mutual_information#Normalized_variants 
% for why square root of product of entropies is used)
miNormalized = mi/ sqrt( entropy(sigFLeft',[],[],2)*entropy(sigFRight',[],[],2) );
features = [features miNormalized];


% connectivity analysis features??




% KEEP THIS UP TO DATE WHENEVER YOU CHANGE THIS FILE SO YOU CAN TELL WHAT
% THE FEATURES ACTUALLY REFER TO WHEN LOOKING TO SEE WHATS IMPORTANT /
% CORRELATED WITH TREATMENT OUTCOMES!!!!!

% as it stands 43 features are output:
%     [bpFront, bpFrontAs%, bpFrontL, bpFrontLAs%, bpFrontR, bpFrontRAs%, bpCentCPar, bpCentCParAs%, bpParOcc, bpParOccAs%, R, MI, MI_normalized]
% where each of the first 10 have 4 measures (delta, theta, alpha, beta)
% i.e., [bpFrontDelta, bpFrontTheta, ... ]






