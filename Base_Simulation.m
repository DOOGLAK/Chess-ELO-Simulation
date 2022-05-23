function [Error, Empty_Brackets, Orphans] = Base_Simulation(n,m,p,GM_Elo,Group,Anchor,Disparity,Type)
    %tic
    rng(10)
    
    %POTENTIALLY ADD - IF LAST ENTRY IN POOL FOR BIN (I.E. WHAT SHOULD BE
    %ANCHOR) THEN DO NOT UPDATE THEIR SKILL! Can just do if else statement
    
    %To make anchor allowed when group is N, need to update "p=player" to
    %be 16 higher
    
    %Initialize Error Matrix
    %Error = zeros(n,m);
    Error = zeros(n,m+1); %m+1 so that the first index is match "0" or initial error
    Empty_Brackets = zeros(n,m);
    Orphans = zeros(n,m);

    for s=1:n %START OF SIMULATIONS (N)
        
        [GM, Ratings] = Initial_Ratings(p,Type,GM_Elo,Disparity);        
        
        %For error before any matches occur or "m=0"
        Error(s,1) = mean(abs(Ratings(1,:) - Ratings(2,:))./Ratings(2,:)); %As Percent
        
        %Add Anchors
        if Anchor == "Y"
            Anchors = [150 300 500 700 900 1100 1300 1500 1700 1900 2100 2250 2350 2450 2600 2882; 150 300 500 700 900 1100 1300 1500 1700 1900 2100 2250 2350 2450 2600 2882];
            Ratings = [Ratings Anchors];
        end
        
        for i=1:m %START OF MATCHES (M)
            
            if Group == "N"
                %Select 2 Random Players
                A = ceil(rand*p);
                B = ceil(rand*p);

                while A == B %Prevent the "same person" playing
                    A = ceil(rand*p);
                end

                %Calculate Expected/Actual Scores
                A_ES = 1./(1+10.^((Ratings(1,B) - Ratings(1,A))/400));
                B_ES = 1 - A_ES;

                A_AS = 1./(1+10.^((Ratings(2,B) - Ratings(2,A))/400));
                B_AS = 1 - A_AS;

                %Set Sensitivity by FIDE Regulations (FOR PLAYER A)
                if Ratings(1,A) < 2300
                    K = 40;
                elseif Ratings(1,A) < 2400
                    K = 20;
                else
                    K = 10;
                end

                %Update Player A Rating
                if Anchor == "Y" && ismember(Ratings(1,A),Anchors(1,:)) && ismember(Ratings(2,A),Anchors(2,:)) %DO NOT UPDATE ANCHOR RATINGS
                    Ratings(1,A) = Ratings(1,A);
                else
                    Ratings(1,A) = Ratings(1,A) + K*(A_AS - A_ES);
                end
                
                %Set Sensitivity by FIDE Regulations (FOR PLAYER B)
                if Ratings(1,B) < 2300
                    K = 40;
                elseif Ratings(1,B) < 2400
                    K = 20;
                else
                    K = 10;
                end

                %Update Player B Rating
                if Anchor == "Y" && ismember(Ratings(1,B),Anchors(1,:)) && ismember(Ratings(2,B),Anchors(2,:)) %DO NOT UPDATE ANCHOR RATINGS
                    Ratings(1,B) = Ratings(1,B);
                else
                    Ratings(1,B) = Ratings(1,B) + K*(B_AS - B_ES);
                end
                %Ratings(1,B) = Ratings(1,B) + K*(B_AS - B_ES);

                
                
                
                
                
            else %IE Grouped
                RP = Ratings(1,:);
                RT = Ratings(2,:);

                %Create Class Ratings
                if Anchor == "Y"
                    Class_Matrix_PR = zeros(16,p+width(Anchors));
                    Class_Matrix_TR = zeros(16,p+width(Anchors));
                else
                    Class_Matrix_PR = zeros(16,p);
                    Class_Matrix_TR = zeros(16,p);
                end

                ClassSSSp_PR = RP(RP >= 2700);
                ClassSSSp_TR = RT(RP >= 2700);
                ClassSSS_PR = RP(RP >= 2500 & RP < 2700);
                ClassSSS_TR = RT(RP >= 2500 & RP < 2700);
                ClassSSp_PR = RP(RP >= 2400 & RP < 2500);
                ClassSSp_TR = RT(RP >= 2400 & RP < 2500);
                ClassSS_PR = RP(RP >= 2300 & RP < 2400);
                ClassSS_TR = RT(RP >= 2300 & RP < 2400);
                ClassSp_PR = RP(RP >= 2200 & RP < 2300);
                ClassSp_TR = RT(RP >= 2200 & RP < 2300);
                ClassS_PR = RP(RP >= 2000 & RP < 2200);
                ClassS_TR = RT(RP >= 2000 & RP < 2200);
                ClassA_PR = RP(RP >= 1800 & RP < 2000);
                ClassA_TR = RT(RP >= 1800 & RP < 2000);
                ClassB_PR = RP(RP >= 1600 & RP < 1800);
                ClassB_TR = RT(RP >= 1600 & RP < 1800);
                ClassC_PR = RP(RP >= 1400 & RP < 1600);
                ClassC_TR = RT(RP >= 1400 & RP < 1600);
                ClassD_PR = RP(RP >= 1200 & RP < 1400);
                ClassD_TR = RT(RP >= 1200 & RP < 1400);
                ClassE_PR = RP(RP >= 1000 & RP < 1200);
                ClassE_TR = RT(RP >= 1000 & RP < 1200);
                ClassF_PR = RP(RP >= 800 & RP < 1000);
                ClassF_TR = RT(RP >= 800 & RP < 1000);
                ClassG_PR = RP(RP >= 600 & RP < 800);
                ClassG_TR = RT(RP >= 600 & RP < 800);
                ClassH_PR = RP(RP >= 400 & RP < 600);
                ClassH_TR = RT(RP >= 400 & RP < 600);
                ClassI_PR = RP(RP >= 200 & RP < 400);
                ClassI_TR = RT(RP >= 200 & RP < 400);
                ClassJ_PR = RP(RP < 200);
                ClassJ_TR = RT(RP < 200);

                Class_Matrix_PR(1,1:width(ClassSSSp_PR)) = ClassSSSp_PR;
                Class_Matrix_TR(1,1:width(ClassSSSp_TR)) = ClassSSSp_TR;
                Class_Matrix_PR(2,1:width(ClassSSS_PR)) = ClassSSS_PR;
                Class_Matrix_TR(2,1:width(ClassSSS_TR)) = ClassSSS_TR;
                Class_Matrix_PR(3,1:width(ClassSSp_PR)) = ClassSSp_PR;
                Class_Matrix_TR(3,1:width(ClassSSp_TR)) = ClassSSp_TR;
                Class_Matrix_PR(4,1:width(ClassSS_PR)) = ClassSS_PR;
                Class_Matrix_TR(4,1:width(ClassSS_TR)) = ClassSS_TR;
                Class_Matrix_PR(5,1:width(ClassSp_PR)) = ClassSp_PR;
                Class_Matrix_TR(5,1:width(ClassSp_TR)) = ClassSp_TR;
                Class_Matrix_PR(6,1:width(ClassS_PR)) = ClassS_PR;
                Class_Matrix_TR(6,1:width(ClassS_TR)) = ClassS_TR;
                Class_Matrix_PR(7,1:width(ClassA_PR)) = ClassA_PR;
                Class_Matrix_TR(7,1:width(ClassA_TR)) = ClassA_TR;
                Class_Matrix_PR(8,1:width(ClassB_PR)) = ClassB_PR;
                Class_Matrix_TR(8,1:width(ClassB_TR)) = ClassB_TR;
                Class_Matrix_PR(9,1:width(ClassC_PR)) = ClassC_PR;
                Class_Matrix_TR(9,1:width(ClassC_TR)) = ClassC_TR;
                Class_Matrix_PR(10,1:width(ClassD_PR)) = ClassD_PR;
                Class_Matrix_TR(10,1:width(ClassD_TR)) = ClassD_TR;
                Class_Matrix_PR(11,1:width(ClassE_PR)) = ClassE_PR;
                Class_Matrix_TR(11,1:width(ClassE_TR)) = ClassE_TR;
                Class_Matrix_PR(12,1:width(ClassF_PR)) = ClassF_PR;
                Class_Matrix_TR(12,1:width(ClassF_TR)) = ClassF_TR;
                Class_Matrix_PR(13,1:width(ClassG_PR)) = ClassG_PR;
                Class_Matrix_TR(13,1:width(ClassG_TR)) = ClassG_TR;
                Class_Matrix_PR(14,1:width(ClassH_PR)) = ClassH_PR;
                Class_Matrix_TR(14,1:width(ClassH_TR)) = ClassH_TR;
                Class_Matrix_PR(15,1:width(ClassI_PR)) = ClassI_PR;
                Class_Matrix_TR(15,1:width(ClassI_TR)) = ClassI_TR;
                Class_Matrix_PR(16,1:width(ClassJ_PR)) = ClassJ_PR;
                Class_Matrix_TR(16,1:width(ClassJ_TR)) = ClassJ_TR;

                for c=1:16 %Class Bins
                    %Set Pool Size to Class Size
                    Pool = nnz(Class_Matrix_PR(c,:));

                    if Pool == 0
                        Empty_Brackets(s,i) = Empty_Brackets(s,i) + 1;
                        continue
                        
                    elseif Pool == 1
                        Orphans(s,i) = Orphans(s,i) + 1;
                        continue
                    end

                    %Select 2 Players
                    A = ceil(rand*Pool);
                    B = ceil(rand*Pool);

                    while A == B %Prevent the "same person" playing
                        A = ceil(rand*Pool);
                    end

                    %Calculate Expected/Actual Scores
                    A_ES = 1./(1+10.^((Class_Matrix_PR(c,B) - Class_Matrix_PR(c,A))/400));
                    B_ES = 1 - A_ES;

                    A_AS = 1./(1+10.^((Class_Matrix_TR(c,B) - Class_Matrix_TR(c,A))/400));
                    B_AS = 1 - A_AS;

                    %Set Sensitivity by FIDE Regulations (FOR PLAYER A)
                    if Class_Matrix_PR(c,A) < 2300
                        K = 40;
                    elseif Class_Matrix_PR(c,A) < 2400
                        K = 20;
                    else
                        K = 10;
                    end

                    %Update Player A Rating - ADJUSTED TO NOT FOR ANCHORS
                    if Anchor == "Y" && ismember(Class_Matrix_PR(c,A),Anchors(1,:)) && ismember(Class_Matrix_TR(c,A),Anchors(2,:)) %DO NOT UPDATE ANCHOR RATINGS
                        Class_Matrix_PR(c,A) = Class_Matrix_PR(c,A); %i.e. does not update if anchor
                    else
                        Class_Matrix_PR(c,A) = Class_Matrix_PR(c,A) + K*(A_AS - A_ES);
                    end

                    %Set Sensitivity by FIDE Regulations (FOR PLAYER B)
                    if Class_Matrix_PR(c,B) < 2300
                        K = 40;
                    elseif Class_Matrix_PR(c,B) < 2400
                        K = 20;
                    else
                        K = 10;
                    end

                    %Update Player B Rating
                    if Anchor == "Y" && ismember(Class_Matrix_PR(c,B),Anchors(1,:)) && ismember(Class_Matrix_TR(c,B),Anchors(2,:)) %DO NOT UPDATE ANCHOR RATINGS
                        Class_Matrix_PR(c,B) = Class_Matrix_PR(c,B); %i.e. does not update if anchor
                    else
                        Class_Matrix_PR(c,B) = Class_Matrix_PR(c,B) + K*(B_AS - B_ES);
                    end
                    %Class_Matrix_PR(c,B) = Class_Matrix_PR(c,B) + K*(B_AS - B_ES);

                end %End of Class Bins

                %Update Ratings Matrix
                Ratings(1,:) = nonzeros(Class_Matrix_PR)';
                Ratings(2,:) = nonzeros(Class_Matrix_TR)';
                
                
            end %END OF GROUP IF/ELSE
            
            %Inputting Error after Simulation s, Match i
            if Anchor == "N"
                Error(s,i+1) = mean(abs(Ratings(1,:) - Ratings(2,:))./Ratings(2,:)); %As Percent
            elseif Anchor == "Y"
                Error(s,i+1) = sum(abs(Ratings(1,:) - Ratings(2,:))./Ratings(2,:),2)/(p); %As Percent - not including anchors!
            end
            
        end %END OF MATCHES (M)

    end %END OF SIMULATIONS (N)
    
    %timer = toc    
    
    %mean(mean(Error,1))
    %hold on
    plot(mean(Error,1)*100)
    %ylim([0 85]);
    %lgnd = sprintf('%.0f',Type);
    %legend(lgnd);
    %ytickformat('percentage')
    %plot(0:length(mean(Error,1))-1,mean(Error,1)*100);
    
end %END FUNCTION



