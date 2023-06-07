% warning('off');

load("Data/processed_data.mat", "pima_data");
%A total of 768 cases, and each case was described with 10 variables,
%namely: %AGE, BMI, ACTL, SYST, DIAS, THOG, THIS, TSFT, PCNT, DPFN	
%269 of the cases were diagnosed with diabetes using the 10 variables;


DataSet = pima_data;
DataLent = length(DataSet);
%Generate random validation data;
VDL = floor(DataLent * 0.30); %VDL: ValidationDataLent is 15% of the whole dataset
Sorted = randi([1, VDL], [1, VDL])';
[Sorted, ValidIdx] = unique(Sorted);
TrainIdx = setdiff([1:DataLent], ValidIdx);

TrainData = DataSet(TrainIdx, 1:7);
TrainClass = DataSet(TrainIdx, 8);

ValidatData = DataSet(ValidIdx, 1:7);
ValidatClass = DataSet(ValidIdx, 8);


%%
MFStart = tic;

%Define an initial FIS structure with five Gaussian input membership functions.
genOpt = genfisOptions('GridPartition');
genOpt.NumMembershipFunctions = 3;
genOpt.InputMembershipFunctionType = 'gaussmf';
inFIS = genfis([TrainData TrainClass], genOpt);

%Configure the ANFIS training options. Set the initial FIS, and suppress the training progress display.
% NetOptions.InitialFIS = 4;                  %Initial FIS with 4 membership functions for each input variable
% NetOptions.EpochNumber = 30;                %Maximum number of training epochs equal to 30.
NetOptions = anfisOptions('InitialFIS', inFIS);
NetOptions.DisplayANFISInformation = 0;
NetOptions.DisplayErrorValues = 0;
NetOptions.DisplayStepSize = 0;
NetOptions.ValidationData = [ValidatData ValidatClass];    %Different from trnData to test generalization
NetOptions.ErrorGoal = 0.01;
NetOptions.StepSizeDecreaseRate = 0.9;      %Step size decrease rate; a positive scalar less than 1
NetOptions.DisplayErrorValues = 1;
NetOptions.OptimizationMethod = 1;
NetOptions.DisplayFinalResults = 1;

[outFIS,trainError,stepSize,chkFIS,chkError] = anfis([TrainData TrainClass], NetOptions);

%display the some stat during each training epoch
figure; 
subplot(2,1,1); plot(stepSize);
len = 1:length(TrainClass);
subplot(2,1,2); plot(len,trainError,'.b', len,chkError,'*r')
display(["The minimum RMS error during training is ", min(trainError)]);

% %Evaluate the ANFIS system with Validation data.
% evalu = evalfis(outFIS, ValidatClass);
% 
% plot(x,evalu)
% legend('Validation Data','ANFIS Output')
