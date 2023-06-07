clc; 
clear; close all;
warning('off')
tic;

% load('Models/Model_Real-TrainData_35C_34C_35C_35L.mat')
%load('Models/Model_New-TrainData90_35C_44C_35C_35C.mat')

% load("Data/real_new_processed_data.mat");
%load ("Data/new_processed_data.mat");

% load('Models/Model_45_35_44_35_xx.mat')
load('Models/Model_New_44C_34C_35C_35C_34L');
load("Data/filled_data.mat");
Threshold = 0.20;
toc
%%
% Evaluating MANFIS model with the three datasets
warning('off')
% Performance Calculation
    Rvalue=@(a,b)(1-abs((sum((b-a).^2)/sum(a.^2))));
    RMSE=@(a,b)(abs(sqrt(sum((b-a).^2)/length(a))));
    MSPE=@(a,b)(sum(((b-a)./b).^2)*(100/length(a))); 
    MAPE=@(a,b)(sum(abs((b-a)./b))*(100/length(a)));
    
    data = all_data;
    Lent = 1:length(data);
%     Lent = TrainIdx; 
    Lent = ValidIdx_10;
    fprintf('(M)ANFIS         Accuracy     R         RMSE         \n')
    %disp('Model'); disp(Model);
    SData_Eval_Ga=abs((ANFIS.classify(Model_Gauss, data(Lent,1:7), Threshold)));
    %figure; clf; plot(SData_Eval_Ga(:,2)); hold on; plot(data(Lent,8)); hold off;
    [c_Ga,cm_Ga,ind_Ga,per_Ga] = confusion(data(Lent,8), SData_Eval_Ga(:,2));    
%     figure; plotconfusion(categorical(data(Lent,8)), categorical(SData_Eval_Ga(:,2)));
    %figure; plotroc(data(Lent,8), SData_Eval_Ga(:,2));
    fprintf('Model_Gauss:     %.4f\t\t%.4f\t\t%.4f\t\t\n', mean(data(Lent,8)==SData_Eval_Ga(:,2)),...
        Rvalue(data(Lent,8), SData_Eval_Ga(:,2)), RMSE(data(Lent,8), SData_Eval_Ga(:,2)));%,...
        %MSPE(data(Lent,8), SData_Eval_Ga(:,1)), MAPE(data(Lent,8), SData_Eval_Ga(:,1)));

%  
    
%   SData_Eval_Gb=abs((ANFIS.classify(Model_Gbell, data(Lent,1:7), Threshold)));        
%     %figure; clf; plot(SData_Eval_Gb(:,2)); hold on; plot(data(Lent,8)); hold off;
%     [c_Gb,cm_Gb,ind_Gb,per_Gb] = confusion(data(Lent,8), SData_Eval_Gb(:,2));    
% %     figure; plotconfusion(categorical(data(Lent,8)), categorical(SData_Eval_Gb(:,2)));
%     %figure; plotroc(data(Lent,8), SData_Eval_Gb(:,2));
%     fprintf('Model_Gbell:     %.4f\t\t%.4f\t\t%.4f\t\t\n', mean(data(Lent,8)==SData_Eval_Gb(:,2)),...
%         Rvalue(data(Lent,8), SData_Eval_Gb(:,2)), RMSE(data(Lent,8), SData_Eval_Gb(:,2)));%,...
%         %MSPE(data(Lent,8), SData_Eval_Gb(:,1)), MAPE(data(Lent,8), SData_Eval_Gb(:,1)));
% %    
%     SData_Eval_Ps=abs((ANFIS.classify(Model_Psig, data(Lent,1:7), Threshold)));        
%     %figure; clf; plot(SData_Eval_Ps(:,2)); hold on; plot(data(Lent,8)); hold off;
%     [c_Ps,cm_Ps,ind_Ps,per_Ps] = confusion(data(Lent,8), SData_Eval_Ps(:,2));    
% %     figure; plotconfusion(categorical(data(Lent,8)), categorical(SData_Eval_Ps(:,2)));
%     %figure; plotroc(data(Lent,8), SData_Eval_Ps(:,2));
%     fprintf('Model_PSig:     %.4f\t\t%.4f\t\t%.4f\t\t\n', mean(data(Lent,8)==SData_Eval_Ps(:,2)),...
%         Rvalue(data(Lent,8), SData_Eval_Ps(:,2)), RMSE(data(Lent,8), SData_Eval_Ps(:,2)));%,...
%         %MSPE(data(Lent,8), SData_Eval_Ps(:,1)), MAPE(data(Lent,8), SData_Eval_Ps(:,1)));    
%    
    SData_Eval_Ds=abs((ANFIS.classify(Model_Dsig, data(Lent,1:7), Threshold)));    
    %figure; clf; plot(SData_Eval_Ds(:,2)); hold on; plot(data(Lent,8)); hold off;
    [c_Ds,cm_Ds,ind_Ds,per_Ds] = confusion(data(Lent,8), SData_Eval_Ds(:,2));    
%     figure; plotconfusion(categorical(data(Lent,8)), categorical(SData_Eval_Ds(:,2)));
    %figure; plotroc(data(Lent,8), SData_Eval_Ds(:,2));
    fprintf('Model_DSig:     %.4f\t\t%.4f\t\t%.4f\t\t\n', mean(data(Lent,8)==SData_Eval_Ds(:,2)),...
        Rvalue(data(Lent,8), SData_Eval_Ds(:,2)), RMSE(data(Lent,8), SData_Eval_Ds(:,2)));%,...
        %MSPE(SData_Eval_Ds(:,1), data(Lent,8)), MAPE(SData_Eval_Ds(:,1), data(Lent,8))); 

%   
    SData_Eval_Pi=abs((ANFIS.classify(Model_Pimf, data(Lent,1:7), Threshold)));    
    %figure; clf; plot(SData_Eval_Ds(:,2)); hold on; plot(data(Lent,8)); hold off;
    [c_Pi,cm_Pi,ind_Pi,per_Pi] = confusion(data(Lent,8), SData_Eval_Pi(:,2));    
%     figure; plotconfusion(categorical(data(Lent,8)), categorical(SData_Eval_Pi(:,2)));
    %figure; plotroc(data(Lent,8), SData_Eval_Ds(:,2));
    fprintf('Model_Pimf:     %.4f\t\t%.4f\t\t%.4f\t\t\n', mean(data(Lent,8)==SData_Eval_Pi(:,2)),...
        Rvalue(data(Lent,8), SData_Eval_Pi(:,2)), RMSE(data(Lent,8), SData_Eval_Pi(:,2)));%,...
        %MSPE(SData_Eval_Ds(:,1), data(Lent,8)), MAPE(SData_Eval_Ds(:,1), data(Lent,8))); 
%
%  
    MANFIS = 3^-0.5344*((SData_Eval_Ga(:,1) + SData_Eval_Ds(:,1) + SData_Eval_Pi(:,1))/3);
    MANFIS(MANFIS<Threshold)=0;   MANFIS(MANFIS>0)=1;  %Apply Threshold
    figure; plotconfusion(categorical(data(Lent,8)), categorical(MANFIS));
    %figure; plotroc(data(Lent,8), SData_Eval_Pi(:,2));
    fprintf('Model_MANFIS:     %.4f\t\t%.4f\t\t%.4f\t\t\n', mean(data(Lent,8)==MANFIS(:,1)),...
        Rvalue(data(Lent,8), MANFIS(:,1)), RMSE(data(Lent,8), MANFIS(:,1)));%,...
        %MSPE(data(Lent,8), dMean(:,1)), MAPE(data(Lent,8), dMean(:,1)));     


%%  
% %   MANFIS = round((2^-6.015)*((((J2-AVERAGE(J:J))^2)/(VAR.P(J:J))^2)+(((K2-AVERAGE(K:K))^2)/(VAR.P(K:K))^2)),2)
% %   round((SData_Eval_Ga(:,1) + SData_Eval_Gb(:,1) + SData_Eval_Ds(:,1))/3);
%     MANFIS = getMANFIS(Threshold, 5.015, SData_Eval_Ga(:,1), SData_Eval_Gb(:,1), SData_Eval_Ds(:,1));
%     MANFIS(MANFIS>1)=1;   MANFIS(MANFIS<0)=0;   %Remove All EXACERBATE tuples
%     figure; plotconfusion(categorical(data(Lent,8)), categorical(MANFIS));
%     %figure; plotroc(data(Lent,8), SData_Eval_Pi(:,2));
%     fprintf('Model_MANFIS:     %.4f\t\t%.4f\t\t%.4f\t\t\n', mean(data(Lent,8)==MANFIS(:,1)),...
%         Rvalue(data(Lent,8), MANFIS(:,1)), RMSE(data(Lent,8), MANFIS(:,1)));%,...
%         %MSPE(data(Lent,8), MANFIS(:,1)), MAPE(data(Lent,8), MANFIS(:,1)));     

               