library(tidyverse)

setwd("~/Desktop/fashion-mnist-csv/")

load_image_file <- function(filename) {
  ret = list()
  f = file(filename, 'rb')
  readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  ret$n = readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  nrow = readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  ncol = readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  x = readBin(f, 'integer', n = ret$n * nrow * ncol, size = 1, signed = F)
  ret$x = matrix(x, ncol = nrow * ncol, byrow = T)
  close(f)
  ret
}
load_label_file <- function(filename) {
  f = file(filename, 'rb')
  readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  n = readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  y = readBin(f, 'integer', n = n, size = 1, signed = F)
  close(f)
  y
}

train <- load_image_file('~/Downloads/fashion-mnist/data/fashion/train-images-idx3-ubyte')
train$y <- load_label_file('~/Downloads/fashion-mnist/data/fashion/train-labels-idx1-ubyte')

fashion_train <- as_data_frame(train$x) %>%
  mutate(y = train$y) %>%
  sample_n(1000)

test <- load_image_file('~/Downloads/fashion-mnist/data/fashion/t10k-images-idx3-ubyte')
test$y <- load_label_file('~/Downloads/fashion-mnist/data/fashion/t10k-labels-idx1-ubyte')  

fashion_test <- as_data_frame(test$x) %>%
  mutate(y = test$y) %>%
  sample_n(1000)

write_csv(fashion_train, "fashion_train.csv")
write_csv(fashion_test, "fashion_test.csv")
