%problem settings
M = 2;

%algorithm parameters
Generations = 100;
Pop_Size = 10;

%main loop
%for i = 1:Generations
   Parameters = struct('p', {Generations, Pop_Size, M});
   main(Parameters)
%end