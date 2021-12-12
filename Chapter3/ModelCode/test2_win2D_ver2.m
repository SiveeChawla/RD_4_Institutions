%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Created on: 5 April 2018
% Purpose : local 3x3 window for 2D array _ particularly for CA Module ,
% basically a testing module, will eventually integrate into 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [neigh_2D] = test2_win2D_ver2(lwin)
clear neigh_2D;
k=0;
[m,n] = size(lwin);

% neigh_2D = zeros(
mini_offset = m ; %assuming m =n => there is a square window 
for j = 1 : n  %col
    for i = 1 : m %row
        k = k  +1 ;
        temp_2DTo1D_Arr(j,i) = k ; 
        neigh_2D(k,:,:)=[i+1,j;i-1,j;i,j+1;i,j-1;i+1,j-1; i-1,j-1;i-1,j+1;i+1,j+1];
        
        % Checking for for non-existent neighbours 
       
    end
end 
clear k ; 
clear j ; 
for k = 1 : (m*n)
    
   
    for j = 1 : 8
        if (any(neigh_2D(k,j,:)<1)) 
            neigh_2D (k,j,:) = -1;
        end
        if (any(neigh_2D(k,j,:)>mini_offset)) 
            neigh_2D(k,j,:) = - 1;
        end
    end
end
        
end
 

% the order is E,W,S,N,NE,NW,SW,SE

