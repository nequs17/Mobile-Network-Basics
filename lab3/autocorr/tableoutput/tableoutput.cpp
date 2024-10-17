#include "tableoutput.hpp"

void tablecorroutput(const std::vector<double>& resultVector){
    if(resultVector.size() > 0){
        std::cout << std::setw(6) << " " << " | " << std::setw(12) << "a"
              << std::setw(12) << "b" << std::setw(12) << "c" << std::endl;
         std::cout << std::setw(6) << "a" << " | " << std::setw(12) << "-"
              << std::setw(12) << resultVector[0] << std::setw(12) << resultVector[2]
              << std::endl;
        std::cout << std::setw(6) << "b" << " | " << std::setw(12) << resultVector[0]
              << std::setw(12) << "-" << std::setw(12) << resultVector[1] << std::endl;
        std::cout << std::setw(6) << "c" << " | " << std::setw(12) << resultVector[2]
              << std::setw(12) << resultVector[1] << std::setw(12) << "-" << std::endl;
    }else{
        std::cerr << "Empty array" << std::endl;
    }
}