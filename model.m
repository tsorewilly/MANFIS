clc;%Loading the dataset 
% try
%     parpool('local',4);%Parallel computing
%     MultiStart('UseParallel', true);
% catch Except
%     delete(gcp('nocreate'));
%     parpool('local',4);%Parallel computing
%     MultiStart('UseParallel', true);
% end
    
load('dataset_pima.mat');
%A total of 768 cases, and each case was described with 10 variables,
%namely: %AGE, BMI, ACTL, SYST, DIAS, THOG, THIS, TSFT, PCNT, DPFN	
%269 of the cases were diagnosed with diabetes using the 10 variables;
featSet = dataset_pima(:,1:10);
class = dataset_pima(:,11);
L = length(featSet);
%Generate random validation data;
VDL = floor(L * 0.30); % VDL: ValidationDataLent is 15% of the whole dataset
Sorted = randi([1, VDL], [1, VDL])';
[Sorted, ValidIdx] = unique(Sorted);
TrainIdx = setdiff([1:L], ValidIdx);
ValidatData = [featSet(ValidIdx, 1:10), class(ValidIdx)];
TrainData = [featSet(TrainIdx, 1:10), class(TrainIdx)];
%Clear unwanted variables
vars2keep = {'dataset_pima','featSet','class','L','ValidIdx','TrainIdx','ValidatData','TrainData'};
clearvars('-except',vars2keep{:});

%% Building the Manfis Model

MFStart = tic;

% NetOptions.ValidationData = ValidatData;    %Different from trnData to test generalization
% NetOptions.InitialFIS = 4;                  %Initial FIS with 4 membership functions for each input variable
% NetOptions.EpochNumber = 30;                %Maximum number of training epochs equal to 30.
% NetOptions.ErrorGoal = 0.01;
% NetOptions.StepSizeDecreaseRate = 0.9;      %Step size decrease rate; a positive scalar less than 1
% NetOptions.DisplayErrorValues = 1;
% NetOptions.OptimizationMethod = 1;

%[training epoch number, error goal, initial step size, step size decrease, step size increase]
t_opt = [50; 0.01;  0.01;  0.9; 1.1];
d_opt = [1; 1; 1; 1];

%anfis(trn_data, in_fismat, t_opt, d_opt, chk_data, method)
fprintf('Started Generating the Membership Functions. Please Wait...\n');
in_fismat_gauss = genfis1(TrainData, 5, 'gaussmf', 'constant');
fprintf('(1/5) Gaussian Membership Function Completed. Please Wait...\n');
in_fismat_gbell = genfis1(TrainData, 5, 'gbellmf', 'constant');
fprintf('(2/5) Generalized Bell Membership Function Completed. Please Wait...\n');
in_fismat_psigmf = genfis1(TrainData, 5, 'psigmf', 'constant');
fprintf('(3/5) Dif. Sigma Membership Function Completed. Please Wait...\n');
in_fismat_dsigmf = genfis1(TrainData, 5, 'dsigmf', 'constant');
fprintf('(4/5) Prod. Sigma Membership Function Completed. Please Wait...\n');
in_fismat_pimf = genfis1(TrainData, 5, 'pimf', 'constant');
fprintf('(5/5) Pi-Shaped Membership Function Completed. Please Wait...\n');
fprintf('Generation of All Membership Function Completed in %3.4f Seconds\n', toc(MFStart));

TrainingStart = tic;

fprintf('ANFIS Network Training Started. Training Takes Time, Please Wait...\n');
[out_fismat1, t_error1, stepsize1, c_fismat1, c_error1] = manfis(TrainData, in_fismat_gauss, t_opt, d_opt, ValidatData);
[out_fismat2, t_error2, stepsize2, c_fismat2, c_error2] = manfis(TrainData, in_fismat_gbell, t_opt, d_opt, ValidatData);
[out_fismat3, t_error3, stepsize3, c_fismat3, c_error3] = manfis(TrainData, in_fismat_psigmf, t_opt, d_opt, ValidatData);
[out_fismat4, t_error4, stepsize4, c_fismat4, c_error4] = manfis(TrainData, in_fismat_dsigmf, t_opt, d_opt, ValidatData);
[out_fismat5, t_error5, stepsize5, c_fismat5, c_error5] = manfis(TrainData, in_fismat_pimf, t_opt, d_opt, ValidatData);

fprintf('All Training Completed in %3.4f Seconds\n', toc(TrainingStart));
save('MANFIS_VAR_LINA')
