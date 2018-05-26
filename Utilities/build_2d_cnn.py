def build_2d_cnn(output_dim, input_shape, conv_units_list, 
                 initial_units=32, output_dense_units=512, verbose=1,
                 activation='relu', kernel_size=(3, 3), 
                 padding='same', strides=2, pool_size=(2, 2), 
                 loss='binary_crossentropy', optimizer=RMSprop(lr=1e-4), 
                 metrics=['acc']):
    '''
    Leverages Keras to build a convolutional network for classification.
    
    Inputs:
    ------------------------------------------------------------------------------
     - output_dim:          <int> number of output units; one per category
     - input_shape:         <tuple> shape of image input (width, height, pixels)
     - conv_units_list:     <list> number of computational units in conv2d layers
     - initial_units:       <int> first unit's number of computational units
     - output_dense_units:  <int> dense layer after Flatten number of units
     - verbose:             <bool> if 1 prints the model.summary(), else pass
     - activation:          <str> keras.activation or str containing name of function
     - kernel_size:         <int> size of receptive field in convolution
     - padding:             <int> padding around image to ensure edges are noticed
     - strides:             <int> kernel stride across the image
     - pool_size:           <tuple> size of pooling field 
     - loss:                <str> keras.loss or str containing name of function
     - optimizer:           <str> keras.optimizer or str containing name of function
     - metrics:             <list> metrics to capture during training for plotting
     
    Outputs:
    ------------------------------------------------------------------------------
     - model:           <keras.model> compiled model ready for training 
    '''
    model = Sequential()
    
    # initial layer
    model.add(Conv2D(initial_units, kernel_size=kernel_size,
                    activation=activation,
                    input_shape=input_shape, strides=strides))
    model.add(MaxPooling2D(pool_size=pool_size))
    
    # subsequent layers
    for units in conv_units_list:
        model.add(Conv2D(units, kernel_size=kernel_size,
                        activation=activation, strides=strides))
        model.add(MaxPooling2D(pool_size=pool_size))
        
    # flatten/dense/output layers
    model.add(Flatten())
    model.add(Dense(output_dense_units, activation=activation))
    model.add(Dense(output_dim, activation='sigmoid'))
    
    if verbose: model.summary()
    
    model.compile(loss=loss,
                 optimizer=optimizer,
                 metrics=metrics)
    
    return model

conv_units_list = [64, 128, 128]
model = build_2d_cnn(output_dim=1, input_shape=(750, 750, 3), conv_units_list=conv_units_list, 
                     initial_units=32, output_dense_units=512, verbose=1,
                     activation='relu', kernel_size=(3, 3), 
                     padding='same', strides=2, pool_size=(2, 2), 
                     loss='binary_crossentropy', optimizer=RMSprop(lr=1e-4), metrics=['acc'])
