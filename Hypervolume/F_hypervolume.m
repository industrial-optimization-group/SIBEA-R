function Loss = F_hypervolume(FunctionValue, FrontValue, Pop_Size )

    [N,M] = size(FunctionValue); 
    rtemp = zeros(Pop_Size,2);
    for i = 1:2:M
        %FunctionValue(:,i:i+1)
        rtemp(i,:) = max(FunctionValue(:,i:i+1));% + 0.1;
    end
    r = max(rtemp) + 0.1; %reference point is the worst outcome in the whole population
    
    
    Loss = zeros(1,N); %loss of each solution if it would be removed
    Fronts = setdiff(unique(FrontValue),inf); %what are the fronts
  
    
    for f = 1 : length(Fronts)
        
        Front = find(FrontValue==Fronts(f)); %which solutions are in a front
        
        %find contributors for each front
       
        thisFront = FunctionValue(Front,:);
        
        inte = zeros(size(thisFront,1)*Pop_Size,2);
        

            inte(1:size(thisFront,1),:) = thisFront(:,1:2);
            inte(size(thisFront,1)+1:size(thisFront,1)*2,:) = thisFront(:,3:4);
            %inte(size(thisFront,1)*2+1:size(thisFront,1)*3,:) = thisFront(:,5:6);
           
        
        Fit = inte;
        
        
     
        %tracking which outcome belongs to which solution
        
        track = zeros(size(Fit,1),3);
        
        track(:,1:2) = Fit;
       
        pop = 3;
        
        %pause
        %thisFront
        %size(Front,1)
        Front = Front';
        if size(Front,2) == 1
            track(:,3) = Front;
        else
            
        
            for i = 1:3
                
                if i < size(Front,2)
                    
                    track(1:size(Front,2),3) = Front;
                elseif i > size(Front,2) && i < size(Front,2)*2
                    track(size(Front,2)+1:size(Front,2)*2,3) = Front;
                else
                    %i >size(thisFront,1)*2 && i <= size(thisFront,1)*3
                    
                    track(size(Front,2)*2+1: size(Front,2)*3,3) = Front;
                    
                end
            end
        
        end
        
        %size(contributors),2
        %pause
        %Fit = FunctionValue(Front,:);
        
        W = ones(1,size(Fit,1));
        TH = P_evaluate_hv_weight('nHV',Fit,r,W); %hypervolumne of a front
        
        temp = Fit;
        temp_W = W;
        
        
        for i = 1:size(Front,2)
            ele = Front(i);
           
            for jj = 1:size(track,1)
               
                
                if track(jj,3) == ele
                    
                    Fit(jj,:)= [0,0]; %delete one outcome
                    W(jj) = [0];
                end
            end
           
            Fit = Fit(any(Fit,2),:);
            
            hv = P_evaluate_hv_weight('nHV',Fit,r,W); %hyper volume of the front excluding the solution
            
            Loss(Front(i)) = TH - hv; %Loss
            Fit = temp;
            W = temp_W;
        end
        %for i = 1 : M
        %    [~,Rank] = sortrows(FunctionValue(Front,i));
        %    Loss(Front(Rank(1))) = inf;
        %    Loss(Front(Rank(end))) = inf;
        %end
    end
    
end


