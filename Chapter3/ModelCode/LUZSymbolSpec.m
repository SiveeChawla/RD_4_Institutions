%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Created on: April 11 , 2019
% Purpose : Make symbol spec for visualing LUZ. 
% This function will be called everytime mapshow is called - it is
% particularly being made for visualization the results in LULC change due
% to urbanization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [SymbolSpec_LUZ] = LUZSymbolSpec(luztable)
% SymbolSpec_LULC = makesymbolspec('polygon',{'LULC','U','FaceColor',[0.5 0.5 0.5]},{'LULC','A','FaceColor',[1 1 0.2]},{'LULC','F','FaceColor',[1 0.5 0.3]},{'LULC','J','FaceColor',[0 0.7 0.2]});
if (luztable==1)
    SymbolSpec_LUZ = makesymbolspec('polygon',{'LUZ_temp','PA','FaceColor',[0.5 0.8 0.06]},{'LUZ_temp','RsA','FaceColor',[0.20 0.65 0.59]},{'LUZ_temp','RgA','FaceColor',[0.18 0.00 0.33]},{'LUZ_temp','GA','FaceColor',[0.85 0.20 0.20]});
else
    SymbolSpec_LUZ = makesymbolspec('polygon',{'LUZ','PA','FaceColor',[0.5 0.8 0.06]},{'LUZ','RsA','FaceColor',[0.20 0.65 0.59]},{'LUZ','RgA','FaceColor',[0.18 0.00 0.33]},{'LUZ','GA','FaceColor',[0.85 0.20 0.20]});    
end
end