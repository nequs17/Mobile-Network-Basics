function printtable(sequence)
    fprintf('┌─────┬───────────────────────────────┬─────────────────┐\n');
    fprintf('│shift│             sequence          │ autocorrelation │\n');
    fprintf('├─────┼───────────────────────────────┼─────────────────┤\n');

    autocorr_gprah_arr = zeros(1,length(sequence) );

    for shift = 0:length(sequence)-1
        seqTemp  = circshift(sequence, shift);
        autocorr = calculate_autocorrelation(sequence, seqTemp);
        autocorr_gprah_arr(shift + 1) = autocorr;

        fprintf('│%5d│', shift);
        fprintf('%s│%17.5f│\n', sprintf('%.0f', seqTemp), autocorr);
    end
    fprintf('└─────┴───────────────────────────────┴─────────────────┘\n');

    figure;
    plot(0:length(sequence)-1, autocorr_gprah_arr, '-o');
    xlabel('Shift');
    ylabel('Autocorrelation');
    grid on;

end