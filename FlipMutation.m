%% Function to flip chromosome
% a random point on the chromosome is chosen and the bit is then flipped
function flipped_chromosome = FlipMutation(chromosome)
    %two ponts on the chromosome chosen
    point1 = randi([1, length(chromosome)]);
    point2 = randi([1, length(chromosome)]);
    
    %check if the points are not the same
    while(point2 == point1)
        point2 = randi([1, length(chromosome)]); 
    end
    
    %if second point of the chromosome is lower than the first swap
    if(point2 < point1) 
        [point1, point2] = swap(point1, point2);
    end
    
    %flip the array from left to right 
    flip_target = chromosome(point1:point2);
    chromosome(point1:point2) = fliplr(flip_target);
    flipped_chromosome = chromosome;
end
