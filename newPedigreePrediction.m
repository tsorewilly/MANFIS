%Build A Model to predict diabetes pedigree function 
% clc
% close all
% clear
%compile everything
if strcmpi(computer,'PCWIN') |strcmpi(computer,'PCWIN64')
   compile_windows
else
   compile_linux
end

total_train_time=0;
total_test_time=0;

%load the twonorm dataset 
load ("Data/real_new_processed_data.mat", "pima_data");
 
%Arrange the data so that training data is NxD and labels are Nx1, where N=#of %examples, D=# of features

X = pima_data(:,1:6);
Y = pima_data(:,7);

%% Plot variable correlations
% figure
% corrplot(pima_data,'type','Kendall','testR','on')

%%
[N D] =size(X);
%randomly split the dataser in 70% training and 30% testing sets
randvector = randperm(N);
TrainCount = 0.7*N;

warning('off')
%collect each dataset into their placeholders
X_trn = X(randvector(1:TrainCount), :);
Y_trn = Y(randvector(1:TrainCount));

X_tst = X(randvector((TrainCount+1) : end), :);
Y_tst = Y(randvector((TrainCount+1) : end));
warning('on')

%Set processed data into random forest
extra_options.do_trace = 1;
extra_options.replace = 0;    % Sample without replacement (1 = Default, with replacement)
extra_options.keep_inbag = 1; %(Default = 0)
extra_options.importance = 1; %(0 = (Default) Don't, 1=calculate)
extra_options.proximity = 1;  %(0 = (Default) Don't, 1=calculate)
extra_options.oob_prox = 1;   % calculate proximity for only on 'out-of-bag' data?
extra_options.nodesize = 7;   % Minimum size of terminal nodes. 
extra_options.nPerm = 10;      % Times OOB data are permuted per tree to assess variable importance. 
    
%% In Classification Mode:  build a model that can do xxxxxxxxx
%     model = classRF_train(X_trn,Y_trn, 100, 4, extra_options);
%     Y_hat = classRF_predict(X_tst,model);

%% In Prediction Mode: build a model that can predict diabetes pedigree values  
    disp("Training started"); tic;
    model = regRF_train(X_trn,Y_trn, 1000, 4, extra_options);
    Y_hat = regRF_predict(X_tst,model);
    
    %Compute the MSE error
    mse = sum((Y_hat-Y_tst).^2)/length(Y_hat); 
    fprintf('\n MSE rate %f\n',   mse);
    
    figure('Name','OOB error rate');
        plot(model.mse); title('OOB MSE error rate');  xlabel('iteration (# trees)'); ylabel('OOB error rate');
%%
    figure('Name',['Importance Plots nPerm=', int2str(extra_options.nPerm)]);
        subplot(3,1,1);
            bar(model.importance(:,end-1));xlabel('feature');ylabel('magnitude');
            title('Mean decrease in Accuracy');    
        subplot(3,1,2);
            bar(model.importance(:,end));xlabel('feature');ylabel('magnitude');
            title('Mean decrease in Gini index');        
        subplot(3,1,3);
            bar(model.importanceSD);xlabel('feature');ylabel('magnitude');
            title('Std. errors of importance measure');            

%%
%Complete the OAU Dataset
     load("Data/processed_data.mat", "oau_data");
% load('RF_Model.mat', 'model')
    disp("OAU Data Filling started"); tic;
    PreDPFN = regRF_predict(oau_data(:,1:6), model);
    
    oau_data(:, 7) = PreDPFN;

    

%Complete the SChorling Dataset
     load("Data/processed_data.mat", "schorl_data");
    disp("Schorling Data Filling started"); tic;
    PreDPFN = regRF_predict(schorl_data(:,1:6), model);
    
    schorl_data(:, 7) = PreDPFN;
    
%     save("Data/filled_data.mat", "oau_data", "schorl_data", "pima_data");

     