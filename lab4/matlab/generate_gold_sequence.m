function gold_sequence = generate_gold_sequence(x, y, taps_x, taps_y, length)
    gold_sequence = zeros(1, length);
    for i = 1:length
        [x, bit_x] = lfsr_shift(x, taps_x);
        [y, bit_y] = lfsr_shift(y, taps_y);
        gold_sequence(i) = xor(bit_x, bit_y);
    end
end

function [reg, output] = lfsr_shift(reg, feedback_positions)
    last_bit = reg(end);
    
    feedback = 0;
    for pos = feedback_positions
        feedback = xor(feedback, reg(pos));
    end
    
    reg = [feedback, reg(1:end-1)];
 
    output = last_bit; 
end
