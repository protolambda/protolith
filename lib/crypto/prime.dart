
bool isPrime(int n) => (n > 1) && ! Iterable.generate(n).any((i) => n % i == 0);
