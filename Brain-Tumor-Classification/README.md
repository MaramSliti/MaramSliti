# Brain Tumor Classification

Binary image-classification experiment distinguishing **Healthy** and **Brain Tumor** images.

## Models
- Custom CNN built with TensorFlow/Keras.
- Transfer-learning model based on ImageNet-pretrained VGG16 with a frozen feature extractor.
- Image resizing and pixel normalization, train/test split, one-hot labels.
- Confusion matrix, classification report, learning curves and ROC analysis.

## Run
Set the environment variable BRAIN_TUMOR_DATASET to a directory containing two subfolders named Healthy and Brain Tumor, install dependencies from requirements.txt, then run brain_tumor_classification.py.

The dataset itself was not included in the upload. No accuracy figures are claimed here; the script reports evaluation metrics when run with the dataset.
