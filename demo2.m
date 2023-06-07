%% ANFIS MULTIMODEL Classification
% Rounding Classification  Demo 2
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
epoch_n = 30;
dispOpt = zeros(1,4);
numMFs = 3;
inmftype= 'gbellmf';
outmftype= 'linear';
split_range=3;
Model=ANFIS.train(TrainData,round(TrainClass),split_range,numMFs,inmftype,outmftype,dispOpt,epoch_n);
disp('Model')
disp(Model)
Result=round(ANFIS.classify(Model,TrainData));
% Performance Calculation
Accuracy=mean(round(TrainClass)==Result);
disp('Accuracy')
disp(Accuracy)
%% Display
n=100;
disp('TestClass Predicted ')
disp(round([TrainClass(1:n),Result(1:n)]))