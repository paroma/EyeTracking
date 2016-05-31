# pylint: disable=g-bad-file-header
# Copyright 2016 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================

"""
Functions for downloading and reading data

Dependencies:

  NumPy (installed on most systems by default)
  PIL (sudo pip install pillow)


  The only function needed outside this file should be load_data
  (see below)

"""

import numpy

from PIL import Image
import os

import time

IMAGE_DATA_FILENAME = "images.npydata"
LABEL_DATA_FILENAME = "labels.npydata"

# The label values. Each value is associated with a bit shift, which
# can be parsed and unparsed using bitwise operators
vvals = ['0V', '10V', '-10V']
hvals = ['-15H', '-10H', '-5H', '0H', '5H', '10H', '15H']
allvals = vvals + hvals
bits = [0x1 << n for n in xrange(len(vvals) + len(hvals))]

shiftmap = dict(zip((allvals), bits))
reversemap = dict(zip((bits), allvals))

def parse_label_decomposed(filename):
  assert filename.endswith('.jpg')
  filename = filename[:-4]
  tokens = filename.strip().split('_')
  values = [0] * 21
  i = len(hvals) * vvals.index(tokens[4]) + hvals.index(tokens[5])
  values[i] = 1
  ret = numpy.array(values)
  print ret
  return ret

def parse_label(filename):
  """
  Convert a filename to a numeric label (using H and V).
  """
  assert filename.endswith('.jpg')
  filename = filename[:-4]
  tokens = filename.strip().split('_')
  val = shiftmap[tokens[4]] | shiftmap[tokens[5]]
  return val

def unumparse_label(val):
  """
  Unparse a numeric value into a human readable label.
  """
  vlab = val & 0b111
  hlab = val & 0b1111111000
  return reversemap[vlab], reversemap[hlab]

def parse_jpeg(filename):
  """
  Returns an image as a NumPy array (i.e. a Tensor in Tensorflow).
  """
  # Open the image
  img = Image.open(filename).convert('L')

  # Cover the data to a NumPy array
  data = numpy.array(img)
  data = numpy.reshape(data, (1, numpy.size(data, 0)*numpy.size(data, 1)))
  data = data[0]
  data = data.astype(numpy.float32)
  data = numpy.multiply(data, 1.0 / 255.0)
  return data

def parse_all(directory):
  """
  Parse all images in a directory, and return a tuple with two objects:

  1. A 2D tensor [image index, pixel index] representing images
  2. A 1D tensor [image index] representing labels
  """
  if not directory.endswith('/'):
    directory += '/'

  files = [f for f in os.listdir(directory) if f.endswith(".jpg")]
  image_data = numpy.array([parse_jpeg(directory + f) for f in files])
  label_data = numpy.array([parse_label_decomposed(f) for f in files])
  return image_data, label_data

class DataSet(object):
  """
  A version of the DataSet object from the MNIST example for our data.
  """

  def __init__(self,
               images,
               labels,
               dtype=numpy.float32):
    """
    Construct a DataSet.
    """
    self._images = images
    self._num_examples = len(images)
    self._labels = labels
    self._epochs_completed = 0
    self._index_in_epoch = 0

  @property
  def images(self):
    return self._images

  @property
  def labels(self):
    return self._labels

  @property
  def num_examples(self):
    return self._num_examples

  @property
  def epochs_completed(self):
    return self._epochs_completed

  def __str__(self):
    return str((self._labels, self._images))

  def next_batch(self, batch_size):
    """Return the next `batch_size` examples from this data set."""
    start = self._index_in_epoch
    self._index_in_epoch += batch_size
    if self._index_in_epoch > self._num_examples:
      # Finished epoch
      self._epochs_completed += 1
      # Shuffle the data
      perm = numpy.arange(self._num_examples)
      numpy.random.shuffle(perm)
      self._images = self._images[perm]
      self._labels = self._labels[perm]
      # Start next epoch
      start = 0
      self._index_in_epoch = batch_size
      assert batch_size <= self._num_examples
    end = self._index_in_epoch
    return self._images[start:end], self._labels[start:end]

def load_data(directory, save=True):
  """
  Load images and labels from the given directory and return a
  dataset object.
  """
  if save and os.path.isfile(IMAGE_DATA_FILENAME) and\
      os.path.isfile(LABEL_DATA_FILENAME):
        return load_from_file(IMAGE_DATA_FILENAME, LABEL_DATA_FILENAME)

  images, labels = parse_all(directory)
  d = DataSet(images, labels)
  if save: save_dataset(d)
  return d

def load_from_file(img_file, label_file):
  """
  Loads data using saved numpy files.
  """
  with open(img_file) as f:
    images = numpy.load(f) 
  with open(label_file) as f:
    labels = numpy.load(f)
  return DataSet(images, labels)

def save_dataset(d):
  """
  Saves data to an outfile
  """
  print "Saving..."
  with open(IMAGE_DATA_FILENAME, "w") as f:
    numpy.save(f, d.images)
  with open(LABEL_DATA_FILENAME, "w") as f:
    numpy.save(f, d.labels)

start = time.time()
d = load_data("Cropped Dataset", save=True)
end = time.time()
print "First Load Time:" + str(end - start)
