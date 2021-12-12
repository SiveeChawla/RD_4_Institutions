%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created by: Sivee Chawla
% Created on: Aug 1 , 2018
% Purpose : Make symbol spec for visualing land use land cover change
% This function will be called everytime mapshow is called - it is
% particularly being made for visualization the results in LULC change due
% to urbanization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [SymbolSpec_LULC] = LULCSymbolSpec()
% SymbolSpec_LULC = makesymbolspec('polygon',{'LULC','U','FaceColor',[0.5 0.5 0.5]},{'LULC','A','FaceColor',[1 1 0.2]},{'LULC','F','FaceColor',[1 0.5 0.3]},{'LULC','J','FaceColor',[0 0.7 0.2]});
SymbolSpec_LULC = makesymbolspec('polygon',{'LULC','I','FaceColor',[0.5 0.5 0.5]},{'LULC','A','FaceColor',[0.89 0.89 0.7]},{'LULC','F','FaceColor',[0.5 0.8 0.06]},{'LULC','Rb','FaceColor',[0.89 0.65 0]},{'LULC','Wa','FaceColor',[0.98 0.88 0.37]},{'LULC','Wb','FaceColor',[0 0.7 0.86]},{'LULC','We','FaceColor',[0.5 0.46 0.19]},{'LULC','G','FaceColor',[0.83 0.5 0.52]},{'LULC','U','FaceColor',[0.95 0.20 0.03]});

end