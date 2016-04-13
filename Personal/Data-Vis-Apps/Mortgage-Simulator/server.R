# server.R
library(shiny)
library(ggplot2)
library(gridExtra)
library(ggthemes)
library(dplyr)
library(scales)

# runApp('C:/Users/Paul/Documents/R/Applications/Mortgage')

# term=30; principal=236000; down=0.2; interest=0.0425; irr=0.05
simulate_data = function(term, principal, down, interest, irr) {
  
  n_months = term * 12
  Month = seq(1, n_months, by=1)
  monthly_interest_rate = interest / 12
  beg_principal = round(principal - (down * principal), 0)
  
  mortgage = data.frame(Month)
  
  
  payment = beg_principal * ( monthly_interest_rate * (1 + monthly_interest_rate) ^ n_months) / 
    ((1 + monthly_interest_rate) ^ n_months - 1)
  payment = round(payment, 0)
  mortgage$Payment = payment
 
 
  mortgage$Remaining.Principal = 0
  # B = balance B = L[(1 + c)^n - (1 + c)^p]/[(1 + c)^n - 1]
  index = seq(2, n_months)
  amt_left = NULL
  for (i in 1:length(index)) {
    amt_left[i] = beg_principal * ((1 + monthly_interest_rate) ^ n_months - (1 + monthly_interest_rate) ^ i) /
    ((1 + monthly_interest_rate) ^ n_months - 1)
    amt_left
  }
  mortgage[c(2:n_months),'Remaining.Principal'] = round(amt_left)
  mortgage[1,'Remaining.Principal'] = beg_principal
  amt_left = mortgage$Remaining.Principal
  
  
  mortgage$Interest.Paid  = round(amt_left * monthly_interest_rate, 0)
  
  index = seq(1, n_months)
  raw_int = mortgage$Interest.Paid
  monthly_irr = irr / 12
  pv_int = NULL
  
  for (i in 1:length(index)) {
    pv_int[i] = raw_int[i] / (1 + monthly_irr) ^ index[i]
    pv_int
  }
  
  mortgage$PV.Interest.Paid = round(pv_int)
  
  mortgage = data.frame(mortgage %>% mutate(PV.Cumulative.Interest.Paid = cumsum(PV.Interest.Paid)))
  mortgage$PV.Cumulative.Interest.Paid = round(mortgage$PV.Cumulative.Interest.Paid, 0)
  
  mortgage 
}




shinyServer(
  function(input, output) {
    
    mortgage_data = reactive({
      mortgage_manifestation = simulate_data(term=30, principal=input$principal, 
                                             down=input$down, interest=input$interest,
                                             irr=input$opportunity_cost)

      return(mortgage_manifestation)
    })
    
   
    intial_loan_value = reactive ({
      input$principal - (input$principal * input$down)
    })
    
    output$plot1 <- renderPlot({
      g = ggplot(data=mortgage_data(), aes(x=Month, y=Remaining.Principal))
      g + geom_bar(stat='identity', size=0.1, alpha=0.2, fill='blue') + 
        geom_point(data=mortgage_data(), aes(x=Month, y=PV.Cumulative.Interest.Paid), size=1, alpha=0.5) +
        geom_line(data=mortgage_data(), aes(x=Month, y=PV.Cumulative.Interest.Paid), colour='red', size=2, alpha=0.7) +
        scale_y_continuous(labels=dollar) +
        ggtitle(expression(atop('Remaining Loan Balance (BLUE) v. NPV of Accumulated Interest Payments', 
                                atop(italic('Manipulate Assumptions Using Sliders'))))) +
        geom_hline(yintercept=as.numeric(intial_loan_value())) +
        labs(y='Dollars')
    })
    
    output$mortgage_data = renderDataTable({
      mortgage_data()
    })
  
    output$npv_interest = reactive({
      net = scales::dollar(tail(mortgage_data()$PV.Cumulative.Interest.Paid, 1))
      net
    })
    
    total_cost_of_loan = reactive({
      o = scales::dollar(tail(mortgage_data()$PV.Cumulative.Interest.Paid, 1) + (input$principal - (input$principal * input$down)) )
      o
    })
    
    output$total_cost_of_loan = reactive({
      total_cost_of_loan()
    })
   
    output$payment = reactive({
      scales::dollar(tail(mortgage_data()$Payment, 1))
    })
    
  })
