breakage_by_class = function(pwbreakage) {
  headTail = function(x) {
    h = head(x)
    t = tail(x)
    print(h)
    print(t)
  }
  
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
  print(invert1)
  
  
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
  print(invert2)
  
  
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
  print(invert3)
  
}
