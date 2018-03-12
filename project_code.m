%% NEURO 545 Project: Quantitative Methods in Neuroscience
% Instructors: Rieke, Bair, Fairhall; Winter 2018
% Patrick M. Donnelly
% University of Washington
% 10 March 2018

% 'C:\Users\Patrick\Downloads\matlab\matlab\PCATutorial'
% 'C:\Users\Patrick\git\donnelly_neuro545prjct'

% read in behavioral data from mat file
load rdrp_data.mat
% get rid of rows with missing data
missing = ismissing(rdrp_data);
data_full = rdrp_data(~any(missing,2),:);
data_full.redcap_event_name = [];
data_full.record_id = [];

% plot examples of variability in data
figure(1);
scatter(data_full.wj_brs, data_full.wasi_fs2);
xlabel('Basic Reading Skill');
ylabel('Verbal/NonVerbal Intelligence);

figure(2);
scatter(data_full.ctopp_elision_ss, data_full.wj_lwid_ss);
xlabel('Elision (a phonological awareness measure)');
ylabel('Real Word Identification');

% the combination of phonological awareness, memory, intelligence, reading
% rate and oral reading fluency and comprehension measures are used to 
% determine if a child could be struggling with a reading disability such 
% as dyslexia.  the goal of this analysis is to figure out the principal
% measures that contribute towards a child's reading ability

% compute covariance matrix of data 
DataCovar = cov(table2array(data_full));

% look at eigenvalues
DataEigVal = eig(DataCovar);
figure(3)
clf
plot(DataEigVal, 'o')
xlabel('component')
ylabel('variance')

% look at the final components
figure(3)
xlim([11, 20]);

% zero in on some eigenvalues
[EigVec, EigVal] = eigs(DataCovar, 3);

% look at these
figure(4)
clf
plot(EigVec);
xlabel('test');

[coeff,score,latent] = pca(table2array(data_full));
Xcentered = score*coeff';
biplot(coeff(:,1:2),'scores',score(:,1:2),'varlabels',...
    {'v_1','v_2','v_3','v_4', 'v_5','v_6','v_7','v_8', ...
    'v_9','v_10','v_11','v_12', 'v_13','v_14','v_15','v_16', ...
    'v_17','v_18','v_19','v_20'});

[coeff,score,latent,tsquared,explained] = pca(table2array(data_full));
