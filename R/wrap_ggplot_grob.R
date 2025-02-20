#' Make a gtable created from a ggplot object patchwork compliant
#'
#' This function converts a gtable, as produced by [ggplot2::ggplotGrob()] and
#' makes it ready to be added to a patchwork. In contrast to passing
#' the gtable to [wrap_elements()], `wrap_ggplot_grob()` ensures proper
#' alignment as expected. On the other hand major restructuring of the gtable
#' will result in an object that doesn't work properly with
#' `wrap_ggplot_grob()`.
#'
#' @param x A gtable as produced by [ggplot2::ggplotGrob()]
#'
#' @return A `table_patch` object to be added to a patchwork
#'
#' @export
wrap_ggplot_grob <- function(x) {
  stopifnot(inherits(x, 'gtable'))
  stopifnot(length(x$widths) <= TABLE_COLS)
  stopifnot(length(x$heights) <= TABLE_ROWS)
  patch <- make_patch()
  class(patch) <- c('table_patch', class(patch))
  attr(patch, 'table') <- x
  patch
}
#' @export
patchGrob.table_patch <- function(x, guides = 'auto') {
  gt <- attr(x, 'table')
  gt <- add_strips(gt)
  add_guides(gt, guides == 'collect')
}
