%% Function for scramble mutation
% a subset within the chromosome is shuffled 
function scramble_chromosome = ScrambleMutation(chromosome)

    %chooose two points on the chromosome
    point1 = randi([1, length(chromosome)]);
    point2 = randi([1, length(chromosome)]);
    
    %keep searching till you find two points which are in increasing order
    while(point1>=point2)
        point1 = randi([1, length(chromosome)]);
        point2 = randi([1, length(chromosome)]);
    end 
    
    %extract a section of the chromosome and randperm to assign a shuffled
    %value, then return the scrambled segment to the chromosome
    chromosome_length = chromosome(point1:point2);
    temp_length = length(chromosome_length);
    flip = chromosome_length(randperm(temp_length));
    chromosome(point1:point2) = flip;
    scramble_chromosome = chromosome;
end