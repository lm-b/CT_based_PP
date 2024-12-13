% Aggregate PP multimask outputs across subjects - NOVEL BASED
clear AggregatedDPressure AggregatedSPressure

PPfolder=uigetdir();

files=dir([PPfolder '\**\AverageValues*.mat']);


for k=1:length(files)
    load([files(k).folder '\' files(k).name])
    i1=strfind(files(k).folder, 'DFUS');
    i2=strfind(files(k).folder, 'Plant');
    i3=strfind(files(k).name, '.mat');
    subjname = files(k).folder(i1(2):i2(2)-2);
    foot = files(k).name(i3-1);
    AggregatedDPressure.Peak(k).name = subjname ;
    AggregatedDPressure.Max(k).name = subjname;
    AggregatedDPressure.PTI(k).name = subjname ;
    AggregatedDPressure.FTI(k).name = subjname ;
    AggregatedDPressure.CA(k).name = subjname;

    AggregatedSPressure.Peak(k).name = subjname ;
    AggregatedSPressure.Max(k).name = subjname;
    AggregatedSPressure.PTI(k).name = subjname ;
    AggregatedSPressure.FTI(k).name = subjname ;
    AggregatedSPressure.CA(k).name = subjname;


    AggregatedDPressure.Peak(k).foot = foot ;
    AggregatedDPressure.Max(k).foot = foot ;
    AggregatedDPressure.PTI(k).foot = foot ;
    AggregatedDPressure.FTI(k).foot = foot ;
    AggregatedDPressure.CA(k).foot = foot ;

    AggregatedSPressure.Peak(k).foot = foot ;
    AggregatedSPressure.Max(k).foot = foot ;
    AggregatedSPressure.PTI(k).foot = foot ;
    AggregatedSPressure.FTI(k).foot = foot ;
    AggregatedSPressure.CA(k).foot = foot ;


%     for q=1:legnth(finalDynamic.PeakPresure)
%         AggregatedDPressure.Peak(k).values = finalDynamic.PeakPresure(q);
%         AggregatedDPressure.Max(k).values = finalDynamic.MaxForce(q);
%         AggregatedDPressure.PTI(k).values = finalDynamic.PTI(q);
%         AggregatedDPressure.FTI(k).values = finalDynamic.FTI(q);
%         AggregatedDPressure.CA(k).values = finalDynamic.ContactArea(q);
% 
%         AggregatedSPressure.Peak(k).values = finalStatic.PeakPresure(q);
%         AggregatedSPressure.Max(k).values = finalStatic.MaxForce(q);
%         AggregatedSPressure.PTI(k).values = finalStatic.PTI(q);
%         AggregatedSPressure.FTI(k).values = finalStatic.FTI(q);
%         AggregatedSPressure.CA(k).values = finalStatic.ContactArea(q);
%     end

for q=1:length(finalDynamic.PeakPresure)
    AggregatedDPressure=setfield(AggregatedDPressure,'Peak',{k},erase(finalDynamic.Mask{q}, ' '),finalDynamic.PeakPresure(q));
    AggregatedDPressure=setfield(AggregatedDPressure,'Max',{k},erase(finalDynamic.Mask{q}, ' '),finalDynamic.MaxForce(q));
    AggregatedDPressure=setfield(AggregatedDPressure,'PTI',{k},erase(finalDynamic.Mask{q}, ' '),finalDynamic.PTI(q));
    AggregatedDPressure=setfield(AggregatedDPressure,'PTI_F',{k},erase(finalDynamic.Mask{q}, ' '),finalDynamic.PTI_F(q));
    AggregatedDPressure=setfield(AggregatedDPressure,'FTI',{k},erase(finalDynamic.Mask{q}, ' '),finalDynamic.FTI(q));
    AggregatedDPressure=setfield(AggregatedDPressure,'CA',{k},erase(finalDynamic.Mask{q}, ' '),finalDynamic.ContactArea(q));

    AggregatedSPressure=setfield(AggregatedSPressure,'Peak',{k},erase(finalStatic.Mask{q}, ' '),finalStatic.PeakPresure(q));
    AggregatedSPressure=setfield(AggregatedSPressure,'Max',{k},erase(finalStatic.Mask{q}, ' '),finalStatic.MaxForce(q));
    AggregatedSPressure=setfield(AggregatedSPressure,'PTI',{k},erase(finalStatic.Mask{q}, ' '),finalStatic.PTI(q));
    AggregatedSPressure=setfield(AggregatedSPressure,'PTI_F',{k},erase(finalStatic.Mask{q}, ' '),finalStatic.PTI_F(q));
    AggregatedSPressure=setfield(AggregatedSPressure,'FTI',{k},erase(finalStatic.Mask{q}, ' '),finalStatic.FTI(q));
    AggregatedSPressure=setfield(AggregatedSPressure,'CA',{k},erase(finalStatic.Mask{q}, ' '),finalStatic.ContactArea(q));
end


end

save([ PPfolder '\AggregatedAcrossSubjects_withDFUS01.mat'] , 'AggregatedSPressure', 'AggregatedDPressure')


