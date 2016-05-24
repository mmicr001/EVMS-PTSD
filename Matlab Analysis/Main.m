
clear; clc; close all;

% Dataset Root Location
mRootDir = 'C:\Users\Mike\Google Drive\EVMS-PTSD\';

% 4 possible sessions for each subject:
% 1: Baseline
% 2: Session5
% 3: Session15
% 4: EndofTreatment

% 4 Runs within each session in this order:
% 1: Eyes open, basically resting eeg
% 2: Eyes closed, resting eeg
% 3: Oddball task 1
% 4: Oddball task 2

% Some sessions are really bad / corrupted!!!!!! So don't just use this as
% is. Also some subjects didn't get all the sessions in

% Patient Identification
kk=1;

Data(kk).pID = {'PT01'};
Data(kk).Sessions=             [  1  2  3 ];
Data(kk).Outcomes.Checklist =  [ 77 22 17 ];
Data(kk).Outcomes.PTSDscale =  [ 27  6  2 ];
Data(kk).Outcomes.BDI =        [ 49  1  1 ];
Data(kk).Outcomes.BAI =        [ 38  0  0 ];
kk=kk+1;


Data(kk).pID = {'PT02'};
Data(kk).Sessions=             [  1  2  3 ];
Data(kk).Outcomes.Checklist =  [ 69 59 67 ];
Data(kk).Outcomes.PTSDscale =  [ 30 17 24 ];
Data(kk).Outcomes.BDI =        [ 38 25 27 ];
Data(kk).Outcomes.BAI =        [ 32 25 47 ];
kk=kk+1;

Data(kk).pID = {'PT03'};
Data(kk).Sessions=             [  1  2  3 ];
Data(kk).Outcomes.Checklist =  [ 61 38 38 ];
Data(kk).Outcomes.PTSDscale =  [ 27 15 17 ];
Data(kk).Outcomes.BDI =        [ 29  4  4 ];
Data(kk).Outcomes.BAI =        [ 14  7 11 ];
kk=kk+1;

Data(kk).pID = {'PT04'};
Data(kk).Sessions=             [  1  2  3 ];
Data(kk).Outcomes.Checklist =  [ 48 33 30 ];
Data(kk).Outcomes.PTSDscale =  [ 22 17 14 ];
Data(kk).Outcomes.BDI =        [ 24  6  6 ];
Data(kk).Outcomes.BAI =        [ 13  9 10 ];
kk=kk+1;

Data(kk).pID = {'PT05'};
Data(kk).Sessions=             [  1  2  3 ];
Data(kk).Outcomes.Checklist =  [ 56 23 19 ];
Data(kk).Outcomes.PTSDscale =  [ 15  5  1 ];
Data(kk).Outcomes.BDI =        [ 27  7  4 ];
Data(kk).Outcomes.BAI =        [ 15  6  0 ];
kk=kk+1;

Data(kk).pID = {'PT06'};
Data(kk).Sessions=             [  1  2   ];
Data(kk).Outcomes.Checklist =  [ 58 42 ];% 33 ];
Data(kk).Outcomes.PTSDscale =  [ 20 17 ];% 16 ];
Data(kk).Outcomes.BDI =        [ 28 21 ];% 8 ];
Data(kk).Outcomes.BAI =        [ 16 14 ];% 9 ];
kk=kk+1;

% improperly recorded data (not even a complete session)
% Data(kk).pID = {'PT07'};
% Data(kk).Sessions=             [  1 ];
% Data(kk).Outcomes.Checklist =  [ 84 ];%51 29 ];
% Data(kk).Outcomes.PTSDscale =  [ 27 ];%20  4 ];
% Data(kk).Outcomes.BDI =        [ 38 ];%24 11 ];
% Data(kk).Outcomes.BAI =        [ 51 ];%21 10 ];
% kk=kk+1;

Data(kk).pID = {'PT08'};
Data(kk).Sessions=             [  1  2 ];
Data(kk).Outcomes.Checklist =  [ 70 73 ];%64 ];
Data(kk).Outcomes.PTSDscale =  [ 28 25 ];% 23 ];
Data(kk).Outcomes.BDI =        [ 44 35 ];%32 ];
Data(kk).Outcomes.BAI =        [ 35 27 ];% 23 ];
kk=kk+1;

Data(kk).pID = {'PT09'};
Data(kk).Sessions=             [  1  2  3 ];
Data(kk).Outcomes.Checklist =  [ 66 48 27 ];
Data(kk).Outcomes.PTSDscale =  [ 24 17  8 ];
Data(kk).Outcomes.BDI =        [ 33  2  4 ];
Data(kk).Outcomes.BAI =        [ 35  9  6 ];
kk=kk+1;

sub = [ 1 : 8 ]; % subjects to look at, since not all are complete, and since some have bad sessions (see excel spreadsheet) due to loose reference on cap2

%% FEATURE CONSTRUCTION
% Let's first construct features for each subject, we want to see how
% they vary over the course of the treatment, and if they vary in
% a manner which is predictable, or if they correlate with some
% measure of outcome (for instance, how depressed they are is BDI: 
% Beck's Depression Index ... or anxiety levels BAI)
% for i = 1:length(Data)
cntr=1;
for i = sub
    fprintf(1,'Creating features for subject %s', char(Data(i).pID));

    % directories for the 3 possible sessions
    mDirs{1} = [char(mRootDir) char(Data(i).pID) '\EVMS-' char(Data(i).pID) '001\'];
    mDirs{2} = [char(mRootDir) char(Data(i).pID) '\EVMS-' char(Data(i).pID) '002\'];
    mDirs{3} = [char(mRootDir) char(Data(i).pID) '\EVMS-' char(Data(i).pID) '003\'];
     
    for j = 1:length(mDirs)
        if( ismember(j,Data(i).Sessions) )
            mDir = char(mDirs{j});
            mFiles = dir([mDir '\*.dat']);            
           
            [ sig,st,prm ] = load_bcidat( [char(mDir) char(mFiles(1).name)],'-calibrated' );
            [ sig,st,prm ] = ArtifactRejection( sig,st,prm );
            Features{cntr}.Open{j,1} = GetRestingFeatures( sig, st, prm );
            fprintf(1,'.');             
            
            [ sig,~,prm ] = load_bcidat( [char(mDir) char(mFiles(2).name)],'-calibrated' );
            [ sig,st,prm ] = ArtifactRejection( sig,st,prm );
            Features{cntr}.Closed{j,1} = GetRestingFeatures( sig, st, prm );
            fprintf(1,'.');            
           
        end
    end        
    fprintf(1,'done\n');
    cntr=cntr+1;
end; clearvars -except Features Data mRootDir sub;



%% FEATURE ORGANIZING
% Now we need to correlate these features with outcomes or see how they
% progress through time

% let's just stick these in order [open closed p3], so (43+43+15)=101
% measures over 4 sessions, still keep as cell arrays for subject?
% replace missing features with Not-a-Number

maxSessions = 3;           % at most 4 sessions
for i = 1:length(Features) % for each subject                           
    o = Features{i}.Open; % for eyes open
    mMaxSize = 0;
    for j = 1:maxSessions 
        if( j < length(o) )
            ms= length( cell2mat( o(j) ));
            if( ms > mMaxSize )
                mMaxSize = ms;
            end
        end        
    end
    for j = 1:maxSessions
       if( j<=length(o) )
           if isempty( cell2mat( o(j) ) )
               o{j} = NaN(1,mMaxSize);
           end
       else
          o{j} = NaN(1,mMaxSize); 
       end        
    end
    o = cell2mat( o ); % for eyes closed                           
    c = Features{i}.Closed;
    mMaxSize = 0;
    for j = 1:maxSessions 
        if( j < length(c) )
            ms= length( cell2mat( c(j) ));
            if( ms > mMaxSize )
                mMaxSize = ms;
            end
        end        
    end
    for j = 1:maxSessions
       if( j<=length(c) )
           if isempty( cell2mat( c(j) ) )
               c{j} = NaN(1,mMaxSize);
           end
       else
          c{j} = NaN(1,mMaxSize); 
       end        
    end
     c = cell2mat( c );  
    
    features{i}=[ o c ];
end; clearvars -except Features Data mRootDir features sub;
features = features';
features = cell2mat( features );


%% NOW SEE WHAT FEATURES FOLLOW TRENDS ACROSS SUBJECTS
%  E.G., CONSISTENTLY INCREASE OR DECREASE THROUGH TREATMENT SESSIONS

% we create vectors containing the BDI, BAI, checklist and PTSD scale values 
BAI = [];
BDI = [];
Checklist = [];
PTSDscale = [];

for i = 1:length(sub)
        
    % vectors containing the BDI and BAI values on EEGDay 
    BDI = cat(1, BDI , Data(i).Outcomes.BDI');
    BAI = cat(1, BAI , Data(i).Outcomes.BAI');
    Checklist = cat(1, Checklist , Data(i).Outcomes.Checklist');
    PTSDscale = cat(1, PTSDscale , Data(i).Outcomes.PTSDscale');
        
end;  

%compute correlation
corr_BDI = zeros (1, size(features,2));  
corr_BAI = zeros (1, size(features,2));  
corr_Checklist = zeros (1, size(features,2));   
corr_PTSDscale = zeros (1, size(features,2));   

for i = 1 : size(features,2)
        corr_BDI(i) = nancorr( BDI , features(:,i));
        corr_BAI(i) = nancorr( BAI , features(:,i));
        corr_Checklist(i) = nancorr( Checklist , features(:,i));
        corr_PTSDscale(i) = nancorr( PTSDscale , features(:,i));
end


[BDI_corrValues BDI_corrInd] = sort(corr_BDI);
[BAI_corrValues BAI_corrInd] = sort(corr_BAI);
[Checklist_corrValues Checklist_corrInd] = sort(corr_Checklist);
[PTSDscale_corrValues PTSDscale_corrInd] = sort(corr_PTSDscale);

clearvars -except Features Data mRootDir features sub BDI BAI d_corr_values d_corr_ind a_corr_values a_corr_ind; 






