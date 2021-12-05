%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Created on: 6 August 2018
% Purpose   : Reaction Term for urban population
% This equation has been adapted from the paper of Chen 2009 - urban rural
% interaction. The reaction will occur per cell i.e. rate of urban
% population growth will be identified per cell and will be influenced by
% rural population that exists within the cell. 
% Will run for all cell at every time step (each iteration)
% 14 Aug : %changed function to 'round' from 'ciel' after discovering a bug with pop update
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [up_next,rp_next]= Reaction_PopGrowth (up,rp,a,b,c,d,phi_urban,phi_rural)

%phi_urban and phi_rural ; a,b,c,d ; are the parameters . 

%URBAN GROWTH
up_next_temp = ceil(up*c + rp*d + ( rp*up*phi_urban));  

%Total urban population
up_next = up_next_temp + up;


%RURAL GROWTH 
rp_next_temp = ceil(rp*a + up*b - (rp*up*phi_rural));

%Total rural population 
rp_next = rp_next_temp + rp;


end