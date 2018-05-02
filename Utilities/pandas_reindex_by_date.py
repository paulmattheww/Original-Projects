fill_fwd_bwd = lambda df_col: df_col.fillna(method='ffill').fillna(method='bfill')

hogan_daily = pd.DataFrame()
dates = pd.date_range('2016-01-01', '2018-04-25', freq='D')
for grp, df in hogan_byday.groupby('loc'):
    df['date'] = pd.to_datetime(df['date'])
    df.set_index('date', inplace=True, drop=False)
    df = df.reindex(dates)
    df['loc'] = fill_fwd_bwd(df['loc'])
    df = df.fillna(0)
    df.reset_index(inplace=True)
    df['date'] = df['index']
    df.drop(columns='index', inplace=True)
    hogan_daily = hogan_daily.append(df)
