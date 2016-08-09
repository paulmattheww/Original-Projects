

# for roadnet consultants, 
# generate qty and dummy alpha numeric order ID
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')
library(xlsx)

fake_orders = read.csv('C:/Users/pmwash/Desktop/Disposable Docs/Customers.csv', header=TRUE); headTail(fake_orders)

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

n_orders = length(fake_orders$CustomerID)

fake_orders$OrderID = generate_random_string(n=n_orders, length=8)
fake_orders$Quantity = round(runif(n_orders, min=1, max=100))



write.xlsx(fake_orders, file='C:/Users/pmwash/Desktop/R_files/Data Output/fake_orders_omnitracs.xlsx',
           sheetName='fake orders')


