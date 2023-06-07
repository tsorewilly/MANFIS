%Make sure the file "PedigreePrediction.m" has been run before executing
%this file

function FilledData = fillPedFxn(data)
    %Load the built RandomForest model
    load ("Models/PedFxnModel.mat", "model");
    
    %Load the targeted dataset
    load ("Data/processed_data.mat", data);
    pData = data(:,1:6);
    
    disp("Training started"); tic;
    PreDPFN = regRF_predict(pData, model);
    
    FilledData = data();
end