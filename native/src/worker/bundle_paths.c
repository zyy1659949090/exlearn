#include "../../include/worker/bundle_paths.h"

void
bundle_paths_free(BundlePaths **paths_address) {
  BundlePaths *paths = *paths_address;

  if (paths != NULL) {
    for (int32_t index = 0; index < paths->count; index += 1) {
      if (paths->path[index] != NULL) free(paths->path[index]);
    }

    free(paths->path);
    free(paths      );

    *paths_address = NULL;
  }
}

BundlePaths *
bundle_paths_new(int32_t count) {
  BundlePaths *paths = malloc(sizeof(BundlePaths));

  paths->count = count;
  paths->path  = malloc(sizeof(char *) * count);

  for (int32_t index = 0; index < count; index += 1) {
    paths->path[index] = NULL;
  }

  return paths;
}
