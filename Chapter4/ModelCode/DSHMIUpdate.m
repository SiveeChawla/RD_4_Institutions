%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Created on: 17 January 2019
% Purpose : Update Rules LUZ for the outer loop , random assignment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [shp]= DSHMIUpdate(shp,no_cell,itr)


for i = 1 : no_cell
    
   
        if (itr < 6) %if DSHMI values are generated for first iteration 
            LUZval = shp(i).LUZ;
        else
          LUZval = shp(i).LUZ_temp;
        end 
        
    switch  LUZval
        case char('PA')
%             disp('You are in PA');  %Just for validation
            r = rand(1);
            if ((r <0.99)&& (r<0.71))
                nxtst = 'PA';
            elseif ((r<0.70)&&(r>0.51))
                nxtst = 'RsA';
            elseif ((r<0.50)&&(r>0.10))
                nxtst = 'RgA';
            else
                nxtst = 'GA';
            end
        case char('RgA')
%             disp('You are in RgA');  %Just for validation
            r = rand(1);
            if ((r <0.99)&& (r<0.71))
                nxtst = 'RgA';
            elseif ((r<0.70)&&(r>0.51))
                nxtst = 'RsA';
            elseif ((r<0.50)&&(r>0.10))
                nxtst = 'PA';
            else
                nxtst = 'GA';
            end
            
        case char('RsA')
%             disp('You are in RsA'); % Just for validation
            r = rand(1);
            if ((r<0.99)&& (r<0.71))
                nxtst = 'GA';
            elseif ((r<0.70)&&(r>0.51))
                nxtst = 'RsA';
            elseif ((r<0.50)&&(r>0.10))
                nxtst = 'RgA';
            else
                nxtst = 'PA';
            end
        case char('GA')
%             disp('You are in GA'); % Just for validation
            nxtst = 'GA' ; % prob = 1, rare probability to be converted into any other LUZ
            
    end
    


%Reset LUZ 
% disp(nxtst);
shp =setfield(shp,{i},'LUZ_temp',nxtst); % UPDATE LULC VALUE

%OR


end

end


