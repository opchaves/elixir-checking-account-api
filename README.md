# Elixir + Phoenix - Checking Account REST API

A REST API that handles operations (credit and debit) in a given checking account.

This project is using:

* [Elixir](https://elixir-lang.org) - Functional programming language
* [Phoenix Framework](http://phoenixframework.org) - An Elixir Web Framework
* [Git](https://git-scm.com) - Version Control System
* [Gitlab](https://gitlab.com) - Online Service to host and share Git repositories with the world

To get started you have to have installed on your machine [Git](https://git-scm.com) and [Erlang + Elixir](https://elixir-lang.org/install.html).

### Installing Elixir

[Follow the instruction to install Elixir on your machine](https://elixir-lang.org/install.html)

### Cloning the repository

```sh
git clone https://gitlab.com/opaulochaves/checking-account-api.git
cd checking-account-api
```

### Getting the dependencies

```sh
mix deps.get
```

### Running tests

```sh
mix test
```

> There are unit and integration tests. The tests run in parallel.

### Starting the server

```sh
mix phx.server
```

> The server is available at [localhost:4000](http://localhost:4000). I suggest you to test the API using a REST client called *Postman*.

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
