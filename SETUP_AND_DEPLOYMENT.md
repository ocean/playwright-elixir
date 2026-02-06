# Setup and Deployment Guide

## How Playwright Elixir Works

Playwright Elixir is a wrapper around the Playwright Node.js library. When installed as a dependency, it requires some setup steps.

## Installation as a Dependency

When a user adds `playwright` to their `mix.exs` dependencies:

```elixir
def deps do
  [
    {:playwright, "~> 1.50.0"}
  ]
end
```

Running `mix deps.get` will install the Elixir library files, **but NOT automatically**:
1. Install the Playwright Node.js package
2. Download browser runtimes

## Manual Setup Required

After installing the dependency, users must perform additional setup:

### Step 1: Install Node.js Dependencies

The library includes a `package.json` at `priv/static/package.json` that specifies the Playwright version:

```json
{
  "engines": {
    "node": ">=22"
  },
  "dependencies": {
    "playwright": "1.58.1"
  }
}
```

Users must manually install these dependencies:

```bash
cd priv/static
npm install
```

Or if using yarn/pnpm:

```bash
cd priv/static
yarn install
# or
pnpm install
```

### Step 2: Download Browser Runtimes

After installing the Node.js dependencies, Playwright will automatically download browser binaries when first used. This happens via the Playwright CLI:

```bash
cd priv/static
npx playwright install
```

This downloads:
- Chromium
- Firefox
- WebKit

Alternatively, users can install specific browsers:

```bash
npx playwright install chromium
npx playwright install firefox
npx playwright install webkit
```

### Step 3: Verify Installation

Users can verify the installation by running:

```bash
npx playwright --version
```

## Automated Setup (Optional)

Projects can automate setup using Mix tasks or build scripts:

### Option 1: Custom Mix Task

Create `lib/mix/tasks/playwright.setup.ex`:

```elixir
defmodule Mix.Tasks.Playwright.Setup do
  use Mix.Task
  
  def run(_args) do
    File.cd!("priv/static", fn ->
      Mix.Shell.IO.info("Installing Node.js dependencies...")
      System.cmd("npm", ["install"])
      
      Mix.Shell.IO.info("Downloading Playwright browsers...")
      System.cmd("npx", ["playwright", "install"])
    end)
  end
end
```

Then users can run: `mix playwright.setup`

### Option 2: Package Prefix Hook

Add to `mix.exs`:

```elixir
def project do
  [
    app: :my_app,
    # ... other config ...
    compilers: [:playwright] ++ Mix.compilers(),
  ]
end

def compilers do
  [Playwright.Compiler]
end
```

### Option 3: Makefile

Create a `Makefile` in the project root:

```makefile
.PHONY: setup
setup:
	cd priv/static && npm install && npx playwright install

.PHONY: setup-ci
setup-ci:
	cd priv/static && npm ci && npx playwright install
```

## Configuration Options

Users can customize the Playwright driver path in `config/config.exs`:

```elixir
config :playwright, Playwright.SDK.Config.Types.LaunchOptions,
  driver_path: "/custom/path/to/cli.js"
```

By default, it uses: `priv/static/driver.js` (which is a symlink to the installed Playwright CLI)

## Deployment

### Docker Setup

For containerized deployments:

```dockerfile
FROM node:22

WORKDIR /app

COPY priv/static/package.json priv/static/package-lock.json ./priv/static/
RUN cd priv/static && npm install && npx playwright install

COPY . .

# Install Elixir dependencies
RUN mix deps.get && mix compile
```

### Release Builds (Distillery/mix release)

For production releases, include the Node.js dependencies:

1. Ensure `node_modules` is NOT in `.gitignore` (or at least `priv/static/node_modules` is committed)
2. Or, run the npm install step during release generation

```bash
# In your release generation step
cd priv/static
npm ci  # use npm ci for exact versions
npx playwright install
```

### Requirements

- **Node.js**: Version 22+ (as specified in `package.json`)
- **npm/yarn/pnpm**: For package management
- **Disk Space**: ~1-2GB for browser binaries
- **Platform Support**: Linux, macOS, Windows

## Troubleshooting

### "Cannot find module 'playwright'"

**Solution**: Run `npm install` in `priv/static/`

```bash
cd priv/static && npm install
```

### "Browser not found"

**Solution**: Run `npx playwright install` to download browsers

```bash
cd priv/static && npx playwright install
```

### Wrong Node.js version

**Solution**: Update Node.js to version 22+

```bash
node --version  # Should be v22.x.x or higher
```

### Driver path issues

**Solution**: Check that the `driver.js` symlink is valid

```bash
ls -la priv/static/driver.js
```

It should point to: `node_modules/playwright/cli.js`

## Best Practices

1. **Version Pinning**: Use `npm ci` instead of `npm install` in CI/CD
   ```bash
   cd priv/static && npm ci
   ```

2. **Caching**: Cache `node_modules` in CI/CD to speed up builds

3. **Separate Build Steps**: Keep Node.js setup separate from Elixir compilation

4. **Environment Variables**: Set `PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1` if you're installing browsers in a separate step

5. **Minimal Installs**: Only install browsers you need:
   ```bash
   npx playwright install chromium  # Only Chromium
   ```

## Related Resources

- [Playwright Node.js Documentation](https://playwright.dev/docs/intro)
- [npm package.json Reference](https://docs.npmjs.com/cli/v10/configuring-npm/package-json)
- [Node.js Installation](https://nodejs.org/en/)
- [Playwright CLI Reference](https://playwright.dev/docs/cli)

## Future Improvements

Ideally, Playwright Elixir could improve this by:

1. Providing a pre-built driver as a binary release
2. Auto-downloading Node.js if not present
3. Automating npm dependency installation during `mix deps.get`
4. Supporting platform-specific pre-compiled binaries

Currently, these improvements are not implemented, so manual setup is required.
