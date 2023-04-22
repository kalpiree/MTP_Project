import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader, Dataset
from sklearn.preprocessing import StandardScaler

input_size = 176 # size of the input features
hidden_size_1 = 128
hidden_size_2 = 64
hidden_size_3 = 32
hidden_size_4 = 16
hidden_size_5 = 8
hidden_size_6 = 4
output_size = 2  # number of classes
model = nn.Sequential(
    nn.Linear(input_size, hidden_size_1),
    nn.ReLU(),
    nn.Dropout(0.5),
    nn.Linear(hidden_size_1, hidden_size_2),
    nn.ReLU(),
    nn.Dropout(0.6),
    nn.Linear(hidden_size_2, hidden_size_3),
    nn.ReLU(),
    nn.Dropout(0.6),
    # nn.Linear(hidden_size_3, hidden_size_4),
    # nn.ReLU(),
    # nn.Dropout(0.7),
    # nn.Linear(hidden_size_4, hidden_size_5),
    # nn.ReLU(),
    # nn.Dropout(0.4),
    # nn.Linear(hidden_size_5, hidden_size_6),
    # nn.ReLU(),
    # nn.Dropout(0.4),
    nn.Linear(hidden_size_3, output_size)
)
