function [Error, GM_Score] = GM_Simulation(n,m,p,GM_Elo,Group,Anchor,Disparity)
    %tic
    rng(10)
    
    %Initialize Error Matrix
    Error = zeros(n,m+1);
    GM_Score = zeros(n,m+1); %For Unique GM Plot
    %X_Line = zeros(n,1); %For Unique GM Plot
    
    for s=1:n %START OF SIMULATIONS (N)
        
        [GM, Ratings] = Initial_Ratings(p,"GM",GM_Elo,Disparity);
        
        %For error before any matches occur or "m=0"
        Error(s,1) = abs(GM(1) - GM(2))/GM(2); %As Percent of TR
        GM_Score(s,1) = GM(1);
        %X_Line(s,1) = 0;
        
        %Add Anchors for Groups
        if Anchor == "Y"
            Anchors = [150 300 500 700 900 1100 1300 1500 1700 1900 2100 2250 2350 2450 2600 2882; 150 300 500 700 900 1100 1300 1500 1700 1900 2100 2250 2350 2450 2600 2882];
            Ratings = [Ratings Anchors];
        end
        
        for i=1:m %START OF MATCHES (M)
            if Group == "Y"
                
                %Update Groupings Based on Anchor Status
                if Anchor == "Y"
                    [ClassSSSp,ClassSSS,ClassSSp,ClassSS,ClassSp,ClassS,ClassA,ClassB,ClassC,ClassD,ClassE,ClassF,ClassG,ClassH,ClassI,ClassJ] = Groupings(p+width(Anchors),Ratings);
                else
                    [ClassSSSp,ClassSSS,ClassSSp,ClassSS,ClassSp,ClassS,ClassA,ClassB,ClassC,ClassD,ClassE,ClassF,ClassG,ClassH,ClassI,ClassJ] = Groupings(p,Ratings);
                end

                %Now Set Ranges
                switch true
                    case GM(1) >= 100 && GM(1) < 200
                        Pool = ClassJ;
                    case GM(1) >= 200 && GM(1) < 400
                        Pool = ClassI;
                    case GM(1) >= 400 && GM(1) < 600
                        Pool = ClassH;
                    case GM(1) >= 600 && GM(1) < 800
                        Pool = ClassG;
                    case GM(1) >= 800 && GM(1) < 1000
                        Pool = ClassF;
                    case GM(1) >= 1000 && GM(1) < 1200
                        Pool = ClassE;
                    case GM(1) >= 1200 && GM(1) < 1400
                        Pool = ClassD;
                    case GM(1) >= 1400 && GM(1) < 1600
                        Pool = ClassC;
                    case GM(1) >= 1600 && GM(1) < 1800
                        Pool = ClassB;
                    case GM(1) >= 1800 && GM(1) < 2000
                        Pool = ClassA;
                    case GM(1) >= 2000 && GM(1) < 2200
                        Pool = ClassS;
                    case GM(1) >= 2200 && GM(1) < 2300
                        Pool = ClassSp;
                    case GM(1) >= 2300 && GM(1) < 2400
                        Pool = ClassSS;
                    case GM(1) >= 2400 && GM(1) < 2500
                        Pool = ClassSSp;
                    case GM(1) >= 2500 && GM(1) < 2700
                        Pool = ClassSSS;
                    case GM(1) >= 2700
                        Pool = ClassSSSp;
                    otherwise
                        fprintf('A VALUE OF <100 OCCURED, ERROR ERROR ERROR, %f\n',i)
                end %END CASES      

                %Exit Simulation if Nobody Left to Play
                if isempty(Pool)
                    %fprintf("There is an empty pool/bin after %.0f matches!\n",i)
                    %fprintf("We are in %s\n",Tag)
                    Error(s,(i+1):m) = abs(GM(1) - GM(2))/GM(2);
                    GM_Score(s,(i+1):m) = GM(1); %Unique GM Plot
                    %X_Line(s) = i+1; %Unique GM Plot
                    %i=m;
                    break
                end
                
                %Select a Random Player
                Player = ceil(rand*width(Pool));

                %Calculate Expected/Actual Scores
                Player_ES = 1./(1+10.^((GM(1) - Pool(1,Player))/400));
                GM_ES = 1 - Player_ES;

                Player_AS = 1./(1+10.^((GM(2) - Pool(2,Player))/400));
                GM_AS = 1 - Player_AS;

                %Set Sensitivity by FIDE Regulations
                if GM(1) < 2300
                    K = 40;
                elseif GM(1) < 2400
                    K = 20;
                else
                    K = 10;
                end

                %Update Rating(s)
                Old_GM = GM(1); %Used to update group score
                GM(1) = GM(1) + K*(GM_AS - GM_ES); %New GM Rating

                %Update GM Rating in Group
                switch true
                    case Old_GM >= 100 && Old_GM < 200
                        ClassJ(1,Player) = Pool(1,Player);
                    case Old_GM >= 200 && Old_GM < 400
                        ClassI(1,Player) = Pool(1,Player);
                    case Old_GM >= 400 && Old_GM < 600
                        ClassH(1,Player) = Pool(1,Player);
                    case Old_GM >= 600 && Old_GM < 800
                        ClassG(1,Player) = Pool(1,Player);
                    case Old_GM >= 800 && Old_GM < 1000
                        ClassF(1,Player) = Pool(1,Player);
                    case Old_GM >= 1000 && Old_GM < 1200
                        ClassE(1,Player) = Pool(1,Player);
                    case Old_GM >= 1200 && Old_GM < 1400
                        ClassD(1,Player) = Pool(1,Player);
                    case Old_GM >= 1400 && Old_GM < 1600
                        ClassC(1,Player) = Pool(1,Player);
                    case Old_GM >= 1600 && Old_GM < 1800
                        ClassB(1,Player) = Pool(1,Player);
                    case Old_GM >= 1800 && Old_GM < 2000
                        ClassA(1,Player) = Pool(1,Player);
                    case Old_GM >= 2000 && Old_GM < 2200
                        ClassS(1,Player) = Pool(1,Player);
                    case Old_GM >= 2200 && Old_GM < 2300
                        ClassSp(1,Player) = Pool(1,Player);
                    case Old_GM >= 2300 && Old_GM < 2400
                        ClassSS(1,Player) = Pool(1,Player);
                    case Old_GM >= 2400 && Old_GM < 2500
                        ClassSSp(1,Player) = Pool(1,Player);
                    case Old_GM >= 2500 && Old_GM < 2700
                        ClassSSS(1,Player) = Pool(1,Player);
                    case Old_GM >= 2700
                        ClassSSSp(1,Player) = Pool(1,Player);
                    otherwise
                        fprintf('A VALUE OF <100 OCCURED, ERROR ERROR ERROR, %f\n',i)
                end

                %UPDATE RATINGS FOR NEXT LOOP
                Ratings = [ClassJ ClassI ClassH ClassG ClassF ClassE ClassD ClassC ClassB ClassA ClassS ClassSp ClassSS ClassSSp ClassSSS ClassSSSp];

                %Inputting Error after Match i
                %Error(s,i) = abs(GM(1) - GM(2));
        
        
        
        
        
        
            %SECTION FOR NON-GROUP
            else            
                %Select a Random Player
                Player = ceil(rand*p);

                %Calculate Expected/Actual Scores
                Player_ES = 1./(1+10.^((GM(1) - Ratings(1,Player))/400));
                GM_ES = 1 - Player_ES;

                Player_AS = 1./(1+10.^((GM(2) - Ratings(2,Player))/400));
                GM_AS = 1 - Player_AS;

                %Set Sensitivity by FIDE Regulations
                if GM(1) < 2300
                    K = 40;
                elseif GM(1) < 2400
                    K = 20;
                else
                    K = 10;
                end

                %Update Rating(s) - Player is not Updated (@ True Skill Alrdy)
                GM(1) = GM(1) + K*(GM_AS - GM_ES); %GM
            
            end %END OF GROUP IF/ELSE
            
            Error(s,i+1) = abs(GM(1) - GM(2))/GM(2); %As Percent of TR
            GM_Score(s,i+1) = GM(1); %Unique GM Plot
            %X_Line(s,i+1) = i; %Unique GM Plot

        end %END OF MATCHES (M)

    end %END OF SIMULATIONS (N)
    
    %TEMPORARY (EVENTUALL WILL BE IN PLOTTING FUNCTION)
    plot(mean(Error,1)*100)
    final_err = (mean(Error,1)*100);
    final_err = round(final_err(m-1),2);
    fprintf('Err: %f\n',final_err)
    ytickformat('percentage')
    %ylim([0 15])
    %REMINDER - WITH ANCHOR OFF THE GRAPH WILL LOOK WEIRD AS IT IS ENDING
    %EARLY
    
    %plot(mean(GM_Score,1))
    %yline(GM_Elo);
    %xline(mean(X_Line));
    
%     %FIGURE OUT TO PUT INTO PLOTTING FUNCTION
%     %CALL WITH "GM_Simulation(1,100,100,2500,"Y","N",0);"
%     if Anchor == "N"
%         %Removes Matches Missed
%         Error(:,all(Error == 0)) = [];
%         
%         figure
%         hold on
%         %legend("",'Location','southwest')
%         for zz = 1:size(Error,1)
%             plot(Error(zz,:));
%         end
%     end
%     %FIGURE OUT TO PUT INTO PLOTTING FUNCTION
    
    %Time2Run = toc;    

end %END FUNCTION



