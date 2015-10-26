moveRenameFile <- function(from, to) {
  destination <- dirname(to)
  if (!isTRUE(file.info(destination)$isdir)) dir.create(destination, recursive=TRUE)
  file.rename(from = from,  to = to)
}
