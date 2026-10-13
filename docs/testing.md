# Testing

This page describes how minifetch is tested and how to run the tests yourself.

## Running the tests

```bash
shellcheck minifetch.sh
```

## What is covered

ShellCheck for the shell version; manual comparison of output across distros.

## Adding tests

- Add tests alongside the code they cover.
- Prefer testing behavior over implementation details.
- Keep fixtures free of real personal data, keys, or credentials.

## Current status

Automated test coverage is a work in progress. Contributions that add tests are
welcome.
