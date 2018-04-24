# -*- coding: utf-8 -*-
"""
Self-Authored Modules
Paul Washburn
"""
import numpy as np
import pandas as pd
from datetime import datetime as dt



class forecasting_model(object):
    def input_data(self, period, demand):
        self.period = period
        self.demand = demand
        df = pd.DataFrame({'Period':period, 'ActualDemand':demand})
        df.set_index('Period', drop=True, inplace=True)
        return df
    
    def coef_var(self, df):
        CV = df.ActualDemand.std() / df.ActualDemand.mean()
        print('Coefficient of Variation = %.4f' %CV)
        return CV
    
    def exponential_forecast(self, df, alpha, seed):
        exp, alpha_not = [], 1 - alpha
        new_value = seed #df.loc[1, 'ActualDemand']
        exp.append(new_value)
        ix = 1
        while ix < len(df):
            list_ix = ix-1
            new_value = df.loc[ix, 'ActualDemand']*alpha + exp[list_ix]*alpha_not
            exp.append(new_value)
            ix += 1
        mape_exp = abs(exp - df.ActualDemand.shift(-1))/df.ActualDemand.shift(-1)
        print('MAPE for Exponential Smoothing = %.4f' % np.mean(mape_exp))
        return exp, mape_exp
    
    def naive_forecast(self, df):
        naive = df.ActualDemand
        mape_naive = abs(naive - df.ActualDemand.shift(-1))/df.ActualDemand.shift(-1)
        print('MAPE for Naive = %.4f' % np.mean(mape_naive))
        return naive, mape_naive
    
    def cumulative_forecast(self, df):
        cumulative = df.ActualDemand.rolling(window=len(df), min_periods=1).mean()
        mape_cumulative = abs(cumulative - df.ActualDemand.shift(-1))/df.ActualDemand.shift(-1)
        print('MAPE for Cumulative = %.4f' % np.mean(mape_cumulative))
        return cumulative, mape_cumulative
    
    def rollingmean_forecast(self, df, periods):
        rollmean = df.ActualDemand.rolling(window=periods).mean()
        mape_rollmean = abs(rollmean - df.ActualDemand.shift(-1))/df.ActualDemand.shift(-1)
        print('MAPE for %s-Period Moving Avg = %.4f' % (str(periods), np.mean(mape_rollmean)))
        return rollmean, mape_rollmean
    
    def level_trend_forecast(self, df, alpha, beta, a_1, b_1, omega, phi):
        level, trend, estimate = [a_1], [b_1], [a_1+b_1]
        damp_level, damp_trend, damp_estimate = [a_1], [b_1], [a_1+b_1]
        alpha_not, beta_not = 1-alpha, 1-beta
        i = 2
        while i < len(df)+1:
            last_ix, last_ix_ls = i-1, i-2
            a_new = alpha*df.loc[i, 'ActualDemand'] + alpha_not*estimate[last_ix_ls]
            a_damp_new = alpha*df.loc[i, 'ActualDemand'] + alpha_not*damp_estimate[last_ix_ls]
            level.append(a_new)
            damp_level.append(a_damp_new)
            
            b_new = beta*(level[last_ix] - level[last_ix_ls]) + beta_not*trend[last_ix_ls]
            b_damp_new = beta*(damp_level[last_ix] - damp_level[last_ix_ls]) + beta_not*phi*damp_trend[last_ix_ls]
            trend.append(b_new)
            damp_trend.append(b_damp_new)
            
            x_new = a_new+b_new
            x_damp_new = a_damp_new+b_damp_new
            estimate.append(round(x_new, 2))
            damp_estimate.append(round(x_damp_new, 2))
            i += 1
        mape_level_trend = abs(estimate - df.ActualDemand.shift(-1))/df.ActualDemand.shift(-1)
        mape_damp_level_trend = abs(damp_estimate - df.ActualDemand.shift(-1))/df.ActualDemand.shift(-1)
        print('''
        MAPE for Level-Trend = %.4f
        MAPE for Dampened Level-Trend = %.4f
        ''' % (np.mean(mape_level_trend), np.mean(mape_damp_level_trend)))
        return level, trend, estimate, mape_level_trend, damp_level, damp_trend, damp_estimate, mape_damp_level_trend
    
    def get_rmse(self, df, omega, err_1):
        omega_not = 1-omega
        models = ['Exponential','Naive','Cumulative','LevelTrend']
        columns = [m+'_Forecast' for m in models]
        
        for col in columns:
            mse_estimate, i = [], 1
            MSE, RMSE = 'MSE_Estimate_'+str(col), 'RMSE_Estimate_'+str(col)
            while i < len(df)+1:
                last_ix_ls, last_ix_df = i-2, i-1
                if i <= 2:
                    new_mse = err_1**2
                    mse_estimate.append(new_mse)
                    df.loc[i, MSE] = new_mse
                    df.loc[i, RMSE] = np.sqrt(new_mse)
                    i += 1
                else:
                    last_mse = mse_estimate[last_ix_ls]
                    squared_error = (df.loc[i, 'ActualDemand'] - df.loc[last_ix_df, col])**2
                    new_mse = omega*squared_error + omega_not*last_mse
                    mse_estimate.append(new_mse)
                    df.loc[i, MSE] = new_mse
                    df.loc[i, RMSE] = np.sqrt(new_mse)
                    i += 1
                rmse_estimate = np.sqrt(mse_estimate)
            rmse = np.mean(rmse_estimate)
            mse = np.mean(mse_estimate)
            #MSE, RMSE = 'SquaredError_'+str(col), 'RootSquaredError_'+str(col)
            print('''
            MSE for %s = %.2f
            RMSE for %s = %.2f
            ''' %(col, mse, col, rmse))
        return mse_estimate, rmse_estimate

            
    def generate_all_forecasts(self, df, periods, alpha, beta, a_1, b_1, omega, err_1, seed, phi):
        df['Exponential_Forecast'],df['Exponential_MAPE'] = self.exponential_forecast(df, alpha, seed)
        df['Naive_Forecast'],df['Naive_MAPE'] = self.naive_forecast(df)
        df['Cumulative_Forecast'],df['Cumulative_MAPE'] = self.cumulative_forecast(df)
        for p in periods:
            cols = ['_Forecast', '_MAPE']
            col_names = [str(p)+'RollingAvg'+str(nam) for nam in cols]
            df[col_names[0]], df[col_names[1]] = self.rollingmean_forecast(df, p)
        df['Level'],df['Trend'],df['LevelTrend_Forecast'],df['LevelTrend_MAPE'],df['DampLevel'],df['DampTrend'],df['DampLevelTrend_Forecast'],df['DampLevelTrend_MAPE'] = self.level_trend_forecast(df, alpha, beta, a_1, b_1, omega, phi)
        self.coef_var(df)
        #self.get_rmse(df, omega, err_1)
        print(df)
        return df
        

f_name = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/Product Forecasting/sku time series by day.csv'
csv = pd.read_csv(f_name, header=0)

csv['Invoice Date'] = dat = [dt.date(dt.strptime(d, '%m/%d/%Y')) for d in csv['Invoice Date']]
csv['Week'] = [format(d, '%W') for d in dat]
csv['Year'] = [format(d, '%Y') for d in dat]
csv = pd.DataFrame(csv.groupby(['Year','Week'])['Non Std Cases'].sum()).reset_index(drop=False)
csv['Period'] = np.arange(1, len(csv)+1)

print(csv.head())

DF = forecasting_model().input_data(csv['Period'], csv['Non Std Cases'])
DF = forecasting_model().generate_all_forecasts(DF, 
                                                periods=[5,10], 
                                                alpha=.333, 
                                                beta=.25,
                                                a_1=600, 
                                                b_1=-20, 
                                                omega=.2,
                                                err_1=10,
                                                seed=600,
                                                phi=0.6)



plot_cols = ['ActualDemand','Cumulative_Forecast',#'5RollingAvg_Forecast','10RollingAvg_Forecast',
             'Exponential_Forecast','LevelTrend_Forecast','DampLevelTrend_Forecast']
DF.plot(y=plot_cols, kind='line', subplots=False, figsize=(15,10))
