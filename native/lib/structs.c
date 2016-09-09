#ifndef INCLUDED_STRUCTS_C
#define INCLUDED_STRUCTS_C

typedef float* Matrix;

typedef void (*ActivityFunction)(Matrix, float);
typedef struct ActivityClosure {
  ActivityFunction function;
  float            alpha;
} ActivityClosure;

typedef int (*PresentationFunction)(Matrix, int);
typedef struct PresentationClosure {
  PresentationFunction function;
  int                  alpha;
} PresentationClosure;

typedef struct NetworkState {
  int     layers;
  Matrix *biases;
  Matrix *weights;
} NetworkState;

typedef struct NetworkStructure {
  int                   layers;
  int                  *rows;
  int                  *columns;
  float                *dropout;
  ActivityClosure     **function;
  ActivityClosure     **derivative;
  PresentationClosure  *presentation;
} NetworkStructure;

#endif
