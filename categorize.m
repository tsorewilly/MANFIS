function cat = categorize(data)
    dim = size(data);
    
    for i = 1:dim(1)
        val = data(i);
        if(val<0.201)
            cat(1,i) = 1;
        elseif(val>0.20 && val<0.401)
            cat(1,i) = 2;
        elseif(val>0.40 && val<0.651)
            cat(1,i) = 3;
        elseif(val>0.65)
            cat(1,i) = 4;                   
        end
    end
end