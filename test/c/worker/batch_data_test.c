#include "../../../native/include/worker/batch_data.h"

#include "../fixtures/file_fixtures.c"

//-----------------------------------------------------------------------------
// Tests
//-----------------------------------------------------------------------------

static void test_batch_data_free() {
  BatchData   *batch;
  BundlePaths *paths = bundle_paths_new(2);
  WorkerData  *data  = worker_data_new(2);

  paths->path[0] = create_first_data_bundle_file();
  paths->path[1] = create_second_data_bundle_file();

  worker_data_read(paths, data);

  batch = batch_data_new(data, 1);

  batch_data_free(&batch);

  assert(batch == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_batch_data_new() {
  BatchData   *batch;
  BundlePaths *paths = bundle_paths_new(2);
  WorkerData  *data  = worker_data_new(2);

  paths->path[0] = create_first_data_bundle_file();
  paths->path[1] = create_second_data_bundle_file();

  worker_data_read(paths, data);

  batch = batch_data_new(data, 1);

  assert(batch->data_length  == 3); /* LCOV_EXCL_BR_LINE */
  assert(batch->batch_length == 1); /* LCOV_EXCL_BR_LINE */

  assert(batch->sample_index[0]->bundle == 0); /* LCOV_EXCL_BR_LINE */
  assert(batch->sample_index[0]->index  == 0); /* LCOV_EXCL_BR_LINE */
  assert(batch->sample_index[1]->bundle == 1); /* LCOV_EXCL_BR_LINE */
  assert(batch->sample_index[1]->index  == 0); /* LCOV_EXCL_BR_LINE */
  assert(batch->sample_index[2]->bundle == 1); /* LCOV_EXCL_BR_LINE */
  assert(batch->sample_index[2]->index  == 1); /* LCOV_EXCL_BR_LINE */

  batch_data_free(&batch);
}

static void test_shuffle_batch_data_indices() {
  BatchData   *batch;
  BundlePaths *paths = bundle_paths_new(2);
  WorkerData  *data  = worker_data_new(2);

  paths->path[0] = create_first_data_bundle_file();
  paths->path[1] = create_second_data_bundle_file();

  worker_data_read(paths, data);

  batch = batch_data_new(data, 1);


  shuffle_batch_data_indices(batch);

  for (int index = 0; index < batch->data_length; index += 1) {
    assert(batch->sample_index[index]->bundle == 0 || batch->sample_index[index]->bundle == 1); /* LCOV_EXCL_BR_LINE */
    assert(batch->sample_index[index]->index == 0 || batch->sample_index[index]->index == 1); /* LCOV_EXCL_BR_LINE */
  }

  batch_data_free(&batch);
}

static void test_batch_data_get_sample_index() {
  BatchData   *batch_data;
  BundlePaths *bundle_paths = bundle_paths_new(2);
  WorkerData  *worker_data  = worker_data_new(2);
  SampleIndex *sample_index;

  bundle_paths->path[0] = create_first_data_bundle_file();
  bundle_paths->path[1] = create_second_data_bundle_file();

  worker_data_read(bundle_paths, worker_data);

  batch_data = batch_data_new(worker_data, 1);

  sample_index = batch_data_get_sample_index(batch_data, 0, 0);
  assert(sample_index->bundle == 0); /* LCOV_EXCL_BR_LINE */
  assert(sample_index->index  == 0); /* LCOV_EXCL_BR_LINE */

  sample_index = batch_data_get_sample_index(batch_data, 1, 0);
  assert(sample_index->bundle == 1); /* LCOV_EXCL_BR_LINE */
  assert(sample_index->index  == 0); /* LCOV_EXCL_BR_LINE */

  sample_index = batch_data_get_sample_index(batch_data, 1, 1);
  assert(sample_index->bundle == 1); /* LCOV_EXCL_BR_LINE */
  assert(sample_index->index  == 1); /* LCOV_EXCL_BR_LINE */
}
