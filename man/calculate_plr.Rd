% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{calculate_plr}
\alias{calculate_plr}
\title{Calculate positive likelihood ratio}
\usage{
calculate_plr(sens, spec)
}
\arguments{
\item{sens}{Sensitivity value}

\item{spec}{Specificity value}
}
\value{
Numeric positive likelihood ratio or NA when inputs are not valid
}
\description{
Calculates positive likelihood ratio from sensitivity and specificity
}
