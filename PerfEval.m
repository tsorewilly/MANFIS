clc; 
clear; close all;
%load('Models/Model_45_35_44_35_xx.mat')
%load('Models/Model_New-TrainData90_35C_44C_35C_35C.mat')
load('Models/Model_New_44C_34C_35C_35C_34L');
load("Data/filled_data.mat");

Threshold = 0.20;

%% Evaluating MANFIS model with the three datasets
warning('off')
% Performance Calculation
    %TP: 1;      FN: 2;      FP: 3     TN: 4;
    F1S=@(C)((2*(C(1)/(C(1)+C(3)))*(C(1)/(C(1)+C(2))))/((C(1)/(C(1)+C(3)))+(C(1)/(C(1)+C(2))))); 
    MCC=@(C)(abs(((C(1)*C(4))-(C(3)*C(2)))/((C(1)+C(3))*(C(1)+C(2))*(C(4)+C(3))*(C(4)+C(2)))^0.5));
 %   MCC=@(C)(abs(((C(1)+C(4))-(C(3)*C(2)))/((C(1)+C(3))*(C(1)+C(2))*(C(4)+C(3))*(C(4)+C(2)))^0.5));
    SEN=@(C)((C(1)/(C(1)+(C(2)))));
    SPE=@(C)(1-(C(3)/(C(3)+(C(4)))));
    AROC = @(C)(trapz([C(1), C(2)]));

    data = all_data;
    Lent = 1:length(data);
%      Lent = TrainIdx; 
%      Lent = ValidIdx();    

% clc;
    fprintf('(M)ANFIS        MP          F1-Score    MCC         SEN         SPE         AROC\n')

    SData_Eval_Ga=abs((ANFIS.classify(Model_Gauss, data(Lent,1:7), Threshold)));
    C_Ga = confusionmat(categorical(data(Lent,8)), categorical(SData_Eval_Ga(:,2)));
    %figure; plotconfusion(categorical(data(Lent,8)), categorical(SData_Eval_Ga(:,2)));
    %figure; plotroc(data(Lent,8), SData_Eval_Ga(:,2));
    C_Ga(C_Ga==0)=0.1;
    C_Ga = C_Ga([4 2 3 1]);
    pp = [eps, C_Ga(2:4)];
    Sensi = SEN(C_Ga(:)); Speci = SPE(C_Ga(:));
    fprintf('Model_Gauss:    %.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t\n', ...
        1-mean(data(Lent,8)==SData_Eval_Ga(:,2)), F1S(C_Ga(:)), MCC(C_Ga(:)), Sensi, Speci, AROC([Sensi, Speci]));

    SData_Eval_Ga=abs((ANFIS.classify(Model_Gauss, data(Lent,1:7), Threshold)));
%     fprintf('Model_Gauss:    %.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t\n', ...
%     1-mean(data(Lent,8)==SData_Eval_Ga(:,2)), F1S(pp), MCC(C_Ga(:)), Sensi, Speci, AROC([Sensi, Speci]));    
%    
    SData_Eval_Ds=abs((ANFIS.classify(Model_Dsig, data(Lent,1:7), Threshold)));    
    C_Ds = confusionmat(categorical(data(Lent,8)), categorical(SData_Eval_Ds(:,2)));
%     figure; plotconfusion(categorical(data(Lent,8)), categorical(SData_Eval_Ds(:,2)));
    %figure; plotroc(data(Lent,8), SData_Eval_Ds(:,2));
    C_Ds(C_Ds==0)=0.1;
    C_Ds = C_Ds([4 2 3 1]);
    pp = [eps, C_Ds(2:4)];
    Sensi = SEN(C_Ds(:)); Speci = SPE(C_Ds(:));
     fprintf('Model_DSig:     %.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t\n', ...
         1-mean(data(Lent,8)==SData_Eval_Ds(:,2)), F1S(C_Ds(:)), MCC(C_Ds(:)), Sensi, Speci, AROC([Sensi, Speci]));
    SData_Eval_Ds=abs((ANFIS.classify(Model_Dsig, data(Lent,1:7), Threshold)));    

%    fprintf('Model_DSig:     %.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t\n', ...
%        1-mean(data(Lent,8)==SData_Eval_Ds(:,2)), F1S(pp), MCC(C_Ds(:)), Sensi, Speci, AROC([Sensi, Speci]));

%   
    SData_Eval_Pi=abs((ANFIS.classify(Model_Gbell, data(Lent,1:7), Threshold)));    
    %figure; clf; plot(SData_Eval_Ds(:,2)); hold on; plot(data(Lent,8)); hold off;
    C_Pi = confusionmat(categorical(data(Lent,8)), categorical(SData_Eval_Pi(:,2)));
%     figure; plotconfusion(categorical(data(Lent,8)), categorical(SData_Eval_Pi(:,2)));
    %figure; plotroc(data(Lent,8), SData_Eval_Ds(:,2));
    C_Pi(C_Pi==0)=0.1;
    C_Pi = C_Pi([4 2 3 1]);    
    pp = [eps, C_Pi(2:4)];
    Sensi = SEN(C_Pi(:)); Speci = SPE(C_Pi(:));
    fprintf('Model_Pimf:     %.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t\n', ...
         1-mean(data(Lent,8)==SData_Eval_Pi(:,2)), F1S(C_Pi(:)), MCC(C_Pi(:)), Sensi, Speci, AROC([Sensi, Speci]));
    
     SData_Eval_Pi=abs((ANFIS.classify(Model_Pimf, data(Lent,1:7), Threshold)));    
%    fprintf('Model_Pimf:     %.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t\n', ...
%        1-mean(data(Lent,8)==SData_Eval_Pi(:,2)), F1S(pp), MCC(C_Pi(:)), Sensi, Speci, AROC([Sensi, Speci]));

%    

    %MANFIS = 3^-0.5344*((SData_Eval_Ga(:,1) + SData_Eval_Pi(:,1) + SData_Eval_Ds(:,1))/3);
    MANFIS = 3^-0.5344*((SData_Eval_Ga(:,1) + SData_Eval_Ds(:,1) + SData_Eval_Pi(:,1))/3);
    MANFIS(MANFIS<Threshold)=0;   MANFIS(MANFIS>0)=1;  %Apply Threshold
    
    C_Man = confusionmat(categorical(data(Lent,8)), categorical(MANFIS));
%    figure; plotconfusion(categorical(data(Lent,8)), categorical(MANFIS));
    %figure; plotroc(data(Lent,8), SData_Eval_Pi(:,2));
    C_Man(C_Man==0)=0.1;
    C_Man = C_Man([4 2 3 1]);    
    pp = [eps, C_Man(2:4)];
    Sensi = SEN(C_Man(:)); Speci = SPE(C_Man(:));
     fprintf('Model_MANFIS:   %.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t\n', ...
         1-mean(data(Lent,8)==MANFIS(:,1)), F1S(C_Man(:)), MCC(C_Man(:)), Sensi, Speci, AROC([Sensi, Speci]));  

%    fprintf('Model_MANFIS:   %.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t\n', ...
%        1-mean(data(Lent,8)==MANFIS(:,1)), F1S(pp), MCC(C_Man(:)), Sensi, Speci, AROC([Sensi, Speci]));

    %final_manfis(oau_data, 0.2, Model_Gauss, Model_Pimf, Model_Dsig)