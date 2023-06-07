% clear; clc;
% x = (0:0.1:10)';
% x = [x x];
y = sin(2*x)./exp(x/5);
%Define an initial FIS structure with five Gaussian input membership functions.

genOpt = genfisOptions('GridPartition');
genOpt.NumMembershipFunctions = 5;
genOpt.InputMembershipFunctionType = 'gaussmf';
inFIS = genfis(x,y,genOpt);
%Configure the ANFIS training options. Set the initial FIS, and suppress the training progress display.

opt = anfisOptions('InitialFIS',inFIS);
opt.DisplayANFISInformation = 0;
opt.DisplayErrorValues = 0;
opt.DisplayStepSize = 0;
opt.DisplayFinalResults = 0;
%Train the FIS using the specified options.

outFIS = anfis([x y],opt);