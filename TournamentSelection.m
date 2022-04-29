%% Function for tournament selection
% a tournament is created for the chromosomes and the fittest individual is
% picked
function path = TournamentSelection(fitness)
[fitness, index] = sortrows(fitness);

%create two points based on the fitness at each individual
pth1 = randi([1 length(fitness)]);
pth2 = randi([1 length(fitness)]);

%compare the fitness of each and output the most fit
if(fitness(pth1)>fitness(pth2))
    path = index(pth1);
else
    path = index(pth2);
end
end