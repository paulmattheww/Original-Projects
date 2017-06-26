
# coding: utf-8

# In[1]:

import pandas as pd
import numpy as np

class income_statement:
    def __init__(self, name, sales, cogs, sga, da, interest, tax_rate):
        self.name = name
        self.sales = sales
        self.cogs = cogs
        self.gross_profit = sales-cogs
        self.sga = sga
        self.ebitda = self.gross_profit - sga
        self.da = da
        self.ebit = self.ebitda - da
        self.interest = interest
        self.ebt = self.ebit-interest
        self.tax = tax_rate*self.ebt
        self.net_income = self.ebt - self.tax
        self.nopat = (1-tax_rate)*self.ebit
    def print_statement(self):
        print('''
        Income Statement
        _________________________________________________________________________
        
        Sales/Revenue ......................................... %.2f
        -Cost of Goods Sold ......................................... %.2f
        _________________________________________________________________________
        Gross Profit ......................................... %.2f
        -Sales General & Admin. ......................................... %.2f
        _________________________________________________________________________
        EBITDA ......................................... %.2f
        -Depreciation/Amortization ......................................... %.2f
        _________________________________________________________________________
        EBIT ......................................... %.2f
        -Interest Expense ......................................... %.2f
        _________________________________________________________________________
        EBT ......................................... %.2f
        -Taxes ......................................... %.2f
        _________________________________________________________________________
        Net Income ......................................... %.2f
        
        '''%(self.sales, self.cogs, self.gross_profit, self.sga, self.ebitda, self.da, self.ebit, 
            self.interest, self.ebt, self.tax, self.net_income))


# In[2]:

class balance_sheet:
    def __init__(self, cash, ar, inventory, ppe, ap, longterm_debt, stock, retained):
        ## Assets
        self.cash = cash
        self.ar = ar
        self.inventory = inventory
        self.total_current_assets = cash+ar+inventory
        self.ppe = ppe
        self.total_longterm_assets = ppe +0#placeholder for extensions
        self.total_assets = self.total_current_assets + self.total_longterm_assets
        ## Liabilities & equity
        self.ap = ap
        self.total_current_liabilities = ap +0#placeholder for extensions
        self.longterm_debt = longterm_debt
        self.total_liabilities = self.total_current_liabilities + self.longterm_debt
        self.stock = stock
        self.retained = retained
        self.total_equity = stock + retained
        self.total_liabilities_equity = self.total_liabilities + self.total_equity
    
    def print_balance_sheet(self):
        print('''
        Assets
        ___________________________________________________________
        Cash & Equivalents .............................. %.4f
        Accounts Receivable .............................. %.4f
        Inventories .............................. %.4f
        ___________________________________________________________
        Total Current Assets .............................. %.4f
        ___________________________________________________________
        Net Property Plant & Equipment .............................. %.4f
        Total Long-Term Assets .............................. %.4f
        ___________________________________________________________
        Total Assets .............................. %.4f
        
        Liabilities
        ___________________________________________________________
        Accounts Payable .............................. %.4f
        ___________________________________________________________
        Total Current Liabilities .............................. %.4f        
        ___________________________________________________________
        Long-Term Debt .............................. %.4f
        ___________________________________________________________
        Total Liabilities .............................. %.4f
        
        Equity
        ___________________________________________________________
        Common Stock .............................. %.4f
        Retained Earnings .............................. %.4f
        ___________________________________________________________
        Total Stockholders Equity .............................. %.4f
        ___________________________________________________________
        Total Liabilities & Equity .............................. %.4f
        
        '''%(self.cash, self.ar, self.inventory, self.total_current_assets, self.ppe, self.total_longterm_assets,
             self.total_assets, self.ap, self.total_current_liabilities, self.longterm_debt, self.total_liabilities,
             self.stock, self.retained, self.total_equity, self.total_liabilities_equity) )


# In[3]:

class financial_metrics:
    def __init__(self, income_statement, balance_sheet):
        ## Income statement
        self.sales = income_statement.sales
        self.cogs = income_statement.cogs
        self.gross_profit = income_statement.gross_profit
        self.sga = income_statement.sga
        self.ebitda = income_statement.ebitda
        self.da = income_statement.da
        self.ebit = income_statement.ebit
        self.interest = income_statement.interest
        self.ebt = income_statement.ebt
        self.tax = income_statement.tax
        self.net_income = income_statement.net_income
        self.nopat = income_statement.nopat
        self.gross_margin = self.gross_margin()
        self.operating_margin = self.operating_margin()
        self.net_margin = self.net_margin()
        ## Balance sheet
        ## Assets
        self.cash = balance_sheet.cash
        self.ar = balance_sheet.ar
        self.inventory = balance_sheet.inventory
        self.total_current_assets = balance_sheet.total_current_assets
        self.ppe = balance_sheet.ppe
        self.total_longterm_assets = balance_sheet.total_longterm_assets
        self.total_assets = balance_sheet.total_assets
        ## Liabilities
        self.ap = balance_sheet.ap
        self.total_current_liabilities = balance_sheet.total_current_liabilities
        self.longterm_debt = balance_sheet.longterm_debt
        self.total_liabilities = balance_sheet.total_liabilities
        self.stock = balance_sheet.stock
        self.retained = balance_sheet.retained
        self.total_equity = balance_sheet.total_equity
        self.total_liabilities_equity = balance_sheet.total_liabilities_equity
        ## Metrics
        self.asset_turnover = self.asset_turnover()
        self.inventory_turnover = self.inventory_turnover()
        self.ar_turnover = self.ar_turnover()
        self.ap_turnover = self.ap_turnover()
        self.roa = self.return_on_assets()
        self.roe = self.return_on_equity()
        self.invested_capital = self.invested_capital()
        self.roic = self.return_on_invested_capital()
        self.gmroi = self.gmroi()
        
    def gross_margin(self):
        return self.gross_profit / self.sales
    def operating_margin(self):
        return self.ebitda / self.sales
    def net_margin(self):
        return self.net_income / self.sales
    def asset_turnover(self):
        return self.sales / self.total_assets
    def inventory_turnover(self):
        return self.cogs / self.inventory
    def ar_turnover(self):
        return self.sales / self.ar
    def ap_turnover(self):
        return self.cogs / self.ap
    def return_on_assets(self):
        return self.net_income / self.total_assets
    def return_on_equity(self):
        return self.net_income / self.total_equity
    def invested_capital(self):
        return self.total_equity + self.longterm_debt
    def return_on_invested_capital(self):
        return self.nopat / self.invested_capital
    def gmroi(self):
        return self.gross_margin * self.inventory_turnover
    def print_metrics(self):
        print('''
        Financial Metrics:
        _______________________________________________________________
        Gross Margin .............................. %.5f
        Operating Margin .............................. %.5f
        Net Margin .............................. %.5f
        Asset Turnover .............................. %.5f
        Inventory Turnover .............................. %.5f
        AR Turnover .............................. %.5f
        AP Turnover .............................. %.5f
        Return on Assets .............................. %.5f
        Return on Equity .............................. %.5f
        NOPAT .............................. %.5f
        Invested Capital .............................. %.5f
        Return on Invested Capital .............................. %.5f
        Gross Margin Return on Inventory .............................. %.5f
        
        '''%(self.gross_margin, self.operating_margin, self.net_margin, self.asset_turnover, self.inventory_turnover,
            self.ar_turnover, self.ap_turnover, self.roa, self.roe, self.nopat, self.invested_capital, 
            self.roic, self.gmroi))

income_b = income_statement(name='bonsa', sales=14000, cogs=11000, sga=1200, da=0, interest=240, tax_rate=.4)
income_b.print_statement()
        
balance_b = balance_sheet(cash=500, ar=3000, inventory=2800, ppe=5000, ap=900, longterm_debt=4800, stock=4200, retained=1400)
balance_b.print_balance_sheet()

metrics_b = financial_metrics(income_b, balance_b)
metrics_b.print_metrics()


# In[4]:

income_o = income_statement(name='osun', sales=5000, cogs=3500, sga=600, da=0, interest=0, tax_rate=.3)
income_o.print_statement()
        
balance_o = balance_sheet(cash=500, ar=550, inventory=700, ppe=2500, ap=550, longterm_debt=0, stock=2900, retained=800)
balance_o.print_balance_sheet()

metrics_o = financial_metrics(income_o, balance_o)
metrics_o.print_metrics()


# In[5]:

## GA1 W10 Osun 
## Osun FY0 not FY1 (above)
income_o = income_statement(name='osun', sales=6000, cogs=3900, sga=700, da=0, interest=0, tax_rate=.3)
income_o.print_statement()
        
balance_o = balance_sheet(cash=500, ar=700, inventory=1000, ppe=3500, ap=600, longterm_debt=0, stock=4100, retained=1000)
balance_o.print_balance_sheet()

metrics_o = financial_metrics(income_o, balance_o)
metrics_o.print_metrics()


# In[ ]:




# In[ ]:




# In[ ]:



