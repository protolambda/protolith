
const int WORD_BYTES = 4; // bytes in word
const int DATASET_BYTES_INIT = 1 << 30; // bytes in dataset at genesis
const int DATASET_BYTES_GROWTH = 1 << 23; // dataset growth per epoch
const int CACHE_BYTES_INIT = 1 << 24; // bytes in cache at genesis
const int CACHE_BYTES_GROWTH = 1 << 17; // cache growth per epoch
const int CACHE_MULTIPLIER = 1024; // Size of the DAG relative to the cache
const int EPOCH_LENGTH = 30000; // blocks per epoch
const int MIX_BYTES = 128; // width of mix
const int MIX_WORDS = MIX_BYTES ~/
    WORD_BYTES; // number of 32 bit words in the mix
const int HASH_BYTES = 64; // hash length in bytes
const int HASH_WORDS = 16; // number of 32 bit words in a hash
const int DATASET_PARENTS = 256; // number of parents of each dataset element
const int CACHE_ROUNDS = 3; // number of rounds in cache production
const int ACCESSES = 64; // number of accesses in hashimoto loop
const int NONCE_BYTES = 8;

int MIX_HASHES = MIX_BYTES ~/ HASH_BYTES;
