function [ClassSSSp,ClassSSS,ClassSSp,ClassSS,ClassSp,ClassS,ClassA,ClassB,ClassC,ClassD,ClassE,ClassF,ClassG,ClassH,ClassI,ClassJ] = Groupings(p,Ratings)
    format long g

    %Initialize Groupings
    ClassSSSp = zeros(2,p); %2700+
    ClassSSS = zeros(2,p); %2500 to %2699
    ClassSSp = zeros(2,p); %2400 to 2499
    ClassSS = zeros(2,p); %2300 to 2399
    ClassSp = zeros(2,p); %2200 to 2299
    ClassS = zeros(2,p); %2000 to 2199
    ClassA = zeros(2,p); %1800 to 1999
    ClassB = zeros(2,p); %1600 to 1799
    ClassC = zeros(2,p); %1400 to 1599
    ClassD = zeros(2,p); %1200 to 1399
    ClassE = zeros(2,p); %1000 to 1199
    ClassF = zeros(2,p); %800 to 999
    ClassG = zeros(2,p); %600 to 799
    ClassH = zeros(2,p); %400 to 599
    ClassI = zeros(2,p); %200 to 399
    ClassJ = zeros(2,p); %100 to 199

    for i=1:p
        PR = Ratings(1,i);
        TR = Ratings(2,i);
        
        %Assign Players to Group Bins
        switch true
            case PR<200
                ClassJ(1,i) = PR;
                ClassJ(2,i) = TR;
            case PR>=200 && PR<400
                ClassI(1,i) = PR;
                ClassI(2,i) = TR;
            case PR>=400 && PR<600
                ClassH(1,i) = PR;
                ClassH(2,i) = TR;
            case PR>=600 && PR<800
                ClassG(1,i) = PR;
                ClassG(2,i) = TR;
            case PR>=800 && PR<1000
                ClassF(1,i) = PR;
                ClassF(2,i) = TR;
            case PR>=1000 && PR<1200
                ClassE(1,i) = PR;
                ClassE(2,i) = TR;
            case PR>=1200 && PR<1400
                ClassD(1,i) = PR;
                ClassD(2,i) = TR;
            case PR>=1400 && PR<1600
                ClassC(1,i) = PR;
                ClassC(2,i) = TR;
            case PR>=1600 && PR<1800
                ClassB(1,i) = PR;
                ClassB(2,i) = TR;
            case PR>=1800 && PR<2000
                ClassA(1,i) = PR;
                ClassA(2,i) = TR;
            case PR>=2000 && PR<2200
                ClassS(1,i) = PR;
                ClassS(2,i) = TR;
            case PR>=2200 && PR<2300
                ClassSp(1,i) = PR;
                ClassSp(2,i) = TR;
            case PR>=2300 && PR<2400
                ClassSS(1,i) = PR;
                ClassSS(2,i) = TR;
            case PR>=2400 && PR<2500
                ClassSSp(1,i) = PR;
                ClassSSp(2,i) = TR;
            case PR>=2500 && PR<2700
                ClassSSS(1,i) = PR;
                ClassSSS(2,i) = TR;
            case PR>=2700
                ClassSSSp(1,i) = PR;
                ClassSSSp(2,i) = TR;
            otherwise
                fprintf('<100 ERROR IN GROUPING FUNCTION, %f\n',i)
        end

    end

    %Remove 0 Columns
    ClassSSSp(:,all(ClassSSSp == 0)) = [];
    ClassSSS(:,all(ClassSSS == 0)) = [];
    ClassSSp(:,all(ClassSSp == 0)) = [];
    ClassSS(:,all(ClassSS == 0)) = [];
    ClassSp(:,all(ClassSp == 0)) = [];
    ClassS(:,all(ClassS == 0)) = [];
    ClassA(:,all(ClassA == 0)) = [];
    ClassB(:,all(ClassB == 0)) = [];
    ClassC(:,all(ClassC == 0)) = [];
    ClassD(:,all(ClassD == 0)) = [];
    ClassE(:,all(ClassE == 0)) = [];
    ClassF(:,all(ClassF == 0)) = [];
    ClassG(:,all(ClassG == 0)) = [];
    ClassH(:,all(ClassH == 0)) = [];
    ClassI(:,all(ClassI == 0)) = [];
    ClassJ(:,all(ClassJ == 0)) = [];
    
end

