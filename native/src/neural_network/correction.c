#include "../../include/neural_network/correction.h"

void
correction_free(Correction **correction_address) {
  Correction *correction = *correction_address;

  for (int layer = 0; layer < correction->layers; layer += 1) {
    matrix_free(&correction->biases[layer]);
    matrix_free(&correction->weights[layer]);
  }

  free(correction->biases);
  free(correction->weights);

  free(correction);

  *correction_address = NULL;
}

Correction *
correction_new(int layers) {
  Correction *correction = malloc(sizeof(Correction));

  correction->layers  = layers;
  correction->biases  = malloc(sizeof(Matrix) * layers);
  correction->weights = malloc(sizeof(Matrix) * layers);

  for (int layer = 0; layer < correction->layers; layer += 1) {
    correction->biases[layer]  = NULL;
    correction->weights[layer] = NULL;
  }

  return correction;
}

void
correction_accumulate(Correction *total, Correction *correction){
  for (int index = 0; index < total->layers; index += 1) {
    int length;

    length = correction->biases[index][0] * correction->biases[index][1];

    for (int bias_index = 2; bias_index < length + 2; bias_index += 1) {
      total->biases[index][bias_index] += correction->biases[index][bias_index];
    }

    length = correction->weights[index][0] * correction->weights[index][1];

    for (int weight_index = 2; weight_index < length + 2; weight_index += 1) {
      total->weights[index][weight_index] += correction->weights[index][weight_index];
    }
  }
}

void
correction_initialize(NetworkStructure *network_structure, Correction *correction) {
  int    rows, columns;
  Matrix matrix;

  for (int index = 0; index < correction->layers; index += 1) {
    rows    = network_structure->rows[index];
    columns = network_structure->columns[index];

    matrix = matrix_new(1, columns);
    matrix_fill(matrix, 0);
    correction->biases[index] = matrix;

    matrix = matrix_new(rows, columns);
    matrix_fill(matrix, 0);
    correction->weights[index] = matrix;
  }
}