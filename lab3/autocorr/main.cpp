#include "header.hpp"

int main(){
    std::vector<int> a = {1,2,5,-2,-4,-2,1,4};
    std::vector<int> b = {3,6,7,0,-5,-4,2,5};
    std::vector<int> c = {-1,0,-3,-9,2,-2,5,1};
    double resuleAB = autocorr(a,b);
    double resuleBC = autocorr(b,c);
    double resuleAC = autocorr(a,c);
    std::cout << "autocorr AB result: " << resuleAB << std::endl;
    std::cout << "autocorr BC result: " << resuleBC << std::endl;
    std::cout << "autocorr AC result: " << resuleAC << std::endl;
    std::cout << "------------------------" << std::endl;
    std::cout << "Correlation between A, B and C: " << std::endl;
    tablecorroutput({resuleAB,resuleBC,resuleAC});
    resuleAB = autocorrnomalization(a,b);
    resuleBC = autocorrnomalization(b,c);
    resuleAC = autocorrnomalization(a,c);
    std::cout << "------------------------" << std::endl;
    std::cout << "autocorr normalization AB result: " << resuleAB << std::endl;
    std::cout << "autocorr normalization BC result: " << resuleBC << std::endl;
    std::cout << "autocorr normalization AC result: " << resuleAC << std::endl;
    std::cout << "------------------------" << std::endl;
    std::cout << "Normalization correlation between A, B and C: " << std::endl;
    tablecorroutput({resuleAB,resuleBC,resuleAC});
    return 0;
}