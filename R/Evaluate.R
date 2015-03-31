# @file Evaluate.R
#
# Copyright 2015 Observational Health Data Sciences and Informatics
#
# This file is part of PatientLevelPrediction
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Compute the area under the ROC curve
#' 
#' @details Computes the area under the ROC curve for the predicted probabilities, given the 
#' true observed outcomes.
#' 
#' @param prediction          A prediction object as generated using the \code{\link{predictProbabilities}} function.
#' @param outcomeData         An object of type \code{outcomeData}.
#' @param confidenceInterval  Should 95 percebt confidence intervals be computed?
#' 
#' @export
computeAuc <- function(prediction, 
                       outcomeData, 
                       confidenceInterval = FALSE) {
  if (attr(prediction, "modelType") != "logistic")
    stop("Computing AUC is only implemented for logistic models")
  
  cohortConceptId <- attr(prediction, "cohortConceptId")
  outcomeConceptId <- attr(prediction, "outcomeConceptId")
  outcomes <- ffbase::subset.ffdf(outcomeData$outcomes, cohortConceptId == cohortConceptId & outcomeId == outcomeConceptId, select = c("personId", "cohortStartDate", "outcomeId", "outcomeCount", "timeToEvent"))
  prediction <- merge(prediction, ff::as.ram(outcomes), all.x = TRUE)
  prediction$outcomeCount[!is.na(prediction$outcomeCount)] <- 1
  prediction$outcomeCount[is.na(prediction$outcomeCount)] <- 0
  if (confidenceInterval){
    auc <-  .Call('PatientLevelPrediction_aucWithCi', PACKAGE = 'PatientLevelPrediction', prediction$value, prediction$outcomeCount)
    return(data.frame(auc=auc[1],auc_lb95ci=auc[2],auc_lb95ci=auc[3]))    
  } else {
    auc <-  .Call('PatientLevelPrediction_auc', PACKAGE = 'PatientLevelPrediction',  prediction$value, prediction$outcomeCount)
    return(auc)    
  }
}

#' Plot the calibration
#' 
#' @details Create a plot showing the predicted probabilities and the observed fractions. Predictions
#' are stratefied into equally sized bins of predicted probabilities.
#' 
#' @param prediction          A prediction object as generated using the \code{\link{predictProbabilities}} function.
#' @param outcomeData         An object of type \code{outcomeData}.
#' @param numberOfStrata      The number of strata in the plot.
#' @param fileName  Name of the file where the plot should be saved, for example 'plot.png'. See the 
#' function \code{ggsave} in the ggplot2 package for supported file formats.
#' 
#' @return A ggplot object. Use the \code{\link[ggplot2]{ggsave}} function to save to file in a different format.
#' 
#' @export
plotCalibration <- function(prediction, outcomeData, numberOfStrata = 5, fileName = NULL){
  if (attr(prediction, "modelType") != "logistic")
    stop("Plotting the calibration is only implemented for logistic models")
  
  cohortConceptId <- attr(prediction, "cohortConceptId")
  outcomeConceptId <- attr(prediction, "outcomeConceptId")
  outcomes <- ffbase::subset.ffdf(outcomeData$outcomes, cohortConceptId == cohortConceptId & outcomeId == outcomeConceptId, select = c("personId", "cohortStartDate", "outcomeId", "outcomeCount", "timeToEvent"))
  prediction <- merge(prediction, ff::as.ram(outcomes), all.x = TRUE)
  prediction$outcomeCount[!is.na(prediction$outcomeCount)] <- 1
  prediction$outcomeCount[is.na(prediction$outcomeCount)] <- 0
  
  q <- quantile(prediction$value, (1:(numberOfStrata-1))/numberOfStrata)
  prediction$strata <- cut(prediction$value, breaks=c(0,q,max(prediction$value)), labels = FALSE)
  computeStratumStats <- function(data){
    return(data.frame(minx = min(data$value), maxx = max(data$value), fraction = sum(data$outcomeCount) / nrow(data)))
  }
  #strataData <- plyr::ddply(prediction, prediction$strata, computeStratumStats)
  counts <- aggregate(outcomeCount ~ strata, data = prediction, sum)
  names(counts)[2] <- "counts"
  backgroundCounts <- aggregate(personId ~ strata, data = prediction, length)
  names(backgroundCounts)[2] <- "backgroundCounts"
  minx <- aggregate(value ~ strata, data = prediction, min)
  names(minx)[2] <- "minx"
  maxx <- aggregate(value ~ strata, data = prediction, max)
  names(maxx)[2] <- "maxx"
  strataData <- merge(counts,backgroundCounts)
  strataData <- merge(strataData,minx)
  strataData <- merge(strataData,maxx)
  strataData$fraction <- strataData$counts / strataData$backgroundCounts
  plot <- ggplot2::ggplot(strataData, ggplot2::aes(xmin = minx, xmax = maxx, ymin = 0, ymax = fraction)) + 
    ggplot2::geom_abline() +
    ggplot2::geom_rect(color = rgb(0, 0, 0.8, alpha = 0.8), fill = rgb(0, 0, 0.8, alpha = 0.5)) +
    ggplot2::scale_x_continuous("Predicted probability") + 
    ggplot2::scale_y_continuous("Observed fraction") 
  if (!is.null(fileName))
    ggplot2::ggsave(fileName,plot,width=5,height=3.5,dpi=400) 
  return(plot)
}


#' Plot the ROC curve
#' 
#' @details Create a plot showing the Receiver Operator Characteristics (ROC) curve.
#' 
#' @param prediction          A prediction object as generated using the \code{\link{predictProbabilities}} function.
#' @param outcomeData         An object of type \code{outcomeData}.
#' @param fileName  Name of the file where the plot should be saved, for example 'plot.png'. See the 
#' function \code{ggsave} in the ggplot2 package for supported file formats.
#' 
#' @return A ggplot object. Use the \code{\link[ggplot2]{ggsave}} function to save to file in a different format.
#' 
#' @export
plotRoc <- function(prediction, outcomeData, fileName = NULL){
  if (attr(prediction, "modelType") != "logistic")
    stop("Plotting the ROC curve is only implemented for logistic models")
  
  cohortConceptId <- attr(prediction, "cohortConceptId")
  outcomeConceptId <- attr(prediction, "outcomeConceptId")
  outcomes <- ffbase::subset.ffdf(outcomeData$outcomes, cohortConceptId == cohortConceptId & outcomeId == outcomeConceptId, select = c("personId", "cohortStartDate", "outcomeId", "outcomeCount"))
  prediction <- merge(prediction, ff::as.ram(outcomes), all.x = TRUE)
  prediction$outcomeCount[!is.na(prediction$outcomeCount)] <- 1
  prediction$outcomeCount[is.na(prediction$outcomeCount)] <- 0
  prediction <- prediction[order(-prediction$value),c("value", "outcomeCount")]
  prediction$sens <- cumsum(prediction$outcomeCount) / sum(prediction$outcomeCount)
  prediction$fpRate <- cumsum(prediction$outcomeCount == 0) / sum(prediction$outcomeCount == 0)
  data <- aggregate(fpRate ~ sens, data = prediction, min)
  data <- aggregate(sens ~ fpRate, data = data, min)
  plot <- ggplot2::ggplot(data, ggplot2::aes(x = fpRate, y = sens)) +
    ggplot2::geom_area(color = rgb(0, 0, 0.8, alpha = 0.8), fill = rgb(0, 0, 0.8, alpha = 0.4)) +
    ggplot2::scale_x_continuous("1 - specificity") + 
    ggplot2::scale_y_continuous("Sensitivity") 
  if (!is.null(fileName))
    ggplot2::ggsave(fileName, plot, width = 5, height = 4.5, dpi = 400) 
  return(plot)  
}