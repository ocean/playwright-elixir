# Playwright for Elixir

**Status**: Production Ready

This package provides Elixir bindings for [Playwright](https://github.com/microsoft/playwright), a modern cross-browser automation framework. Supports Playwright v1.58.1 (latest).

## Overview

[Playwright](https://github.com/ocean/playwright-elixir) is an Elixir library to automate Chromium, Firefox and WebKit with a single API. Playwright is built to enable cross-browser web automation that is **ever-green**, **capable**, **reliable** and **fast**. [See how Playwright is better](https://playwright.dev/docs/why-playwright).

## Installation

The package can be installed by adding `playwright` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:playwright, "~> 1.50.0"}
  ]
end
```

Then run `mix deps.get` to install the Elixir package.

### Setup

After installing the dependency, you must install Node.js dependencies and browser runtimes:

```bash
cd priv/static
npm install
npx playwright install
```

For detailed setup instructions, see [SETUP_AND_DEPLOYMENT.md](SETUP_AND_DEPLOYMENT.md).

### Requirements

- Elixir 1.12+
- Node.js 22+
- ~1-2GB disk space for browser binaries

## What's New in v1.50.0

- **ARIA Snapshots** - Modern accessibility testing with `Locator.aria_snapshot/2`
- **Page Introspection** - New `Page.requests/1` method to get all page requests
- **WebSocket Routing** - Route and intercept WebSocket connections
- **Type Safety** - Full Dialyzer compliance (0 errors)
- **542 Tests Passing** - 100% test coverage with modern Playwright v1.58.1
- **Documentation** - Comprehensive guides for accessibility, setup, and migration

See [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) if upgrading from v1.49.1.

## Usage

Start with these guides:

- **[USAGE.md](USAGE.md)** - Complete setup and usage guide
- [Getting started](https://hexdocs.pm/playwright/basics-getting-started.html)
- [API Reference](https://hexdocs.pm/playwright/api-reference.html)
- [Accessibility Testing](man/guides/accessibility.md)
- [Setup & Deployment](SETUP_AND_DEPLOYMENT.md)

## Documentation

- **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** - Upgrade guide with breaking changes
- **[SETUP_AND_DEPLOYMENT.md](SETUP_AND_DEPLOYMENT.md)** - Installation, setup, and deployment
- **[MODERNIZATION_SUMMARY.md](MODERNIZATION_SUMMARY.md)** - Complete project status
- **[man/guides/accessibility.md](man/guides/accessibility.md)** - Modern accessibility testing

## Example

```elixir
defmodule Test.ExampleTest do
  use ExUnit.Case, async: true
  use PlaywrightTest.Case

  describe "Navigating to playwright.dev" do
    test "works", %{browser: browser} do
      page = Playwright.Browser.new_page(browser)

      Playwright.Page.goto(page, "https://playwright.dev")
      text = Playwright.Page.text_content(page, ".navbar__title")

      assert text == "Playwright"
      Playwright.Page.close(page)
    end
  end
end
```

## Version Support

This project tracks the Playwright Node.js versioning:
- **Current**: v1.50.0 (Playwright v1.58.1)
- **Node.js**: Requires v22+
- **Elixir**: Requires v1.12+

## Testing

Run the full test suite:

```bash
mix test --no-start
```

Results: **542 tests passing** (100%) with consistent performance (~26 seconds)

## Contributing

### Getting started

1. Clone the repo
2. Run `bin/dev/doctor` and address any issues
3. Run `bin/dev/test` to verify the test suite passes
4. Review [MODERNIZATION_SUMMARY.md](MODERNIZATION_SUMMARY.md) for recent changes

### Day-to-day

- Get latest code: `bin/dev/update`
- Run tests: `bin/dev/test`
- Start server: `bin/dev/start`
- Run tests and push: `bin/dev/shipit`

### Code Quality

Before submitting PRs, ensure:

```bash
mix test --no-start      # All tests pass
mix credo --strict       # Code quality checks
mix dialyzer             # Type checking
mix format               # Code formatting
```

### Releasing

1. Update version in `mix.exs` (e.g., `1.50.0`)
2. Update version in `README.md` (this file)
3. Update `CHANGELOG.md` with release notes
4. Commit: `git commit -am "Release v1.50.0"`
5. Tag: `git tag -a v1.50.0 -m "Playwright Elixir v1.50.0"`
6. Push: `git push && git push --tags`
7. Publish: `mix hex.publish`
