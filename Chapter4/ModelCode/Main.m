
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Created on: Rewritten on 8 June 2018
% Purpose :Main function
% Revised on : 1 May 2020
% Purpose :To adapt to research question 2 /Chapter 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Main

%%%%%%%% FOR MULTIPLE SIMULATIONS
%%%%%%%% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%%***************READ INPUT FOLDER PATH AND OUTPUT FOLDER PATH FOR HPC************************** %%

% inp_pathname = '/home/4/jc442626/RQ2/InputFiles/ForSim'; %change the file name as suited
% op_pathname = '/home/4/jc442626/RQ2/May_Results/Dove_70/'; %change the file name as suited
% 
% 
% for tf = 1 : 100 % for the input shape files,tf is the shape file 
% 
%  **************************************************************************
%     
%     close all;
%     
%     disp('***********************************');
%     fprintf('Running Shape file %d ',tf);
%     disp('***********************************');
%     
    
% %     %%**********************READ THE SHAPE FILE **************************** %%
% %     
%     Input_Shapefile = strcat(inp_pathname,'/','shpfile_',num2str(tf),'.shp'); 
%     S = shaperead(Input_Shapefile);
%     f1 = figure;
%     % symbspec = LULCSymbolSpec(S);
%     mapshow(S,'symbolspec',LULCSymbolSpec);
% %     
% %     %%**********************CREATE FOLDER FOR STORING THE OUTPUT************ %%
%     %
%     foldername = strcat('Output_',num2str(tf));
%     mkfolder = strcat(op_pathname,foldername);
%     mkdir(mkfolder);
%    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%      END OF HPC MODULE CODE 
%     %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    
    
    %%**************************************************************************
    
    %cHANGE PATH NAME AS REQUIRED
    S = shaperead('C:\Users\jc442626\OneDrive - James Cook University\Documents\PhD\PhD_Tasks_imp\RQ2\InputFiles\shpfile_7.shp');
    f1 = figure('Name','Input Shape file');
    % symbspec = LULCSymbolSpec(S);
    mapshow(S,'symbolspec',LULCSymbolSpec);
    
    %*****************CREATE OUTPUT FOLDER ***************************
    foldername = input('Enter folder name for storing results (date_Vx)','s');
    % foldername = 't1';
    pathname = 'C:\Users\jc442626\OneDrive - James Cook University\Documents\PhD\PhD_Tasks_imp\RQ2\OutputFiles\TestingCode\';
    mkfolder = strcat(pathname,foldername);
    mkdir(mkfolder);
    
    no_cell_superset = numel(S); % returns total number of cells in shape file
    
    %no_neigh = input('Enter maximum number of neighbours:');
    no_neigh = 8;
    
    %identify_offset = input ('Do you want to include the entire shape file or the subset ? (1 (entire shapefil) /2 (subset)) :');
    identify_offset = 1;
    
    %Calculate offset value and number of cells based on data set selected
    %above
    
    if (identify_offset == 1)
        m_offset = sqrt(no_cell_superset); % Assuming that it is a square matrix
        no_cell = no_cell_superset;
        newS = S;
        disp('USING COMPLETE DATA SET');
        
    else
        if (identify_offset == 2)
            m_offset = sqrt(no_cell_subset);  % Assuming that it is a square matrix
            no_cell = no_cell_subset;
            newS = Ss;
        else
            disp('you have entered wrong value');
        end
    end
    
    % array stores the FOUR NEIGHBOURS for each target cell. Target cell is
    % identified by row number and columns have the neighbours
    
    neigh_array_four= zeros(no_cell,4);
    % factor_temp = 0;
    for z = 1 : no_cell
        neigh_array_four(z,:) = [z+1,z-1,z+m_offset, z-m_offset];  % in the order of E,W,N,S
        if(z>(m_offset-1))
            %   factor_temp = factor_temp + 1 ;
            if(mod(z,m_offset)==0) %When the cell is on end of the
                %the right edge Ignore right/neighbour on the EAST which is the first elelement of neigh_array
                neigh_array_four(z,1) = -1;
            end
            if (mod(z-1,m_offset)==0)%Ignore left/neighbour on the WEST which is the first elelement of neigh_array
                neigh_array_four(z,2) = -1;
            end
            
            if ((z+m_offset)>no_cell)
                neigh_array_four(z,3)= -1;
            end
        end
    end
    
    neigh_array_eight = zeros(no_cell,8);
    
    for z = 1 :no_cell
        neigh_array_eight(z,:)=[z+1,z-1,z+m_offset, z-m_offset, z-m_offset+1,z-m_offset-1,z+m_offset-1,z+m_offset+1 ];
        if(z>(m_offset-1))
            %   factor_temp = factor_temp + 1 ;
            if(mod(z,m_offset)==0) %When the cell is on end of the
                %the right edge Ignore right/neighbour on the EAST which is the first elelement of neigh_array
                neigh_array_eight(z,1) = -1;
                % also ignore the NE  element
                neigh_array_eight(z,5) = -1;
                % also ignore the SE element
                neigh_array_eight(z,8) = -1;
            end
            if (mod(z-1,m_offset)==0)%Ignore left/neighbour on the WEST which is the first elelement of neigh_array
                neigh_array_eight(z,2) = -1;
                %also ignore NW element
                neigh_array_eight(z,6) = - 1;
                %also ignore SW element
                neigh_array_eight(z,7) = -1;
            end
            if ((z+m_offset)>no_cell)%Ignore the upper/north if it is more than no_cell
                neigh_array_eight(z,3)= -1;
            end
            if ((z+m_offset-1)>no_cell) %NW
                neigh_array_eight(z,7)= -1;
            end
            if ((z+m_offset+1)>no_cell) %NW
                neigh_array_eight(z,8)= -1;
            end
        end
    end
    
    if (no_neigh == 4)
        neigh_arr=neigh_array_four;
    elseif(no_neigh==8)
        neigh_arr = neigh_array_eight;
    else disp('You have not selected right number of neighbours');
        exit
    end
    %************** LULC types from the input shapefile*********************
    
    lulc_temp = {S(:).LULC}; %get the values in cell array
    LULCtype = unique(lulc_temp); %extract unique values of each class type
    no_lulctype=numel(LULCtype); %total number of classes
    
    
    %*********************************************************
    %*************REACTION TERM PARAMETERS********************
    %*********************************************************
    %RURAL GROWTH equation parameters  % taking value from paper of Chen 2009
    %Appendix
    a = 0.02 ;
    b = 0.01;
    % phi_rural = 0.03615;
    phi_rural = 0.2044;
    
    %URBAN GROWTH equation parameters
    c = 0.09;
    d = 0.05;
    phi_urban = 0.8144;
    
    %CARRYING CAPACITY
    kc = 18; %5 June 2019
    
    % %************************************************************
    % %************DIFFUSION TERM PARAMETERS***********************
    % %************************************************************
    lambda1 = 0.5;  %weight for contextual information
    lambda2 = 1-lambda1; % weight for pay off matrix
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %LULC similarlity matrix
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %A,F,J,U vs A,F,J,U
    %actual values have to be calculated - some random values are being used
    %for now  - date 7 Aug 2018
    % SI_Mtx = [1,0.75,0.35,0.25;0.75,1,0.75,0.1;0.35,0.75,1,0.65;0.5,0.75,0.5,1];
    
    %   = {'A','F','J','U'};  %LULC type
    %
    % %Enter upper and lower limit for the cost of fighting rural opponent
    % disp('Enter upper and lower limit for cost of fighting the rural opponent');
    % cost_up=input('UPPER LIMIT');
    % cost_ll=input('LOWER LIMIT');
    
    %Enter type of D_SHMI to be assigned.
    %rand_option = input('How do you want D_SHMI values to generated (LUZ based == 1  or random == 0) ?');
    rand_option = 1;
    if (rand_option>1)
        disp('you have entered wrong value, enter again');
        rand_option = input('How do you want D_SHMI values to generated (LUZ based == 1  or random == 0) ?');
    end
    
    %Enter the window size for local DSHMI
    DSHMIWindow = floor(m_offset/5); % Remainder identifies number of windows for
    % DSHMIWindow = input('Enter the window size');
    
    % Update rules local or regional
    % updaterules = input('Do you want to run local updates or per cell random update. Enter 1 for local update and 0 for cell level update , 2 for regional update');
    updaterules = 2;
    
    newS = S;
    
    %~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% CASE 2 - Distance Meausre  CASE 1 - Random Hawk and Dove
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    RurTh = 0; %Distance measure threshold for rural actors
    UrbTh = 0;
    % case_p2 = input('Enter 1 for Random Hawk  & Dove , Enter 2 for Distance Measure');
    case_p2 = 1;
    
    
    if(case_p2 == 1)
        count_Rur =0;
        idxR = 0;
        no_cell = numel(S);
        [newS.Strategy] = deal(0); % all cells are intialised value zero
        No_Dove = input('Enter percentage of doves between 0 and 1 , in single decimal');
        %No_Dove = 0.7 ;
        % Count the number of Rural cells
        for i = 1 : no_cell
            if ((strcmp((newS(i).LULC),'U')==0))
                count_Rur = count_Rur+1;
                idxR = idxR + 1;
                idx_Rur(idxR) = i;
            end
        end
        %Number of hawks and doves
        Dove_num = ceil(No_Dove*(count_Rur));
        %     Hawk_num = count_Rur - Dove_num;
        
        dovestr_cell = randsample(idx_Rur,Dove_num); %randomly select rural cells for dove strategy
        hawkstr_cell = setdiff(idx_Rur,dovestr_cell); %select remeining cells for hawk strategy
        
        
        
        [newS(dovestr_cell).Strategy] = deal(2); % assign dove strategy to dove_num cells
        [newS(hawkstr_cell).Strategy] = deal(1); %assign hawk strategy to remaining cells
        
    elseif(case_p2==2)
        RurTh = 0.5; %Distance measure threshold for rural actors
        UrbTh = 1;
    end
    %%
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %REACTION DIFFUSION TERM BEGINS FROM HERE
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    itr = input('Enter number of iterations');
    
    %To check update in rural population
    tempcheck_ruralpop = zeros(itr,no_cell);
    
    % Sumtotal_UrbanPop = zeros(1,itr);  %Total urban population per iteration
    
    % LULCsum_A= zeros(1,itr);
    
    count = zeros(itr,no_cell);
    
    
    % cntnofinteraction = zeros(itr,no_cell,4);
    % figcnt = 0;
    cnt_outerloop = 0; %counter number of times outerloop is running
    All_DSHMI=zeros(itr,no_cell);
    testvar = 0;
    for z = 1 : itr  % For several iterations - where each iteration is a time step
        fprintf('iteration No %d ',z);
        
        
        % counter_update = zeros(1,itr);
        %*************************************************************************
        % REPRODUCTION FUNCTION  - urban rural interaction model that will run
        % percell for every iteration
        %*************************************************************************
        
        
        %**********OUTPUT SUMTOTAL OF URBANPOPULATION AT EVERY ITERATION
        %****************************************************************
        %     Sumtotal_UrbanPop(i)= sum([newS(:).Urban_pop]);
        %
        for y =  1 :  no_cell
            
            %This CALCULATES TOTAL CELLS WITH LULC TYPE 'A' AT EACH ITERATION
            
            %         if(strcmp(newS(j).LULC,'A') ~= 0);
            %             LULCsum_A(i) = LULCsum_A(i) + 1;
            %         end
            % TO CALCULATE DIFFERENCE IN NUMBER OF CELLS WITH LULC TYPE 'A'
            %         tot_pop=0;
            if (newS(y).K_Check == 0) %reaction term should only proceed if the population hasn't reached the carrying capacity yet
                
                %temporary variables should be refreshed for every iteration
                %and cell
                tot_pop_temp = 0;
                clear up_next;
                clear rp_next;
                Tot_pop = newS(y).Pop_count;  %Total Population
                Urban_p = newS(y).Urban_pop; %Urban population in each cell
                Rural_p = newS(y).Rural_pop; %Rural population in each cell
                [up_next,rp_next]= Reaction_PopGrowth(Urban_p,Rural_p,a,b,c,d,phi_urban,phi_rural);
                tempcheck_ruralpop(z,y) = rp_next;
                tot_pop_temp = up_next + rp_next;  %new population size
                if((up_next > - 1)&&(rp_next>-1))
                    %                 disp('CHECKING REACTION FUNCTION');
                    newS = setfield(newS,{y},'Urban_pop', up_next); %update urban pop per cell
                    newS = setfield(newS,{y},'Rural_pop', rp_next); %update rural pop per cell
                    %                 count(i,j) = 1;
                    newS = setfield(newS,{y},'Pop_count', tot_pop_temp); % update total pop per cell
                end
            end
            %check the maximum capacity flag
            count(z,y) = newS(y).Urban_pop;
            if (newS(y).Pop_count >= kc)
                %             disp('updating K_Check :');
                %             disp(j);
                %             count(i,j);
                newS = setfield(newS,{y},'K_Check',1);
            end
            
            % Date : 6 August 2018 - if the cell reaches its carrying capacity
        end
        
        
        
        %**************************************************************************
        % DIFFUSION TERM : it includes two componets (1) diffusion terms
        % (2)population size for diffusion
        % Component (1) is further divided into three more components
        % 1.1 SHMI (Di)
        % 1.2 Spatial contextual information or Neighbourhood information
        % 1.3 Game theory - Infrastructure (HHMI, NI , SI and HI)
        % Diffusion will occur when carrying capacity flag, K_Check = 1, which
        % implies, diffusion will occur when carrying capacity reaches the carrying
        % capacity of the cell.
        %**************************************************************************
        
        %
        
        %***************************************************************
        %****************HAWK AND DOVE INTERACTION**********************
        %***************************************************************
        
        % [temp_sel,move_to_cell,nextS] = Neigh_Interaction (neigh_array,newS,no_neigh,no_cell);  % Call to play games among cell
        % [temp_sel,move_to_cell,nextS,temprule,target_cell,counter] = Hawk_Dove_Game_2 (neigh_array,newS,no_neigh,no_cell,kc,SI_Mtx,neigh_array_eight,lambda1,lambda2, LULCtype,,cost_up,cost_ll);  % Call to play games among cell
        clear temp_sel
        clear move_to_cell
        clear nextS
        clear temprule
        clear target_cell
        clear temprule
        
        [D_SHMI] = Generating_RandomSHMI_Value(newS,no_cell,rand_option,z);
        
        %     All_DSHMI(z,:)=D_SHMI;
        %      D_SHMI = 1;
        All_DSHMI(z,:)=1;
        
        % [temp_sel,move_to_cell,nextS,temprule,target_cell] = Hawk_Dove_Game_2 (neigh_array,newS,no_neigh,no_cell,kc,SI_Mtx,neigh_array_eight,lambda1,lambda2,LULCtype,,cost_up,cost_ll);  % Call to play games among cell
        
        %PopS is shape file returned after LULC update
        if (no_neigh == 4)
            [checkneigh,temp_sel,move_to_cell,nextS,target_cell,tn,lulc_update,cntA,cntU] = InnerLoop_4neigh(neigh_arr,newS,no_neigh,no_cell,kc,neigh_array_eight,lambda1,lambda2,D_SHMI,LULCtype);  % Call to play games among cell
            
        elseif (no_neigh==8)
            %     [checkneigh,temp_sel,move_to_cell,nextS,target_cell,tn,lulc_update,cntA,cntU] = InnerLoop_8neigh(newS,no_neigh,no_cell,kc,neigh_array_eight,lambda1,lambda2,D_SHMI,LULCtype);  % Call to play games among cell
            %     [checkneigh,temp_sel,move_cell,nextS,target_cell,tn,lulc_update,cntA,cntU
            
            %         [checkneigh,temp_sel,move_to_cell,nextS,target_cell,tn,lulc_update,cntA,cntU] = InnerLoop_8neigh_noDSHMI(newS,no_neigh,no_cell,kc,neigh_array_eight,lambda1,lambda2,D_SHMI,LULCtype);  % Call to play games among cell
            
            [~,nextS,~,~,~] = InnerLoop_8neigh_Case1_P2_v2(newS,no_neigh,no_cell,kc,neigh_array_eight,lambda1,lambda2,D_SHMI,LULCtype,No_Dove);  % Call to play games among cell
            
            
        end
        
        
        
        %******************************************************************
        %******************DIFFUSION OF POPULATION TO URBAN****************
        %CELLS*************************************************************
        
        %12 May 2019 : No need of this module because the population is being
        %updated within another module
        %       if (no_neigh == 4)
        %         [nextS]=PopulationDiffusion(PopS,no_cell,neigh_array_four,no_neigh);%change to PopS when calling #InnerLoop
        %       elseif (no_neigh == 8)
        %           [nextS]=PopulationDiffusion(PopS,no_cell,neigh_array_eight,no_neigh);
        %       else
        %           disp('wrong number ...he he he ');
        %       end
        
        
        
        %******************************************************************
        %******************CHECKING FOR THE OUTER LOOP ********************
        %**At every 10th iteration, the code for outer loop i.e. LUZ update
        %will run *******************************************************
        %****************************************************************
        
        % Temp file
        tempshp = strcat(mkfolder,'/','outputshp_temp');
        
        shapewrite(newS,tempshp);
        
        if ((z>4) && (rem(z,5)==0))  %Update LUZ at every 5th iteration, check for 10th iteration
            
            disp('**************Running the outer loop at ITR***************');
            disp (z);
            cnt_outerloop = cnt_outerloop+1;
            if (updaterules == 1)
                [newS]= UpdateLUZ_LocalWin_CA(nextS,z);
                
            elseif (updaterules == 2)
                [newS] = Regional_CA_2(nextS,mkfolder,z,no_cell);
            else
                disp('running null model');
                [newS] = DSHMIUpdate(nextS,no_cell,z);
            end
            
        else
            
            newS = nextS;
        end
        
        
        
        
        %*************************************************************
        %*********************OUTPUT : ESTIMATE INDICATORS ***********
        %*************************************************************
        
        %***********saving as csv ************************************
        [greencell_count,greycell_count,urbancell_count,classwisearr]= EstimateEnvIndicator(newS,no_cell,z);
        
        greencount(z)=greencell_count;
        
        greycount(z)=greycell_count;
        
        urbancount(z)= urbancell_count;
        
        greyvsgreenratio(z)=greencell_count/greycell_count;
        
        ClassWise_Results(z,:) = classwisearr; %(to estimate the rate)
        
%             LUZ_Results(z,:)= LUZ_arr;
        %
        %     filename = strcat(mkfolder,'\LUZ_Results.csv');
        
        %     %Writing output in Excel files : use this when running on
        %     file_parameter_analysis = strcat(mkfolder,'\','ParameterAnalysis.xlsx');
        %     Xls_file_2 = strcat(mkfolder,'\','Xlsfile2.xlsx');
        %     xlswrite(file_parameter_analysis,greencount',1);
        %     xlswrite(file_parameter_analysis,greycount',2);
        %     xlswrite(file_parameter_analysis,urbancount',3);
        %     xlswrite(file_parameter_analysis,All_DSHMI',4);% Univariate analysis of random values (0,1) of D using
        %     xlswrite(file_parameter_analysis,ClassWise_Results',5);
        %     xlswrite(file_parameter_analysis,LUZ_Results',6);
        %
        
        
        
        
        
        testvar = testvar + 1;
        % Display limited output
        
        
        %     if((i>9) && (rem(i,10)==0))
        %         hold on;
        %         pause(5);
        %
        %             f(i+1) = figure;
        %             mapshow(newS,'symbolspec',LULCSymbolSpec);
        %
        %     elseif (i<9)
        %         hold on;
        %         pause(5);
        %         f(i+1) = figure;
        %         mapshow(newS,'symbolspec',LULCSymbolSpec);
        %         if ((i>4) && (rem(i,5)==0))
        %             f(i+2) = figure;
        %             mapshow(newS,'symbolspec',LULCSymbolSpec);
        %         else
        %              f(i+1) = figure;
        %             mapshow(newS,'symbolspec',LULCSymbolSpec);
        %         end
        %     end
        %      %save shape file after every iteration
        % if ((z == 5)|| (z==15)||(rem(z,25)==0))
        if(z>4)
            if (rem(z,4)==0)
                %LULC map
                f(z+1) = figure('Name','LULC Map', 'NumberTitle','off');
                mapshow(newS,'symbolspec',LULCSymbolSpec);
                strcat_figlulc = strcat(mkfolder,'/','LULC_',num2str(z));
                saveas(f(z+1),strcat_figlulc,'jpeg');
                %LUZ map
                f(z+2) = figure('Name','LUZ Map', 'NumberTitle','off');
                mapshow(newS,'symbolspec',LUZSymbolSpec(1));
                strcat_figluz = strcat(mkfolder,'/','LUZ_',num2str(z));
                saveas(f(z+2),strcat_figluz,'jpeg');
                
                shpfile = strcat(mkfolder,'/','outputshp_',num2str(z));
                shapewrite(newS,shpfile);
            end
        end
    end
    
    
    
    
    %%******* Writing output in CSV files : use this when running on HPC******
    %%************************************************************************
    
    filename1 = strcat(mkfolder,'/GreencellCount.csv');
    csvwrite(filename1,greencount');
    
    filename2 = strcat(mkfolder,'/GreyCount.csv');
    csvwrite(filename2,greycount');
    
    filename3 = strcat(mkfolder,'/UrbanCellCount.csv');
    csvwrite(filename3,urbancount');
    
    filename4 = strcat(mkfolder,'/ClassWiseResults.csv');
    csvwrite(filename4, ClassWise_Results');
    
    filename5 = strcat(mkfolder,'/All_DSHMI.csv');
    csvwrite(filename5,All_DSHMI');
    %
    % filename6 = strcat(mkfolder,'\LUZ_Results.csv');
    % csvwrite(filename6,LUZ_Results');
    
    f(itr+4)= figure;
    plot (urbancount);
    xlabel('Iterations');
    ylabel('urban cells');
    plot_1 = strcat(mkfolder,'/','UrbanCell');
    saveas(f(itr+4),plot_1,'fig');
    saveas(f(itr+4),plot_1,'jpeg');
    %
    f(itr+5) = figure;
    plot (greencount);
    xlabel('Iterations');
    ylabel('No. of green cells');
    plot_2 = strcat(mkfolder,'/','Greencell');
    saveas(f(itr+5),plot_2,'fig');
    saveas(f(itr+5),plot_2,'jpeg');
    %
    % Ratio of Green count vs grey count
    f(itr+6) = figure;
    
    plot (greyvsgreenratio);
    xlabel('Iterations');
    ylabel('Ratio of green cells vs grey cells');
    plot_3 = strcat(mkfolder,'/','GreenvsGreyRatio');
    saveas(f(itr+6),plot_3,'fig');
    saveas(f(itr+6),plot_3,'jpeg');
    
    % Class wise figure
    CW_Results_tp = ClassWise_Results'; %clearly, a transpose
    ratexy = diff(CW_Results_tp,[],2);
    %     xlswrite(file_parameter_analysis,ratexy,7);
    f(itr+7) = figure;
    for k = 1 : 8
        hold on
        plot(ratexy(k,:));
        hold off
        xlabel('Iterations');
        ylabel('ClassWise Results');
        title ('Rate of change in total area occupied by each class');
    end
    
    plot_4 = strcat(mkfolder,'/','ClasswiseResutls_Rate');
    saveas(f(itr+7),plot_4,'fig');
    saveas(f(itr+7),plot_4,'jpeg');
    
    %     fig3 = figure;
    
    
    %     plot(CW_Results_tp
    clear k;
    f(itr+8) = figure;
    %  CW_temp = CW_Results_tp(1:5:end);
    for k = 1 : 8
        hold on ;
        %         CW_temp = CW_Results_tp(k,1:5:end);
        plot(CW_Results_tp(k,:));
        %         plot(1:5,CW_temp);
        %         scatter(1:5:25,CW_temp);
        hold off;
        xlabel('Years');
        ylabel('ClassWise Results');
        title ('Total area occupied by each class at every iteration');
        legend('Agri','Waste Land','Water Body','Grassland','Rural Builtup','Wet Land','Urban','Forest');
    end
    
    plot_5 = strcat(mkfolder,'/','ClasswiseResults');
    saveas(f(itr+8),plot_5,'fig');
    saveas(f(itr+8),plot_5,'jpeg');
    
    
% % %     LUZ results
% %         f(itr+9) = figure;
% %         LUZ_tp = LUZ_Results';
% %         for d = 1 : 4
% %             hold on ;
% %             LUZ_sctplt =LUZ_tp(d,1:5:end);
% %             scatter(1:5:25,LUZ_sctplt);
% %            plot(LUZ_tp(d,:));
% %             hold off;
% %             xlabel('Years');
% %             ylabel('LUZ Results');
% %             title ('Total cells corresponding to each LUZ at every iteration');
% %             legend('Preserved Area','Registered Area','Reserved Area','Guided Area');
% %     
% %         end
% %     
% %     plot_6 = strcat(mkfolder,'\','LUZ_Results');
%     saveas(f(itr+9),plot_6,'fig');
%     saveas(f(itr+9),plot_6,'jpeg');
    
    
    %     saveas();
    
    
    disp('**************END OF PROGRAM ***********************');
    close all;
%end
end
