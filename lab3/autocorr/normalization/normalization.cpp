#include "normalization.hpp"

// Formula 3.3
double autocorrnomalization(const std::vector<int>& firstVector,const std::vector<int>& secondVector){
    if (firstVector.size() == secondVector.size()){

        double resultDownedFirst = 0;
        double resultDownedSecond = 0;   

        for(int i = 0; i < firstVector.size();i++){
            resultDownedFirst += std::pow(firstVector[i],2);
            resultDownedSecond += std::pow(secondVector[i],2);
        }

        return (autocorr(firstVector,secondVector) / (std::sqrt(resultDownedFirst * resultDownedSecond)));

    }
    else{
        std::cerr << "Invalid, you need cross corrilation function" << std::endl;
    }
    return 0;
}