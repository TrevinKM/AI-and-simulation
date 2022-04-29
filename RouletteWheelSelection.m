%% Function for roulette wheel selection
% create a weighted 'wheel' to choose chromosome based on relative fit
function path = RouletteWheelSelection(weights)

  %provide the cumulative sum of all the weights
  acc = cumsum(weights);
  
  %declare variables
  randnum = rand();
  temp_index = -1;
  
  %for each item in the cumalative weights check if the weight is greater
  %than each generated number, allowing larger numbers to be chosen more
  %often
  for index = 1 : length(acc)
    if (acc(index) > randnum)
      temp_index = index;
      break;
    end
  end
  
  path = temp_index;