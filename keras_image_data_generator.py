# instantiate ImageDataGenerator & rescale 1./255.
train_datagen = ImageDataGenerator(rotation_range=30, 
                                  width_shift_range=.2,
                                  height_shift_range=.2,
                                  rescale=1./255,
                                  shear_range=.2,
                                  zoom_range=.2,
                                  horizontal_flip=False,
                                  fill_mode='nearest')
val_datagen = ImageDataGenerator(rescale=1./255)

# create data generator for later use
# we want to flow from directory to ease up on memory usage
train_generator = train_datagen.flow_from_directory(train_dir,
                                                   target_size=(750, 750),
                                                   batch_size=20,
                                                   class_mode='binary')
val_generator = val_datagen.flow_from_directory(val_dir,
                                               target_size=(750, 750),
                                               batch_size=20,
                                               class_mode='binary')
