# Development

This page describes how to set up a development environment and work on
minifetch.

## Requirements

- A C compiler (for the C version)
- Bash (for the shell version)

## Getting the code

```bash
git clone https://github.com/anshlabs716/minifetch.git
cd minifetch
```

## Build

```bash
cc -O2 -o minifetch minifetch.c
```

## Run

```bash
./minifetch
```

## Test

```bash
shellcheck minifetch.sh
```

## Workflow

- Branch from `main` (see [CONTRIBUTING.md](../CONTRIBUTING.md)).
- Keep changes focused and documented.
- Update `CHANGELOG.md` for user-facing changes.
