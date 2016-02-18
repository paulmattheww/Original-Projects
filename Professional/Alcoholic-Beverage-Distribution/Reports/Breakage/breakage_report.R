
breakage_by_class_incidents = function(breaks) {
  spread1 = aggregate(CASES ~ X.RCODE + PTYPE, data=breaks, FUN=length)
  spread1 = data.frame(spread1)
  moneyShot1 = spread(spread1, PTYPE, CASES)
  names(moneyShot1) = c("Reason.Code", "Liquor (1)", "Wine (2)", "Beer (3)", "Non-Alc (4)")
  reason = moneyShot1$Reason.Code
  moneyShot1$Reason.Code = ifelse(reason == 2, "Sales (2)", 
                                  ifelse(reason == 3, "Warehouse (3)",
                                         ifelse(reason==4, "Driver (4)", 
                                                ifelse(reason==5, "Columbia (5)", ""))))
  names(moneyShot1) =c("", "Liquor (1)", "Wine (2)", "Beer (3)", "Non-Alc (4)")
  invert1 = data.frame(t(moneyShot1))
  names(invert1) = c('Sales (2)', 'Warehouse (3)', 'Driver (4)', 'Columbia (5)')
  invert1 = invert1[-c(1) ,]
  print(invert1)
}

breakage_by_class_cost = function(breaks) {
  breaks$EXT_COST = as.numeric(as.character(breaks$EXT_COST))
  spread2 = aggregate(EXT_COST ~ X.RCODE + PTYPE, data=breaks, FUN=sum)
  spread2 = data.frame(spread2)
  moneyShot2 = spread(spread2, PTYPE, EXT_COST)
  names(moneyShot2) = c("Reason.Code", "Liquor (1)", "Wine (2)", "Beer (3)", "Non-Alc (4)")
  reason = moneyShot2$Reason.Code
  moneyShot2$Reason.Code = ifelse(reason == 2, "Sales (2)", 
                                  ifelse(reason == 3, "Warehouse (3)",
                                         ifelse(reason==4, "Driver (4)", 
                                                ifelse(reason==5, "Columbia (5)", ""))))
  names(moneyShot2) =c("", "Liquor (1)", "Wine (2)", "Beer (3)", "Non-Alc (4)")
  invert2 = data.frame(t(moneyShot2))
  names(invert2) = c("Liquor (1)", "Wine (2)", "Beer (3)", "Non-Alc (4)")
  invert2 = invert2[-c(1) ,]
  print(invert2)
}


breakage_by_class_summary = function(breaks) {
  spread3 = aggregate(as.numeric(as.character(CASES)) ~ X.RCODE, data=breaks, FUN=sum)
  spread3 = data.frame(spread3)
  moneyShot3 = spread3
  names(moneyShot3) = c("Reason.Code", "Cases.Broken")
  reason = moneyShot3$Reason.Code
  moneyShot3$Reason.Code = ifelse(reason == 2, "Sales (2)", 
                                  ifelse(reason == 3, "Warehouse (3)",
                                         ifelse(reason==4, "Driver (4)", 
                                                ifelse(reason==5, "Columbia (5)", ""))))
  names(moneyShot3) =c("", "Cases.Broken")
  moneyShot3
  invert3 = data.frame(t(moneyShot3))
  names(invert3) = c('Sales (2)', 'Warehouse (3)', 'Driver (4)', 'Columbia (5)')
  invert3 = invert3[-c(1) ,]
  print(invert3)
}




warehouse_breakage_by_item = function(breaks) {
  library(dplyr)
  
  breaks$CASES = round(breaks$X.RCASE + (breaks$X.RBOTT / breaks$X.RQPC), 2)
  
  #Warehouse is code 3
  warehouse = breaks %>% filter(X.RCODE == 3)
  warehouse = warehouse[, c('X.RDESC', 'X.RSIZE', 'CASES', 'EXT_COST')]
  
  whse_cost = aggregate(EXT_COST ~ X.RDESC + X.RSIZE, data=warehouse, FUN=sum)
  whse_cases = aggregate(CASES ~ X.RDESC + X.RSIZE, data=warehouse, FUN=sum)
  
  whse_summary = merge(whse_cases, whse_cost, by=c('X.RDESC', 'X.RSIZE'))
  whse_summary = arrange(whse_summary, CASES)
  names(whse_summary) = c('DESCRIPTION', 'SIZE', 'SUM.CASES', 'SUM.COST')
  
  whse_summary
}


driver_breakage_by_item = function(breaks) {
  library(dplyr)
  
  breaks$CASES = round(breaks$X.RCASE + (breaks$X.RBOTT / breaks$X.RQPC), 2)
  
  #driver is code 3
  driver = breaks %>% filter(X.RCODE == 4)
  driver = driver[, c('X.RDESC', 'X.RSIZE', 'CASES', 'EXT_COST')]
  
  drv_cost = aggregate(EXT_COST ~ X.RDESC + X.RSIZE, data=driver, FUN=sum)
  drv_cases = aggregate(CASES ~ X.RDESC + X.RSIZE, data=driver, FUN=sum)
  
  drv_summary = merge(drv_cases, drv_cost, by=c('X.RDESC', 'X.RSIZE'))
  drv_summary = arrange(drv_summary, CASES)
  names(drv_summary) = c('DESCRIPTION', 'SIZE', 'SUM.CASES', 'SUM.COST')
  
  drv_summary
}

