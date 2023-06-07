
clear; clc
FootItems = readtable('G:\Documents\Research Home\Diabetics\2017\Submission\JournalFoodTable.xlsx');


%Selected
MondayMorning={'Milk+Quaker Oats+Akara'; 'Soya Milk+Agidi+Akara'; 'Soya Milk+Agidi+Moin Moin'; 'Soya Milk+Agidi+Beans Porridge'; 'Soya Milk+Corn flakes+Akara'; 
    'Soya Milk+Corn flakes+Moin Moin'; 'Soya Milk+Corn flakes+Beans Porridge'; 'Soya Milk+Corn flakes+Potato Porridge'; 'Soya Milk+Pap+Akara'; 
    'Soya Milk+Pap+Moin Moin'; 'Soya Milk+Pap+Beans Porridge'; 'Soya Milk+Quaker Oats+Akara'; 'Soya Milk+Quaker Oats+Moin Moin';
    'Soya Milk+Quaker Oats+Beans Porridge'; 'Soya Milk+White bread+Beans Porridge'; 'Evaporated milk+Agidi+Akara'; 'Evaporated milk+Agidi+Moin Moin';
    'Evaporated milk+Agidi+Beans Porridge'; 'Evaporated milk+Corn flakes+Akara'; 'Apple Oatmeal+Ekuru+Milk'; 
    'Evaporated milk+Corn flakes+Moin Moin'; 'Evaporated milk+Corn flakes+Beans Porridge'; 'Evaporated milk+Corn flakes+Potato Porridge'; 'Evaporated milk+Pap+Akara'; 
    'Evaporated milk+Pap+Moin Moin'; 'Evaporated milk+Pap+Beans Porridge'; 'Evaporated milk+Quaker Oats+Akara'; 'Evaporated milk+Quaker Oats+Moin Moin';
    'Evaporated milk+Quaker Oats+Beans Porridge'; 'Evaporated milk+White bread+Beans Porridge'; 'Condensed Milk+Agidi+Akara'; 'Condensed Milk+Agidi+Moin Moin'; 
    'Condensed Milk+Agidi+Beans Porridge'; 'Condensed Milk+Corn flakes+Akara'; 'Condensed Milk+Corn flakes+Moin Moin'; 'Milk+Corn flakes+Beans Porridge';
    'Condensed Milk+Corn flakes+Potato Porridge'; 'Condensed Milk+Pap+Akara'; 'Condensed Milk+Pap+Moin Moin'; 'Condensed Milk+Pap+Beans Porridge'; 
    'Condensed Milk+Quaker Oats+Akara'; 'Condensed Milk+Quaker Oats+Moin Moin'; 'Milk+Quaker Oats+Beans Porridge'; 'Milk+White bread+Beans Porridge'};



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
                Kendall = kendall_tau(X, Y);
                [SpearMan_R Pearson_Diag(2) CHI_Mic Kendall]
                
                S_R(fItem, w)= SpearMan_R;  
                P_R(fItem, w)= Pearson_Diag(2);  
                C_R(fItem, w)= MinMax(CHI_Mic, 415.355);  
                K_R(fItem, w) = Kendall
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
    MondayMorning{d, 5} = mean(abs(K_R));
    if d==dAlt;        dl=2;     else         dl=1;     end
    
    figure(1); plot(mean(abs(S_R)), 'LineWidth', dl); hold on;
    figure(2); plot(mean(abs(P_R)), 'LineWidth', dl); hold on;
    figure(3); plot(mean(abs(C_R)), 'LineWidth', dl); hold on;
    figure(4); plot(mean(abs(K_R)), 'LineWidth', dl); hold on;

end
figure(1); title("Spearman Correlation Coefficient for all Food Substitutes"); legend('Planned'); 
figure(2); title("Pearson Correlation Coefficient for all Food Substitutes"); legend('Planned'); 
figure(3); title("Maximal Information Coefficient for all Food Substitutes"); legend('Planned'); 
figure(4); title("Kendall Rank Correlation Coefficient for all Food Substitutes"); legend('Planned'); 

