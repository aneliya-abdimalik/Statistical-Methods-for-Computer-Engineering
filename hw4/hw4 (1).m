% Parameters
lambda_bulk = 50;
alpha_bulk = 60;
lambda_bulk_weight = 0.1;

lambda_container = 40;
alpha_container = 100;
lambda_container_weight = 0.05;

lambda_oil_tanker = 25;
alpha_oil_tanker = 120;
lambda_oil_tanker_weight = 0.02;

% Total weight threshold
threshold = 300000;

% Number of simulations
num_simulations = 100000;

% Perform Monte Carlo simulation
total_weight_exceed_threshold = 0;
total_weight_sum = 0;
total_weight_sum_squared = 0;

for i = 1:num_simulations
    % Generate random numbers for ship types
    num_bulk = poissrnd(lambda_bulk);
    num_container = poissrnd(lambda_container);
    num_oil_tanker = poissrnd(lambda_oil_tanker);

    % Calculate total weight for each ship type
    total_weight_bulk = gamrnd(alpha_bulk, 1 / lambda_bulk_weight, [1, num_bulk]);
    total_weight_container = gamrnd(alpha_container, 1 / lambda_container_weight, [1, num_container]);
    total_weight_oil_tanker = gamrnd(alpha_oil_tanker, 1 / lambda_oil_tanker_weight, [1, num_oil_tanker]);

    % Calculate the total weight of all cargo
    total_weight = sum(total_weight_bulk) + sum(total_weight_container) + sum(total_weight_oil_tanker);

    % Check if the total weight exceeds the threshold
    if total_weight > threshold
        total_weight_exceed_threshold = total_weight_exceed_threshold + 1;
    end

    % Accumulate total weight for calculating expected weight and standard deviation
    total_weight_sum = total_weight_sum + total_weight;
    total_weight_sum_squared = total_weight_sum_squared + total_weight^2;
end

% Estimate the probability
estimated_probability = total_weight_exceed_threshold / num_simulations;

% Calculate expected weight and standard deviation
expected_weight = total_weight_sum / num_simulations;
variance = (total_weight_sum_squared / num_simulations) - (expected_weight^2);
standard_deviation = sqrt(variance);

% Display the results
fprintf('Estimated probability: %.4f\n', estimated_probability);
fprintf('Expected weight: %.2f tons\n', expected_weight);
fprintf('Standard deviation: %.2f tons\n', standard_deviation);
