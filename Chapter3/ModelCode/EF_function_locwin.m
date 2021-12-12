%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Revised on: 5 October 2018 
% Re-Revised on : 13 Nov 2018 with normalised values 
% Purpose : Estimating Enrichment factor (EF) for the neighbourhood
% interaction
% Re-Revised on : 4 April 2019
% Purpose : To estimate Enrichment factor in the local window as input in 
% the  CA_local module. A word of Caution : 
% the window is this time a 2D struct array, hence,
% there will be changes as compared to previous version. 
% Re-Re-Revised : 11 April 2019 (after debugging)
% It throws an error "index exceeds matrix dimensions" when number of
% classes in the local window is only 1. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[lulctype,no_lulctype,EF_percell_norm] = EF_function_locwin(neigh_2D,shp)

%***********************************************
%Identifying the lulc types in the shapefile shp
%***********************************************

lulc_temp = {shp(:).LULC}; %get the values in cell array
lulctype = unique(lulc_temp); %extract unique values of each class type
no_lulctype=numel(lulctype);

[m,n] = size(shp); 
no_cell = m*n;
if (no_lulctype>1)
 Nk = zeros(no_lulctype,1);
else
    Nk = 0;
end 
% For total cells Nk/N
for i = 1 : no_cell
    if (no_lulctype>1)
    for j = 1 : no_lulctype
        if (strcmp(shp(i).LULC,lulctype(j))==1)
            Nk(j)=Nk(j)+1;
            
        end
    end 
    else
        Nk = Nk +1 ;
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
if (no_lulctype>1)
    nk = zeros(no_cell,no_lulctype);
else
    nk = zeros(no_cell,1);
end


%*************************************************************************
%**Calculating number of particular lulc type in the neighbourhood of each
%cell*********************************************************************
nd = 8;% neighbourhood size  
for k = 1:no_cell  %for all the cell
    for i = 1 : nd
        if (all(neigh_2D(k,i,:)>0))
           if (no_lulctype>1)
            for j = 1:no_lulctype
                if ((strcmp((shp(neigh_2D(k,i,1),neigh_2D(k,i,2)).LULC),lulctype(j)))==1)
                    nk(k,j)=nk(k,j)+1;
                end
            end
           else
%                if ((strcmp((shp(neigh_2D(k,i,1),neigh_2D(k,i,2)).LULC),lulctype(j)))==1)
                    nk(k)=nk(k)+1;
%                 end
           end 
        end
    end
    
end

if (no_lulctype>1)
no_of_neigh = sum(nk');% gives the total number of neighbours 
else
    no_of_neigh = nk;
end 

% else
%  no_of_neigh = nk;
% end
%*******************************************************************
%**Estimating Enrichment factor  for each cell for lulc type U and A 
%*******************************************************************
if (no_lulctype >1)
    EF_percell = zeros(no_cell,no_lulctype);
else
    EF_percell = zeros(no_cell,1);
end
clear i; 
clear j ; 
for i = 1 : no_cell
    if (no_lulctype > 1)  %for if there is more than one class else, it throws and error for which we have the else statement below.
    for j = 1:no_lulctype
        EF_percell(i,j)=(nk(i,j)/no_of_neigh(i))/Denom_N(j);
    end 
    else
        EF_percell(i)=(nk(i)/no_of_neigh(i))/Denom_N;
    end 
end 

%**************Normalise *******************

EF_percell_norm = zeros(no_cell,no_lulctype);
maxEF = max(EF_percell);
minEF = min(EF_percell);
clear j; 
if (no_lulctype>1)
    for j = 1 : no_lulctype
    EF_percell_norm(:,j)= (EF_percell(:,j)-minEF(j))/(maxEF(j)-minEF(j));
    end 
else
    EF_percell_norm = EF_percell; 
end 





end
