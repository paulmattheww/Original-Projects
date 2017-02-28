
# coding: utf-8

# In[1]:

## Get some data from open source
## Pandas Yahoo Finance API
import numpy as np
import pandas as pd
import pandas.io.data as web
from datetime import datetime
pd.set_option('display.max_columns', None)
get_ipython().magic('matplotlib inline')
    
end = datetime.now()
start = datetime(end.year - 1, end.month, end.day)
df = web.DataReader("SPY", 'google', start, end)
df['Period'] = np.arange(1, len(df)+1)

wdayz = [format(dat, '%A') for dat in pd.to_datetime(df.index.values)]
df['Weekday'] = wdayz

print(df.groupby('Weekday')['Close'].mean() / df.Close.mean())

print(df.head())
print(df.shape)
df.Close.hist(figsize=(15, 6))


# In[2]:

import pandas as pd
import numpy as np
from datetime import datetime as dt
get_ipython().magic('matplotlib inline')

class forecasting_model(object):
    def input_data(self, period, demand):
        '''
        Input data should be scaled by period 
        use dictionary to convert if necessary
        '''
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
            try:
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
            except KeyError:
                pass
        mape_level_trend = abs(estimate - df.ActualDemand.shift(-1))/df.ActualDemand.shift(-1)
        mape_damp_level_trend = abs(damp_estimate - df.ActualDemand.shift(-1))/df.ActualDemand.shift(-1)
        print('''
        MAPE for Level-Trend = %.4f
        MAPE for Dampened Level-Trend = %.4f
        ''' % (np.mean(mape_level_trend), np.mean(mape_damp_level_trend)))
        return level, trend, estimate, mape_level_trend, damp_level, damp_trend, damp_estimate, mape_damp_level_trend
    
    
    def leveltrend_seasonality(self, df, alpha, beta, a_1, b_1, omega, phi, gamma, F_set, TAU):
        ## Set P & assert its sum
        P = len(F_set)
        assert np.sum(F_set) == P
        
        ## Add index rows BEFORE current dataset
        ix_small_less_P, ix_small = np.min(df.index.values) - P, np.min(df.index.values)
        ix_range = [ix for ix in range(ix_small_less_P, ix_small, 1)]
        for item, ix in enumerate(ix_range):
            df.loc[ix, 'Seasonality'] = df.loc[ix, 'SeasonalityUpdated'] = 0
            df.loc[ix, 'Seasonality'] = F_set[item]
            df.loc[ix, 'SeasonalityUpdated'] = F_set[item]
        df.sort_index(inplace=True)
        
        ## Perform calculations
        level, trend, estimate = [a_1], [b_1], [a_1+b_1]
        damp_level, damp_trend, damp_estimate = [a_1], [b_1], [a_1+b_1]
        alpha_not, beta_not, gamma_not = 1-alpha, 1-beta, 1-gamma
    
        i = 1
        while i < len(df)+1:
            try:
                last_ix, last_ix_ls, next_ix, last_ix_per = i-1, i-2, i+TAU, i-P
                actual, season = df.loc[i, 'ActualDemand'], df.loc[i-P, 'SeasonalityUpdated']
                a_new = alpha*(actual/season) + alpha_not*estimate[last_ix_ls]
                #a_damp_new = alpha*df.loc[i, 'ActualDemand'] + alpha_not*damp_estimate[last_ix_ls]
                level.append(a_new)
                df.loc[i, 'Level_Seasonal'] = a_new
                #damp_level.append(a_damp_new)

                b_new = beta*(level[last_ix] - level[last_ix_ls]) + beta_not*trend[last_ix_ls]
                df.loc[i, 'Trend_Seasonal'] = b_new
                #b_damp_new = beta*(damp_level[last_ix] - damp_level[last_ix_ls]) + beta_not*phi*damp_trend[last_ix_ls]
                trend.append(b_new)
                #damp_trend.append(b_damp_new)

                x_new = (a_new + TAU*b_new)*df.loc[next_ix-P, 'SeasonalityUpdated']
                df.loc[i, 'SeasonalLevelTrend_Forecast'] = a_new
                #x_damp_new = a_damp_new+b_damp_new
                estimate.append(round(x_new, 2))
                #damp_estimate.append(round(x_damp_new, 2))

                F_old = gamma*(actual/a_new) + gamma_not*season
                df.loc[i, 'Seasonality'] = F_old
                F_new = F_old * (P / sum(df.loc[:i]['Seasonality'].tail(P))) 
                df.loc[i, 'SeasonalityUpdated'] = F_new
                
                i += 1
            except KeyError:
                #print(df.head(10))
                pass
                i += 1
        
        last_ix = max(df.index.values)
        ix_drop = [int(ix) for ix in np.arange(np.min(df.index.values), 1, 1)]
        df.drop(ix_drop, axis=0, inplace=True)
        
        last_per_demand = df.iloc[:last_ix]['ActualDemand'].shift(-1)
        estimates = np.array(estimate[:last_ix])
        
        for_mape_df = pd.DataFrame({'Estimates':estimates, 'Actual':last_per_demand})
        for_mape_df = for_mape_df[for_mape_df.index.values < np.max(for_mape_df.index.values)]
        for_mape_df['AbsDiff'] = abs(np.subtract(for_mape_df.Estimates, for_mape_df.Actual))
        for_mape_df['ForMape'] = mape_level_trend = for_mape_df.AbsDiff / for_mape_df.Actual
        
        #mape_damp_level_trend = abs(damp_estimate - df.ActualDemand.shift(-1))/df.ActualDemand.shift(-1)
        print('''
        MAPE for Seasonal Level-Trend = %.4f
        ''' % (np.mean(mape_level_trend)))
        return level, trend, estimate, mape_level_trend
    
    
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

            
    def generate_all_forecasts(self, df, periods, alpha, beta, a_1, b_1, omega, err_1, seed, phi, gamma, F_set, TAU):
        df['Exponential_Forecast'],df['Exponential_MAPE'] = self.exponential_forecast(df, alpha, seed)
        df['Naive_Forecast'],df['Naive_MAPE'] = self.naive_forecast(df)
        df['Cumulative_Forecast'],df['Cumulative_MAPE'] = self.cumulative_forecast(df)
        for p in periods:
            cols = ['_Forecast', '_MAPE']
            col_names = [str(p)+'RollingAvg'+str(nam) for nam in cols]
            df[col_names[0]], df[col_names[1]] = self.rollingmean_forecast(df, p)
        df['Level'],df['Trend'],df['LevelTrend_Forecast'],df['LevelTrend_MAPE'],df['DampLevel'],df['DampTrend'],df['DampLevelTrend_Forecast'],df['DampLevelTrend_MAPE'] = self.level_trend_forecast(df, alpha, beta, a_1, b_1, omega, phi)
        
        self.leveltrend_seasonality(df, alpha, beta, a_1, b_1, omega, phi, gamma, F_set, TAU)
        self.coef_var(df)
        
        ix_plus1 = np.max(df.index.values) + 1
        df.loc[ix_plus1] = np.nan
        cols_to_shift = df.columns.tolist()
        cols_to_shift.remove('ActualDemand')
        df[cols_to_shift] = df[cols_to_shift].shift(1)
        
        print('The final output \n\n',df.head(),'\n\n')
        print(df.tail())
               
        return df




## Test models
DF = forecasting_model().input_data(df['Period'], df['Close'])
DF = forecasting_model().generate_all_forecasts(DF, 
                                                periods=[100,300], 
                                                alpha=.333, 
                                                beta=.25,
                                                a_1=200, 
                                                b_1=0, 
                                                omega=.2,
                                                err_1=10,
                                                seed=200,
                                                phi=0.6,
                                                gamma=.33, 
                                                F_set=[0.995781, 0.999371, 1.001138, 1.001047, 1.0026630000000003], 
                                                TAU=1)


# In[3]:

## Plot
plot_cols = ['ActualDemand','Cumulative_Forecast','DampLevelTrend_Forecast','SeasonalLevelTrend_Forecast']
DF.plot(y=plot_cols, kind='line', subplots=False, figsize=(15,10))


# In[4]:

f_name = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/Product Forecasting/sku time series by day.csv'
csv = pd.read_csv(f_name, header=0)

csv['Invoice Date'] = dat = [dt.date(dt.strptime(d, '%m/%d/%Y')) for d in csv['Invoice Date']]
csv['Week'] = [format(d, '%W') for d in dat]
csv['Year'] = [format(d, '%Y') for d in dat]
csv = pd.DataFrame(csv.groupby(['Year','Week'])['Non Std Cases'].sum()).reset_index(drop=False)
csv['Period'] = np.arange(1, len(csv)+1)

print(csv.head())
print(csv.tail())

DF = forecasting_model().input_data(csv['Period'], csv['Non Std Cases'])
DF = forecasting_model().generate_all_forecasts(DF, 
                                                periods=[4,8], 
                                                alpha=.333, 
                                                beta=.25,
                                                a_1=200, 
                                                b_1=0, 
                                                omega=.2,
                                                err_1=10,
                                                seed=200,
                                                phi=0.6,
                                                gamma=.33, 
                                                F_set=[1,1,1,1,1], 
                                                TAU=1)

plot_cols = ['ActualDemand','Cumulative_Forecast','DampLevelTrend_Forecast','SeasonalLevelTrend_Forecast']
DF.plot(y=plot_cols, kind='line', subplots=False, figsize=(15,10))

