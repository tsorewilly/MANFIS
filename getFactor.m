% load('Data_45_35_44_35_xx.mat')
% load("Data/filled_data.mat");

load('Models/Model_Real-TrainData_35C_34C_35C_35L.mat')
load ("Data/real_new_processed_data.mat");
Threshold=0.2;
ddata = pima_data;

Lent = 1:length(ddata);
 Lent = TrainIdx_10; 
%  Lent = ValidIdx_10;    

SData_Eval_Ga=abs((ANFIS.classify(Model_Gauss, ddata(Lent,1:7), Threshold)));
SData_Eval_Pi=abs((ANFIS.classify(Model_Pimf, ddata(Lent,1:7), Threshold)));        
SData_Eval_Ds=abs((ANFIS.classify(Model_Dsig, ddata(Lent,1:7), Threshold)));    

  
%%
data=[SData_Eval_Ga(:,1), SData_Eval_Pi(:,1), SData_Eval_Ds(:,1), ddata(Lent,8)];
scale=[];
k=1;a=1; figure (100); hold on;

for j = -1:0.0001:1
    count=0;
     for i = 1 : length(data)
        data(i, 5) = (3^-j)*sum(data(i,1:3))/3;
        %Apply Threshold
        if(data(i, 5)<Threshold)
            data(i, 5) = 0;
        else
            data(i, 5) = 1;  
        end
        if data(i, 4)==data(i, 5); count = count + 1; end;
     end
    per = (count/length(data))*100;
    scale(k,:) = [j per];
    disp(scale); pause(0.001);
    if(mod(k,100)==0)
        figure (100); plot(scale(a:k,1), scale(a:k,2), 'LineWidth',3)
        a=k;
    end
    k=k+1;
end


%%
figure; plot(all_scale_real.Scale,all_scale_real.Pima, 'LineWidth',3); hold on
plot(all_scale_real.Scale,all_scale_real.Pima_Training, 'LineWidth',3)
plot(all_scale_real.Scale,all_scale_real.Pima_Validation, 'LineWidth',3); 
plot(all_scale_real.Scale,all_scale_real.Schorl, 'LineWidth',3)
plot(all_scale_real.Scale,all_scale_real.OAU, 'LineWidth',3)
plot(all_scale_real.Scale,all_scale_real.All, 'LineWidth',3)
legend('Pima','Pima_T_r','Pima_T_e','Schorl','OAU','All')