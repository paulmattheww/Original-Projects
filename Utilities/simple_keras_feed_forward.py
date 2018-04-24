from sklearn.metrics import r2_score
from keras import models, layers

dropout_rate = .8
epochs = 5000

model = models.Sequential()
model.add(layers.Dense(32, activation='relu', 
                       input_shape=(X_train.shape[1], )))
model.add(layers.Dropout(dropout_rate))
model.add(layers.Dense(16, activation='relu'))
model.add(layers.Dropout(dropout_rate))
model.add(layers.Dense(16, activation='relu'))
model.add(layers.Dropout(dropout_rate))
model.add(layers.Dense(16, activation='relu'))
model.add(layers.Dropout(dropout_rate))
model.add(layers.Dense(16, activation='relu'))
model.add(layers.Dropout(dropout_rate))
model.add(layers.Dense(8, activation='relu'))
model.add(layers.Dropout(dropout_rate))
model.add(layers.Dense(8, activation='relu'))
model.add(layers.Dropout(dropout_rate))
model.add(layers.Dense(8, activation='relu'))
model.add(layers.Dropout(dropout_rate))
model.add(layers.Dense(8, activation='relu'))
model.add(layers.Dropout(dropout_rate))

model.add(layers.Dense(8, activation='relu'))
model.add(layers.Dense(1))

model.summary()
model.compile(optimizer='rmsprop', 
             loss='mse',
             metrics=['accuracy'])

history = model.fit(X_train, y_train,
                   epochs=epochs,
                   batch_size=32,
                   verbose=0,
                   validation_data=(X_val, y_val))

plot_accuracy_loss(history.history)
pred = model.predict(X_test)
_r2 = r2_score(y_test, pred)

print('R-squared on test data = %.4f' % _r2)
