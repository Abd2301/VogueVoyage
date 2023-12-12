import matplotlib.pyplot as plt
import numpy as np
import os
import PIL
import tensorflow as tf
import keras
from keras.layers import Dense, Flatten, Conv2D, MaxPooling2D, GlobalAveragePooling2D
from keras.models import Sequential
from keras.optimizers import Adam
import cv2
import imghdr
from keras.applications.resnet_v2 import ResNet50V2
import matplotlib.pyplot as plt
import numpy as np
from keras import layers
from keras.callbacks import EarlyStopping,  LearningRateScheduler, LambdaCallback

data_dir = os.path.join('archive', 'mainsource')

class_names = ['dress','hat','hoodie','jeans','outwear','pants','shirt','shoes','shorts','skirt','top','tshirt']

trainDs = keras.preprocessing.image_dataset_from_directory(
    data_dir, labels="inferred", batch_size=10, label_mode='categorical',
      subset="training", validation_split=0.2, image_size=(512,512), seed=27
)

validationDs = keras.preprocessing.image_dataset_from_directory(
    data_dir, labels="inferred", batch_size=10, label_mode='categorical',
    subset="validation", validation_split=0.2, image_size=(512,512), seed=21
)

# Preprocessing and Data Augmentation
augmentation = Sequential([
    layers.RandomFlip("horizontal_and_vertical"),
    layers.RandomRotation(0.2),
])

# Checking for progress stagnation
def lr_schedule(epoch, lr):

    return lr * 1.1

lr_scheduler = LearningRateScheduler(lr_schedule)
early_stopping = EarlyStopping(monitor='val_loss', patience=3, restore_best_weights=True)


# Base model
base_model = Sequential([
    augmentation,
    ResNet50V2(include_top=False, weights='imagenet', input_shape=(512, 512, 3)),
    # Add GlobalAveragePooling2D here if needed
])

# Additional layers
model = Sequential([
    base_model,
    Conv2D(16, (3, 3), activation='relu', strides=(1, 1)),
    MaxPooling2D(pool_size=(4, 4)),
    Conv2D(32, (3, 3), activation='relu', strides=(1, 1)),
    MaxPooling2D(pool_size=(4, 4)),
    Conv2D(64, (3, 3), activation='relu', strides=(1, 1)),
    MaxPooling2D(pool_size=(4, 4)),
    GlobalAveragePooling2D(),
    Flatten(),
    Dense(512, activation='relu'),
    Dense(12, activation='softmax'),
])

opt = keras.optimizers.Adam(learning_rate=0.001)
model.compile(loss='categorical_crossentropy', optimizer=opt, metrics=['accuracy'])
def print_shapes(epoch, logs):
    sample_data = next(iter(trainDs.take(1)))
    intermediate_shapes = [layer.output_shape for layer in model.layers]
    print(f"Epoch {epoch + 1} - Intermediate Layer Shapes: {intermediate_shapes}")

print_shapes_callback = LambdaCallback(on_epoch_end=print_shapes)

# Train the model with the print_shapes_callback

history = model.fit(trainDs, epochs=10, validation_data=validationDs, callbacks=[lr_scheduler, early_stopping, print_shapes_callback])

# Save the model
model.save('clothing')

# Display the model summary
model.summary()
#Plotting



fig1 = plt.gcf()
plt.plot(history.history['accuracy'])
plt.plot(history.history['val_accuracy'])
plt.axis(ymin=0.4,ymax=1)
plt.grid()
plt.title('Model Accuracy')
plt.ylabel('Accuracy')
plt.xlabel('Epochs')
plt.legend(['train', 'validation'])
plt.show()



plt.plot(history.history['loss'])
plt.plot(history.history['val_loss'])
plt.grid()
plt.title('Model Loss')
plt.ylabel('Loss')
plt.xlabel('Epochs')
plt.legend(['train', 'validation'])
plt.show()
     
