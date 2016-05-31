
import numpy

import os

import time

IMAGE_DATA_FILENAME = "images.npydata"
LABEL_DATA_FILENAME = "labels.npydata"

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


def load_from_file(img_file, label_file):
  """
  Loads data using saved numpy files.
  """
  with open(img_file) as f:
    images = numpy.load(f) 
  with open(label_file) as f:
    labels = numpy.load(f)
  return DataSet(images, labels)
