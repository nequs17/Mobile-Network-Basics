#include "autocorr.hpp"

// Formula 3.2
double autocorr(const std::vector<int>& firstVector,const std::vector<int>& secondVector){
    if (firstVector.size() == secondVector.size()){
        double result = 0;
        for(int i = 0; i < firstVector.size();i++){
            result += firstVector[i] + secondVector[i];
        }
        return result;
    }
    else{
        std::cerr << "Invalid, you need cross corrilation function" << std::endl;
    }
    return 0;
}