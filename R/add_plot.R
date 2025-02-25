#' @importFrom ggplot2 ggplot_add
#' @export
ggplot_add.ggplot <- function(object, plot, object_name) {
  patches <- get_patches(plot)
  add_patches(object, patches)
}
#' @importFrom ggplot2 ggplot_add
#' @export
ggplot_add.grob <- function(object, plot, object_name) {
  plot + wrap_elements(full = object)
}
#' @importFrom ggplot2 ggplot_add
#' @export
ggplot_add.formula <- ggplot_add.grob
# Convert a plot with a (possible) list of patches into a selfcontained
# patchwork to be attached to another plot
get_patches <- function(plot) {
  empty <- is_empty(plot)
  if (is_patchwork(plot)) {
    patches <- plot$patches
    plot$patches <- NULL
    class(plot) <- setdiff(class(plot), 'patchwork')
  } else {
    patches <- new_patchwork()
  }
  if (!empty) {
    patches$plots <- c(patches$plots, list(plot))
  }
  patches
}
is_patchwork <- function(x) inherits(x, 'patchwork')
as_patchwork <- function(x) {
  UseMethod('as_patchwork')
}
as_patchwork.default <- function(x) {
  stop('Don\'t know how to convert an object of class <', paste(class(x), collapse = ', '),'> to a patchwork', call. = FALSE)
}
as_patchwork.ggplot <- function(x) {
  class(x) <- c('patchwork', class(x))
  x$patches <- new_patchwork()
  x
}
as_patchwork.patchwork <- function(x) x

add_patches <- function(plot, patches) {
  UseMethod('add_patches')
}
add_patches.ggplot <- function(plot, patches) {
  plot <- as_patchwork(plot)
  plot$patches <- patches
  plot
}
add_patches.patchwork <- function(plot, patches) {
  patches$plots <- c(patches$plots, list(plot))
  add_patches(plot_filler(), patches)
}
new_patchwork <- function() {
  list(
    plots = list(),
    layout = plot_layout(),
    annotation = plot_annotation()
  )
}
#' @importFrom ggplot2 ggplot
plot_filler <- function() {
  p <- ggplot()
  class(p) <- c('plot_filler', class(p))
  p
}
is_empty <- function(x) inherits(x, 'plot_filler')

