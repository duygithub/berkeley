library(broom)
library(dplyr)
library(ggplot2)

rmystery <- function(n){
  x = runif(n)
  y = runif(n, min=0, max = 1/x)
  data.frame(x=x,y=y)
}
plot(rmystery(100))


experiment_m <- function(number_of_samples) {
  data_frame = rmystery(100)
  sample_df = sample_n(data_frame, number_of_samples)
}

calculate_slope <- function(data_frame) {
  sample_result <= experiment_m(100)
  model <- lm(y ~x, data_frame)
  regression_coefficients <- coef(model)
  slope <- regression_coefficients[2]
}

for (i in 1:10) {
  sample_result <- experiment_m(100)
  model <- lm(y ~ x, sample_result)
  regression_coefficients <- coef(model)
  print(tidy(model))
}


slope_samples <- replicate(100, calculate_slope(sample_n(experiment_m(100), 100)))

slope_samples

min_slope <- min(slope_samples)
max_slope <- max(slope_samples)

print(paste("Minimum Slope:", min_slope))
print(paste("Maximum Slope:", max_slope))

hist(slope_samples,
     breaks = 100,
     xlim = c(-200, 0))
