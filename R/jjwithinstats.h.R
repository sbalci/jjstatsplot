
# This file is automatically generated, you probably don't want to edit this

jjwithinstatsOptions <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
    "jjwithinstatsOptions",
    inherit = jmvcore::Options,
    public = list(
        initialize = function(
            dep = NULL,
            group = NULL,
            grvar = NULL,
            pointpath = TRUE,
            meanpath = TRUE,
            typestatistics = "parametric",
            pairwisecomparisons = TRUE,
            pairwisedisplay = "significant",
            padjustmethod = "holm",
            plottype = "boxviolin",
            originaltheme = FALSE, ...) {

            super$initialize(
                package='jjstatsplot',
                name='jjwithinstats',
                requiresData=TRUE,
                ...)

            private$..dep <- jmvcore::OptionVariables$new(
                "dep",
                dep,
                suggested=list(
                    "continuous"),
                permitted=list(
                    "numeric"))
            private$..group <- jmvcore::OptionVariable$new(
                "group",
                group,
                suggested=list(
                    "ordinal",
                    "nominal"),
                permitted=list(
                    "factor"))
            private$..grvar <- jmvcore::OptionVariable$new(
                "grvar",
                grvar,
                suggested=list(
                    "ordinal",
                    "nominal"),
                permitted=list(
                    "factor"))
            private$..pointpath <- jmvcore::OptionBool$new(
                "pointpath",
                pointpath,
                default=TRUE)
            private$..meanpath <- jmvcore::OptionBool$new(
                "meanpath",
                meanpath,
                default=TRUE)
            private$..typestatistics <- jmvcore::OptionList$new(
                "typestatistics",
                typestatistics,
                options=list(
                    "parametric",
                    "nonparametric",
                    "robust",
                    "bayes"),
                default="parametric")
            private$..pairwisecomparisons <- jmvcore::OptionBool$new(
                "pairwisecomparisons",
                pairwisecomparisons,
                default=TRUE)
            private$..pairwisedisplay <- jmvcore::OptionList$new(
                "pairwisedisplay",
                pairwisedisplay,
                options=list(
                    "significant",
                    "non-significant",
                    "everything"),
                default="significant")
            private$..padjustmethod <- jmvcore::OptionList$new(
                "padjustmethod",
                padjustmethod,
                options=list(
                    "holm",
                    "hochberg",
                    "hommel",
                    "bonferroni",
                    "BH",
                    "BY",
                    "fdr",
                    "none"),
                default="holm")
            private$..plottype <- jmvcore::OptionList$new(
                "plottype",
                plottype,
                options=list(
                    "box",
                    "violin",
                    "boxviolin"),
                default="boxviolin")
            private$..originaltheme <- jmvcore::OptionBool$new(
                "originaltheme",
                originaltheme,
                default=FALSE)

            self$.addOption(private$..dep)
            self$.addOption(private$..group)
            self$.addOption(private$..grvar)
            self$.addOption(private$..pointpath)
            self$.addOption(private$..meanpath)
            self$.addOption(private$..typestatistics)
            self$.addOption(private$..pairwisecomparisons)
            self$.addOption(private$..pairwisedisplay)
            self$.addOption(private$..padjustmethod)
            self$.addOption(private$..plottype)
            self$.addOption(private$..originaltheme)
        }),
    active = list(
        dep = function() private$..dep$value,
        group = function() private$..group$value,
        grvar = function() private$..grvar$value,
        pointpath = function() private$..pointpath$value,
        meanpath = function() private$..meanpath$value,
        typestatistics = function() private$..typestatistics$value,
        pairwisecomparisons = function() private$..pairwisecomparisons$value,
        pairwisedisplay = function() private$..pairwisedisplay$value,
        padjustmethod = function() private$..padjustmethod$value,
        plottype = function() private$..plottype$value,
        originaltheme = function() private$..originaltheme$value),
    private = list(
        ..dep = NA,
        ..group = NA,
        ..grvar = NA,
        ..pointpath = NA,
        ..meanpath = NA,
        ..typestatistics = NA,
        ..pairwisecomparisons = NA,
        ..pairwisedisplay = NA,
        ..padjustmethod = NA,
        ..plottype = NA,
        ..originaltheme = NA)
)

jjwithinstatsResults <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
    inherit = jmvcore::Group,
    active = list(
        todo = function() private$.items[["todo"]],
        plot2 = function() private$.items[["plot2"]],
        plot = function() private$.items[["plot"]]),
    private = list(),
    public=list(
        initialize=function(options) {
            super$initialize(
                options=options,
                name="",
                title="Violin Plots to Compare Within Groups",
                refs=list(
                    "ggplot2",
                    "ggstatsplot"),
                clearWith=list(
                    "dep",
                    "group",
                    "grvar",
                    "typestatistics",
                    "originaltheme",
                    "excl"))
            self$add(jmvcore::Html$new(
                options=options,
                name="todo",
                title="To Do"))
            self$add(jmvcore::Image$new(
                options=options,
                name="plot2",
                title="`Violin Plots by ${grvar}`",
                renderFun=".plot2",
                requiresData=TRUE,
                visible="(grvar)"))
            self$add(jmvcore::Image$new(
                options=options,
                name="plot",
                title="Violin Plots",
                renderFun=".plot",
                requiresData=TRUE))}))

jjwithinstatsBase <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
    "jjwithinstatsBase",
    inherit = jmvcore::Analysis,
    public = list(
        initialize = function(options, data=NULL, datasetId="", analysisId="", revision=0) {
            super$initialize(
                package = 'jjstatsplot',
                name = 'jjwithinstats',
                version = c(1,0,0),
                options = options,
                results = jjwithinstatsResults$new(options=options),
                data = data,
                datasetId = datasetId,
                analysisId = analysisId,
                revision = revision,
                pause = NULL,
                completeWhenFilled = FALSE,
                requiresMissings = FALSE)
        }))

#' Box-Violin Plots to Compare Within Groups
#'
#' 
#'
#' @examples
#' \dontrun{
#' # example will be added
#'}
#' @param data The data as a data frame.
#' @param dep .
#' @param group .
#' @param grvar .
#' @param pointpath .
#' @param meanpath .
#' @param typestatistics .
#' @param pairwisecomparisons .
#' @param pairwisedisplay .
#' @param padjustmethod .
#' @param plottype .
#' @param originaltheme .
#' @return A results object containing:
#' \tabular{llllll}{
#'   \code{results$todo} \tab \tab \tab \tab \tab a html \cr
#'   \code{results$plot2} \tab \tab \tab \tab \tab an image \cr
#'   \code{results$plot} \tab \tab \tab \tab \tab an image \cr
#' }
#'
#' @export
jjwithinstats <- function(
    data,
    dep,
    group,
    grvar,
    pointpath = TRUE,
    meanpath = TRUE,
    typestatistics = "parametric",
    pairwisecomparisons = TRUE,
    pairwisedisplay = "significant",
    padjustmethod = "holm",
    plottype = "boxviolin",
    originaltheme = FALSE) {

    if ( ! requireNamespace('jmvcore', quietly=TRUE))
        stop('jjwithinstats requires jmvcore to be installed (restart may be required)')

    if ( ! missing(dep)) dep <- jmvcore::resolveQuo(jmvcore::enquo(dep))
    if ( ! missing(group)) group <- jmvcore::resolveQuo(jmvcore::enquo(group))
    if ( ! missing(grvar)) grvar <- jmvcore::resolveQuo(jmvcore::enquo(grvar))
    if (missing(data))
        data <- jmvcore::marshalData(
            parent.frame(),
            `if`( ! missing(dep), dep, NULL),
            `if`( ! missing(group), group, NULL),
            `if`( ! missing(grvar), grvar, NULL))

    for (v in group) if (v %in% names(data)) data[[v]] <- as.factor(data[[v]])
    for (v in grvar) if (v %in% names(data)) data[[v]] <- as.factor(data[[v]])

    options <- jjwithinstatsOptions$new(
        dep = dep,
        group = group,
        grvar = grvar,
        pointpath = pointpath,
        meanpath = meanpath,
        typestatistics = typestatistics,
        pairwisecomparisons = pairwisecomparisons,
        pairwisedisplay = pairwisedisplay,
        padjustmethod = padjustmethod,
        plottype = plottype,
        originaltheme = originaltheme)

    analysis <- jjwithinstatsClass$new(
        options = options,
        data = data)

    analysis$run()

    analysis$results
}

