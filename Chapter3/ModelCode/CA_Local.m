%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Created on: 1 March 2019
% Purpose : CA Module of local windows - Local rules and governance 
% localwin comes from Indexing_LocalWindow and 'array : lulctype', 
% 'single value : no_lulctype' and  ' 2D array of EFval which is
% EFpercell_norm' , all will come from EF_function_locwin
% 'MappedArr' consist of mapped inded values from 2D to 1D 
%Fucntion will return a 2D struct array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [localwin] = CA_Local(localwin,lulctype,no_lulctype, EFval,itr_main)

% *****State probability and Transition probability matrix ***********
[m,n] = size(localwin);
%********Estimate ratio of Green vs Grey cells in the local window ******
green_space_cl= {'F','G','We'}; %Changed on 27 Jan
grey_space_cl = {'Rb','U','Wa'};
greencell_ct = 0;
greycell_ct =0;

ChoicefConv_LULC = {'Wb','A','Rb','We'}; % 
clear i ; 
clear j; 
for i = 1:m
    for j = 1:n
        if (any(strcmp(green_space_cl,localwin(i,j).LULC))) % if the LULC belongs to any of the
            %three classes specified in the cell array
            greencell_ct = greencell_ct +1;
        elseif (any(strcmp(grey_space_cl,localwin(i,j).LULC)))
            greycell_ct = greycell_ct  + 1 ;
        end
    end
    
end

%Mapping LULC to EF factor, lulctype will come from the EF function. 
% index of LULC type is implicit. For example, if lulctype =
% {'A'.'Rb','Wa'}; then A is 1, Rb is 2, Wa is 3. 

clear i ; 
ForRsa2Ga = {'Wa','U'};
urban_indx = 0;

% intializing the xx_indx

U_indx = 0;
Wa_indx =0 ;
% F_indx = 0;
% A_indx =0 ;

%identifying urban index - hardocded for lulc type - has to be changed to a
%more general code later.
for i = 1 : no_lulctype
    if(strcmp('U',lulctype(i))==1)
        U_indx = i ; 
    elseif(strcmp('Wa',lulctype(i))==1)
        Wa_indx = i; 
    
    elseif(strcmp('F',lulctype(i))==1)
        F_indx = i; 
    elseif(strcmp('A',lulctype(i))==1)
        A_indx = i; 
    elseif(strcmp('Wb',lulctype(i))==1)
        Wb_indx = i ; 
    elseif(strcmp('We',lulctype(i))==1)
        We_indx  = i; 
    elseif(strcmp('Rb',lulctype(i))==1)
        Rb_indx = i; 
    else 
        G_indx = i; 
    end    
          
end 



% ************************************************************************
% The transition of LUZ from one state to another will vary based on the
% intial LUP type. Next condition is CL_Ration. For example, in case of RsA
% ,if the Cl_Ratio has already reached a certain threshold then it will be
% assumed that it is near GA and hence, there is an increasing demand of
% the land. Also, the land is available.
% What if I assume that CL_Ratio gives the transition of green areasto
% grey areas. 
%*************************************************************************


Cl_Ratio = greencell_ct/greycell_ct; 
 
clear i; 
clear j ; 
k = 0;
% ************* transition of states **********************************
for i = 1 : m %col
    for j = 1 :n %row
       if (itr_main > 6) 
          LUZtemp  = localwin(i,j).LUZ_temp;
       else
           LUZtemp = localwin(i,j).LUZ;
       end 
       LULCtemp = localwin(i,j).LULC;
%         EFarrayIndx = MappedArr(i,j);
        k = k +1; 
        switch LUZtemp
            case 'PA'
%                 disp('You are in PA');  %Just for validation
                %***** State probability *******
                if (Cl_Ratio < 0.85)
                 nxtst = 'RgA';
                else
                    nxtst = 'PA';
                end
        
            case 'RgA'
%                 disp('You are in RgA');  %Just for validation
                [val,indx] =  max(EFval(k,:));
                if(Cl_Ratio <0.45) %as the zone is restricted it will be converted to RsA when it is too much under urban pressure.
                    if  (indx == U_indx) || (indx == Wa_indx) % if max of EF value belongs to Urban or Wa then convert it into GA irresepctive of LULC typ
                        %i.e. there is an urban pressure.
                        nxtst='RsA';
                    else %else put them in a restricted zone
                        nxtst ='PA';
                    end
                    
                else 
                    nxtst = 'RgA';
                end
                
                
            case 'RsA'
%                 disp('You are in RsA'); % Just for validation
                if(Cl_Ratio < 0.85) % this implies that there is a pressure from urban areas for the change with reduction in number of green spaces.
                    % and as RsA is already pressured, it is preferable to
                    % change it in GA. this is based on current CL_Ratio ,
                    % it mya be better to have a CL ratio value from
                    % previous datae set. For now, it is current value.
                    % Now, if CL_Ratio is below a certain threshold it
                    % implies that the pressure has increased
                    [val,indx] = max(EFval(k,:));
                    if  (indx == U_indx) || (indx == Wa_indx) % if max of EF value belongs to Urban or Wa then convert it into GA irresepctive of LULC typ
                        %i.e. there is an urban pressure.
                        nxtst='GA';
                    else %else put them in a restricted zone
                        nxtst ='RgA';
                    end
                    
                else
                    nxtst = 'RsA';
                end
                
                
            case 'GA'
%                 disp('You are in GA'); % Just for validation
                nxtst = 'GA';  %Transition probability iz zero
                
        end
%         disp(nxtst);
        localwin = setfield(localwin,{i,j},'LUZ_temp',nxtst); %LUZ_temp is set here for the FIRST time and updated for rest of the time
%         localwin = setfield(localwin,{5,5},'LUZ_temp','RgA');% UPDATE LUZ VALUE
    end
end
end 