#' @title Waffle Charts
#' @importFrom R6 R6Class
#' @import jmvcore
#' @import ggplot2
#' @import waffle
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom glue glue
#' @import scales
#'
#' @description Create Waffle Charts to visualize distributions.
#'
#' @param data A data frame.
#' @param groups A grouping variable to organize the squares.
#' @param counts Optionally, a numeric variable for specific counts (if not provided, will use number of cases).
#' @param facet Optionally, a variable to facet the plot.
#' @param rows Number of rows in the waffle chart.
#' @param flip Flip the waffle chart.
#' @param color_palette The color palette to use. Options are 'default', 'colorblind', 'professional',
#' 'presentation', 'journal', 'pastel', and 'dark'.
#' @param legendtitle Title for the legend.
#' @param show_legend Show the legend.
#' @param mytitle Title for the plot.
#'
#' @return The function produces a waffle chart.
#'
#'

jwaffleClass <- if (requireNamespace('jmvcore')) R6::R6Class(
    "jwaffleClass",
    inherit = jwaffleBase,
    private = list(
        .init = function() {
            self$results$plot$setSize(600, 500)

            if (!is.null(self$options$facet)) {
                mydata <- self$data
                facet_var <- self$options$facet
                if (!is.null(mydata[[facet_var]])) {
                    num_levels <- length(unique(mydata[[facet_var]]))
                    if (num_levels > 1)
                        self$results$plot$setSize(num_levels * 600, 500)
                }
            }
        },

        .run = function() {
            if (is.null(self$options$groups)) {
                todo <- glue::glue(
                    "<br>Welcome to ClinicoPath
                    <br><br>
                    This tool will help you create Waffle Charts to visualize distributions.
                    <br><br>
                    Please provide:
                    <br>1. A grouping variable to organize the squares
                    <br>2. Optionally, a numeric variable for specific counts (if not provided, will use number of cases)
                    <br><br>
                    The waffle chart will show proportions using squares arranged in a grid.
                    <br><hr>"
                )
                self$results$todo$setContent(todo)
                return()
            }

            if (nrow(self$data) == 0)
                stop('Data contains no (complete) rows')

            todo <- glue::glue("<br>Creating waffle chart...<br><hr>")
            self$results$todo$setContent(todo)
        },

        .plot = function(image, ...) {
            if (is.null(self$options$groups))
                return()

            if (nrow(self$data) == 0)
                stop('Data contains no (complete) rows')

            # Prepare data
            mydata <- self$data
            mydata <- jmvcore::naOmit(mydata)

            groups_var <- self$options$groups
            facet_var <- self$options$facet
            counts_var <- self$options$counts

            # Build grouping expression based on whether faceting is used
            if (!is.null(facet_var)) {
                if (!is.null(counts_var)) {
                    plotdata <- mydata %>%
                        dplyr::group_by(
                            !!rlang::sym(groups_var),
                            !!rlang::sym(facet_var)
                        ) %>%
                        dplyr::summarise(
                            count = sum(!!rlang::sym(counts_var))
                        ) %>%
                        dplyr::ungroup()
                } else {
                    plotdata <- mydata %>%
                        dplyr::group_by(
                            !!rlang::sym(groups_var),
                            !!rlang::sym(facet_var)
                        ) %>%
                        dplyr::summarise(
                            count = dplyr::n()
                        ) %>%
                        dplyr::ungroup()
                }
            } else {
                if (!is.null(counts_var)) {
                    plotdata <- mydata %>%
                        dplyr::group_by(!!rlang::sym(groups_var)) %>%
                        dplyr::summarise(
                            count = sum(!!rlang::sym(counts_var))
                        ) %>%
                        dplyr::ungroup()
                } else {
                    plotdata <- mydata %>%
                        dplyr::group_by(!!rlang::sym(groups_var)) %>%
                        dplyr::summarise(
                            count = dplyr::n()
                        ) %>%
                        dplyr::ungroup()
                }
            }

            # Calculate values for caption
            total_cases <- sum(plotdata$count)
            n_squares <- 100  # Total number of squares in waffle chart
            cases_per_square <- total_cases / n_squares
            squares_per_case <- 100 / total_cases  # Each square represents this percentage
            caption_text <- sprintf("Each square represents %.1f cases (approximately %.1f%%) (total n=%d)",
                                    cases_per_square, squares_per_case, total_cases)

            # Get number of unique groups
            n_groups <- length(unique(plotdata[[groups_var]]))

            # Generate color palettes based on number of groups
            # Enhanced color palettes
            palettes <- list(
                default = colorRampPalette(c("#4DA6FF", "#FFB84D"))(n_groups),
                colorblind = colorRampPalette(c("#999999", "#E69F00", "#56B4E9", "#009E73"))(n_groups),
                professional = colorRampPalette(c("#2C3E50", "#E74C3C", "#3498DB", "#2ECC71"))(n_groups),
                presentation = colorRampPalette(c("#003f5c", "#bc5090", "#ffa600", "#58508d"))(n_groups),
                journal = colorRampPalette(c("#334455", "#778899", "#99AABB", "#BBCCDD"))(n_groups),
                pastel = colorRampPalette(c("#69b3a2", "#404080", "#FFA07A"))(n_groups),
                dark = colorRampPalette(c("#1B9E77", "#D95F02", "#7570B3"))(n_groups)
            )




            sel_palette <- palettes[[self$options$color_palette]]
            if (is.null(sel_palette))
                sel_palette <- palettes$default

            # Create base plot
            p <- ggplot2::ggplot(
                plotdata,
                ggplot2::aes(
                    fill = !!rlang::sym(groups_var),
                    values = count
                )
            ) +
                waffle::geom_waffle(
                    n_rows = self$options$rows,
                    size = 0.5,
                    color = "white",
                    flip = self$options$flip,
                    make_proportional = TRUE
                ) +
                ggplot2::scale_fill_manual(
                    values = sel_palette,
                    name = if (self$options$legendtitle != '')
                        self$options$legendtitle
                    else
                        groups_var
                ) +
                ggplot2::coord_equal() +
                ggplot2::theme_minimal()

            # Add labels in specific order
            if (!is.null(facet_var)) {
                facet_title <- facet_var  # Store the facet variable name
                p <- p +
                    ggplot2::labs(
                        tag = facet_title,  # Facet variable name
                        caption = paste0(  # Combine caption and title
                            self$options$mytitle,
                            "\n\n",
                            caption_text
                        )
                    ) +
                    ggplot2::facet_wrap(
                        as.formula(paste0("~", facet_var)),
                        nrow = 1,
                        strip.position = "bottom"
                    )
            } else {
                p <- p + ggplot2::labs(
                    caption = paste0(
                        self$options$mytitle,
                        "\n\n",
                        caption_text
                    )
                )
            }

            # Handle legend
            if (!self$options$show_legend) {
                p <- p + ggplot2::theme(legend.position = "none")
            }

            # Apply final theme adjustments
            p <- p + ggplot2::theme(
                plot.title = ggplot2::element_text(
                    hjust = 0.5,
                    size = 14,
                    margin = ggplot2::margin(b = 15)  # Increased bottom margin
                ),
                plot.caption = ggplot2::element_text(
                    size = 10,
                    hjust = 0.5,
                    face = "bold",  # Make title bold
                    margin = ggplot2::margin(t = 20)
                ),
                plot.tag = ggplot2::element_text(
                    size = 12,
                    face = "bold",
                    hjust = 0.4
                ),
                plot.tag.position = "top",  # Position below title  # Position at top
                legend.position = if(self$options$show_legend) "right" else "none",
                legend.title = ggplot2::element_text(size = 10),
                legend.text = ggplot2::element_text(size = 8),
                strip.background = ggplot2::element_rect(
                    fill = "white",
                    color = "white"
                ),
                strip.text = ggplot2::element_text(
                    size = 12,
                    face = "bold",
                    margin = ggplot2::margin(b = 10, t = 10)
                ),
                panel.grid = ggplot2::element_blank(),
                axis.text = ggplot2::element_blank(),
                axis.title = ggplot2::element_blank()
            )

            print(p)
            TRUE
        }
    )
)
