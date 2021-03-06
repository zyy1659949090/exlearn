#ifndef INCLUDE_BATCH_DATA_H
#define INCLUDE_BATCH_DATA_H

#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

#include <stdint.h>
#include <stdlib.h>
#include <time.h>

#include "./sample_index.h"
#include "./worker_data.h"

typedef struct BatchData {
  int32_t       batch_length;
  int32_t       data_length;
  SampleIndex **sample_index;
} BatchData;

void
batch_data_free(BatchData **data);

BatchData *
batch_data_new(WorkerData *data, int32_t batch_length);

void
batch_data_initialize(BatchData *batch_data, WorkerData *data, int32_t batch_length);

void
batch_data_inspect(BatchData *batch_data);

void
batch_data_inspect_internal(BatchData *batch_data, int32_t indentation);

void
shuffle_batch_data_indices(BatchData *data);

SampleIndex *
batch_data_get_sample_index(
  BatchData *batch_data,
  int32_t    batch_number,
  int32_t    offset
);

#endif
