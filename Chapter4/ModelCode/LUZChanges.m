% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Created on: 19 August 2019
% Purpose : Analysing LUZ results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Experimenting with  LUZ data to identify change in LUZ 
pathname_reg = 'C:\Users\jc442626\OneDrive - James Cook University\Documents\PhD\PhD_Tasks_imp\RQ1\Paper1_code\OutputFiles\Case1\RegionalLevel\Output_';
pathname_loc = 'C:\Users\jc442626\OneDrive - James Cook University\Documents\PhD\PhD_Tasks_imp\RQ1\Paper1_code\OutputFiles\Case1\LocalLevel\Output_';
pathname_null = 'C:\Users\jc442626\OneDrive - James Cook University\Documents\PhD\PhD_Tasks_imp\RQ1\Paper1_code\OutputFiles\Case1\NullModel\Output_';

LUZtypes = {'PA','RgA','RsA','GA'};



tot_files = 100; %input('Enter total number of files ');

Tot_Area = 2500;
LUZClasses_Reg = zeros(4,200,tot_files);
LUZClasses_Loc = zeros(4,200,tot_files);
LUZClasses_Null = zeros(4,200,tot_files);
for i = 1: tot_files
    
    %        opfolder = strcat('Output_',num2str(i));
    filename_reg = strcat(pathname_reg,num2str(i),'\LUZ_Results.csv');
%     filename_loc = strcat(pathname_loc,num2str(i),'\LUZ_Results.csv');
%     filename_null= strcat(pathname_null,num2str(i),'\LUZ_Results.csv');
    LUZClasses_Reg(:,:,i) = csvread(filename_reg);
%     LUZClasses_Loc(:,:,i) = csvread(filename_loc);
%     LUZClasses_Null(:,:,i) = csvread(filename_null);
        
end

% How many times PA increased and decreased
dec_counter = zeros(100,4);
inc_counter = zeros(100,4); 
nochange = zeros(100,4); 

for j = 1: 100 % For every simulated image j
    for i = 1 : 4
        for k = 2 : 200  % counter for all the simulations for each image j
            temp = 0;
            temp = LUZClasses_Reg(i,k,j) - LUZClasses_Reg(i,k-1,j);
            if (temp>0)
                inc_counter(j,i) = inc_counter(j,i)+1;
            else
                if (temp<0)
                    dec_counter(j,i) = dec_counter(j,i) +1 ;
                else
                    nochange(j,i) = nochange(j,i) +1 ;
                end
            end
        end
    end
end

%EStimating for simualted data

mean_INC_reg = mean(inc_counter);
std_INC_reg = std(inc_counter);

mean_DEC_reg = mean(dec_counter);
std_DEC_reg  = std(dec_counter);

mean_NOChg_reg = mean(nochange);
std_NOChg_reg = std(nochange);

subplot(1,3,1);
boxplot(inc_counter);
subplot(1,3,2);
boxplot(dec_counter);
subplot(1,3,3);
boxplot(nochange);

% % subplot(1,3,1);
% errorbar(mean_INC_reg,std_INC_reg);
%Finding difference

for i = 1 : 4
    df_reg(i,:) = diff(x(i,:));
    
end