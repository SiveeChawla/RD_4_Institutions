%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Created on: 28 February 2019
% Purpose : Local window function . The program perform processes on local
% nonoveralpping windows within the landscape. Rowwise reading :
% The nested for loop keeps
% the column constant and reads the rows under the colunms.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [shpre]= UpdateLUZ_LocalWin_CA(comp_shp,itr)  % Work on input and output variable - depending on where it has to be called in the MAIN function




%**********************READ SHAPE FILE ***********************************
% S = shaperead('C:\Users\jc442626\OneDrive - James Cook University\Documents\PhD\PhD_Tasks_imp\RQ1\ProgrammingModules_Frm23Oct18\InputFiles\InpShpFile_V1.shp'); %S give strucutre and A are the attributes of the file
% f1 = figure;


% mapshow(S,'symbolspec',LULCSymbolSpec);
mapshow(comp_shp,'symbolspec',LUZSymbolSpec(0));  %LUZ map
% no_cell_superset = numel(comp_shp); % returns total number of cells in shape file
shp_2Dstruct = reshape(comp_shp,10,10); %Reshape struct from 1D to 2D.  hard coded for now.  % updated by 50

%*************************************************************************

%*************CONSTANTS*****************************
end_c = 10;  % local window size  - CONSTANT
nitr  = 5; % sqrt of number of windows

% end_c = input('Enter the size of the local window');
% nitr = input('Enter total number of windows');

% jend_c = sqrt(no_cell_superset); % landscape window size (complete window size) - constant
%******************************************************

istart = 1;
jstart = 1;
jend  = end_c;
iend = end_c;  % intialize
jstartarr = zeros(1,nitr);
jendarr = zeros(1,nitr);
istartarr = zeros(1,nitr);
iendarr = zeros(1,nitr);

cnttemp = 0;
for col = 1 : nitr
    
%     disp('Coloumn Number : ');
%     disp(col);
    istartarr(col) = istart;
    iendarr(col) = iend;
    
    
    %        *****************************
    %ACCESS SUB WINDOW FROM THE RESHAPED STRUCTURE ARRAY AND PERFORM THE
    %FUNCTIONS**********************************************
    
    %Update Column numbers for next round of itration
    istart = iend+1;
    iend = (col+1)*end_c;
    
    
    jstart = 1;
    jend  = end_c;
    for row = 1 : nitr  % Keeps the column constant and changes the row.As I am working row size
% %         disp('Row Number : ');
%         disp(row);
        
        jstartarr(row)=jstart;
        jendarr(row)=jend;
        
        cnttemp = cnttemp + 1;
        
        %Local window
        
        
        localwin = shp_2Dstruct(istartarr(col):iendarr(col), jstartarr(row):jendarr(row)); %subset of  reshaped struct , subsetted window
        %         localwin_LULC = {shp_2Dstruct(istartarr(col):iendarr(col), jstartarr(row):jendarr(row)).LULC};
        %         localwin_LUZ = [shp_2Dstruct(istartarr(col):iendarr(col), jstartarr(row):jendarr(row)).LUZ];
        %         %Count Forest
        %         F_cells = strcmp(localwin_LULC,'Rb');
        %         F_cnt(cnttemp) = sum(nonzeros(F_cells));
        %********************* CA MODULE FOR HTE LOCAL WINDOW ***********************
        %          For every  Window CA module will be called
        %%*********************Intialize%***************************************
        
        [neigh_2D] = test2_win2D_ver2(localwin);  % Get the neighbourhood window
        [lulctype,no_lulc,EFval_array] = EF_function_locwin(neigh_2D,localwin);
        [shp_LUZupdate] = CA_Local(localwin,lulctype,no_lulc,EFval_array,itr) ;
        
        %Updating original shape file -- assuming there is an update in
        %struct file
        
        
        shp_2Dstruct(istartarr(col):iendarr(col), jstartarr(row):jendarr(row)) = shp_LUZupdate;
        
        % %        Visulaize update
        %        hold on;
        %        pause(5);
        %        f(cnttemp) = figure;
        %        shpre = reshape(shp_2Dstruct,2500,1);
        %        mapshow(shpre,'symbolspec',LUZSymbolSpec(1));
        
        
        %**********************************************************************
        %Update Row numbers
        jstart = jend + 1;
        jend = (row+1)*end_c; 
    end
end
%Reshaping the (LUZ updated) 2D struct shape back into S

% % Visulaize update
% hold on;
% pause(5);
% f(itr+1) = figure;
shpre = reshape(shp_2Dstruct,2500,1);
% mapshow(shpre,'symbolspec',LUZSymbolSpec(spec));

end

