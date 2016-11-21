#ifndef INCLUDE_CORRECTION_FIXTURES_C
#define INCLUDE_CORRECTION_FIXTURES_C

#include "../../../native/include/neural_network/correction.h"

static Correction *
correction_expected_basic() {
  Correction *correction = correction_new(4);

  // First Hidden Layer Correction
  float layer_1_biases_correction[5]   = {1, 3, 90, 186, 282};
  float layer_1_weights_correction[11] = {3, 3,
    90, 186, 282, 180, 372, 564, 270, 558, 846
  };

  correction->biases[1]  = matrix_new(1, 3);
  correction->weights[1] = matrix_new(3, 3);

  matrix_clone(correction->biases[1],  layer_1_biases_correction );
  matrix_clone(correction->weights[1], layer_1_weights_correction);

  // Second Hidden Layer Correction
  float layer_2_biases_correction[4]  = {1, 2, 6, 42};
  float layer_2_weights_correction[8] = {3, 2, 186, 1302, 228, 1596, 270, 1890};

  correction->biases[2]  = matrix_new(1, 2);
  correction->weights[2] = matrix_new(3, 2);

  matrix_clone(correction->biases[2],  layer_2_biases_correction );
  matrix_clone(correction->weights[2], layer_2_weights_correction);

  // Output Layer Correction
  float layer_3_biases_correction[4]  = {1, 2, 30, -12};
  float layer_3_weights_correction[6] = {2, 2, 11130, -4452, 14580, -5832};

  correction->biases[3]  = matrix_new(1, 2);
  correction->weights[3] = matrix_new(2, 2);

  matrix_clone(correction->biases[3],  layer_3_biases_correction );
  matrix_clone(correction->weights[3], layer_3_weights_correction);

  return correction;
}

static Correction *
correction_expected_with_dropout() {
  Correction *correction = correction_new(4);

  // First Hidden Layer Correction
  float layer_1_biases_correction[5]   = {1, 3, 336, 672, 0};
  float layer_1_weights_correction[11] = {3, 3,
    336, 672, 0, 672, 1344, 0, 1008, 2016, 0
  };

  correction->biases[1]  = matrix_new(1, 3);
  correction->weights[1] = matrix_new(3, 3);

  matrix_clone(correction->biases[1],  layer_1_biases_correction );
  matrix_clone(correction->weights[1], layer_1_weights_correction);

  // Second Hidden Layer Correction
  float layer_2_biases_correction[4]  = {1, 2, 0, 84};
  float layer_2_weights_correction[8] = {3, 2, 0, 2604, 0, 3192, 0, 3780};

  correction->biases[2]  = matrix_new(1, 2);
  correction->weights[2] = matrix_new(3, 2);

  matrix_clone(correction->biases[2],  layer_2_biases_correction );
  matrix_clone(correction->weights[2], layer_2_weights_correction);

  // Output Layer Correction
  float layer_3_biases_correction[4]  = {1, 2, 30, -12};
  float layer_3_weights_correction[6] = {2, 2, 11130, -4452, 14580, -5832};

  correction->biases[3]  = matrix_new(1, 2);
  correction->weights[3] = matrix_new(2, 2);

  matrix_clone(correction->biases[3],  layer_3_biases_correction );
  matrix_clone(correction->weights[3], layer_3_weights_correction);

  return correction;
}

#endif
