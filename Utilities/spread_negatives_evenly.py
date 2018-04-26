# paul matthew washburn 
def spread_negatives_evenly(df, col):
    below_zero = df[col] < 0
    while np.sum(below_zero) >= 1:
        negs = df.loc[below_zero, col].abs().sum()
        nrow = df.loc[~below_zero, col].shape[0]
        spread = np.divide(negs, nrow)
        df.loc[~below_zero, col] = np.subtract(df.loc[~below_zero, col], spread) 
        df.loc[below_zero, col] = 0
        below_zero = df[col] < 0
    return df

hogan_byday = spread_negatives_evenly(hogan_byday, 'contract__billed_amount')
