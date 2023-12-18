import os
import keras
import tensorflow as tf
from keras import layers
from keras.layers import Dense, Flatten, Conv2D, MaxPooling2D, GlobalAveragePooling2D
from keras.models import Sequential
from keras.optimizers import Adam
from keras.callbacks import EarlyStopping, LearningRateScheduler

data_dir = os.path.join('S:/Repo/VogueVoyage/mainsource')

class_names = ['dress', 'hat', 'hoodie', 'jeans', 'outwear', 'pants', 'shirt', 'shoes', 'shorts', 'skirt', 'top', 'tshirt']

trainDs = tf.keras.preprocessing.image_dataset_from_directory(
    data_dir, labels="inferred", batch_size=32, label_mode='categorical',
    subset="training", validation_split=0.2, image_size=(512, 512), seed=27
)

validationDs = tf.keras.preprocessing.image_dataset_from_directory(
    data_dir, labels="inferred", batch_size=32, label_mode='categorical',
    subset="validation", validation_split=0.2, image_size=(512, 512), seed=21
)

# Preprocessing and Data Augmentation
augmentation = Sequential([
    layers.RandomFlip("horizontal_and_vertical"),
    layers.RandomRotation(0.2),
])

# Checking for progress stagnation
def lr_schedule(epoch, lr):
    return lr * 1.1

opt = keras.optimizers.Adam(learning_rate=0.002)

# Load the model
loaded_model = keras.models.load_model('S:/Repo/clothingApp/model')

# Compile the loaded model
loaded_model.compile(loss='categorical_crossentropy', optimizer=opt, metrics=['accuracy'])

# Callbacks
lr_scheduler = LearningRateScheduler(lr_schedule)
early_stopping = EarlyStopping(monitor='val_loss', patience=3, restore_best_weights=True)

# Continue training on the loaded model
history = loaded_model.fit(trainDs, epochs=5, validation_data=validationDs, callbacks=[lr_scheduler, early_stopping])
