%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Created on: 21 January 2019
% Purpose : Estimate Green space and Grey space. The module counts number
% of green cells and grey cells. The green cells are natural green cells
% which include LULC type Forest(F), Grassland (G), Wetland (We). While
% Grey cells are impervious cells that comprises of LULC type Rural Build
% up (Rb), Urban Built (U) and Wasteland (Wa). Water Body (Wb) and
% Agriculture land are not counted here for the purpose.
%( as on 21 Jan 2019)
%Added LUZ estimation on 14 May 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[greencell_ct,greycell_ct,urbancell_ct,classarr,LUZarr]= EstimateEnvIndicator (shp,no_cell,itr_main)

% green_space_cl= {'F','G','We'};

green_space_cl= {'F','G','We','A'}; %Changed on 27 Jan
grey_space_cl = {'Rb','U','Wa'};

greencell_ct = 0;
greycell_ct = 0;
urbancell_ct = 0;

classwisearr = zeros(8,no_cell);
LUZarr = zeros(4,no_cell);



for h = 1 : no_cell
    
    if ~(~any(strcmp(green_space_cl,shp(h).LULC))) % if the LULC belongs to any of the
        %three classes specified in the cell array
        greencell_ct = greencell_ct +1;
    elseif ~(~any(strcmp(grey_space_cl,shp(h).LULC)))
        greycell_ct = greycell_ct  + 1 ;
    end
    
    if(strcmp(shp(h).LULC,'U')==1)
        
        urbancell_ct =  urbancell_ct + 1 ;
    end
    
    %Estimate number of cells per class
    switch shp(h).LULC
        case char('A')
            classwisearr(1,h) = classwisearr(1,h)+1;
        case char('Wa')
            classwisearr(2,h) = classwisearr(2,h)+1;
        case char('Wb')
            classwisearr(3,h) = classwisearr(3,h)+1;
        case char('G')
            classwisearr(4,h) = classwisearr(4,h) + 1 ;
        case char('Rb')
            classwisearr(5,h) = classwisearr(5,h) + 1 ;
        case char('We')
            classwisearr(6,h) = classwisearr(6,h) + 1 ;
        case char('U')
            classwisearr(7,h) = classwisearr(7,h) + 1 ;
        case char('F')
            classwisearr(8,h) = classwisearr(8,h) + 1;
        otherwise
            disp('there exist another unknown class');
    end
    classarr = sum(classwisearr');
    
    if (itr_main<5)
        LUZtempval = shp(h).LUZ; 
    else 
        LUZtempval = shp(h).LUZ_temp; 
    end 
        
    switch LUZtempval
        case char('PA')
            LUZarr(1,h)= LUZarr(1,h)+1;
        case char('RgA')
            LUZarr(2,h)= LUZarr(2,h)+1;
        case char('RsA')
            LUZarr(3,h)= LUZarr(3,h)+1;
        case char('GA')
            LUZarr(4,h)= LUZarr(4,h)+1;
        otherwise
            disp('there exists another LUZ');
    end
    LUZarr_sum = sum(LUZarr');
    
end






end

