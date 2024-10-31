#include <iostream>
#include <vector>
#include <cmath>
#include <iomanip>

using namespace std;

#define LENGTH 31

int generation_next_value(std::vector<int>& reg, const std::vector<int>& taps){
    int new_bit = 0;

    for (int tap : taps) new_bit ^= reg[tap - 1];

    reg.pop_back();

    reg.insert(reg.begin(), new_bit);

    return reg.back();

}

vector<int> generate_gold_sequence(vector<int> regX, vector<int> regY) {
    vector<int> gold_sequence;

    int bitX,bitY = 0;

    for (size_t i = 0; i < LENGTH; ++i) {
        bitX = generation_next_value(regX, {5,2});
        bitY = generation_next_value(regY, {5, 4, 3, 1});

        gold_sequence.push_back(bitX ^ bitY);
    }
    return gold_sequence;
}

vector<int> rotate_right_vector(const vector<int>& bit_vector) {
    if (bit_vector.empty()) return bit_vector;

    vector<int> rotated_vector(bit_vector.size());
    
    rotated_vector[0] = bit_vector.back();

    size_t arrSize = bit_vector.size();

    for (size_t i = 0; i < bit_vector.size(); ++i) {

        rotated_vector[i] = bit_vector[(i + 1) % arrSize ];

    }

    return rotated_vector;
}

double autocorrFunc(const std::vector<int>& seq1, const std::vector<int>& seq2){
    int matches = 0;
    for (size_t i = 0; i < seq1.size(); ++i) {

        matches += (seq1[i] == seq2[i]) ? 1 : -1;

    }
    return static_cast<double>(matches) / seq1.size();
}

void Calculatecorrelation(const vector<int>& seq){
    vector<int> seqTemp = seq;
    double autocorrResult = 0;

    cout << "┌─────┬───────────────────────────────┬─────────────────┐" << endl;
    cout << "│shift│             sequence          │ autocorrelation │" << endl;
    cout << "├─────┼───────────────────────────────┼─────────────────┤" << endl;
    
    for (size_t i = 0; i < seq.size(); ++i){

        seqTemp = rotate_right_vector(seqTemp);

        cout << "│" << std::setw(5) <<i<<"│";

        for (int bit : seqTemp) cout << bit;

        autocorrResult = autocorrFunc(seq,seqTemp);

        cout  << "│" << std::setw(17) << autocorrResult << "│" << endl;
    }
    cout << "└─────┴───────────────────────────────┴─────────────────┘" << endl;

} 

int main() {
    std::vector<int> m_sequence_x = {0, 0, 0, 0, 1};  
    std::vector<int> m_sequence_y = {0, 0, 1, 1, 1};

    vector<int> gold_sequence = generate_gold_sequence(m_sequence_x, m_sequence_y);
    cout << "gold sequence:   ";
    for (int bit : gold_sequence) cout << bit;
    cout << "\n" << endl;

    Calculatecorrelation(gold_sequence);

    m_sequence_x = {0, 0, 0, 1, 0};  
    m_sequence_y = {0, 0, 0, 1, 0};

    vector<int> _gold_sequence = generate_gold_sequence(m_sequence_x, m_sequence_y);
    
    cout << "\nnew gold sequence:   ";
    for (int bit : gold_sequence) cout << bit;
    cout <<"\n"<< endl;

    double goldCorr = autocorrFunc(gold_sequence, _gold_sequence);

    cout << "correlation between original and new sequences: " << goldCorr <<"\n"<< endl;

    return 0;
}

