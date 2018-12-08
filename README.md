# Protolith

Protolith is a compositional codebase to innovate within the blockchain space.

## Rationale

From the [Oxford Dictionary](https://en.oxforddictionaries.com/definition/protolith):

> The parent rock from which a given metamorphic rock developed.

We think of the code on ethereum-mainnet as one (well-defined) metamorphism of the concept of "blockchain".
When you want to build another metamorphism (e.g. a plasma chain), you should start at the base, but re-use components where possible.
Protolith provides an extensible abstraction of the many components used in popular blockchains,
 and enables you to literally [mix](https://www.dartlang.org/articles/language/mixins) them together.

Protolith aims to be:

1) Easy to re-compose for different user needs.
2) Easy to add new features to, without affecting existing code.
4) Easy to maintain; a well defined but extensible interface should enable innovations to be introduced easily.
3) Blockchain-agnostic. A compositional codebase enables different projects to build on it, and share their contributions.
5) Platform-agnostic. Dart may not be the fastest language, but scaling and innovation is about the bigger picture of architecture.
 Dart enables others to run it on servers (DartVM), browsers (dart2js), and mobile (Flutter).

## Getting Started / Installation

This is an experiment in early stage, run/deploy wherever and however you would like.
Discussions about features are welcome, but do not expect to have your use case supported from the very start.

## Contributing

This project is very much still an *experiment*, and is in constant change.
With the ETHSingapore event the first blockchain spec implementation (other than default main-net)
 on top of this codebase is prototyped; a sharded chain, simplified by abstracting away some of the 
 less theoretically-rewarding components such as networking, and a DB.

## License

MIT, see License file. 

## Credits

Original project by @protolambda

