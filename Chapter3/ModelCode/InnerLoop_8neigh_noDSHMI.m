%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Created on : 2 November 2018
% Modified on : 29 Novmeber 2018
% Purpose :Inner loop - capturing actor interaction using Game Theory
% influenced by rules and considering the spatial context explicitly
% Based on previous function named - Hawk_Dove_Game_2_VarD.m
% Assumption 1 : D_SHMI value evalueated based on four LUZ classes.
% 2. What should be target LULC ( A vs U ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function[checkneigh,temp_sel,move_cell,nextS,target_cell,tn,lulc_update,cntA,cntU] =  InnerLoop_8neigh_noDSHMI(shp,neigh,no_cell,kc,neigh_eight,lambda1,lambda2,D_SHMI,lulctype)

[m,n]=size(neigh);  % m is the total number of cells and n is the number of neighbours

% 5 Nov : those cells will interact where LULC is either 'U' or the
% carrying capacity ahs been reached. If total pop > K then the target
% lulc is U but if the movemebt is from urban area with tot pop < K, then
% target lulc is A.


%**************************************Estimate Spatial Contextual********
%****information for each cell in the Entire landscaspe*******************
% templulc = {shp.LULC}; % collect all the lulc type in a cell array
% lulctype = unique(templulc); %identify unique lulctypes - it returns in alphabetical order
no_lulctype = numel(lulctype);

%EF_Function always uses eight neighbourhood window
SC_info = EF_function(neigh_eight,shp,no_cell,lulctype,no_lulctype);

%To estimate total urban population for identifying agriculture
% %intensification
% temp_pc_u = zeros(pop_count,1);
% cnt_ucell =0;
% for i = 1: no_cell
%     if(strcmp(S(i).LULC,'U')==1)  % if it is an urban cell
%         temp_pc_u(i)=S(i).Popcount; %population of ith cell which is urban
%         cnt_ucell = cnt_ucell+1; % cnt_ucell will keep track of total number of urbancell
%     else
%         temp_pc_u(i)=0;
%     end
% end
% temp_totpop = sum(temp_pc_u); %total Population in urban area
%
% PopDen



%*********!!!!!!HARD CODED!!!!!!!!***************************************
tlulctype = {'A','U'};  %hard coded for now ...can be changed later
indxA = find(strcmp(lulctype,tlulctype(1)));  % Agriculture(A)hardcoded for now for target lulc type
indxU = find(strcmp(lulctype,tlulctype(2)));  % Urban (U) hardcoded for now, can be changed late

tempst = struct('focus_cell',{},'t_LULC',{}); % Intialize
% Check what is the array target_cell and if it is picking up the right
% values.
kcnt = 0;
% cntU= 0 ;
% cntA = 0;

for i = 1:no_cell %total number of cells
    %     if ((strcmp(shp(i).LULC,'U')==1)&&(shp(i).Pop_count >=kc))%kc is the carrying capacity of the cell
    %         kcnt = kcnt+1;
    %         tempst(kcnt).focus_cell= i;
    %         tempst(kcnt).t_LULC= 'U';
    %         cntU = cntU+1;
    %         else
    if((strcmp(shp(i).LULC,'U')==1)&&((shp(i).Pop_count>= (kc -2))))
        %         p(i).Pop_count)>=(kc-1))) %%&&((shp(i).Pop_count)<=kc))
        kcnt= kcnt+1;
        tempst(kcnt).focus_cell=i;
        tempst(kcnt).t_LULC= 'U';
        %         cntA= cntA+1;
        %     else
        %         tempst(i).focus_cell=0;
        %         tempst(i).t_LULC = '';
    end
end


target_cell = [tempst.focus_cell];

%****************************
% Hawk and Dove Payoff matrix
%****************************
%Get intermediate infrastructure values from the function
[V_u,C_u]= HD_Infst_Val(shp,neigh_eight,tempst,neigh); % returned values are array for each of four neighbours for all the target cell
%
tn = numel(target_cell);  %number of target cell

Strategy = {'H','D'};  %Hawk or Dove


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interaction for one iteration%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%intialize with zeros

interact_target = zeros(tn,neigh);%target cell payoff value w.r.t each neighbour in order of E,W,N,S
interact_neigh = zeros(tn,neigh); %neighbour payoff value w.r.t target
temp_sel = zeros(tn,neigh); % target cell, number of neighbours, score of each respective neighbour


%********HAWK AND DOVE GAME ******
%*********************************
i=0;
j=0;
checkneigh = zeros(1,tn);
cntU=0;
cntA = 0;

%******2Sep : Get D_SHMI value for all cells ***********
% D_SHMI = Generating_SHMI_Value(shp,no_cell); %can be moved to the main function , if it hampers performance
%*******************************************************
for i = 1 : tn
    
    % Strategy is fixed - urban actor is Hawk and rural actor is dove ,
    % therefore pay off matrix will have value V (for urban actor ) and 0
    % (for rural actor), while V will vary for each neighbour of the target
    
    % cell/focus cell.
    for j = 1 : neigh
        %         disp(tempst(i).focus_cell);
        %         disp('With target LULC of : ');
        %         disp(tempst(i).t_LULC);
        
        if(neigh_eight(tempst(i).focus_cell,j)>0)
            if (strcmp(shp(neigh_eight(tempst(i).focus_cell,j)).LULC,'U')==0) %If the target cell has a neighbour in the direction being visited
                
                checkneigh(i) = checkneigh(i) + 1;
                GT = V_u(i,j);% - interact_neigh(i,k);  % to identify who is winning
                
%                 disp('you are in urban!!');
                DCterm1 = (lambda1*(SC_info(tempst(1).focus_cell,indxU)))+(lambda2*(GT));
                cntU = cntU+1;
%                 Dc(j) = (D_SHMI(neigh_eight(tempst(i).focus_cell,j)))*DCterm1;
                Dc(j) = DCterm1; 
                
                if (Dc(j)>0)  %If land use policy allows
                    %              temp_sel(i,k,1) = k;
                    temp_sel(i,j) = Dc(j);
                else
                    temp_sel(i,j) = -1; % 27 Jan : If we add value zero then it confuses the value of zero to maximum value
                    
                end
            else  %if the neighbourhood cell is urban
                
                GT = 0.99;  %Game theory will not exist in case of urban cells, game is being played between urban and rural actors
                
                DCterm1 = (lambda1*(SC_info(tempst(1).focus_cell,indxU)))+(lambda2*(GT));
                cntU = cntU+1;
%                 Dc(j) = (D_SHMI(neigh_eight(tempst(i).focus_cell,j)))*DCterm1;
                Dc(j) = DCterm1; 
                
                if (Dc(j)>0)  %If land use policy allows
                    %              temp_sel(i,k,1) = k;
                    temp_sel(i,j) = Dc(j);
                else
                    temp_sel(i,j) = -1; % 27 Jan : If we add value zero then it confuses the value of zero to maximum value
                    
                end
            end
            
        else
            interact_neigh(i,j) = -999;  %at the boundaries when one of the neighbour doesn't exist
        end
    end
end
%*********8 Aug : Estimating the value of the Diffusion coefficient
%for each prospective neighbour
%         lambda1 = 0;

%     for k = 1: neigh
%         Dc = zeros(1,neigh);
%         %if(interact_neigh(i,k)>-1)&& (neigh_eight(tempst(i).focus_cell,k)>-1)  % check if there is a a suitable neighbour)
%         if ((neigh_eight(tempst(i).focus_cell,k)>-1)  % check if there is a a suitable neighbour)
%             GT = V_u(i,k);% - interact_neigh(i,k);  % to identify who is winning
%             % and the one who is winning will keep the cell out of urban or rural actor
%             % for different target lulctypes
%             %                 lambda1 = 1 ; lambda2 = 1;
%
%             switch tempst(i).t_LULC
%                 case tlulctype(1)
%                     disp('you are in agri!!');
%                     cntA = cntA +1 ;
%                     DCterm1 = (lambda1*(SC_info(tempst(1).focus_cell,indxA)))+(lambda2*(GT));
%
%
%                 case tlulctype(2)
% %                     disp('you are in urban!!');
%                     DCterm1 = (lambda1*(SC_info(tempst(1).focus_cell,indxU)))+(lambda2*(GT));
%                     cntU = cntU+1;
%             end
%
%             Dc(k) = (D_SHMI(neigh_eight(tempst(i).focus_cell,k)))*DCterm1;
%
%             if (Dc(k)>0)  %If land use policy allows
%                 %              temp_sel(i,k,1) = k;
%                 temp_sel(i,k) = Dc(k);
%             else
%                 temp_sel(i,k) = -1; % 27 Jan : If we add value zero then it confuses the value of zero to maximum value
%
%             end
%
%         end
%     end




%  disp(temp_sel);
% [m_tempsel,n_tempsel,p_tempsel] =size(temp_sel);

%************************************************************
%************* Identify the cell to move into ***************
%************************************************************
move_cell = zeros(tn,1); % vector of size equal to target cells
for i = 1:tn
    maxDc_temp = 0;    %temporary variable
    pros_movecell = zeros(neigh,1); %temporary vector of size equal to number of neighbours included in the analysis
    temp1 = temp_sel(i,:); %get the collective diffusion coeffcient value for all the neighbours for each target/center cell
%     maxDc_temp = max(temp1);  %get the max value

    [DC_val,neigh_val]=max(temp1);

    if (neigh_eight(tempst(i).focus_cell,neigh_val)>0) %if the neighbour exists with max score estimated above

%         disp('TESTING potential neighbour');
%         disp(neigh_eight(tempst(i).focus_cell,neigh_val));
%         disp('the neighbour has value ' );
%         disp(DC_val);
        move_cell(i) = neigh_val;
    else
%         disp('No potential neighbour exists');
        move_cell(i) = -1;
    end

%     for j = 1:neigh  %get the neighbour with max value
%         if (temp_sel(i,j)== maxDc_temp)&& (maxDc_temp>0)
%             %             pros_movecell(j) = j;
%             %         end
%             %     end
%             %        if numel(nonzeros(pros_movecell>0))
%             %         temp_move = randperm(numel(nonzeros(pros_movecell)));
%             %         move_cell(i) = temp_move(1);
%             move_cell(i) = j; % to know the actual cell that has to be moved
%             %we have to access the index of the ith cell from the structure tempst
%         else
%              indxtemp = randi(8,1);
%             if (temps_sel(1,indxtemp)>0)
%                 % %             inx_temp = randi(8,1)
%                 move_cell(i) = indxtemp;
%             else
%                 move_cell(i) = -1;
%             end
%         end
%
%     end
end

[nS,lulc_update]= update_shape_structfield(move_cell,shp,neigh_eight,tn,tempst);

nextS = nS;
% disp('No of updates in this ITERATION');
% disp(count_lulcupdate);
% counter = count_lulcupdate;


end