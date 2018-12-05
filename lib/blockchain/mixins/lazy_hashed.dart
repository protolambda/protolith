
mixin LazyHashed<H> {

  H _hash;

  /// hash of the data, of type [H].
  H get hash => _hash;

  /// Changes the hash. Should only be called when the data is trusted.
  set hash(H h) {
    _hash = h;
  }

  /// Used to define that a variable is hashed.
  /// This applies all the side-effects to make sure the hash is always
  ///  either un-initialized or consistent with the latest data.
  V hashed<V>(V v) {
    /// This is essentially a helper function that passes through
    ///  the argument while resetting the hash.
    /// Note: a class can override this implement
    ///  their own hashing/invalidation of hashes.
    _hash = null;
    return v;
  }

}