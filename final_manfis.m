function [Value, Status, Degree] = final_manfis(data, Threshold, Model_Gauss, Model_Pimf, Model_Dsig)
    
    if (nargin == 2)
        load('Data_45_35_44_35_xx.mat');% load the ANFIS blocks, takes some time
    end
    dim = size(data);
    Lent = 1:dim(1);
    
    warning ('off')
    SData_Eval_Ga=abs((ANFIS.classify(Model_Gauss, data(Lent,1:7), Threshold)));
    %SData_Eval_Gb=abs((ANFIS.classify(Model_Gbell, data(Lent,1:7), Threshold)));
    SData_Eval_Ds=abs((ANFIS.classify(Model_Dsig, data(Lent,1:7), Threshold)));    
    SData_Eval_Pi=abs((ANFIS.classify(Model_Pimf, data(Lent,1:7), Threshold)));    

    warning ('on')
    
    Status = 3^-0.534*((SData_Eval_Ga(:,1) + SData_Eval_Pi(:,1) + SData_Eval_Ds(:,1))/3);
    Value=Status';
    
    Degree = categorize(Status); %categorize outcome of MANFIS with different labels 
    
    Status(Status<Threshold)=0;   
    
    Status(Status>0)=1;  
    Status=Status';
end




