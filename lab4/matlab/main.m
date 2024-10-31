regX = [0, 0, 0, 0, 1];
regY = [0, 0, 1, 1, 1];


tapsX = [5,2]; 
tapsY = [5, 4, 3, 1];

sequenceLength = 31;

goldSequence = generate_gold_sequence(regX, regY, tapsX, tapsY, sequenceLength);
fprintf('gold sequence:\n');
fprintf('%s\n\n', sprintf('%.0f', goldSequence)); 

fprintf('Autocorrelation table:\n');
printtable(goldSequence);

newRegX = [0, 0, 0, 1, 0]; 
newRegY = [0, 0, 0, 1, 0];

gold_sequence_ = generate_gold_sequence(newRegX, newRegY, tapsX, tapsY, sequenceLength);
fprintf('new gold sequence::\n');
fprintf('%s\n\n', sprintf('%.0f', gold_sequence_));

goldCorr = calculate_autocorrelation(goldSequence, gold_sequence_);
fprintf('correlation between original and new sequences: %.2f\n', goldCorr);