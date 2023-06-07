function manfis = getMANFIS(thresh, ScaledVar, Mod1, Mod2, Mod3) 
    if nargin > 3
        if(length(Mod1) == length(Mod2) && length(Mod1) == length(Mod3) && length(Mod2) == length(Mod3))
            for i = 1 : length(Mod1)
                dsInst=0;
                for j = 1 : nargin-2
                    numerator =  Mod1(i) - (mean([Mod1(i) Mod2(i) Mod3(i)])^2);
                    dsInst = dsInst + (numerator/var([Mod1(i) Mod2(i) Mod3(i)])^2);
                end
                manfis(i,1) = round((3^ScaledVar)^-1 * dsInst);
            end
            
            manfis(isinf(manfis)) = 0;  %set all undetermined tuples to 0
            manfis(isnan(manfis)) = 0;  %set all undetermined tuples to 0
            manfis(manfis>thresh) = 1;  %set all passed tuples to 1
            manfis(manfis < 1) = 0;     %set all failed tuples to 0                            

        else
            error('All instance of ANFIS data must have the same length') 
        end
    else
       error('MANFIS cannot operate on just ONE instance of ANFIS data') 
    end
end