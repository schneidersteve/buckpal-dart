# Dart Example Implementation of a Hexagonal/Onion/Clean Architecture

Inspired by https://github.com/thombergs/buckpal

* Kotlin Version: https://github.com/schneidersteve/buckpal-kotlin
* Rust Version: https://github.com/schneidersteve/buckpal-rust

## Tech Stack
* [Dart 3](https://dart.dev)
* [Visual Studio Code](https://code.visualstudio.com)
* [Visual Studio Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers#_quick-start-open-a-git-repository-or-github-pr-in-an-isolated-container-volume)

## Layers and Dependency Inversion

![Dependency Inversion](di.png)

## Send Money Use Case

```gherkin
Feature: Send Money

  Scenario: Transaction succeeds
    Given a source account
    And a target account

    When money is send

    Then send money succeeds

    And source account is locked
    And source account withdrawal will succeed
    And source account is released

    And target account is locked
    And target account deposit will succeed
    And target account is released

    And accounts have been updated
```

# Dart Examples

> dart pub get

> dart analyze

> dart test

> dart test -r expanded

> dart run

> find . -name "*.dart" | entr -cr dart test -r expanded
