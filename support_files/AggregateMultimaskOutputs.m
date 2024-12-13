% Aggregate Multimask Output within subject
% ONLY WORKS FOR SINGLE FOOT
clear 
% select static and dynamic files to include in analysis 
[file_n_s,pathloc_s] = uigetfile('*.txt', 'Select STATIC Plantar Pressure Files','\\foot\users\LyndaB\Scanner\PlantarPressure', 'MultiSelect', 'on' );

[file_n_d,pathloc_d] = uigetfile('*.txt', 'Select DYNAMIC Plantar Pressure Files','\\foot\users\LyndaB\Scanner\PlantarPressure', 'MultiSelect', 'on' );

% in the event user selects only one file, convert file name to cell array
% so that the code still works. 
switch class(file_n_s)
    case 'char'
        file_n_s={file_n_s};
end

switch class(file_n_d)
    case 'char'
        file_n_d={file_n_d};
end

%% Aggregate static files and calculate means of desired vars 
%%%% static  %%%%%
for k=1:length(file_n_s)
    [masklegend,LengthOfContact, TimePP_MaxF,PTI_FTI,FundVals]=GetMultiMaskOutput([pathloc_s file_n_s{k}], 10);
%     newCell=[LengthOfContact, TimePP_MaxF(:,2:end),PTI_FTI(:,2:end),FundVals(:,2)];
%     structNames={'Mask','Length_ms','Length_per','Begin_per','End_per','PP','IPP_ms','IPP_per','MF','IMF_ms','IMF_per','PTI','PTI_thresh','FTI','FTI_thresh','ContactArea'};
%     cell2struct(newCell(2:end,:),structNames,2);
    PP(:,k)=str2double(TimePP_MaxF(2:end,2));
    MF(:,k)=str2double(TimePP_MaxF(2:end,5));
    PTI(:,k)=str2double(PTI_FTI(2:end,2));
    FTI(:,k)=str2double(PTI_FTI(2:end,5));
    CA(:,k)=str2double(FundVals(2:end,2));
    PTI_F(:,k)=FTI(:,k)./CA(:,k);
end

finalStatic.Mask=masklegend(:,2);
finalStatic.PeakPresure= mean(PP,2);
finalStatic.MaxForce=mean(MF,2);
finalStatic.PTI=mean(PTI,2);
finalStatic.PTI_F=mean(PTI_F,2);
finalStatic.FTI=mean(FTI,2);
finalStatic.ContactArea=mean(CA,2);
finalStatic.PeakRaw= PP;

%% Aggregate dynamic files and calculate means of desired vars 
clear PP MF PTI FTI CA
%%%% dynamic  %%%%%
for k=1:length(file_n_d)
    [masklegend,LengthOfContact, TimePP_MaxF,PTI_FTI,FundVals]=GetMultiMaskOutput([pathloc_d file_n_d{k}], 10);
%     newCell=[LengthOfContact, TimePP_MaxF(:,2:end),PTI_FTI(:,2:end),FundVals(:,2)];
%     structNames={'Mask','Length_ms','Length_per','Begin_per','End_per','PP','IPP_ms','IPP_per','MF','IMF_ms','IMF_per','PTI','PTI_thresh','FTI','FTI_thresh','ContactArea'};
%     cell2struct(newCell(2:end,:),structNames,2);
    PP(:,k)=str2double(TimePP_MaxF(2:end,2));
    MF(:,k)=str2double(TimePP_MaxF(2:end,5));
    PTI(:,k)=str2double(PTI_FTI(2:end,2));
    FTI(:,k)=str2double(PTI_FTI(2:end,5));
    CA(:,k)=str2double(FundVals(2:end,2));
    PTI_F(:,k)=FTI(:,k)./CA(:,k);
end

finalDynamic.Mask=masklegend(:,2);
finalDynamic.PeakPresure= mean(PP,2);
finalDynamic.MaxForce=mean(MF,2);
finalDynamic.PTI=mean(PTI,2);
finalDynamic.PTI_F=mean(PTI_F,2);
finalDynamic.FTI=mean(FTI,2);
finalDynamic.ContactArea=mean(CA,2);
finalDynamic.PeakRaw= PP;

%% save dynamic and static means to file in subject folder

%save([pathloc_s 'AverageValues.mat'], 'finalStatic', 'finalDynamic');
