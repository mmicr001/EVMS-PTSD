
clear; clc; close all;

% Dataset Root Location
mRootDir = 'C:\Users\Johnson\Google Drive\EVMS\';

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
Data(1).pID = {'AMa'};
Data(1).Sessions=[1 2 3 4];
Data(1).Outcomes.Days = [  1 16 23 30 37 45 55 65 ];
Data(1).Outcomes.BDI =  [ 40 24 14 15 16 14 16 15 ];
Data(1).Outcomes.BAI =  [ 14 10  3  3  5  4  4  3 ];
Data(1).Outcomes.EEGDay = [ 6 14 28 65 ];

Data(2).pID = {'AWa'};
Data(2).Sessions=[1 2 3 4];
Data(2).Outcomes.Days = [  1 45 53 59 66 73 81 93 ];
Data(2).Outcomes.BDI =  [ 35 10 13  0  0  0  0  0 ];
Data(2).Outcomes.BAI =  [ 14  4 10  1  3  1  1  0 ];
Data(2).Outcomes.EEGDay = [ 39 45 56 93];

Data(3).pID = {'GMu'};
Data(3).Sessions=[1 2 3 4];
Data(3).Outcomes.Days = [  1 16 23 33 40 47 65 71 81 ]; 
Data(3).Outcomes.BDI =  [ 38 17 11  9  8  4  3  2  1 ];
Data(3).Outcomes.BAI =  [ 17  6  5  2  2  2  1  0  0 ];
Data(3).Outcomes.EEGDay = [ 5 23 31 81 ];

Data(4).pID = {'HLu'};
Data(4).Sessions=[1 2 3 4];
Data(4).Outcomes.Days = [ 1 58 66 72 84 91 101 114 ];
Data(4).Outcomes.BDI = [ 29 29 21 24 28 18 12 11 ];
Data(4).Outcomes.BAI = [ 4 5 3 2 4 2 1 2 ];
Data(4).Outcomes.EEGDay = [ 51 60 71 114];

Data(5).pID = {'JCa'};
Data(5).Sessions=[1 2 3 4];
Data(5).Outcomes.Days = [  1 24 31 54 61 71 78 93];
Data(5).Outcomes.BDI =  [ 43 38 36 31 33 36 35 40 ];
Data(5).Outcomes.BAI =  [ 45 37 35 40 30 39 43 42 ];
Data(5).Outcomes.EEGDay = [ 10 22 51 93 ];

Data(6).pID = {'MPe'}; 
Data(6).Sessions=[2 3]; % fix structure!!
Data(6).Outcomes.Days = [  1 13 20 27 35 42 49 58 ];
Data(6).Outcomes.BDI =  [ 33 31 26 36 37 40 40 44 ];
Data(6).Outcomes.BAI =  [  9 11  7  8 11 15 13 15 ];
Data(6).Outcomes.EEGDay = [ 13 26 ];

Data(7).pID = {'MWi'};
Data(7).Sessions=[1 2 3 4];
Data(7).Outcomes.Days = [  1 63 70 77 90 97 105 112 ];
Data(7).Outcomes.BDI =  [ 38 32 22 14 14 11  11   6 ];
Data(7).Outcomes.BAI =  [ 10  5  4  2  1  0   0   0 ];
Data(7).Outcomes.EEGDay = [ 8 62 77 112 ];

Data(8).pID = {'NTo'};
Data(8).Sessions=[1 2 3 4];
Data(8).Outcomes.Days = [  1 27 37 44 63 70 78 99 ];
Data(8).Outcomes.BDI =  [ 41 25 32 15 18 15 12  8 ];
Data(8).Outcomes.BAI =  [ 10 11 14  9  9  7  4  3 ];
Data(8).Outcomes.EEGDay = [ 14 30 44 99 ];

Data(9).pID = {'R-LGo'};
Data(9).Sessions=[1 2 3 4];
Data(9).Outcomes.Days = [  1 21 28 36 42 49 57 79 ];
Data(9).Outcomes.BDI =  [ 46 26 10  4  2  2  2  1 ];
Data(9).Outcomes.BAI =  [ 28 25 21 13  6  3  5  4 ];
Data(9).Outcomes.EEGDay = [ 8 17 36 79 ];

Data(10).pID = {'SHa'};
Data(10).Sessions=[1 2 3];
Data(10).Outcomes.Days = [  1 13 21 28 36 44 55 73 ];
Data(10).Outcomes.BDI = [ 23 19 14 13 15  8 10  7 ];
Data(10).Outcomes.BAI = [ 17 11  5  7  5  3  1  1 ];
Data(10).Outcomes.EEGDay = [ 1 10 27 ];

Data(11).pID = {'PCi'};
Data(11).Sessions=[ 2 3 ];
Data(11).Outcomes.BDI = [  ];
Data(11).Outcomes.BAI = [  ];

Data(12).pID = {'NSt'};
Data(12).Sessions=[ 2 3 ];
Data(12).Outcomes.BDI = [  ];
Data(12).Outcomes.BAI = [  ];

Data(13).pID = {'BKBr'};
Data(13).Sessions=[ 3 ];
Data(13).Outcomes.BDI = [  ];
Data(13).Outcomes.BAI = [  ];

Data(14).pID = {'SCo'};
Data(14).Sessions=[ 3 ];
Data(14).Outcomes.BDI = [  ];
Data(14).Outcomes.BAI = [  ];



sub = [1 3 7 9]; % subjects to look at, since not all are complete, and since some have bad sessions (see excel spreadsheet) due to loose reference on cap2

%% FEATURE CONSTRUCTION
% Let's first construct features for each subject, we want to see how
% they vary over the course of the treatment, and if they vary in
% a manner which is predictable, or if they correlate with some
% measure of outcome (for instance, how depressed they are is BDI: 
% Beck's Depression Index ... or anxiety levels BAI)
% for i = 1:length(Data)
cntr=1;
for i = sub
    fprintf(1,'Creating features for subject %g',i);

    % directories for the 4 possible sessions
    mDirs{1} = [char(mRootDir) char(Data(i).pID) '\RegistrySubject' char(Data(i).pID) 'Baseline\'];
    mDirs{2} = [char(mRootDir) char(Data(i).pID) '\RegistrySubject' char(Data(i).pID) 'Session5\'];
    mDirs{3} = [char(mRootDir) char(Data(i).pID) '\RegistrySubject' char(Data(i).pID) 'Session15\'];
    mDirs{4} = [char(mRootDir) char(Data(i).pID) '\RegistrySubject' char(Data(i).pID) 'EndofTx\'];
     
    for j = 1:length(mDirs)
        if( ismember(j,Data(i).Sessions) )
            mDir = char(mDirs{j});
            mFiles = dir([mDir '\*.dat']);            
            [ sig,~,prm ] = load_bcidat( [char(mDir) char(mFiles(1).name)],'-calibrated' );
            Features{cntr}.Open{j,1} = GetRestingFeatures( sig,prm );
            fprintf(1,'.');             
            [ sig,~,prm ] = load_bcidat( [char(mDir) char(mFiles(2).name)],'-calibrated' );
            Features{cntr}.Closed{j,1} = GetRestingFeatures( sig,prm );
            fprintf(1,'.');            
            [ sig,st,prm ] = load_bcidat( [char(mDir) char(mFiles(3).name)],[char(mDir) char(mFiles(4).name)],'-calibrated' );            
            Features{cntr}.P3{j,1} = GetP3Features( sig,st,prm,0 );
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

maxSessions = 4;           % at most 4 sessions
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
    p = Features{i}.P3; % for p300
    mMaxSize = 0;
    for j = 1:maxSessions
        if( j < length(p) )
            ms= length( cell2mat( p(j) ));
            if( ms > mMaxSize )
                mMaxSize = ms;
            end
        end        
    end
    for j = 1:maxSessions
       if( j<=length(p) )
           if isempty( cell2mat( p(j) ) )
               p{j} = NaN(1,mMaxSize);
           end
       else
          p{j} = NaN(1,mMaxSize); 
       end        
    end
    p = cell2mat( p );        
    features{i}=[ o c p ];
end; clearvars -except Features Data mRootDir features sub;
features = features';
features = cell2mat( features );


%% NOW SEE WHAT FEATURES FOLLOW TRENDS ACROSS SUBJECTS
%  E.G., CONSISTENTLY INCREASE OR DECREASE THROUGH TREATMENT SESSIONS

% we create vectors containing the BDI and BAI values 
BAI = [];
BDI = [];
for i = 1:length(sub)
    
    if (isfield(Data(sub(i)).Outcomes, 'EEGDay' ))
        c = Data(sub(i)).Outcomes.EEGDay(:) ;
        a = Data(sub(i)).Outcomes.Days(:);
        b = Data(sub(i)).Outcomes.BDI(:) ;
        d = Data(sub(i)).Outcomes.BAI(:) ;
        r = interp1(a , b, c);
        s = interp1(a , d, c);
    end          
        
    % vectors containing the BDI and BAI values on EEGDay 
    BDI = cat(1, BDI , r);
    BAI = cat(1, BAI , s);
        
end;  

%compute correlation
crl_depression = zeros (1, size(features,2));   %depression correlation
crl_anxiety = zeros (1, size(features,2));      %anxiety correlation
for i = 1 : size(features,2)
        crl_depression(i) = corr( BDI , features(:,i));
        crl_anxiety(i) = corr( BAI , features(:,i));
end


[d_corr_values d_corr_ind] = sort(crl_depression);
[a_corr_values a_corr_ind] = sort(crl_depression);

clearvars -except Features Data mRootDir features sub BDI BAI d_corr_values d_corr_ind a_corr_values a_corr_ind; 






