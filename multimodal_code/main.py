from statistics import mean
import torch
from sklearn.model_selection import StratifiedKFold

skf = StratifiedKFold(n_splits=5)
import torch.nn as nn
import torch.optim as optim
from dataloader import MyDataset, MyDatasetv2
from torch.utils.data import DataLoader
from preprocessing import preprocess
from deep_nn_model import model
from training import train
from evaluation import evaluate
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split

torch.manual_seed(0)
scaler = StandardScaler()

# df = pd.read_csv(r'/content/normal_vs_pre_cancerous_clinical_dataset.csv')
df = pd.read_csv(
    r'C:/Users/ntnbs/Documents/common_database/clinical_dataset/malignant_vs_normal_clinical_dataset.csv')
# df = pd.read_csv(
#     r'C:/Users/ntnbs/Documents/common_database/clinical_dataset/normal_vs_pre_cancerous_clinical_dataset.csv')
df = preprocess(df)
X1 = df.iloc[:, :-1]
y = df.iloc[:, -1]

# df2 = pd.read_csv('/content/normal_vs_precancerous_frontal.csv', header=None)
df2 = pd.read_csv('C:/Users/ntnbs/Documents/common_database/frontal_dataset/malignant_vs_normal_frontal.csv',
                  header=None)
# df2 = pd.read_csv('C:/Users/ntnbs/Documents/common_database/frontal_dataset/normal_vs_precancerous_frontal.csv',
#                   header=None)
df2 = df2.drop([0], axis=1)
X2 = df2.iloc[:, :-1]

# df3 = pd.read_csv('/content/normal_vs_precancerous_profile.csv', header=None)
df3 = pd.read_csv('C:/Users/ntnbs/Documents/common_database/profile_dataset/malignant_vs_normal_profile.csv',
                  header=None)
# df3 = pd.read_csv('C:/Users/ntnbs/Documents/common_database/profile_dataset/normal_vs_precancerous_profile.csv', header=None)
df3 = df3.drop([0], axis=1)
X3 = df3.iloc[:, :-1]

horizontal_stack = pd.concat([X1, X2, X3], axis=1)

# dataset = pd.concat([horizontal_stack, y], axis=1)

horizontal_stack.columns = horizontal_stack.columns.astype(str)

# target_map = {'Normal': 0, 'PreCancerous': 1}
target_map = {'Normal': 0, 'Malignant': 1}
labels = y.map(target_map)
# X_train, X_test, y_train, y_test = train_test_split(horizontal_stack, labels, test_size=0.33, random_state=42)
# X_train.reset_index()
# X_test.reset_index()
# y_train.reset_index()
# y_test.reset_index()
# scaler.fit(X_train)
# X_train = scaler.transform(X_train)
# X_test = scaler.transform(X_test)
# train_dataset = MyDataset(X_train, y_train)
# test_dataset = MyDataset(X_test, y_test)

# Define the loss function and optimizer
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.00045)

optimised_accuracy = []
# max_accuracy =0
# f1_score =[]

num_epochs = 500
batch_size = 128
data = skf.split(horizontal_stack, labels)
# target_map = {'Normal': 0, 'PreCancerous': 1}
labels = y.map(target_map)
for fold, (train_idx, test_idx) in enumerate(data):
    training_loss = []
    accuracy = []
    plot_accuracy = []
    plot_loss = []
    print(f"Fold {fold}:")
    # print(train_dataset, test_dataset)
    max_accuracy = 0
    train_dataset = MyDatasetv2(horizontal_stack.to_numpy()[train_idx], labels.to_numpy()[train_idx])
    test_dataset = MyDatasetv2(horizontal_stack.to_numpy()[test_idx], labels.to_numpy()[test_idx])
    train_dataloader = DataLoader(train_dataset, batch_size=batch_size)  # , shuffle=True)
    test_dataloader = DataLoader(test_dataset, batch_size=batch_size)
    for epoch in range(num_epochs):
        train_loss = train(model, train_dataloader, criterion, optimizer)
        training_loss.append(train_loss)
        test_accuracy = evaluate(model, test_dataloader)
        accuracy.append(test_accuracy)
        max_accuracy = max(max_accuracy, test_accuracy)
        if epoch % 20 == 0:
            plot_accuracy.append(test_accuracy)
            plot_loss.append(train_loss)
        # print(f'Epoch {epoch + 1}/{num_epochs}, Train Loss: {train_loss:.4f}, Test Accuracy: {test_accuracy:.4f}')
    print('The accuracy in fold', fold, 'is =', max_accuracy)
    optimised_accuracy.append(max_accuracy)
    plt.plot(plot_accuracy)
    plt.ylim(0, 1.2)
    plt.xlabel('epoch')
    plt.ylabel('Accuracy')
    plt.title('Accuracy vs epochs')
    plt.show()

    plt.plot(plot_loss)
    # plt.plot(f1_eval, '-o')
    plt.ylim(0.01, 0.7)
    plt.xlabel('epoch')
    plt.ylabel('Training loss')
    # plt.legend(['Train', 'Valid'])
    plt.title('Training loss vs epochs')
    plt.show()

print('The test accuracy is :', mean(optimised_accuracy))
