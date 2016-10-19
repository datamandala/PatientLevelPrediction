// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// aucWithCi
std::vector<double> aucWithCi(std::vector<double> propensityScores, std::vector<int> treatment);
RcppExport SEXP PatientLevelPrediction_aucWithCi(SEXP propensityScoresSEXP, SEXP treatmentSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::vector<double> >::type propensityScores(propensityScoresSEXP);
    Rcpp::traits::input_parameter< std::vector<int> >::type treatment(treatmentSEXP);
    rcpp_result_gen = Rcpp::wrap(aucWithCi(propensityScores, treatment));
    return rcpp_result_gen;
END_RCPP
}
// auc
double auc(std::vector<double> propensityScores, std::vector<int> treatment);
RcppExport SEXP PatientLevelPrediction_auc(SEXP propensityScoresSEXP, SEXP treatmentSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::vector<double> >::type propensityScores(propensityScoresSEXP);
    Rcpp::traits::input_parameter< std::vector<int> >::type treatment(treatmentSEXP);
    rcpp_result_gen = Rcpp::wrap(auc(propensityScores, treatment));
    return rcpp_result_gen;
END_RCPP
}
// bySum
DataFrame bySum(List ffValues, List ffBins);
RcppExport SEXP PatientLevelPrediction_bySum(SEXP ffValuesSEXP, SEXP ffBinsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List >::type ffValues(ffValuesSEXP);
    Rcpp::traits::input_parameter< List >::type ffBins(ffBinsSEXP);
    rcpp_result_gen = Rcpp::wrap(bySum(ffValues, ffBins));
    return rcpp_result_gen;
END_RCPP
}
// byMax
DataFrame byMax(List ffValues, List ffBins);
RcppExport SEXP PatientLevelPrediction_byMax(SEXP ffValuesSEXP, SEXP ffBinsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List >::type ffValues(ffValuesSEXP);
    Rcpp::traits::input_parameter< List >::type ffBins(ffBinsSEXP);
    rcpp_result_gen = Rcpp::wrap(byMax(ffValues, ffBins));
    return rcpp_result_gen;
END_RCPP
}
