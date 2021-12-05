%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Created on : 13 Februrary 2020
% Revised on : 6 April 2020
% Revised on : 29 April 2020
% Purpose : Working on resistance vs comply for n number of rural actors.
% Code1 for paper 2 (C1_P2). Here we will change the number of rural actors
% to be hawk and dove. RurHawk = 1 - RurDove. And check what happens if the
% rural actors resist (conservation oriented) vs comply (inclinded to
% urbanization). LEVEL OF RESISTANCE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function[ToMove,nextS,focus_cell,n,lulc_update] =  InnerLoop_8neigh_Case1_P2_v2(shp,neigh,no_cell,kc,neigh_eight,lambda1,lambda2,D_SHMI,lulctype,Dove_level)

[m,n]=size(neigh);  % m is the total number of cells and n is the number of neighbours

no_lulctype = numel(lulctype);

uidx = find(strcmp (lulctype,'U'));

%EF_Function always uses eight neighbourhood window
SC_info = EF_function(neigh_eight,shp,no_cell,lulctype,no_lulctype);
kcnt = 0;

% Get the target cells - urban cells that need to move out to peri urban
% areas
for i = 1:no_cell %total number of cells
    
    if(strcmp(shp(i).LULC,'U')==1)
        if(shp(i).Pop_count>= (kc -1))
            kcnt= kcnt+1;
            focus_cell(kcnt)=i;  % cannot preallocate as number of urban cells are unknown in advance/
        end
    end
end


TotUrbCell = numel(focus_cell);
% fprintf('Number of urban cell %d ',TotUrbCell)

i =0 ;
j = 0;
checkneigh = zeros(TotUrbCell,1);

errorst = 'Undefined function or variable ''GTval''';

%*********************Game Theory module ********************************
%************************************************************************
for i = 1 : TotUrbCell  %For each urban cell
    DCterm = zeros(8,1);
    cnt = 0;
    poscell = zeros(8,1);
    for j = 1 : neigh
        winner = 0;
        %********** Game Theory Module ******************* %
        
        if(neigh_eight(focus_cell(i),j)>0) %If the target cell has a neighbour in the direction being visited
            if (strcmp(shp(neigh_eight(focus_cell(i),j)).LULC,'U')==0) % and if the neighbour is not urban then Game is played
                checkneigh(i) = checkneigh(i) + 1;
                %Check if hawk and dove strategy % V = 0.99, C = 0.30
                if ((shp(neigh_eight(focus_cell(i),j)).Strategy)== 1) % Rural Hawk
                    %possibility of winning 50-50
                    winner = randi([0,9],1);  % 0 implies Urban Hawk , 9 implies Rural Hawk
                    if(winner == 0) % Urban Hawk is the winner
                        GTval = (0.99 - 0.33)/2; % (V - C)/2  = Urbanpayoff
                    elseif(winner == 9) %Rural Hawk is the winner
                        GTval = 0; % UrbanHawk looses and retracts
                    end
                    
                elseif((shp(neigh_eight(focus_cell(i),j)).Strategy)==2) % Rural Dove
                    
                    GTval = 0.99; % V = Ruralpayoff
                end
            else %if the neighbour is urban
                GTval = 0.01;  % least priority to urban areas 
            end
            %************* Land Use Policy Module ************************** %
           try
            DCterm(j) = D_SHMI(neigh_eight(focus_cell(i),j))*(lambda1*(SC_info(neigh_eight(focus_cell(i),j),uidx))+(lambda2*(GTval)));
           catch ME
               if(strcmp (ME.identifier, errorst))
                   err_cell = i ; 
                   err_neigh = j ; 
                   err_neigh_idx = neigh_eight(focus_cell(i),j);
                   
               end 
           end 
            % SC_info(k,5) - value of urban lulc type because the urban
            %               cell wants to ahve urban proximity
            poscell(j) = neigh_eight(focus_cell(i),j);
        else
            GTval = -999;%at the boundaries when one of the neighbour doesn't exist
            DCterm(j) = GTval ;
            poscell(j) = neigh_eight(focus_cell(i),j);
        end
        
    end
    %Identify the cell with maximum score i.e. DCterm and that will be
    %converted into urban cell
    if (length(find(DCterm > 0))>0)
        [maxval,pos] = max(DCterm);  % [value, position]
        %  Get index of all the position where value is maxval
      
        idx = find(DCterm == maxval);
        % random selection of the cell with maximum value
      if(length(idx)>1)
          randidx = randi(length(idx),1);
          pos_cell = randidx ;
      else 
          pos_cell = pos;
      end 
        
        
        %     disp('Position to move into :');
        ToMove(i)=poscell(pos_cell);
    else
        ToMove(i) =  0 ;
    end
    % for the focus cell the cell to move into will be poscell;
    
end

[nS,lulc_update]= update_shape_structfieldP2(shp,focus_cell,ToMove,TotUrbCell);

nextS = nS;
end












