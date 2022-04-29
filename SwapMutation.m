%% Function for swap mutation
% pick two points on the chromosome and swap values
function swappedChromosome = SwapMutation(chromosome)
    % label two random points on the chromosome
    point1 = randi([1, length(chromosome)]);
    point2 = randi([1, length(chromosome)]);
    
    %check if it is the same point - if so keep choosing till you find
    %another distinct point
    while(point2 == point1)
        point2 = randi([1, length(chromosome)]);
    end
    
    %use deal to assign the values to each respective point (swap)
    [chromosome(point2), chromosome(point1)] = deal(chromosome(point1), chromosome(point2));
    swappedChromosome = chromosome;
end