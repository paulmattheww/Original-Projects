breakage_by_class = function(breaks) {
  #pwbreakage query is input
  print('Isolate counts of incidents by type')
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
  print('By incidents:')
  names(invert1) = c('Sales (2)', 'Warehouse (3)', 'Driver (4)', 'Columbia (5)')
  invert1 = invert1[-c(1) ,]
  print(invert1)
  
  print('------------------------------------------------------')
  
  print('Isolate breakage by EXT COST')
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
  print('By dollars:')
  names(invert2) = c("Liquor (1)", "Wine (2)", "Beer (3)", "Non-Alc (4)")
  invert2 = invert2[-c(1) ,]
  print(invert2)
  
  print('------------------------------------------------------')
  
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
  print('Summary:')
  names(invert3) = c('Sales (2)', 'Warehouse (3)', 'Driver (4)', 'Columbia (5)')
  invert3 = invert3[-c(1) ,]
  print(invert3)
  print('------------------------------------------------------')
  
  print('Compare these to Excel; copy/paste into *_breakage_2016.xlsx')
}
