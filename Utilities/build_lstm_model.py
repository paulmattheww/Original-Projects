from keras.models import *
from keras.layers import *

def extract_window_data(df, window=7):
    window_data = list()
    for ix in range(df.shape[0] - window):
        end_ix = ix + window
        tmp = df[ix:end_ix].copy()
        window_data.append(tmp.values)
    return np.array(window_data)

def build_lstm_model(input_data, output_size, neurons, metrics, batch_size,
                    activation, dropout, loss, optimizer):
    model = Sequential()
    model.add(LSTM(neurons, 
                   input_shape=(input_data.shape[1], input_data.shape[2]),
                   return_sequences=True))
    model.add(LSTM(neurons, return_sequences=True))
    model.add(LSTM(neurons))
    model.add(Dropout(dropout, seed=7))
    model.add(Dense(units=output_size))
    model.add(Activation(activation))
    model.compile(loss=loss, optimizer=optimizer, metrics=metrics)
    model.summary()
    return model


# transform labels into predictors
window = 10
X_train_lstm = extract_window_data(X_train, window=window)
X_val_lstm = extract_window_data(X_val, window=window)
X_test_lstm = extract_window_data(X_test, window=window)
y_train_lstm = y_train[window:]
y_val_lstm = y_val[window:]
y_test_lstm = y_test[window:]

# specify model
batch_size = 4
neurons = 20
epochs = 50

model = build_lstm_model(X_train_lstm, output_size=1, neurons=neurons, metrics=['accuracy'],
                         batch_size=batch_size, activation='linear', dropout=.5, loss='mae', 
                         optimizer='adam')

history = model.fit(X_train_lstm, y_train_lstm, 
                   epochs=epochs,
                   batch_size=batch_size,
                   verbose=0,
                   validation_data=(X_val_lstm, y_val_lstm))

plot_accuracy_loss(history.history)
pred = model.predict(X_test_lstm)
_r2 = r2_score(y_test_lstm, pred)

print('R-squared on test data = %.4f' % _r2)
