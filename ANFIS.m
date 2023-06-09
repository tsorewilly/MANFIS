classdef ANFIS
    %%
    %
    % * Developer Er.Abbas Manthiri S
    % * EMail abbasmanthiribe@gmail.com
    % * Date 24-03-2017
    %
    methods (Static)
        function Model=train(TrainData,TrainClass,split_range,numMFs,inmftype,outmftype,dispOpt,epoch_n)
            
            % Inputs
            % TrainData-Data to be Train
            % TrainClass Class of train
            % split_range=Data split to Anfis Classification range (2,3)
            % FIS INPUTS
            % 1.numMFs===== is a vector whose coordinates specify the number of membership functions associated with each input.
            % If you want the same number of membership functions to be associated with each input, then specify numMFs as a single number.
            % 2.inmftype====== is a string array in which each row specifies the membership function type associated with each input.
            % This can be a one-dimensional single string if the type of membership functions associated with each input is the same.
            % 3.outmftype=== is a string that specifies the membership function type associated with the output.
            % There can only be one output, because this is a Sugeno-type system. The output membership function type must be either linear or constant.
            % The number of membership functions associated with the output is the same as the number of rules generated by genfis1.
            % ANFIS INPUT
            % Output
            % Model Which has multiple models
            
            Model=struct('AnfisModel',{},'Reference',[],'splitrange',[]);
            iteration=1;
            while(1)
                if iteration==1
                    [Model(iteration).AnfisModel,Model(iteration).Reference,Model(iteration).splitrange]=ANFIS.subtrain(TrainData,TrainClass,...
                        split_range,inmftype,outmftype,numMFs,dispOpt,epoch_n );
                else
                    [Model(iteration).AnfisModel,Model(iteration).Reference,Model(iteration).splitrange]=ANFIS.subtrain(Model(iteration-1).Reference,...
                        TrainClass,split_range,inmftype,outmftype,numMFs,dispOpt,epoch_n );
                end
                if length(Model(iteration).splitrange)<3
                    break
                end
                iteration=iteration+1;
            end
        end
        function [AnfisModel,Refernce,splitrange]=subtrain(TrainData,TrainClass,split_range,mfType1,mfType2,numMFs,dispOpt,epoch_n )
            %% Split data for Better Classification
            lengthOfdata=size(TrainData,2);
            splitrange=zeros(100,1);
            tempVar=0;
            i=2;
            while(1)
                count=(lengthOfdata-tempVar);
                if count>split_range
                    tempVar=tempVar+split_range;
                    splitrange(i)=tempVar;
                elseif count<=split_range && count>0
                    splitrange(i)=lengthOfdata;
                    tempVar=lengthOfdata;
                else
                    break;
                end
                i=i+1;
            end
            splitrange=splitrange(1:i-1);
            
            %% Anfis Train Model
            cycle=length(splitrange)-1;
            AnfisModel=cell(1,cycle);
            Refernce=zeros(size(TrainData,1),cycle);
            for i=1:cycle
                dataRange=splitrange(i)+1:splitrange(i+1);
                fisdata=[TrainData(:,dataRange) TrainClass];
                fis1=genfis1(fisdata,numMFs,mfType1,mfType2);
                AnfisModel{i}=anfis(fisdata,fis1,epoch_n,dispOpt);
                Refernce(:,i)=evalfis(TrainData(:,dataRange),AnfisModel{i});
            end
        end
        
        function Result=classify(Model,TestData,thresh)
            % Inputs
            % Model -Anfis Multi Model
            % Test Data
            % Result Class of Test Data
            if(~exist('thresh','var')); tt=1;  end
            for iteration=1:length(Model)
                splitrange=Model(iteration).splitrange;
                if iteration==1
                    Result=zeros(size(TestData,1),length(splitrange)-1);
                    for i=1:length(splitrange)-1
                        range=splitrange(i)+1:splitrange(i+1);
                        Result(:,i)=evalfis(TestData(:,range),Model(iteration).AnfisModel{i});
                    end
                else
                    ResultOld=Result;
                    Result=zeros(size(TestData,1),length(splitrange)-1);
                    for i=1:length(splitrange)-1
                        range=splitrange(i)+1:splitrange(i+1);
                        %Result(:,i) = round(temp); %Replaced this with next 4 lines
                        temp = abs(evalfis(ResultOld(:,range),Model(iteration).AnfisModel{i}));
                        Result(:,1) = temp;
                        if(~exist('tt','var')) 
                            temp(isinf(temp)) = 0;  %set all undetermined tuples to 0
                            temp(isnan(temp)) = 0;  %set all undetermined tuples to 0
%                             temp(temp > 1.05) = 1.05;     %Normalize All EXACERBATE tuples
%                             temp(temp < 0.05) = 0.05;     %Normalize All EXACERBATE tuples
                            Result(:,1) = temp;     %Set all cases of inf and NaN in predicted result to zero
                            temp(temp>thresh) = 1;  %set all passed tuples to 1
                            temp(temp < 1) = 0;     %set all failed tuples to 0                            
                        end                        
                        Result(:,2) = temp;
                    end
                    clear ResultOld
                end
            end
        end
    end
end