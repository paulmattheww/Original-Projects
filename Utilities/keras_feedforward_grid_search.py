from keras import backend as K
import gc
K.clear_session()

config = tf.ConfigProto()
config.gpu_options.allow_growth=True
sess = tf.Session(config=config)
K.set_session(sess)

from keras.models import *
from keras.layers import *
from keras.regularizers import *
from sklearn.metrics import r2_score
from keras.callbacks import EarlyStopping

def simple_feedforward_model(num_neurons, num_dense_layers, reg=.001,
                            loss='mse', #test later mean_squared_logarithmic_error
                            activation='relu', optimizer='rmsprop',
                            metrics=None, dropout=.5, verbose=0):
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

    model.add(Dense(1))

    if verbose: model.summary()

    model.compile(optimizer=optimizer, 
                 loss=loss,
                 metrics=metrics)
    
    return model

# instantiate model & run
epochs = 1000
num_batches = 4
batch_size = X_train.shape[0] // num_batches
verbose = 0

dropout_rates = np.arange(0, .31, .1)
n_units_per_layer = np.arange(16, 37, 6)
n_dense_layers = np.arange(1, 3, 1)
regularizer_range = [.005, .001, .0005]
r2_cutoff = 0.98

model_dict = dict()
model_number = 1
for layers in n_dense_layers:
    for units in n_units_per_layer:
        for dropout in dropout_rates:
            for reg in regularizer_range:
                # define feed forward model with parameters of CV
                model = simple_feedforward_model(units, layers, reg, 
                                                 dropout=dropout)
                
                # use early stopping to ensure the model doesn't go too far
                # or waste time training un-fit models
                early_stopping = EarlyStopping(patience=1, 
                                              monitor='mse',
                                              verbose=1, 
                                              mode='auto')
                
                model_name = '''
                    Model # %i
                    Fully Connected Model w/ Dropout & Regularization 
                     - Regularizer Rate:    %.7f
                     - Dropout Rate:        %.3f
                     - Number Dense Layers: %i
                     - Neurons per Layer:   %i
                    '''%(model_number, reg, dropout, layers, units)

                history = model.fit(X_train, y_train,
                                   epochs=epochs,
                                   batch_size=batch_size,
                                   verbose=verbose,
                                   validation_data=(X_val, y_val),
                                   callbacks=[early_stopping])

                test_pred = model.predict(X_test)
                test_r2 = r2_score(y_test, test_pred)
                val_pred = model.predict(X_val)
                val_r2 = r2_score(y_val, val_pred)
                train_pred = model.predict(X_train)
                train_r2 = r2_score(y_train, train_pred)
                
                actual_layers = layers + 1
                model_id = str(model_number).zfill(3)+'_'+str(reg)+'_'+str(round(dropout, 2))+'_'+str(actual_layers)+'_'+str(units)
                print('Model ID: {}'.format(model_id))
                print('-'*80)
                print('R-squared on training data = %.4f' % train_r2)
                print('R-squared on validation data = %.4f' % val_r2)
                print('R-squared on testing data = %.4f' % test_r2)
                print('-'*80)
                
                # only keep data on reasonable models
                if test_r2 > r2_cutoff:
                    model_dict[model_id] = {'model_number': model_number,
                                           'model_id': model_name,
                                           'model': model,
                                           'r2_test': test_r2, 
                                           'r2_val': val_r2,
                                           'r2_train': train_r2, 
                                           'history': history.history,
                                           'units': units,
                                           'layers': actual_layers,
                                           'epochs': epochs,
                                           'dropout': dropout,
                                           'regularizer': reg}
                    print(model_name, '\n')
                    plot_loss(history.history)
                else:
                    model_dict[model_id] = {'model_number': model_number,
                       'model_id': model_name,
                       'model': None,
                       'r2_test': test_r2, 
                       'r2_val': val_r2,
                       'r2_train': train_r2, 
                       'history': None,
                       'units': units,
                       'layers': actual_layers,
                       'epochs': epochs,
                       'dropout': dropout,
                       'regularizer': reg}
                    pass
                
                model_number += 1
                
                # manage memory and gpu usage
                del history; del model
                for i in range(10):
                    gc.collect()
                K.clear_session()
