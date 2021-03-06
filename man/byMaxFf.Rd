% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GetCovariates.R
\name{byMaxFf}
\alias{byMaxFf}
\title{Compute max of values binned by a second variable}
\usage{
byMaxFf(values, bins)
}
\arguments{
\item{values}{An ff object containing the numeric values to take the max of.}

\item{bins}{An ff object containing the numeric values to bin by.}
}
\description{
Compute max of values binned by a second variable
}
\examples{
values <- ff::as.ff(c(1, 1, 2, 2, 1))
bins <- ff::as.ff(c(1, 1, 1, 2, 2))
byMaxFf(values, bins)

}

