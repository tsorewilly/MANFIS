%% ANFIS MULTIMODEL Classification
% Classification  Demo 1
%
% * Developer Er.Abbas Manthiri S
% * EMail abbasmanthiribe@gmail.com
% * Date 24-03-2017
%
%% Initialize
clc
clear
close all
warning off all
%% Load Data
load data

epoch_n = 50;
dispOpt = zeros(1,4);
numMFs = 2;
inmftype= 'gbellmf';
outmftype= 'linear';
split_range=2;
Model=ANFIS.train(TrainData,TrainClass,split_range,numMFs,inmftype,outmftype,dispOpt,epoch_n);
disp('Model')
disp(Model)
Result=ANFIS.classify(Model,TrainData);
%Performance Calculation
Rvalue=@(a,b)(1-abs((sum((b-a).^2)/sum(a.^2))));
RMSE=@(a,b)(abs(sqrt(sum((b-a).^2)/length(a))));
MAPE=@(a,b)(abs(sum(sqrt((b-a).^2)*100./a)/length(a)));
fprintf('Anfis     R      RMSE     MAPE\n')
r=Rvalue(TrainClass,Result);
rmse=RMSE(TrainClass,Result);
mape=MAPE(TrainClass,Result);
fprintf('Anfis  %.4f\t%.4f\t%.4f\n',r,rmse,mape);
%% Display
n=40;
disp('TestClass Predicted ')
disp([TrainClass(1:n),Result(1:n)])

