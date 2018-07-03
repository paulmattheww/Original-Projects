from keras.models import *
from keras.layers import *
from keras.regularizers import *
from sklearn.metrics import r2_score
from keras.callbacks import EarlyStopping
from keras.utils import to_categorical

def feedforward_classification_network(num_neurons, num_dense_layers, num_classes, 
                                       reg=.001, loss='categorical_crossentropy', 
                                       activation='relu', optimizer='rmsprop',
                                       metrics=['accuracy'], dropout=.5, verbose=1):
    '''
    Inputs:
    
    Outputs:
    '''
    model = Sequential()
    model.add(Dense(num_neurons, activation=activation, 
                    input_shape=(X_train.shape[1], ),
                    kernel_regularizer=l2(reg),
                    activity_regularizer=l1(reg)))

    for lyr in range(num_dense_layers):
        model.add(Dense(num_neurons, 
                        activation=activation,
                        kernel_regularizer=l2(reg),
                        activity_regularizer=l1(reg)))
        model.add(Dropout(dropout))

    model.add(Dense(num_classes+1, activation='sigmoid'))

    if verbose: model.summary()

    model.compile(optimizer=optimizer, 
                 loss=loss,
                 metrics=metrics)
    
    return model

num_neurons = 300
num_dense_layers = 10

# instantiate model
model = feedforward_classification_network(num_neurons, num_dense_layers, num_classes, verbose=0)

from keras.callbacks import EarlyStopping

epochs = 100
batch_size = 32
early = EarlyStopping(patience=5)

model.fit(X_train, y_train, num_classes,
         #batch_size=batch_size, 
         validation_data=(X_val, y_val),
         callbacks=[early])
