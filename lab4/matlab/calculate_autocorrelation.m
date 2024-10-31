function autocorr = calculate_autocorrelation(seq1, seq2)
    matches = sum(seq1 == seq2);
    autocorr = (2 * matches - length(seq1)) / length(seq1);
end