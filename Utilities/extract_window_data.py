# Paul M Washburn
def extract_window_data(df, window):
    window_data = list()
    for ix in range(df.shape[0] - window):
        end_ix = ix + window
        tmp = df[ix:end_ix].copy()
        window_data.append(tmp.values)
    return np.array(window_data)

extract_window_data(y_train, window=7)
