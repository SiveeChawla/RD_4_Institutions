%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Created on: 8 May 2019
% Purpose : CA module for regional level update
% Green cells are naturally conserved green lands , Agriculture doesn't
% comes as a part of green cell count
% Revised on : 9 May 2020
% Purpose : Remove contraint on update based on the green to grey ration no
% use of GIS .
% Cannot go back .
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [nxshp]= Regional_CA_2(nxshp,mkfolder,itr_main,no_cell)

%    nxshp = shaperead('C:\Users\jc442626\OneDrive - James Cook University\Documents\PhD\PhD_Tasks_imp\RQ1\TestingCode_18Mar2019\InputFiles\InpShpFile_V1.shp'); %S give strucutre and A are the attributes of the file
m = no_cell;


%********Estimate ratio of Green vs Grey cells in the local window ******
green_space_cl= {'F','G','We'};
% grey_space_cl = {'Rb','U','Wa'};
grey_space_cl = {'U','Wa'};
greencell_ct = 0;
greycell_ct =0;

%*********** Counting the green spaces vs grey spaces *****************
for k = 1:m
%     if (any(strcmp(green_space_cl,nxshp(k).LULC))) % if the LULC belongs to any of the
        %three classes specified in the cell array
%         greencell_ct = greencell_ct +1;
%     else
    if (any(strcmp(grey_space_cl,nxshp(k).LULC)))
        greycell_ct = greycell_ct  + 1 ;
    end
end




% first condition : green to grey cell ratio
% Cl_ratio = greencell_ct/m;
Cl_ratio = greycell_ct/m;


% threshold



for j = 1 : m
    if (itr_main > 6)
        LUZtemp  = nxshp(j).LUZ_temp;
    else
        LUZtemp = nxshp(j).LUZ;
        %             disp(LUZtemp);
    end
    %        LULCtemp = tempshp(i).LULC; % we don't need LULC here because we
    %        get to know the urban pressure from the distance from urban centre
    
    
    switch LUZtemp
        case 'PA'
            if (Cl_ratio < 0.55)
                nxtst = 'RgA';
            else
                nxtst = 'PA';
            end
        case 'RgA'
            if (Cl_ratio < 0.55)
                nxtst = 'RsA';
            else
                nxtst = 'RgA';
            end
            
        case 'RsA'
            
            if (Cl_ratio <0.55)
                nxtst = 'GA';
            else
                nxtst = 'RsA';
            end
        case 'GA'
            nxtst = 'GA';
    end
    nxshp = setfield(nxshp,{j},'LUZ_temp',nxtst);
end
end



