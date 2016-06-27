function features = RestingFeaturesKemp( sig, st, prm )

% groupings are based on eloc32.txt
% frontalLeft =  [1 2 17 19 21 22]; % maybe ignore 2, which is Fz???
% frontalRight = [2 3 18 20 23 24]; % maybe ignore 2, which is Fz???
% CentCPar =     [5 6 7 9 10 25];
% ParOcc =       [12 13 14 15 16 26 27 28 29 30 31 32];

groupings = [{[1 17 19 21 22]};
             {[3 18 20 23 24]};];

% sampling rate of our EEG
fs = prm.SamplingRate.NumericValue;

% then filter between 1 and 30Hz with 8th order butterworth
h  = design( fdesign.bandpass('N,F3dB1,F3dB2', 8, 1, 30, fs), 'butter' );
sig= filter(h,sig);


% ignore first and last 3 seconds of EEG clip (to drowsy at end, and the
% signal is sometimes not stabilized at the beginning from amplifiers)
ignore = 3;
st.Artifact = st.Artifact( round(ignore*fs+1): round(end-ignore*fs),: );
sig = sig( round(ignore*fs+1): round(end-ignore*fs),: );


bands = [1.5 3.5; 4 7.5; 8 13; 14.5 30];

delta = log( bandpower(sig, fs, bands(1,:)) );
theta = log( bandpower(sig, fs, bands(2,:)) );
alpha = log( bandpower(sig, fs, bands(3,:)) );
beta  = log( bandpower(sig, fs, bands(4,:)) );

groupingAvrg = zeros( size(groupings,1), size(bands, 1) );

for i = 1 : size(groupings,1)
    groupingAvrg(i,:) = [ mean(delta(groupings{i})) mean(theta(groupings{i})) mean(alpha(groupings{i})) mean(beta (groupings{i}))];
end

FAI = zeros(size(bands, 1),1);

for i = 1 : size(bands, 1)
    FAI(i,:) = groupingAvrg(2,i) - groupingAvrg(1,i) ;
end

features =  FAI;