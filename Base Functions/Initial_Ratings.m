function [GM,Ratings] = Initial_Ratings(p,Type,GM_Elo,Disparity)
    format long g
    
    %GENERAL CONTENT
    %Initialize Matrices
    Ratings = zeros(2,p);
    GM = zeros(2,1);

    %Section for True Ratings
    m = 1000 ; % mean
    v = 95000; %variance
    mu = log((m^2)/sqrt(v+m^2));
    sigma = sqrt(log(v/(m^2)+1));
    
    %Ensure Vector is Same in All Instances (so RNG seed is secure)
    True_Rating = lognrnd(mu,sigma,1,p);
    
    
    %TYPE SPECIFIC CONTENT
    %Select Version
    if isstring(Type) && Type == "GM"
        %Applying Ratings
        Ratings(1,:) = True_Rating; %Public Rating
        Ratings(2,:) = True_Rating; %True Rating

        %Setting GM Ratings
        GM(1) = 600; %Start GM's at 600
        GM(2) = GM_Elo; %GM
    
    elseif class(Type) == 'double'
        %Make for Any Number
        %Applying Ratings
        Ratings(1,:) = ones(1,p)*Type; %Public Rating = 600
        Ratings(2,:) = True_Rating; %True Rating
        
        GM = [];
        
    elseif isstring(Type) && Type == "Random"
        %Applying Ratings
        Ratings(1,:) = ceil(2900.*rand(1,p)); %Public Rating = U(0,2900)
        Ratings(2,:) = True_Rating; %True Rating
        
        GM = [];
        
    elseif isstring(Type) && Type == "Range"
        %Create Variation in Public Rating from True Rating
        Up_Down = rand(1,p);
        Up_Down(Up_Down <= 0.5) = -1;
        Up_Down(Up_Down > 0.5) = 1;
        
        Disparity = Up_Down*Disparity;
        Adjustment = 1+rand(1,p).*Disparity;
        
        %Applying Ratings
        Ratings(1,:) = Adjustment.*True_Rating; %Public Rating +/- RNG Disparity
        Ratings(2,:) = True_Rating; %True Rating
        
        GM = [];
        
    elseif isstring(Type) && Type == "Hybrid"
        Hybrid_Rand = rand(1,p);
        Hybrid_Rand(Hybrid_Rand <= 1/3) = 600;
        Hybrid_Rand(Hybrid_Rand <= 2/3) = 1000;
        Hybrid_Rand(Hybrid_Rand <= 3) = 1200;
        
        Ratings(1,:) = Hybrid_Rand; %Public Rating equally split 600 1000 1200
        Ratings(2,:) = True_Rating; %True Rating
        
        GM = [];
        
    elseif isstring(Type) && Type == "HybridDist"
        Hybrid_Rand = rand(1,p);
        Hybrid_Rand(Hybrid_Rand <= 0.25) = 600;
        Hybrid_Rand(Hybrid_Rand <= (0.50+0.25)) = 1200;
        Hybrid_Rand(Hybrid_Rand <= (0.50+0.25+0.25)) = 1000;
        
        Ratings(1,:) = Hybrid_Rand; %Public Rating equally split 600 1000 1200
        Ratings(2,:) = True_Rating; %True Rating
        
        GM = [];
    end
    
end