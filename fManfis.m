clc
clear
close all

%Load Data
load("Data/real_new_processed_data.mat");

InMFs = {'gaussmf','gbellmf','psigmf','dsigmf', 'pimf'};
OutMFs = {'linear', 'constant'};

%Data Training with ANFIS Model
epoch_n = 50;
dispOpt = zeros(1,4);
warning('off');
disp("Start building the MANFIS System");
tic
%%
%Build the first ANFIS Block
%Model_Gauss = ANFIS.train(pima_data(:, 1:7), pima_data(:, 8), 4, 4, InMFs{1}, OutMFs{2}, dispOpt, epoch_n);
Model_Gauss = ANFIS.train(pima_data(TrainIdx_10, 1:7), pima_data(TrainIdx_10, 8), 3, 5, InMFs{1}, OutMFs{2}, dispOpt, epoch_n);

%Build the second ANFIS Block
Model_Gbell = ANFIS.train(pima_data(TrainIdx_10, 1:7), pima_data(TrainIdx_10, 8), 3, 4, InMFs{2}, OutMFs{2}, dispOpt, epoch_n);

%Build the third ANFIS Block
Model_Psig = ANFIS.train(pima_data(TrainIdx_10, 1:7), pima_data(TrainIdx_10, 8), 3, 5, InMFs{3}, OutMFs{2}, dispOpt, epoch_n);

%Build the fourth ANFIS Block
Model_Dsig = ANFIS.train(pima_data(TrainIdx_10, 1:7), pima_data(TrainIdx_10, 8), 3, 5, InMFs{4}, OutMFs{2}, dispOpt, epoch_n);

%Build the fifth ANFIS Block
Model_Pimf = ANFIS.train(pima_data(TrainIdx_10, 1:7), pima_data(TrainIdx_10, 8), 3, 4, InMFs{5}, OutMFs{1}, dispOpt, epoch_n);
% Model_Dsig(1).Data = 'classify-pima';
% Model_Dsig(1).Value = ANFIS.classify(Model_Dsig, pima_data(:, 1:7));
% Model_Dsig(1).Data = 'classify-schorl';
% Model_Dsig(1).Value = ANFIS.classify(Model_Dsig, schorl_data(:, 1:7));
% Model_Dsig(1).Data = 'classify-oau';
% Model_Dsig(1).Value = ANFIS.classify(Model_Dsig, oau_data(:, 1:7));

fprintf('MANFIS System was successfully built in: %0.3f sec(s)\n', toc);

warning('off');

save('Model_Real-TrainData_35C_34C_35C_35L.mat', 'Model_Gauss', 'Model_Gbell', 'Model_Dsig', 'Model_Pimf')
% EvalManfis
