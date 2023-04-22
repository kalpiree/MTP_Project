import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader, Dataset
from sklearn.preprocessing import StandardScaler


# Define the dataset class
class MyDataset(Dataset):
    def __init__(self, data, labels):
        self.data = data  # .to_numpy()
        self.labels = labels.to_numpy()

    def __len__(self):
        return len(self.labels)

    def __getitem__(self, index):
        x = torch.tensor(self.data[index], dtype=torch.float32)
        y = torch.tensor(self.labels[index], dtype=torch.int64)
        return x, y


class MyDatasetv2(Dataset):
    def __init__(self, data, labels):
        self.data = data#to_numpy()
        self.labels = labels#.to_numpy()

    def __len__(self):
        return len(self.labels)

    def __getitem__(self, index):
        x = torch.tensor(self.data[index], dtype=torch.float32)
        y = torch.tensor(self.labels[index], dtype=torch.int64)
        return x, y
