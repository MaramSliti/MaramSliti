"""CIFAR-10 classification and regularization experiment from H2_optimization.ipynb."""
import tensorflow as tf
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.metrics import ConfusionMatrixDisplay, confusion_matrix
from tensorflow.keras.datasets import cifar10
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.callbacks import EarlyStopping, ReduceLROnPlateau
from tensorflow.keras.layers import Dense, Flatten, Dropout, BatchNormalization
from tensorflow.keras.models import Sequential
from tensorflow.keras.optimizers import SGD

(X_train_full, y_train_full), (X_test, y_test) = cifar10.load_data()
X_train, X_valid, y_train, y_valid = train_test_split(
    X_train_full, y_train_full, test_size=0.2, random_state=0
)
classes = ["airplane", "automobile", "bird", "cat", "deer",
           "dog", "frog", "horse", "ship", "truck"]

augmenter = ImageDataGenerator(
    rotation_range=15,
    horizontal_flip=True,
    brightness_range=(0.9, 1.1),
    rescale=1.0 / 255.0,
)
augmenter.fit(X_train)

model = Sequential([
    Flatten(input_shape=(32, 32, 3)),
    Dense(256, activation="relu"),
    BatchNormalization(),
    Dropout(0.5),
    Dense(128, activation="relu"),
    BatchNormalization(),
    Dropout(0.3),
    Dense(64, activation="relu"),
    BatchNormalization(),
    Dense(10, activation="softmax"),
])
model.compile(
    optimizer=SGD(learning_rate=0.01),
    loss="sparse_categorical_crossentropy",
    metrics=["accuracy"],
)
callbacks = [
    EarlyStopping(monitor="val_loss", patience=5, restore_best_weights=True),
    ReduceLROnPlateau(monitor="val_loss", factor=0.5, patience=2),
]
history = model.fit(
    augmenter.flow(X_train, y_train, batch_size=64),
    validation_data=(X_valid / 255.0, y_valid),
    epochs=30,
    callbacks=callbacks,
)
test_loss, test_accuracy = model.evaluate(X_test / 255.0, y_test, verbose=0)
print(f"Test accuracy: {test_accuracy:.4f}")

predictions = model.predict(X_test / 255.0, verbose=0).argmax(axis=1)
ConfusionMatrixDisplay(confusion_matrix(y_test.ravel(), predictions), display_labels=classes).plot(
    xticks_rotation="vertical"
)
plt.tight_layout()
plt.show()
model.save("cifar10_model.keras")
