%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Created on: 8 May 2019
% Purpose : CA module for regional level update
% Green cells are naturally conserved green lands , Agriculture doesn't
% comes as a part of green cell count
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [tempshp_shpstruct]= Regional_CA(nxshp,mkfolder,itr_main,no_cell)

%    nxshp = shaperead('C:\Users\jc442626\OneDrive - James Cook University\Documents\PhD\PhD_Tasks_imp\RQ1\TestingCode_18Mar2019\InputFiles\InpShpFile_V1.shp'); %S give strucutre and A are the attributes of the file
m = no_cell;


%********Estimate ratio of Green vs Grey cells in the local window ******
green_space_cl= {'F','G','We'};
grey_space_cl = {'Rb','U','Wa'};
greencell_ct = 0;
greycell_ct =0;


for k = 1:m
    if (any(strcmp(green_space_cl,nxshp(k).LULC))) % if the LULC belongs to any of the
        %three classes specified in the cell array
        greencell_ct = greencell_ct +1;
    elseif (any(strcmp(grey_space_cl,nxshp(k).LULC)))
        greycell_ct = greycell_ct  + 1 ;
    end
end




% first condition : green to grey cell ratio
Cl_ratio = greencell_ct/greycell_ct;

if (Cl_ratio >= 0.50) %Only if we have enough green spaces
    
    %Python code will be called within this if condtion because it is
    %allowing the change in LULC type
    tmpshp_shpfile = strcat(mkfolder,'\','outputshp_temp');
    %     shapewrite(nxshp,tmpshp_shpfile);
    %READ SHAPE FILE
    
    % creat temporary shape file
    %     tmpshp_shpfile = strcat(mkfolder,'\','outputshp_temp');
    shapewrite(nxshp,tmpshp_shpfile);
    %READ SHAPE FILE
    fileForMat = strcat(tmpshp_shpfile,'.shp');
    
    %     fileForMat = strcat(tmpshp_shpfile,'.shp');
    filetopass = strcat('"',tmpshp_shpfile,'.shp','"'); %file name for python scrip
    
    
    
    % CAll Python scrip to update distance from urban centre.
    Cmd =['Model_UbDist.py',' ',filetopass];
    
    system(Cmd);
    tempshp_shpstruct = shaperead(fileForMat);
    % Read shape file after estimation of urban distance
    
    
    
    %**************************************************************************
    %************Estimating Initial Condition for Urban Distance***************
    %**************************************************************************
    
    %*********setting up threshold*****************************
    
    %if the distance is 80% of min then the cell is a candidate of converstion
    % else if the distance is 80% of max then the cell is not a candidate of
    % conversion
    
    % "TO BE OR NOT TO BE"
    
    % To BE (to convert) - Estimate urban distance threshold
    
    arr_urbdist = [tempshp_shpstruct.NEAR_DIST];
    urbdist_percell = nonzeros(arr_urbdist);
    %     Min_Threshold = 0.8*min(urbdist_percell);  % Remving minimum for the
    %     time being (3/7/2019). it is creaing an error. If the cell is at a
    %     certain distance w.r.t to maximum possibel distance in the landscape
    %     then it will be converted to the next lesser restricted LUZ type
    Max_Threshold = 0.4*max(urbdist_percell);
    
    
    
    %     [m,n] = size(tempshp_shpstruct);
    
    for j = 1 : m
        if (itr_main > 6)
            LUZtemp  = tempshp_shpstruct(j).LUZ_temp;
        else
            LUZtemp = tempshp_shpstruct(j).LUZ;
%             disp(LUZtemp);
        end
        %        LULCtemp = tempshp(i).LULC; % we don't need LULC here because we
        %        get to know the urban pressure from the distance from urban centre
        
        
        switch LUZtemp
            case 'PA'
                %                 if (tempshp_shpstruct(j).NEAR_DIST <= Min_Threshold)
                %                     nxtst = 'RgA';
                %                 elseif(tempshp_shpstruct(j).NEAR_DIST>=Max_Threshold)
                %                     nxtst = 'PA';
                %                 end
                
                
                if (tempshp_shpstruct(j).NEAR_DIST <= Max_Threshold)
                    nxtst = 'RgA';
                else
                    nxtst = 'PA';
                end
            case 'RgA'
                %                 if (tempshp_shpstruct(j).NEAR_DIST <= Min_Threshold)
                %                     nxtst = 'RsA';
                %                 elseif(tempshp_shpstruct(j).NEAR_DIST>=Max_Threshold)
                %                     nxtst = 'RgA';
                %                 end
                %
                if (tempshp_shpstruct(j).NEAR_DIST <= Max_Threshold)
                    nxtst = 'RsA';
                else
                    nxtst = 'RgA';
                end
                
                
            case 'RsA'
                %                 if (tempshp_shpstruct(j).NEAR_DIST <= Min_Threshold)
                %                     nxtst = 'GA';
                %                 elseif(tempshp_shpstruct(j).NEAR_DIST>=Max_Threshold)
                %                     nxtst = 'RsA';
                %                 end
                
                if (tempshp_shpstruct(j).NEAR_DIST <= Max_Threshold)
                    nxtst = 'GA';
                else
                    nxtst = 'RsA';
                end
            case 'GA'
                nxtst = 'GA';
        end
        tempshp_shpstruct = setfield(tempshp_shpstruct,{j},'LUZ_temp',nxtst);
    end
elseif(Cl_ratio < 0.50)  %if green ration is less then restrict further , or if it is not less nor more
    % then it is
    
    tmpshp_shpfile = strcat(mkfolder,'\','outputshp_temp');
    
    % creat temporary shape file
    shapewrite(nxshp,tmpshp_shpfile);
    %READ SHAPE FILE
    fileForMat = strcat(tmpshp_shpfile,'.shp');
    tempshp_shpstruct = shaperead(fileForMat);
    
    
    
    for j = 1 : m
        
        if (itr_main > 6)
            LUZtemp  = tempshp_shpstruct(j).LUZ_temp;
        else
            LUZtemp = tempshp_shpstruct(j).LUZ;
        end
        
        if (strcmp(LUZtemp,'RgA')==1)
            nxtst = 'PA';
        elseif (strcmp(LUZtemp,'RsA')==1)
            nxtst = 'RgA';
        else
            nxtst = LUZtemp;
        end
        tempshp_shpstruct = setfield(tempshp_shpstruct,{j},'LUZ_temp',nxtst);
    end
end

%Delete temporary file "fileForMat" to allow to be created again for the
%next iteration /call to the function
if exist(fileForMat, 'file') == 2
    disp('file exists....deleting temporary shape file');
    delete(fileForMat);
else
    disp('temporary file doesnot exists');
end

end