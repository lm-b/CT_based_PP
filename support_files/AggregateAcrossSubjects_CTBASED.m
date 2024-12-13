% Aggregate PP multimask outputs across subjects 
clear AggregatedPressure AggregatedSPressure

PPfolder=uigetdir();

files=dir([PPfolder '\**\ProcessedEmedData_alltrials_9.mat']);

countr = 1;
for k=1:length(files)
    load([files(k).folder '\' files(k).name])
    i1=strfind(files(k).folder, 'DFUS');
    i2=strfind(files(k).folder, 'Plant');
    subjname = files(k).folder(i1(2):i2(2)-2);
    foot = 'R';
    for m = 1:length(PressureData)
        AggregatedPressure.Peak(countr).name = subjname ;
        AggregatedPressure.PTI(countr).name = subjname ;
        AggregatedPressure.PTI_F(countr).name = subjname ;
        AggregatedPressure.FTI(countr).name = subjname ;
        AggregatedPressure.MPPG(countr).name = subjname;

        
        AggregatedPressure.Peak(countr).foot = foot ;
        AggregatedPressure.PTI(countr).foot = foot ;
        AggregatedPressure.PTI_F(countr).foot = foot ;
        AggregatedPressure.FTI(countr).foot = foot ;
        AggregatedPressure.MPPG(countr).foot = foot ;

        AggregatedPressure.Peak(countr).trialType = PressureData(m).TrialType;
        AggregatedPressure.PTI(countr).trialType = PressureData(m).TrialType ;
        AggregatedPressure.PTI_F(countr).trialType = PressureData(m).TrialType ;
        AggregatedPressure.FTI(countr).trialType = PressureData(m).TrialType;
        AggregatedPressure.MPPG(countr).trialType = PressureData(m).TrialType ;

        AggregatedPressure.Peak(countr).trialNumber = PressureData(m).Trial;
        AggregatedPressure.PTI(countr).trialNumber = PressureData(m).Trial ;
        AggregatedPressure.PTI_F(countr).trialNumber = PressureData(m).Trial ;
        AggregatedPressure.FTI(countr).trialNumber = PressureData(m).Trial;
        AggregatedPressure.MPPG(countr).trialNumber = PressureData(m).Trial ;
%         
%         if contains(PressureData(m).TrialType, 'dyn')
%             figure(5), imagesc(PressureData(m)
%             PGA_MPPGlocs = [PressureData(m).PGA_idx;PressureData(m).MPG_idx];
%             
%         end   

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

        for q=1:length(PressureData(m).Peak_regions)
            AggregatedPressure=setfield(AggregatedPressure,'Peak',{countr},erase(PressureData(m).RegionOrder{q}, ' '),PressureData(m).Peak_regions(q));
            AggregatedPressure=setfield(AggregatedPressure,'PTI',{countr},erase(PressureData(m).RegionOrder{q}, ' '),PressureData(m).PTI_regions(q));
            AggregatedPressure=setfield(AggregatedPressure,'PTI_F',{countr},erase(PressureData(m).RegionOrder{q}, ' '),PressureData(m).PTI_F_regions(q));
            AggregatedPressure=setfield(AggregatedPressure,'FTI',{countr},erase(PressureData(m).RegionOrder{q}, ' '),PressureData(m).FTI_regions(q));
            if contains(PressureData(m).TrialType, 'dyn')
            AggregatedPressure=setfield(AggregatedPressure,'MPPG',{countr},erase(PressureData(m).RegionOrder{q}, ' '),PressureData(m).MPPG_regions(q));
             AggregatedPressure=setfield(AggregatedPressure,'PGA',{countr},erase(PressureData(m).RegionOrder{q}, ' '),PressureData(m).PGA_regions(q));
            end
            
        end
        
        countr=countr+1;
    end

end

save([ PPfolder '\AggregatedAcrossSubjects_CTBASED3_withDFUS01.mat'] , 'AggregatedPressure')


