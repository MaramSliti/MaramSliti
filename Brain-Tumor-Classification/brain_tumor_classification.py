"""Binary brain MRI classification: Healthy vs Brain Tumor.

Adapted from the supplied BrainTumor-1.ipynb. Set BRAIN_TUMOR_DATASET to a
folder containing subfolders named "Healthy" and "Brain Tumor".
"""
import os
from pathlib import Path
import cv2
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix, classification_report, roc_curve, auc
from tensorflow.keras.utils import to_categorical
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense, Dropout, GlobalAveragePooling2D
from tensorflow.keras.applications import VGG16

DATASET_DIR = Path(os.environ.get("BRAIN_TUMOR_DATASET", "data/Brain Tumor Data Set"))
CATEGORIES = ["Healthy", "Brain Tumor"]
IMG_SIZE = 224
images, labels = [], []

for label, category in enumerate(CATEGORIES):
    folder = DATASET_DIR / category
    if not folder.is_dir():
        raise FileNotFoundError(f"Expected class folder not found: {folder}")
    for image_file in folder.iterdir():
        image = cv2.imread(str(image_file), cv2.IMREAD_COLOR)
        if image is not None:
            image = cv2.resize(image, (IMG_SIZE, IMG_SIZE))
            images.append(image)
            labels.append(label)

X = np.asarray(images, dtype=np.float32) / 255.0
y = np.asarray(labels, dtype=np.int64)
if len(np.unique(y)) != 2:
    raise ValueError("Both Healthy and Brain Tumor classes must contain readable images.")

X_train, X_test, y_train_idx, y_test_idx = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)
y_train = to_categorical(y_train_idx, num_classes=2)
y_test = to_categorical(y_test_idx, num_classes=2)

# Custom convolutional neural network.
cnn = Sequential([
    Conv2D(32, (3, 3), activation="relu", input_shape=(IMG_SIZE, IMG_SIZE, 3)),
    MaxPooling2D(2, 2),
    Conv2D(64, (3, 3), activation="relu"),
    MaxPooling2D(2, 2),
    Conv2D(128, (3, 3), activation="relu"),
    MaxPooling2D(2, 2),
    Flatten(),
    Dense(128, activation="relu"),
    Dropout(0.5),
    Dense(2, activation="softmax"),
])
cnn.compile(optimizer="adam", loss="categorical_crossentropy", metrics=["accuracy"])
cnn_history = cnn.fit(X_train, y_train, epochs=10, batch_size=16, validation_split=0.2)

# Transfer-learning experiment based on a frozen ImageNet VGG16 backbone.
backbone = VGG16(weights="imagenet", include_top=False, input_shape=(IMG_SIZE, IMG_SIZE, 3))
backbone.trainable = False
vgg = Sequential([
    backbone,
    GlobalAveragePooling2D(),
    Dense(128, activation="relu"),
    Dropout(0.5),
    Dense(2, activation="softmax"),
])
vgg.compile(optimizer="adam", loss="categorical_crossentropy", metrics=["accuracy"])
vgg_history = vgg.fit(X_train, y_train, epochs=10, batch_size=16, validation_split=0.2)

for name, model in [("CNN", cnn), ("VGG16", vgg)]:
    loss, accuracy = model.evaluate(X_test, y_test, verbose=0)
    print(f"{name} test accuracy: {accuracy:.4f}")

# Report and confusion matrix for VGG16.
probabilities = vgg.predict(X_test, verbose=0)
predictions = probabilities.argmax(axis=1)
print(classification_report(y_test_idx, predictions, target_names=CATEGORIES))
sns.heatmap(confusion_matrix(y_test_idx, predictions), annot=True, fmt="d",
            xticklabels=CATEGORIES, yticklabels=CATEGORIES)
plt.xlabel("Predicted")
plt.ylabel("Actual")
plt.title("VGG16 Confusion Matrix")
plt.tight_layout()
plt.show()

fpr, tpr, _ = roc_curve(y_test_idx, probabilities[:, 1])
roc_auc = auc(fpr, tpr)
plt.plot(fpr, tpr, label=f"VGG16 ROC AUC = {roc_auc:.3f}")
plt.plot([0, 1], [0, 1], "--")
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")
plt.legend()
plt.tight_layout()
plt.show()
