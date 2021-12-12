%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Created on: 02 July 2018
% Revised on: 14 November 2018
% Purpose :update the shapefile - change value in the attribute (struct
% array) of the shape file - for one iteration but for the entire shapefile
% Comment : 2 July 2018 , at present the lulc type is converted into
% agriculture (static) but it will change in future when different
% infrastrcuture are included
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [nxtS,count_lulcupdate]= update_shape_structfield(move_cell,Ss,neigh_arr,tn,tempst)

count_lulcupdate = 0;%to keep check on number of cells updated

% updatecell=0;
for i = 1 : tn
    if(strcmp(Ss(tempst(i).focus_cell).LULC,'U')==1) %target cell should be an 'U'
        
        if (move_cell(i)>-1) %if there is any neighbour available to move
            
            %             if (neigh_arr(tempst(i).focus_cell,move_cell(i))>-1)&&(strcmp(Ss(neigh_arr(tempst(i).focus_cell,move_cell(i))).LULC,tempst(i).t_LULC)==0) % check if neighbour exist and LULC is not same as the focus cell
            %             if (strcmp(Ss(neigh_arr(tempst(i).focus_cell,move_cell(i))).LULC,tempst(i).t_LULC)==0) % check if neighbour exist and LULC is not same as the focus cell
            
            %                  disp(neigh_arr(i,move_cell(j)));
            
            %From neigh_array we can identify the cell in the actual shape file that has to be updated
            %                 Ss = setfield(Ss,{neigh_arr(i,move_cell(j))},'Actor',
            %                 'U');  %UPDATE ACTOR VALUE  -- 8 Aug : It requires a
            %                 whole new procedure of how much population has migrated
            %                 or diffused into the neighbouring cell
            %                 disp('Update LULC type');
            
            Ss = setfield(Ss,{neigh_arr(tempst(i).focus_cell,move_cell(i))},'LULC', tempst(i).t_LULC);% UPDATE LULC VALUE
            % %                 % **Change the POPULATION OF CELL by incremementing it to 1
            % %                 prev_popcount = getfield(Ss,{neigh_arr(i,move_cell(j))},'Pop_count');
            % %                 new_popcount = prev_popcount+1;
            count_lulcupdate = count_lulcupdate+1;
%             disp('UPDATE FIELD');
        
            %             %******************UPDATE POPULATION BASED ON DIFFUSION************************************
            
           
%                          disp('updating pop based on diffusion');
                        TargetCellPop = Ss(tempst(i).focus_cell).Pop_count ;
                        ToMoveCellPop = Ss(neigh_arr(tempst(i).focus_cell,move_cell(i))).Pop_count;
                        Diff_Pop = TargetCellPop - ToMoveCellPop;
                        PopcountToMove = ceil(0.50*Diff_Pop);
                        new_popcount = ToMoveCellPop + PopcountToMove;
                        new_urbanpop = Ss(neigh_arr(tempst(i).focus_cell,move_cell(i))).Urban_pop + PopcountToMove;
%                         fprintf('population diffused to the cell : %d \n',neigh_arr(tempst(i).focus_cell,move_cell(i)));
        
            
                        Ss = setfield(Ss,{neigh_arr(tempst(i).focus_cell,move_cell(i))},'Pop_count',new_popcount);
                        Ss = setfield(Ss,{neigh_arr(tempst(i).focus_cell,move_cell(i))},'Urban_pop',new_urbanpop);
            %
            %             if ((Ss(neigh_arr(tempst(i).focus_cell,move_cell(i))).Urban_pop) >(Ss(neigh_arr(tempst(i).focus_cell,move_cell(i))).Rural_pop))
            %                 %                         disp('resetting actor type to U');
            %                 Ss = setfield(Ss,{neigh_arr(tempst(i).focus_cell,move_cell(i))},'Actor','U');
            %
            %             end
            %             %                else
            %             %                   As = setfield(As,{neigh_arr(i,move_cell(j))},'Actor', 'R');
            %             %             end
            %
            %             %             else
            %             %                  As = setfield(As,{neigh_arr(i,move_cell(j))},'Actor', 'R');
        end
      
    end
end
nxtS = Ss;
end