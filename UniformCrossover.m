%% Function to implememnt uniform crossover
% this is where each bit is alternatively used from each of the chrmosomes
function [temp_chromosome1 temp_chromosome2] = UniformCrossover(temp_chromosome1, temp_chromosome2)
   
   %create a series of increasing crossover points
   cross_point1=randi([1,27]);
   cross_point2=randi([cross_point1+1,28]);
   cross_point3=randi([cross_point2+1,29]);
        
   %assignt the chromosomes each values at every crossover point
   parent1a=temp_chromosome1(1:cross_point1);
   parent1b=temp_chromosome1(cross_point2+1:cross_point3);
        
   child1a=temp_chromosome2(1:cross_point1);
   child1b=temp_chromosome2(cross_point2+1:cross_point3);
        
   %assing the output to each mixed chromosome
   temp_chromosome1(1:cross_point1)=child1a;
   temp_chromosome1(cross_point2+1:cross_point3)=child1b;
   
   temp_chromosome2(1:cross_point1)=parent1a;
   temp_chromosome2(cross_point2+1:cross_point3)=parent1b; 
end