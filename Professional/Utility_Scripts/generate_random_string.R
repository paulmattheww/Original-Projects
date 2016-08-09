set.seed(9999)

generate_random_string = function(n=1, length=12)
{
  rand_str = c(1:n)                  
  for(i in 1:n)
  {
    rand_str[i] = paste(sample(c(0:9, letters, LETTERS),
                                    length, replace=TRUE),
                             collapse="")
  }
  rand_str = make.unique(rand_str)
  return(rand_str)
}
