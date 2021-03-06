#include "../../include/neural_network/objective.h"

//-----------------------------------------------------------------------------
// Objective functions
//-----------------------------------------------------------------------------

static float
cross_entropy_function(Matrix expected, Matrix actual) {
  int32_t length = expected[0] * expected[1] + 2;
  float   sum    = 0;
  float   first, second, normalised;

  for (int32_t index = 2; index < length; index += 1) {
    first  = expected[index];
    second = actual[index];

    if      (second == 0.0) normalised = 0.0000000000001;
    else if (second == 1.0) normalised = 0.9999999999999;
    else                    normalised = second;

    sum += first * log(normalised) + (1 - first) * log(1 - normalised);
  }

  return -sum;
}

static Matrix
cross_entropy_error_simple(
  Matrix             expected,
  Matrix             actual,
  Matrix             last_input,
  ActivationClosure *last_derivative
) {
  int32_t length = expected[0] * expected[1] + 2;
  Matrix  result = matrix_new(expected[0], expected[1]);
  float   top, bottom;

  matrix_clone(result, last_input);
  activation_closure_call(last_derivative, result);

  for (int32_t index = 2; index < length; index += 1) {
    top    = actual[index] - expected[index];
    bottom = actual[index] * (1.0 - actual[index]);

    result[index] *= top / bottom;
  }

  return result;
}

static float
negative_log_likelihood_function(Matrix expected, Matrix actual) {
  float length = expected[0] * expected[1] + 2;
  float sum = 0;

  for (int32_t index = 2; index < length; index += 1) {
    sum += expected[index] * log(actual[index]);
  }

  return -sum;
}

static Matrix
negative_log_likelihood_error_simple(
  Matrix             expected,
  Matrix             actual,
  Matrix             _last_input,
  ActivationClosure *_last_derivative
) {
  (void)(_last_input     );
  (void)(_last_derivative);

  int32_t length = expected[0] * expected[1] + 2;
  Matrix  result = matrix_new(expected[0], expected[1]);

  result[0] = expected[0];
  result[1] = expected[1];

  for (int32_t index = 2; index < length; index += 1) {
    result[index] = actual[index] - expected[index];
  }

  return result;
}

static Matrix
negative_log_likelihood_error_optimised(
  Matrix             expected,
  Matrix             actual,
  Matrix             _last_input,
  ActivationClosure *_last_derivative
) {
  (void)(_last_input     );
  (void)(_last_derivative);

  int32_t length = expected[0] * expected[1] + 2;
  Matrix  result = matrix_new(expected[0], expected[1]);

  result[0] = expected[0];
  result[1] = expected[1];

  for (int32_t index = 2; index < length; index += 1) {
    result[index] = actual[index] - expected[index];
  }

  return result;
}

static float
quadratic_function(Matrix expected, Matrix actual) {
  float length = expected[0] * expected[1] + 2;
  float sum    = 0;
  float difference;

  for (int32_t index = 2; index < length; index += 1) {
    difference = expected[index] - actual[index];

    sum += difference * difference;
  }

  return 0.5 * sum;
}

static Matrix
quadratic_error(
  Matrix             expected,
  Matrix             actual,
  Matrix             last_input,
  ActivationClosure *last_derivative
) {
  int32_t length = expected[0] * expected[1] + 2;
  Matrix  result = matrix_new(expected[0], expected[1]);

  matrix_clone(result, last_input);
  activation_closure_call(last_derivative, result);

  for (int32_t index = 2; index < length; index += 1) {
    result[index] *= actual[index] - expected[index];
  }

  return result;
}

//-----------------------------------------------------------------------------
// API
//-----------------------------------------------------------------------------

ObjectiveFunction
objective_determine_function(int32_t function_id) {
  switch (function_id) {
    case  0: return cross_entropy_function;
    case  1: return negative_log_likelihood_function;
    case  2: return quadratic_function;
    default: return NULL;
  }
}

ObjectiveError
objective_determine_error_simple(int32_t function_id) {
  switch (function_id) {
    case  0: return cross_entropy_error_simple;
    case  1: return negative_log_likelihood_error_simple;
    case  2: return quadratic_error;
    default: return NULL;
  }
}

ObjectiveError
objective_determine_error_optimised(int32_t function_id) {
  switch (function_id) {
    // case  0: return cross_entropy_error_optimised;
    case  1: return negative_log_likelihood_error_optimised;
    case  2: return quadratic_error;
    default: return NULL;
  }
}
