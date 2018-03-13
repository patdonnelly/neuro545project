%% NEURO 545 Project: Quantitative Methods in Neuroscience
% Instructors: Rieke, Bair, Fairhall; Winter 2018
% Patrick M. Donnelly
% University of Washington
% 13 March 2018


% This tutorial will walk though the pca of various classifications of data
% in the UW Reading and Dyslexia Research Program. In the dataset are
% children with a variety of reading skills.  First we will look at all
% participants combined, then we will look at just the impaired population.

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
ylabel('Verbal/NonVerbal Intelligence');

figure(2);
scatter(data_full.ctopp_elision_ss, data_full.wj_lwid_ss);
xlabel('Elision (a phonological awareness measure)');
ylabel('Real Word Identification');

% The combination of phonological awareness, memory, intelligence, reading
% rate and oral reading fluency and comprehension measures are used to 
% determine if a child could be struggling with a reading disability such 
% as dyslexia.  The goal of this analysis is to figure out the principal
% measures that contribute towards a child's reading ability and see how
% strongly each of our measures is associated with those principal
% components.

% compute covariance matrix of data 
DataCovar = cov(zscore(table2array(data_full)));

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
[EigVec, EigVal] = eigs(DataCovar);

% look at these
figure(4)
clf
plot(EigVec);
xlabel('test');

% standardize and convert to array for pca
data = zscore(table2array(data_full));

[coeff,score,latent,tsquared,explained] = pca(data);
Xcentered = score*coeff';
biplot(coeff(:,1:2),'scores',score(:,1:2),'varlabels',...
    data_full.Properties.VariableNames);

% From this biplot you can see that all variables are positively associated
% with the first component.  This is understandable given that these tests 
% are all apitude measures on similar scales - no score indicates higher
% performance with lesser values. The negative association with the second
% component for many of the scores (specifically the decoding and fluency
% measures) indicates that although they are able to account for
% variability in one dimension, they are inefficient in another.  These
% results suggest that those scores in the upper right quadrant may be more
% parsimonious indicators of variability in performance across the battery
% of tests assessed. 

exp_variance = explained(1) + explained(2) + explained(3);

% From the explained variance variable, it is discovered that the first
% three principal components explain 74.88% of the variance. 

%% To declutter the results, let's instead use only the composite measures
% zero in on composite scores in dataset
data_composites = table(data_full.wj_brs, data_full.wj_rf, ...
    data_full.twre_index,data_full.wasi_fs2, data_full.ctopp_pa, ...
    data_full.ctopp_rapid);
data_composites.Properties.VariableNames = {'WJ_BRS', 'WJ_RF', ...
    'TWRE_INDEX', 'WASI', 'CTOPP_PA', 'CTOPP_RAPID'}
% compute covariance matrix of data 
DataCovar_comp = cov(table2array(data_composites));

% look at eigenvalues
DataEigVal_comp = eig(DataCovar_comp);
figure(5)
clf
plot(DataEigVal_comp, 'o')
xlabel('component')
ylabel('variance')

% zero in on some eigenvalues
[EigVec_comp, EigVal_comp] = eigs(DataCovar_comp);

% look at these
figure(6)
clf
plot(EigVec_comp);
xlabel('test');

% Many of the trends that are indicated in figure 6 may relate to how
% related the tests are to each other (in other words, the order in which
% they appear in the table). The trend line indicated in blue appears to be
% rather good across the board.

% prepare composite data for pca - standardize/normalize
data_composite = zscore(table2array(data_composites));

[coeff_comp,score_comp,latent_comp,tsquared_comp,explained_comp] ...
    = pca(data_composite);
Xcentered = score_comp*coeff_comp';
biplot(coeff_comp(:,1:2),'scores',score_comp(:,1:2),'varlabels',...
    data_composites.Properties.VariableNames); axis('square');
exp_variance_comp = explained_comp(1) + explained_comp(2) + ...
    explained_comp(3);

% The biplot vastly declutters the results and shows that IQ and
% phonological awareness (PA) are the main features in the postive
% direction for both components. Interestingly the TOWRE_Index feature
% is most correlated with component 1, but the CTOPP_PA feature is most
% associated with component 2.  Combined with the other features that
% produce the dichotomy across the x axis, it appears that intelligence and
% phonological awareness most parsimoniously relate to the variability in
% our dataset, but that wrd reading, fluency, and automaticity measures
% capture intricacies in the data that the other two cannot account for on
% their own.  

% From the explained variance variable, it is discovered that the first
% three principal components explain 89.04% of the variance. 

%% Now let's look at just our impaired population
% load in reading impaired only
load dx_rdrp.mat
missing = ismissing(dx_rdrp);
data_dx = dx_rdrp(~any(missing,2),:);
data_dx.redcap_event_name = [];
data_dx.record_id = [];

% compute covariance matrix of data 
DataCovar_dx = cov(zscore(table2array(data_dx)));

% look at eigenvalues
DataEigVal_dx = eig(DataCovar_dx);
figure(7)
clf
plot(DataEigVal_dx, 'o')
xlabel('component')
ylabel('variance')

% zero in on some eigenvalues
[EigVec_dx, EigVal_dx] = eigs(DataCovar_dx);

% look at these
figure(8)
clf
plot(EigVec_dx);
xlabel('test');

% prepare data for pca, normalize/standardize
dx = zscore(table2array(data_dx));
[coeff_dx,score_dx,latent_dx, tsquared_dx,explained_dx] = pca(dx);
Xcentered = score_dx*coeff_dx';
biplot(coeff_dx(:,1:2),'scores',score_dx(:,1:2),'varlabels',...
    data_dx.Properties.VariableNames); axis('square');

explained_variance_dx = explained_dx(1) + explained_dx(2)...
    + explained_dx(3);

% explained variance is 62.1% for the first three components

%% again let's declutter to see just the composite measures

% zero in on composite scores for dx
dx_composites = table(data_dx.wj_brs, data_dx.wj_rf, data_dx.twre_index,...
    data_dx.wasi_fs2, data_dx.ctopp_pa, data_dx.ctopp_rapid);
dx_composites.Properties.VariableNames = {'WJ_BRS', 'WJ_RF',...
    'TWRE_INDEX', 'WASI', 'CTOPP_PA', 'CTOPP_RAPID'};
% compute covariance matrix of data 
DataCovar_dx_comp = cov(zscore(table2array(dx_composites)));

% look at eigenvalues
DataEigVal_dx_comp = eig(DataCovar_dx_comp);
figure(9)
clf
plot(DataEigVal_dx_comp, 'o')
xlabel('component')
ylabel('variance')

% zero in on some eigenvalues
[EigVec_dx_comp, EigVal_dx_comp] = eigs(DataCovar_dx_comp);

% look at these
figure(10)
clf
plot(EigVec_dx_comp);
xlabel('test');

% prepare data for pca
dx_comp = zscore(table2array(dx_composites));

[coeff_dx_comp,score_dx_comp,latent_dx_comp,tsquared_dx_comp,...
    explained_dx_comp] = pca(dx_comp);
Xcentered = score_dx_comp*coeff_dx_comp';
biplot(coeff_dx_comp(:,1:2),'scores',score_dx_comp(:,1:2),'varlabels',...
    dx_composites.Properties.VariableNames); axis('square');

% from this biplot it is apparent that a very similiar relationship exists
% to the whole dataset, but that the IQ score (WASI) is much more related
% and that the WJ_BRS measure crossed the divide to be influential in both
% components.  This is interesting, but also understandable and should be
% treated with caution - to be classified in our database as an impaired
% reader, one must demonstrate impaired WJ_BRS and IQ (WASI) in the normal
% range or higher.  

explained_variance_dx_comp = explained_dx_comp(1) + explained_dx_comp(2)...
    + explained_dx_comp(3);

% explained variance is 81.39% for the first three components

%% let's look at the composite biplots side by side for impaired and across
% all participants

figure; hold;
ax(1) = subplot(1,2,1);
biplot(coeff_comp(:,1:2),'scores',score_comp(:,1:2),'varlabels',...
    data_composites.Properties.VariableNames); axis('square');
title('All');
ax(2) = subplot(1,2,2);
biplot(coeff_dx_comp(:,1:2),'scores',score_dx_comp(:,1:2),'varlabels',...
    dx_composites.Properties.VariableNames); axis('square');
title('Impaired');
linkaxes(ax, 'xy');


% side by side these biplots indicate that the features are pretty similar,
% and more importantly the contribution of each feature to the components
% is the same, the sign just changes for one of them.  This is important
% since this juxtaposition shows that the stability of these components is
% quite high even across the continuum of reading ability. 