%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Created on: 02 July 2018
% Revised on: 19 January 2020
% Purpose :update the shapefile - change value in the attribute (struct
% array) of the shape file - for one iteration but for the entire shapefile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [nxtS,count_lulcupdate]= update_shape_structfieldP2(Ss,f_cell,t_cell,tn)

%Ss - shape file
%f_cell- position of the cell under focus
%t_cell- position in the lattice which has been recognized as the cell to
%move into
%tn - total number of focus cell (f_cell)
count_lulcupdate = 0;%to keep check on number of cells updated

% updatecell=0;
for i = 1 : tn
    %if(strcmp(Ss(tempst(i)).LULC,'U')==1) %target cell should be an 'U'
        
        if (t_cell(i)>0) %if there is any potential cell to move into
            Ss = setfield(Ss,{t_cell(i)},'LULC', 'U');% UPDATE LULC VALUE
            % %                 % **Change the POPULATION OF CELL by incremementing it to 1
            % %                 prev_popcount = getfield(Ss,{neigh_arr(i,move_cell(j))},'Pop_count');
            % %                 new_popcount = prev_popcount+1;
            count_lulcupdate = count_lulcupdate+1;
            %             disp('UPDATE FIELD');
            
            %****************** UPDATE Rflag ***************
            %***********************************************
            
%             Ss = setfield(Ss,{t_cell(i)},'Rflag',2);

            
            %*******************************************************************************************
            %%******************UPDATE POPULATION BASED ON DIFFUSION************************************
            %*******************************************************************************************
            
            
            %                          disp('updating pop based on diffusion');
            TargetCellPop = Ss(f_cell(i)).Pop_count ;
            ToMoveCellPop = Ss(t_cell(i)).Pop_count;
            Diff_Pop = TargetCellPop - ToMoveCellPop;
            PopcountToMove = ceil(0.50*Diff_Pop);
            new_popcount = ToMoveCellPop + PopcountToMove;
            new_urbanpop = Ss(t_cell(i)).Urban_pop + PopcountToMove;
            %                         fprintf('population diffused to the cell : %d \n',neigh_arr(tempst(i).focus_cell,move_cell(i)));
            
            
            Ss = setfield(Ss,{t_cell(i)},'Pop_count',new_popcount);
            Ss = setfield(Ss,{t_cell(i)},'Urban_pop',new_urbanpop);
          
        end
        
    end

nxtS = Ss;
end