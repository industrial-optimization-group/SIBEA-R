function main(Parameters)
gen = Parameters(1).p;
Pop_Size = Parameters(2).p;
M = Parameters(3).p;
Pop_Size;
%pause
addpath(genpath('Evalution'));
addpath(genpath('Hypervolume'));

[Population,Boundary] = P_objective('init',M,Pop_Size); %initial population

FunctionValue = P_objective('value',M,Population) %evaluate the initial population
% fileID = fopen('objfn.txt','a');
%     fmt = '%5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d \n';
%     fprintf(fileID,fmt, FunctionValue);
%     fclose(fileID);
% pause
[FrontValue, MaxFront] = fast_set_based_sorting(FunctionValue); %non-dominated sorting
%pause
Loss = F_hypervolume(FunctionValue,FrontValue, Pop_Size);
%pause

for generations = 1:gen
    
    no_gen = generations;
    
    
    MatingPool = F_mating(Population, FrontValue, Loss);
    %pause
    Offspring = P_generator(MatingPool,Boundary,'Real',Pop_Size);
    Fitness = P_objective('value',M,Offspring);
    Population = [Population;Offspring];
    %pause
    
    FunctionValue = [FunctionValue;Fitness];
    %pause
    next_generation = zeros(1,Pop_Size);
    
   [FrontValue,MaxFront] = fast_set_based_sorting(FunctionValue); %sort the recombined population
  
   
    while any(next_generation(:) == 0)
        for front = 1:MaxFront
           
            find_abs = abs(next_generation); % it is a trick which forces min to do not consider your negative numbers as minimum 
            [~,ind] = min(find_abs); %where is the smallest number in next_generation, we fill individuals from there
            
            NoN = numel(FrontValue,FrontValue==front); %number of individuals in the current front
            
            if NoN < sum(next_generation(:)==0)
                if front == 1
                    
                    indi = find(FrontValue==front);
                    
                    
                    next_generation(1:NoN) = find(FrontValue==front);
                    
                    
                else
                    
                    next_generation(ind:ind+NoN-1) = find(FrontValue==front);
                    
                    
                end
            else
                Loss = F_hypervolume(FunctionValue,FrontValue, Pop_Size);
                %pause
                
                %indi = find(FrontValue(:) < front);
                indi2 = find(FrontValue(:) == front);
                    
                %Loss_copy = Loss;
                Loss_copy = Loss(indi2); %delete from Loss those ones belongs to front considered
                
                [~,Rank] = sort(Loss_copy,'descend');
                 %Rank(1:sum(next_generation(:) == 0))
                %pause
%                 store = [];
                %sum(next_generation(:)==0)
%                 for find_indi = 1:size(selected,2)
%                     find(indi2 == selected(find_indi))
%                     store(end+1) = indi2 (= selected(find_indi));
%                end
                next_generation(ind:end) = indi2(Rank(1:sum(next_generation(:) == 0)));
                
                break
            end
                
        end
    end
    
   
    Population = Population(next_generation,:);
    
  
   
    FrontValue = FrontValue(next_generation);
    
    
    Loss = Loss(next_generation);
    FunctionValue = FunctionValue(next_generation,:);
    
%     fileID = fopen('objfn.txt','a');
%     fmt = '%5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d \n';
%     fprintf(fileID,fmt, FunctionValue);
%     fclose(fileID);
   % pause
    %pause
%     while size(Population,1) > Pop_Size
%         %size(Population,1)
%         
%         [FrontValue,MaxFront] = fast_set_based_sorting(FunctionValue);
%        % pause
%    
%     
%     
%         %if i<=N_DI && HH ==1
%             Loss = F_hypervolume(FunctionValue,FrontValue,2);
% %         Loss = 0;
% %         for jj = 1:2:M*4
% %    
% %             Loss = Loss + F_hypervolume(FunctionValue(:,jj:jj+1),FrontValue);
% %         end
%         %else
% %         Loss = 0;
% %         for jj = 1:2:M*4
% %    
% %             Loss = Loss + F_hypervolume_weight(FunctionValue(:,jj:jj+1),FrontValue, W_I, AA, RA, V);
% %         end
%             %Loss = F_hypervolume_weight(FunctionValue,FrontValue,W_I,AA,RA,V);        
%         %end
%         Next = zeros(1,Pop_Size);
% %     new_inx = find(FrontValue ~= MaxFront);
%     %pause
% %     for s = 1:size(new_inx,2)
% %         new_pop(end+1,:) = Population(s,:);
% %         new_fv(end+1,:) = FunctionValue(s,:);
% %     end
%     %pause
%     %break
%     NoN = numel(FrontValue,FrontValue<MaxFront);%returns the number of elements which are not in the worst front
%     
% %     if NoN == 0 %if all solutions are in one front, select according to hyper volume
% %         Last = find(FrontValue==MaxFront);
% %         [~,Rank] = sort(Loss(Last),'descend');
% %         Next(NoN+1:Pop_Size) = Last(Rank(1:Pop_Size-NoN));
% %     else 
% %         Next(1:NoN) = find(FrontValue<MaxFront);
% %         Last = find(FrontValue==MaxFront);
% %         [~,Rank] = sort(Loss(Last),'descend');
% %         Next(NoN+1:Pop_Size) = Last(Rank(1:Pop_Size-NoN));
% %     end 
%     Next
%     
%     %MaxFront
%     Next(1:NoN) = find(FrontValue<MaxFront) %index of solutions which are not in the worst front
%     
%     Last = find(FrontValue==MaxFront)
%     FrontValue
%     Loss
%     [sorted_loss,Rank] = sort(Loss(Last),'descend')
%     pause
%     
%     
%     Next(NoN+1:Pop_Size) = Last(Rank(1:Pop_Size-NoN))
%     %
%     pause
%     Population = Population(Next,:);
%     FrontValue = FrontValue(Next);
%     Loss = Loss(Next);
%     FunctionValue = FunctionValue(Next,:);
%     %Population = new_pop;
%     %FunctionValue = new_fv;
%     end
 %    Population, 
    % FunctionValue
   %  pause
    pause(0.001)
    
    color = [[0, 0,1], [0.36, 0.36, 0.54], [0.6, 0.2, 0.6], [0.8, 0, 0], [0.6, 0.4, 0.2], [0.4, 0.6, 0], [1,0.6,0.2], [0.4, 0.6, 0.6]];
    marker = ['o', '+', '*', '.', 's', 'd', '^', 'v', '>', '<', 'p','h'];
    if M==2
        if no_gen == 1 || no_gen == 20 || no_gen == 40 || no_gen == 50 || no_gen == 80 || no_gen == 100
        
            figure
        hold on
            for k = 1:10
            
            scatter(FunctionValue(k,1), FunctionValue(k,2),  36, 'k')% color(k), marker(k));
            scatter(FunctionValue(k,3), FunctionValue(k,4), 36, 'k') %color(k), marker(k));
            %scatter(FunctionValue(k,5), FunctionValue(k,6), 36, 'k') % color(k), marker(k));
            %scatter(FunctionValue(k,7), FunctionValue(k,8), 36, 'k')% color(k), marker(k));
            %scatter(FunctionValue(k,9), FunctionValue(k,10), 36, 'k')%color(k), marker(k));
            %scatter(FunctionValue(k,11), FunctionValue(k,12), 36, 'k')%  color(k), marker(k));
            
%             scatter(FunctionValue(k+1,1), FunctionValue(k+1,2), 36, color(k), marker(k), 'filled');
%             scatter(FunctionValue(k+1,3), FunctionValue(k+1,4), 36, color(k), marker(k),'filled');
%             scatter(FunctionValue(k+1,5), FunctionValue(k+1,6), 36, color(k), marker(k),'filled');
%             scatter(FunctionValue(k+1,7), FunctionValue(k+1,8), 36, color(k), marker(k),'filled');
%             scatter(FunctionValue(k+1,9), FunctionValue(k+1,10), 36, color(k), marker(k),'filled');
%             scatter(FunctionValue(k+1,11), FunctionValue(k+1,12), 36, color(k), marker(k),'filled');
            end
        grid on
        end
% pause
        %axis([min(FunctionValue(:,1))-1,max(FunctionValue(:,1))+1,min(FunctionValue(:,2))-1,max(FunctionValue(:,2))+1]);
    elseif M==3
        scatter3(FunctionValue(:,1),FunctionValue(:,2),FunctionValue(:,3))
        axis([0,3.0,0,3.0,0,3.0]);
    end
%     if no_gen == 20
%         break
    % end
    
end
Population
%nominal_obj = evaluate_nominal(Population)

figure 
hold on
for k = 1:10
            for jj = 1:2:4
            scatter(FunctionValue(k,jj), FunctionValue(k,jj+1),  36, color(k), marker(k));
           
            end
            % scatter(nominal_obj(k,1), nominal_obj(k,2), 50, 'r', 'o', 'filled')
end
grid on



function objfn = evaluate_nominal(Population)
fn = zeros(8, 2);
for i = 1:8
g = sum((Population(i,1:end)-0.5).^2);
f1 = (1+g)*cos(Population(i,1)*pi/2);
f2 = (1+g)*sin(Population(i,1)*pi/2);
fn(i,:) = [f1, f2];
end
objfn = fn;