% plot(X(:,1),'LineWidth',2); hold on;
% plot(Y(:,1),'LineWidth',2); 
% plot(XY(:,1),'LineWidth',2, 'LineStyle','--'); hold off;


clear; clc
FootItems = readtable('foodNutrients.xlsx');
FootItems = readtable('G:\Documents\Research Home\Diabetics\2017\Submission\foodList.xlsx');
lent = height(FootItems);



for dsFood = 1 :lent    
    dsFoodItemId = find(strcmp(FootItems.Nature, table2cell(FootItems(dsFood, 29)))==1);
    for altFood = 1 : length(dsFoodItemId)        
%         if (dsFood == altFood)
%        if(altFood < lent)
%            altFood = altFood+1;
%        else
%             continue
%       end
%         else
%         end
        if(dsFood ~=dsFoodItemId(altFood))
            X = table2array(FootItems(dsFood, 3:26));
            Y = table2array(FootItems(dsFoodItemId(altFood), 3:26));

            compaNames = strcat(string(table2cell(FootItems(dsFood, 2))), " VS ", string(table2cell(FootItems(dsFoodItemId(altFood), 2))));


            [SpearMan_R, SpearMan_Pvalue] = corr(X', Y','Type','Spearman');
            [Pearson_Diag, Pearson_Pvalue] = corrcoef(X, Y);
            [CHI_Mic, CHI_Pvalue] = chi2test([X; Y]);

            FoodCorrel{dsFood, altFood} = [compaNames SpearMan_R SpearMan_Pvalue Pearson_Diag(2) Pearson_Pvalue(2) CHI_Mic CHI_Pvalue];

            FoodCorrel_SpearMan_R(dsFood, altFood) = SpearMan_R;
            FoodCorrel_SpearMan_Pvalue(dsFood, altFood) = SpearMan_Pvalue;
            FoodCorrel_Pearson_Diag(dsFood, altFood) = Pearson_Diag(2);
            FoodCorrel_Pearson_Pvalue(dsFood, altFood) = Pearson_Pvalue(2);
            FoodCorrel_CHI_Mic(dsFood, altFood) = CHI_Mic;        
            FoodCorrel_CHI_Pvalue(dsFood, altFood) = CHI_Pvalue;
        end
    end
end
%%
%Selected
MondayMorning={'Soya Milk+Agidi+Akara'; 'Soya Milk+Agidi+Moin Moin'; 'Soya Milk+Agidi+Beans pottage'; 'Soya Milk+Corn flakes+Akara'; 
    'Soya Milk+Corn flakes+Moin Moin'; 'Soya Milk+Corn flakes+Beans pottage'; 'Soya Milk+Corn flakes+Potato pottage'; 'Soya Milk+Pap+Akara'; 
    'Soya Milk+Pap+Moin Moin'; 'Soya Milk+Pap+Beans pottage'; 'Soya Milk+Quaker Oats+Akara'; 'Soya Milk+Quaker Oats+Moin Moin';
    'Soya Milk+Quaker Oats+Beans pottage'; 'Soya Milk+White bread+Beans pottage'; 'Evaporated milk+Agidi+Akara'; 'Evaporated milk+Agidi+Moin Moin'; 'Evaporated milk+Agidi+Beans pottage'; 'Evaporated milk+Corn flakes+Akara'; 
    'Evaporated milk+Corn flakes+Moin Moin'; 'Evaporated milk+Corn flakes+Beans pottage'; 'Evaporated milk+Corn flakes+Potato pottage'; 'Evaporated milk+Pap+Akara'; 
    'Evaporated milk+Pap+Moin Moin'; 'Evaporated milk+Pap+Beans pottage'; 'Evaporated milk+Quaker Oats+Akara'; 'Evaporated milk+Quaker Oats+Moin Moin';
    'Evaporated milk+Quaker Oats+Beans pottage'; 'Evaporated milk+White bread+Beans pottage'; 'Condensed Milk+Agidi+Akara'; 'Condensed Milk+Agidi+Moin Moin'; 
    'Condensed Milk+Agidi+Beans pottage'; 'Condensed Milk+Corn flakes+Akara'; 'Condensed Milk+Corn flakes+Moin Moin'; 'Milk+Corn flakes+Beans pottage';
    'Condensed Milk+Corn flakes+Potato pottage'; 'Condensed Milk+Pap+Akara'; 'Condensed Milk+Pap+Moin Moin'; 'Condensed Milk+Pap+Beans pottage'; 
    'Condensed Milk+Quaker Oats+Akara'; 'Condensed Milk+Quaker Oats+Moin Moin'; 'Milk+Quaker Oats+Beans pottage'; 'Milk+White bread+Beans pottage'};



for d = 1 : length(MondayMorning)    
    [S_R, P_R, C_R] = deal([]); 
    dsMenu = MondayMorning{d, 1};
    dsFoodItems = split(dsMenu, '+');

    for fItem = 1 : length(dsFoodItems)
        dsFoodItemId = find(strcmp(FootItems.FoodDescription, dsFoodItems(fItem))==1);
        X = table2array(FootItems(dsFoodItemId, 3:13));
        w=1;
        for dAlt = 1 : length(MondayMorning)
%             if d~=dAlt
                AltMenu = MondayMorning{dAlt,1};
                AltFoodItems = split(AltMenu, '+');
                AltFoodItemId = find(strcmp(FootItems.FoodDescription, AltFoodItems(fItem))==1);                
                Y = table2array(FootItems(AltFoodItemId, 3:13));

                [SpearMan_R, SpearMan_Pvalue] = corr(X', Y','Type','Spearman');
                [Pearson_Diag, Pearson_Pvalue] = corrcoef(X, Y);
                [CHI_Mic, CHI_Pvalue] = chi2test([X; Y]);
                [SpearMan_R Pearson_Diag(2) CHI_Mic]
                
                S_R(fItem, w)= SpearMan_R;  
                P_R(fItem, w)= Pearson_Diag(2);  
                C_R(fItem, w)= MinMax(CHI_Mic, 415.355);  
                w = w+1;
%             end
        end        
    end
%    S_R(4,:) = mean(abs(S_R));     TuesdayMorning{d, 2} = S_R;
%    P_R(4,:) = mean(abs(P_R));     TuesdayMorning{d, 3} = P_R;
%    C_R(4,:) = mean(abs(C_R));     TuesdayMorning{d, 4} = C_R;
    MondayMorning{d, 2} = mean(abs(S_R));
    MondayMorning{d, 3} = mean(abs(P_R));
    MondayMorning{d, 4} = mean(abs(C_R));
    figure(1); plot(mean(abs(S_R))); hold on;
    figure(2); plot(mean(abs(P_R))); hold on;
    figure(3); plot(mean(abs(C_R))); hold on;

end
figure(1); title("Spearman Correlation Coefficient for all Food Substitutes"); legend('Planned'); 
figure(2); title("Pearson Correlation Coefficient for all Food Substitutes"); legend('Planned'); 
figure(3); title("Maximal Information Coefficient for all Food Substitutes"); legend('Planned'); 

%%
figure(1), clf; plot(FoodCorrel_SpearMan_R(1,:), 'r-o+LineWidth', 3); hold on
plot(FoodCorrel_SpearMan_Pvalue(1,:), 'c-o+LineWidth', 2); hold off; 
legend('SpearMan_R+SpearMan_P+Location+best')

figure(2), clf; plot(FoodCorrel_Pearson_Diag(1,:), 'r-o+LineWidth', 2);hold on; 
plot(FoodCorrel_Pearson_Pvalue(1,:), 'c-o+LineWidth', 2);hold off; 
legend('Pearson_R+Pearson_P+Location+best')

figure(3), clf; plot(MinMax(FoodCorrel_CHI_Mic(1,:), max(max(FoodCorrel_CHI_Mic)),...
        min(min(FoodCorrel_CHI_Mic))), 'r-o+LineWidth', 2); hold on; 
plot(FoodCorrel_CHI_Pvalue(1,:), 'c-o+LineWidth', 2); hold off; 
legend('CHI_R+CHI_P+Location+best')
