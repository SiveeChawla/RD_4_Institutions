%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Revised on: 5 October 2018 
% Re-Revised on : 13 Nov 2018 with normalised values 
% Purpose : Estimating Enrichment factor (EF) for the neighbourhood
% interaction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[EF_percell_norm] = EF_function(neigh_eight,shp,no_cell,lulctype,no_lulctype)

%***********************************************
%Identifying the lulc types in the shapefile shp
%***********************************************
% temp = zeros(no_cell);
% for i = 1 : no_cell
%     temp(i) = shp(i).LULC;
% end 


Nk = zeros(no_lulctype,1);
% For total cells Nk/N
for i = 1 : no_cell   % for all cells in the landscape
    for j = 1 : no_lulctype
        if (strcmp(shp(i).LULC,lulctype(j))==1)
            Nk(j)=Nk(j)+1;
            
        end
    end 
end 

%To check the output of above for loop

if (sum(Nk) == no_cell); 
    disp('Value of Total Nk estimated is correct. Please, proceed!!');
else
    disp('Issue in calculation of total Nk. Kindly,Redo..existing function');
    return; 
end 

Denom_N = (Nk/no_cell); 
nk = zeros(no_cell,no_lulctype);
no_of_neigh = zeros(no_cell,1);

%*************************************************************************
%**Calculating number of particular lulc type in the neighbourhood of each
%cell*********************************************************************
nd = 8;% neighbourhood size  
for i = 1:no_cell  %for all the cell
    for k = 1 : nd
        if (neigh_eight(i,k)>0)
            no_of_neigh(i)= no_of_neigh(i)+1; %effective number of neighbours to identify edges 
            for j = 1:no_lulctype
                if((strcmp(shp(neigh_eight(i,k)).LULC,lulctype(j))==1))
                    nk(i,j)=nk(i,j)+1;
                end   
            end       
        end
    end    
end
 
%*******************************************************************
%**Estimating Enrichment factor  for each cell for lulc type U and A 
%*******************************************************************



for i = 1 : no_cell
    for j = 1:no_lulctype
        EF_percell(i,j)=(nk(i,j)/no_of_neigh(i))/Denom_N(j);
    end 
end 

%**************Normalise *******************

maxEF = max(EF_percell);
minEF = min(EF_percell);
for j = 1 : no_lulctype
    EF_percell_norm(:,j)= (EF_percell(:,j)-minEF(j))/(maxEF(j)-minEF(j));
end 

end
