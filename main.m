clear;
close all; 

%%create parameters
next_pop = 2;
sequence_length = 30;
crossover_prob = 0.8;
mutation_prob = 0.2;
environment = dlmread('muir_world.txt', ' ');
new_pop = zeros(sequence_length);
path_1 = zeros(sequence_length);
path_2 = zeros(sequence_length);
temp_chr = zeros(sequence_length);
temp_int = sequence_length;
temp_chromosome1 = zeros(sequence_length);
temp_chrmomosome2 = zeros(sequence_length);

trail = zeros(sequence_length);
fitness = zeros(sequence_length);
%%allow user defined population size
%generate random population
fprintf('Runs best with population size <150 and generations around 1000\n');

population_size = input('Enter the population size: ');
generations = input('Enter the number of generations: ');
population = zeros(population_size, sequence_length);

for i = 1:population_size
    index = 0:9;
    temp_chromosome((index*3)+1) = randi([1,4]);
    temp_chromosome((index*3)+2) = randi([0,9]);
    temp_chromosome((index*3)+3) = randi([0,9]);
    population(i,:) = temp_chromosome;
end

%%%create column to show scores
population = [population zeros(population_size, 1)];

fittest = zeros(generations,1);

%%%prepare rank selection matrix
rank_selection = zeros(sum(1:population_size), 1);
Temp = 0;
for i = 1:population_size
    for j = 1:i
        Temp = Temp + 1;
        rank_selection(Temp) = i;
    end
end
%% extract user input
%choose whether to run a default or custom iteration
run_type = input('Which way would you like to run (0) Default or (1)Custom? ');

switch run_type
    case 0
        selection_type = 0;
        crossover_type = 0;
        mutation_type = 0;
        fprintf('Using DEFAULT settings : TournamentSelection, Uniform Crossover and Swap Mutation\n');
        fprintf('LOADING...\n');
    case 1
         selection_type = input('What type of selection would you like (0) RouletteWheel (1) TournamentSelection (2) RankSelection');
         crossover_type = input('What type of crossover would you like (0) Single-Point Crossover (1) Multi-Point Crossover (2) Uniform Crossover');
         mutation_type = input('What type of mutation would you like (0) Flip Mutation (1) Swap Mutation (2) Scramble Mutation');
         fprintf('LOADING...\n');
end

%% begin the ant simuation 
%start a timer and begin simulation for n generations
tic
for n = 1:generations
    for p = 1:population_size
        [fitness, trail] = simulate_ant(environment, population(p,:)); 
        population(p,31)=fitness;
    end 
    
    %sort to keep the best 2 'ants'
    population = sortrows(population,31);
    new_pop = zeros(population_size,30);
    new_pop(1:2,:) = population(population_size-1:population_size,1:30);
    
    next_pop = 2;
    fittest = zeros(generations,1);
    fittest(n,1)=population(population_size,31);

    %iterate through generations to fill population till the population size is reached
    while(next_pop <  population_size)
        %%choose a selection type to use
        switch selection_type 
            case 0 % implement tournament selection - select the best individuals from a selection by using a tournament
                path_1 = TournamentSelection(population(:,31));
                path_2 = TournamentSelection(population(:,31));

                temp_chromosome1 = population(path_1, 1:30);
                temp_chromosome2 = population(path_2, 1:30); 
            case 1 % implement roulette wheel selection - by using the fitness of each individual in order to calculate the probability of each individual chosen
                weights= population(:,31)/sum(population(:,31));
                path_1 = RouletteWheelSelection(weights);
                path_2 = RouletteWheelSelection(weights);
                temp_chromosome1 = population(path_1, 1:30);
                temp_chromosome2 = population(path_2, 1:30);
            case 2  %implement rank selection - allows to choose individuals regardless of relative fitness, using this allows us to rank individuals with close fitness values
                path_1 = rank_selection(randi(sum(1:population_size), 1));
                temp_chromosome1 = population(path_1, 1:sequence_length);
                path_2 = rank_selection(randi(sum(1:population_size), 1));
                temp_chromosome2 = population(path_2, 1:sequence_length); 
        end
        if (rand<crossover_prob) %check if crossover occurs
            switch crossover_type
                case 0 % implement single point crossover - a single point on bits of both parents chromosomes allow children to carry genetic information from both parents
                    temp_int = randi([1,29]);
                    temp_chr = [temp_chromosome1(1:temp_int) temp_chromosome2(temp_int+1:end)];
                    
                    temp_chromosome2 = [temp_chromosome2(1:temp_int) temp_chromosome1(temp_int+1:end)];
                    temp_chromosome1 = temp_chr;
                case 1 % impement multipoint crossover - two points are used to mark points where bits are crossed over between the two parents allowing better mix of parent genetic information
                    crossover_point1 = randi(sequence_length-2, 1);
                    crossover_point2 = randi([crossover_point1+1,sequence_length-1], 1);
                    crossover_chromosome1 = [temp_chromosome1(1:crossover_point1) temp_chromosome2(crossover_point1+1:crossover_point2) temp_chromosome1(crossover_point2+1:end)];
                    crossover_chromosome2 = [temp_chromosome2(1:crossover_point1) temp_chromosome1(crossover_point1+1:crossover_point2) temp_chromosome2(crossover_point2+1:end)];
                    
                    temp_chromosome1 = crossover_chromosome1;
                    temp_chromosome2 = crossover_chromosome2;
                case 2 % implement uniform crossover 
                    [temp_chromosome1 temp_chromosome2]= UniformCrossover(temp_chromosome1,temp_chromosome2);
            end
        end
        if (rand<mutation_prob) %check if mutation occurs
            switch mutation_type
                case 0 %perform flip mutation
                    temp_chromosome1 = FlipMutation(temp_chromosome1);
                    temp_chromosome2  = FlipMutation(temp_chromosome2);
                case 1 %perform swap mutation
                    temp_chromosome1 = SwapMutation(temp_chromosome1);
                    temp_chromosome2  = SwapMutation(temp_chromosome2);
                case 2 %perform scramble mutation
                    temp_chromosome1 = ScrambleMutation(temp_chromosome1);
                    temp_chromosome2  = ScrambleMutation(temp_chromosome2);
            end
        end
        
        %add the first chromosome to the new population
        next_pop = next_pop +1;
        new_pop(next_pop,:) = temp_chromosome1;
        if (next_pop < population_size)
            next_pop = next_pop + 1;
            new_pop(next_pop,:) = temp_chromosome2;
        end

%comment back in if errors occur in the testing
%         next_pop = next_pop + 1;
%         new_pop(next_pop,:) = temp_chromosome1;
%         new_pop(next_pop,:) = temp_chromosome2;
   

    end
    %enter the updated last column
    population(:,1:30) = new_pop;
end
toc
    %alert users of how many generations have run
    fprintf('with %d generations \n',generations);


 %% Plot showing the fitness score of the most fit ant in each generation
  Ngen= generations;
  hf=figure(1);set(hf,'Color',[1 1 1]);
  hp=plot(1:Ngen,100*fittest/89,'r');
  set(hp,'Linewidth',2);
  axis([0 Ngen 0 100]);grid on
  xlabel('Generation Number');
  ylabel('Ant Fitness [%]');
  title('Ant Fitness as a function of generation')
  
 %% evaluation of fitness scores
 for i=1:population_size
     [fitness,trail]=simulate_ant(dlmread('muir_world.txt',''),population(i,1:30));
     population(i,31)=fitness;
 end
 population = sortrows(population,31);
 best_fitness = population(end, 31);

%% Plot showing the trail of the most fit ant in the final generation

  %read the John Moir Trail (world)
  filename_world='muir_world.txt';
  world_grid=dlmread(filename_world,' ');
  
  % display the John Moir Trail (world)
  world_grid=rot90(rot90(rot90(world_grid)));
  xmax=size(world_grid,2);
  ymax=size(world_grid,1);
  
  hf=figure(2);
  set(hf,'Color',[1 1 1]);
  for y=1:ymax
      for x=1:xmax
          if (world_grid(x,y)==1)
              h1=plot(x,y,'sk');
              hold on
          end
      end
  end
  grid on
  
  %display the fittest individual trail
  for k=1:size(trail)
      h2=plot(trail(k,2),33-trail(k,1),'*m');
      hold on
  end
  axis([1 32 1 32])
  title_str=sprintf('John Muri Trail - Hero Ant Fitness %d%% in %d generation ',uint8(100*best_fitness/89),Ngen);
  title(title_str)
  lh=legend([h1 h2],'Food cell','Ant Movement');
  set(lh,'Location','SouthEast');
  
  fprintf('Highest ant fitness : %d%%\n ',uint8(100*best_fitness/89));



    



