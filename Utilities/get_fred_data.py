# paul washburn
import pandas_datareader.data as web
from datetime import datetime
import pandas as pd

series_list = ['SP500', 'NASDAQCOM', 'DJIA', 'RU2000PR',
              'BOGMBASEW', 'DEXJPUS', 'DEXUSEU', 'DEXCHUS', 'DEXUSAL',
              'VIXCLS',
              'USDONTD156N', 'USD1MTD156N', 'USD3MTD156N', 'USD12MD156N',
              'BAMLHYH0A0HYM2TRIV', 'BAMLCC0A1AAATRIV',
              'GOLDAMGBD228NLBM', 
              'DCOILWTICO',
              'MHHNGSP', # natural gas
              'VXXLECLS'] # cboe energy sector etf volatility
start = datetime(2011, 1, 1)
end = datetime.now()

def get_fred_data(series_list, start, end):
    fred_df = pd.DataFrame()
    for i, series in enumerate(series_list):
        print('Calling FRED API for Series:  {}'.format(series))
        if i == 0:
            fred_df = web.get_data_fred(series, start, end)
        else:
            _df = web.get_data_fred(series, start, end)
            fred_df = fred_df.join(_df, how='outer')
    return fred_df

econ_df = get_fred_data(series_list, start, end)
econ_df.head()
