#include "../../include/neural_network/presentation.h"

static int32_t argmax_function(Matrix matrix, int32_t alpha) {
  int32_t argmax = matrix_argmax(matrix);

  return argmax + alpha;
}

static int32_t floor_first_function(Matrix matrix, int32_t alpha) {
  int32_t result = floorf(matrix_first(matrix));

  return result + alpha;
}

static int32_t round_first_function(Matrix matrix, int32_t alpha) {
  int32_t result = roundf(matrix_first(matrix));

  return result + alpha;
}

static int32_t ceil_first_function(Matrix matrix, int32_t alpha) {
  int32_t result = ceilf(matrix_first(matrix));

  return result + alpha;
}

int32_t
presentation_closure_call(PresentationClosure *closure, Matrix matrix) {
  if (closure != NULL)
    return closure->function(matrix, closure->alpha);
  else
    return 0;
}

void
presentation_closure_free(PresentationClosure **closure_address) {
  PresentationClosure *closure = *closure_address;

  if (closure != NULL) free(closure);

  *closure_address = NULL;
}

PresentationClosure *
presentation_closure_new(PresentationFunction function, int32_t alpha) {
  PresentationClosure *closure = malloc(sizeof(PresentationClosure));

  closure->function = function;
  closure->alpha    = alpha;

  return closure;
}

PresentationClosure *
presentation_determine(int32_t function_id, int32_t alpha) {
  switch (function_id) {
    case 0:  return presentation_closure_new(argmax_function,      alpha);
    case 1:  return presentation_closure_new(floor_first_function, alpha);
    case 2:  return presentation_closure_new(round_first_function, alpha);
    case 3:  return presentation_closure_new(ceil_first_function,  alpha);
    default: return NULL;
  }
}
