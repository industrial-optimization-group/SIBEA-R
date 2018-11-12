function [FrontValue, MaxFront] = fast_set_based_sorting(FunctionValue)
% FunctionValue
% pause
[N,M] = size(FunctionValue);
domination_count = zeros(N,1); %domination count for each solution
dominated = zeros(N,1); %the solution dominated by each solution
fronts = zeros(N,1);
for i = 1:N
  %find the domination count for each solution
  for j = 1:N
      dominance = false(M,1);
      %dominance_1 = false(M,1);
      if j ~= i
          for sce = 1:2:M
            for check = 1:2:M
                 
                if  FunctionValue(i, sce:sce+1) < FunctionValue(j,check:check+1)
                    %indice = [j, sce, i , check]
                    dominance(sce:sce+1) = true;
                    %pause
                    
                    %domination_count(i) = domination_count(i) + 1; 
                    %break
                end
                %break
            end
          end
%           for check_1 = 1:2:M
%               for sce_1 = 1:2:M
%                   if FunctionValue(i,check_1:check_1+1) <= FunctionValue(j, sce_1:sce_1+1)
%                     dominance_1(check_1:check_1+1) = true;
%                     %domination_count(i) = domination_count(i) + 1; 
%                     %break
%                   end
%               end
%           end
          
      %end
%       dominance
%       pause
      if dominance == true
          %domination_count(i) = domination_count(i)+1;
      %elseif dominance == false
          dominated(i, end+1) = j;
      end
%       if dominance_1 == true
%           dominated(i,end+1) = j;
       end
  end
  for ii = 1:N
     domination_count(ii) = sum(dominated(:)==ii) ;
  end
  %store the solutions dominated by solution i
    
end
%   domination_count
%   dominated
% pause

sorted = [];
sort_tracking = ones(N,1);

for d = 1: N
    if domination_count(d) == 0
        fronts(d) = 1;
        sorted(end+1) = d; 
        sort_tracking(d) = 0;
    end
end
      
%      size(sorted,2)
      
%     sort_tracking
    front_count = 1;
    fronts;
    sorted;
    check_tacking = any(sort_tracking); 
new_sorted = [];  

while sum(sort_tracking(:) == 0) < N
    sum(sort_tracking(:)==0);
    %pause
    front_count = front_count+1;
for s= 1: size(sorted, 2)
    
    cur = dominated(sorted(s),:);
    
    cur(cur == 0) = [];
    %[sharedVals,idxsIntoA] = intersect(cur,sorted);
    %idxs = cur(idxsIntoA)
    %%idxs = arrayfun(@(x)find(cur==x,1),sorted);
    %cur(idxs) = [];
    
    cur_count = domination_count(cur);
    cur_count = cur_count-1;
    
    indx = find(cur_count); %nonzero elements in cur_count
    if isempty(indx) == false
    domination_count(cur(indx)) = cur_count(indx);
    end
    indx2 = find(~cur_count); %zero elements
    fronts(cur(indx2)) = front_count;
    tr = cur(indx2);
    for ns = 1:size(tr,2)
    new_sorted(end+1) = tr(ns); 
    end
    sort_tracking(cur(indx2)) = 0;
    domination_count(cur(indx2)) = 0;
end

sorted = new_sorted;

if sum(sort_tracking) <1
   break 
end
end

% while any(sort_tracking(:) ~= 0)%sum(sort_tracking(:) == 0) <= N%any(sort_tracking(:) ~= 0) 
%      % sort_tracking
% %       fronts
% %       sorted
% %       pause
%       %for s = 1:size(sorted,2)
%  
%         current = dominated(sorted,:);
%         
%         %pause
%       %for cur = 1:size(current_dom,1)
%           %cur_dom = current_dom(cur,:);
%         %sorted = [];
%         front_count = front_count+1;
%         for cur = 1:size(current,1)
%             
%             current_dom = current(cur,:);
%             %pause
%             current_dom(current_dom == 0) = [];
%             if isempty(current_dom)
%                 
%                 %fronts(current(cur)) = front_count;
%                 %sort_tracking() = 0;
%                 check = 1
%             else
%       
%            current_count = domination_count(current_dom);
%            current_count;
%           
%           %pause
%            %while all(current_count)  == true
%            current_count = current_count-1;
%                   
%            %end
%            indx = find(current_count); %indices of non-zero elements
%            domination_count(current_dom(indx));
%            %pause
%            
%            domination_count(current_dom(indx)) = current_count(indx);
%            
%            %
%            %pause
%            last = sort_tracking;
%            last(indx) = [];
%            if cur == size(current,1) && isempty(current_count) == false
%                fronts(current_dom(indx)) = front_count;
%                sort_tracking(current_dom(indx)) = 0;
%                
%            end
%            
%            [r,l,v] = find(~current_count);
%           % pause
%          
%             %current_count
% %             pause
%            
%            
%            for ll = 1:size(r,1)
%            %r(ll)
% %           pause
%              
%              sorted = [];
%              check_already_sorted = ismember(current_dom(r(ll)), sorted(:));
%              if check_already_sorted == false
%                  current_dom(r(ll));
%                 sorted(end+1) = current_dom(r(ll));
%                 domination_count(sorted) = 0;
%                 fronts(current_dom(r(ll))) = front_count;
%                 sort_tracking(current_dom(r(ll))) = 0;
%              %pause
%              end
%            end
%            
%            
%             end
%          
%         end
%         %fronts(dominated(sorted(s), l)) = 2;
%          sort_tracking;
% %         sorted
% %         fronts
% %         pause
%         
%       %end
%       break
%        
%       
%end

MaxFront = max(fronts);
sort_tracking;
FrontValue = fronts;
%pause
%pause


