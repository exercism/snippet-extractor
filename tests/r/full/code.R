#!/usr/bin/env Rscript
# Game of Life exemplar
# Each generation is computed from the previous one.

library(dplyr)
require(stringr)

tick <- function(cells) {
  coords <- expand.grid(seq_len(nrow(cells)), seq_len(ncol(cells)))

  # Count the live neighbours of each cell
  matrix(apply(coords, 1, function(coord) {
    cell <- cells[coord[1], coord[2]]
    rows <- max(1, coord[1] - 1):min(nrow(cells), coord[1] + 1)
    cols <- max(1, coord[2] - 1):min(ncol(cells), coord[2] + 1)
    alive <- sum(cells[rows, cols]) - cell
    as.integer(alive == 3 || (cell == 1 && alive == 2))
  }), nrow = nrow(cells))
}
