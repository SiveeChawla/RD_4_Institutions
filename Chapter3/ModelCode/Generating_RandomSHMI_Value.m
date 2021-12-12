%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Revised on: 30 August 2018 
% Purpose : Rule per cell _tae
% Assumption 1 : Randomly  assing vary value of D_SHMI or rule_temp between
% 0 and 1 from a uniform distirbution .  Line  114 and Line 162- 166
% Based on LUPolicy and Land Utilization Zones (LUZ)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [D_SHMI] = Generating_RandomSHMI_Value(shp,no_cell,rand_option,itr)

D_SHMI = zeros(no_cell,1);
for i = 1 :no_cell
    if (rand_option == 1)
        if (itr < 6) %if DSHMI values are generated for first iteration 
            LUZval = shp(i).LUZ;
        else
         LUZval = shp(i).LUZ_temp;
        end 
        switch LUZval
            case 'PA'
                D_SHMI(i)= 0;
            case 'RgA'
                D_SHMI(i)= 0.15+(0.49-0.15)*rand(1) ; % r  = a +(b-a).*rand(N,1) , generate N numbers in the interval (a,b).
            case 'RsA'
                D_SHMI(i)= 0.49+(0.98-0.49)*rand(1);
            case 'GA'
                D_SHMI(i) = 0.99;
        end
    else
        if(rand_option == 0)
            D_SHMI(i)= rand(1);
        end
    end
end

end