% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GetCovariates.R
\name{getDbCovariateData}
\alias{getDbCovariateData}
\title{Get covariate information from the database}
\usage{
getDbCovariateData(connection, oracleTempSchema = NULL, cdmDatabaseSchema,
  cdmVersion = "4", cohortTempTable = "cohort_person",
  rowIdField = "subject_id", covariateSettings, normalize = TRUE)
}
\arguments{
\item{connection}{A connection to the server containing the schema as created using the
\code{connect} function in the \code{DatabaseConnector} package.}

\item{oracleTempSchema}{A schema where temp tables can be created in Oracle.}

\item{cdmDatabaseSchema}{The name of the database schema that contains the OMOP CDM instance.
Requires read permissions to this database. On SQL Server, this should
specifiy both the database and the schema, so for example
'cdm_instance.dbo'.}

\item{cdmVersion}{Define the OMOP CDM version used: currently support "4" and "5".}

\item{cohortTempTable}{Name of the temp table holding the cohort for which we want to construct
covaraites}

\item{rowIdField}{The name of the field in the cohort temp table that is to be used as the
row_id field in the output table. This can be especially usefull if there
is more than one period per person.}

\item{covariateSettings}{Either an object of type \code{covariateSettings} as created using one of
the createCovariate functions, or a list of such objects.}

\item{normalize}{Should covariate values be normalized? If true, values will be divided by
the max value per covariate.}
}
\value{
Returns an object of type \code{covariateData}, containing information on the baseline covariates.
Information about multiple outcomes can be captured at once for efficiency reasons. This object is
a list with the following components: \describe{ \item{covariates}{An ffdf object listing the
baseline covariates per person in the cohorts. This is done using a sparse representation:
covariates with a value of 0 are omitted to save space. The covariates object will have three
columns: rowId, covariateId, and covariateValue. The rowId is usually equal to the person_id,
unless specified otherwise in the rowIdField argument.} \item{covariateRef}{An ffdf object
describing the covariates that have been extracted.} \item{metaData}{A list of objects with
information on how the covariateData object was constructed.} }
}
\description{
Uses one or several covariate builder functions to construct covariates.
}
\details{
This function uses the data in the CDM to construct a large set of covariates for the provided
cohort. The cohort is assumed to be in an existing temp table with these fields: 'subject_id',
'cohort_definition_id', 'cohort_start_date'. Optionally, an extra field can be added containing the
unique identifier that will be used as rowID in the output. This function is called automatically
by the \code{\link{getDbPlpData}} function.
}

