import time
import torch
from torch.nn.utils.rnn import pad_sequence
from transformers import DistilBertModel, DistilBertTokenizer


tokenizer = DistilBertTokenizer.from_pretrained('distilbert-base-uncased')
transformer = DistilBertModel.from_pretrained('distilbert-base-uncased')

sentences = ["Hello, my dog is so so cute", 'asd asd f', "Hello, my dog is cute"]


def use_padding(seqs):
    input_ids = pad_sequence([torch.tensor(tokenizer.encode(s)) for s in sentences], batch_first=True)
    return transformer(input_ids)


def no_padding(seqs):
    return [transformer(torch.tensor(tokenizer.encode(s)).unsqueeze(0)) for s in sentences]


outputs = use_padding(sentences)
print(outputs[0].shape)  # torch.Size([3, 10, 768])
print(outputs[0][:, :, 0])
#tensor([[-0.1424,  0.1228, -0.2951, -0.0255,  0.1642, -0.2319, -0.1442, -0.3640,
#         -0.4400,  0.7978],
#        [-0.1681, -0.2347, -0.1939, -0.1841, -0.0204, -0.3167,  0.8404,  0.0729,
#          0.1651,  0.1049],
#        [-0.1483, -0.0358, -0.5315, -0.0940,  0.0796, -0.4333, -0.3959,  0.8105,
#          0.0569,  0.1229]], grad_fn=<SelectBackward>)


t0 = time.time()
_ = use_padding(sentences * 100000000)
print(time.time() - t0)  # 1.5

t0 = time.time()
_ = no_padding(sentences * 100000000)
print(time.time() - t0)  # 1.3

