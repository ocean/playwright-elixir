# Usage Guide

Complete guide for setting up and using Playwright Elixir in your projects.

## Table of Contents

1. [Installation](#installation)
2. [Local Setup](#local-setup)
3. [Remote Setup](#remote-setup)
4. [Basic Usage](#basic-usage)
5. [Common Tasks](#common-tasks)
6. [Configuration](#configuration)
7. [Troubleshooting](#troubleshooting)

## Installation

Add Playwright to your `mix.exs`:

```elixir
def deps do
  [
    {:playwright, "~> 1.50.0"}
  ]
end
```

Run `mix deps.get` to fetch the dependency.

## Local Setup

For local browser automation (default mode), you need to install Node.js dependencies and browser binaries.

### Step 1: Install Node.js Dependencies

Navigate to the `priv/static` directory and install Playwright:

```bash
cd priv/static
npm install
```

This installs the Playwright Node.js package (v1.58.1) specified in `package.json`.

### Step 2: Download Browser Binaries

Download browser runtimes for Chromium, Firefox, and WebKit:

```bash
npx playwright install
```

Or install only specific browsers:

```bash
npx playwright install chromium
npx playwright install firefox
npx playwright install webkit
```

### Step 3: Verify Installation

Check that Playwright is properly installed:

```bash
npx playwright --version
```

## Remote Setup

Playwright Elixir can connect to a remote Playwright server via WebSocket. This is useful for:
- Cloud-based automation
- Distributed testing
- Scaled automation services
- Services like Cloudflare Browser Rendering

### Option 1: Self-Hosted Playwright Server

Run a local Playwright server:

```bash
cd priv/static
npx playwright server
```

The server will listen on `ws://localhost:3000`.

### Option 2: Docker-Based Server

Run Playwright server in Docker:

```bash
docker run -p 3000:3000 mcr.microsoft.com/playwright:v1.58.1-focal \
  npx playwright server --host 0.0.0.0
```

### Option 3: Cloud Services

Services that provide Playwright-compatible WebSocket endpoints:
- BrowserBase
- Cloudflare Browser Rendering
- Custom deployments on AWS, GCP, Azure, etc.

### Configure Elixir to Use Remote Server

Update your configuration to connect via WebSocket:

```elixir
# config/config.exs
config :playwright, PlaywrightTest,
  transport: :websocket,
  ws_endpoint: "ws://remote-server:3000"
```

Or for a secure connection:

```elixir
config :playwright, PlaywrightTest,
  transport: :websocket,
  ws_endpoint: "wss://remote-server.example.com"
```

## Basic Usage

### Using PlaywrightTest.Case

For testing, use the `PlaywrightTest.Case` helper:

```elixir
defmodule MyApp.BrowserTest do
  use ExUnit.Case, async: true
  use PlaywrightTest.Case

  test "navigates to a website", %{page: page} do
    Playwright.Page.goto(page, "https://example.com")
    text = Playwright.Page.text_content(page, "h1")
    assert text != nil
  end
end
```

The test case automatically provides:
- `page` - A fresh browser page for each test
- `browser` - The browser instance
- `context` - The browser context
- `assets` - Test asset server

### Manual Browser Creation

For non-test usage:

```elixir
defmodule MyApp.Scraper do
  alias Playwright.{Browser, Page}

  def scrape_website(url) do
    # Launch browser
    {:ok, browser} = Browser.launch()
    page = Browser.new_page(browser)

    # Navigate and interact
    Page.goto(page, url)
    title = Page.title(page)
    html = Page.content(page)

    # Cleanup
    Page.close(page)
    Browser.close(browser)

    {title, html}
  end
end
```

## Common Tasks

### Navigation

```elixir
# Navigate to a URL
Page.goto(page, "https://example.com")

# Wait for URL to match
Page.goto(page, "https://example.com", %{wait_until: "networkidle"})

# Get current URL
url = Page.url(page)

# Go back/forward
Page.go_back(page)
Page.go_forward(page)

# Reload page
Page.reload(page)
```

### Locating Elements

```elixir
alias Playwright.Page

# CSS selector
button = Page.locator(page, "button")

# XPath
element = Page.locator(page, "xpath=//div[@class='item']")

# Accessible name (recommended)
button = Page.get_by_role(page, "button", %{name: "Submit"})

# Text content
link = Page.get_by_text(page, "Click here")

# Test ID
input = Page.get_by_test_id(page, "username")
```

### Interacting with Elements

```elixir
alias Playwright.Locator

# Click
Locator.click(button)

# Type text
Locator.fill(input, "hello world")

# Select option
Locator.select_option(select, "option1")

# Check/uncheck
Locator.check(checkbox)
Locator.uncheck(checkbox)

# Hover
Locator.hover(element)

# Scroll into view
Locator.scroll_into_view(element)
```

### Extracting Data

```elixir
alias Playwright.{Page, Locator}

# Get text content
text = Locator.text_content(button)

# Get attribute
href = Locator.get_attribute(link, "href")

# Get input value
value = Locator.input_value(input)

# Get HTML
html = Locator.inner_html(element)

# Count elements
count = Locator.count(Page.locator(page, "li"))
```

### Waiting

```elixir
alias Playwright.Page

# Wait for selector to be visible
Page.wait_for_selector(page, ".modal", %{timeout: 5000})

# Wait for function to return true
Page.wait_for_function(page, "() => document.readyState === 'complete'")

# Wait for navigation
Page.wait_for_navigation(page, fn -> Locator.click(link) end)

# Wait for popup
new_page = Page.wait_for_popup(page, fn -> Locator.click(link) end)
```

### Taking Screenshots and Videos

```elixir
alias Playwright.{Page, Locator}

# Full page screenshot
Page.screenshot(page, %{path: "screenshot.png"})

# Element screenshot
Locator.screenshot(button, %{path: "button.png"})

# Record video (set when creating context)
context = Browser.new_context(browser, %{record_video_dir: "videos/"})
page = BrowserContext.new_page(context)
```

### Accessibility Testing

```elixir
alias Playwright.{Page, Locator}

# Get ARIA snapshot
button = Page.locator(page, "button")
snapshot = Locator.aria_snapshot(button)
IO.inspect(snapshot)

# Verify accessible name
button = Page.get_by_role(page, "button", %{name: "Submit"})
assert Locator.is_visible(button)
```

### Network Interception

```elixir
alias Playwright.{Page, Route}

# Route requests
Page.route(page, "**/api/**", fn route ->
  if Route.request(route).url() |> String.contains?("sensitive") do
    Route.abort(route)
  else
    Route.continue(route)
  end
end)

# Mock responses
Page.route(page, "**/api/users", fn route ->
  Route.fulfill(route, %{
    status: 200,
    content_type: "application/json",
    body: Jason.encode!(%{id: 1, name: "John"})
  })
end)
```

### WebSocket Routing

```elixir
alias Playwright.Page

# Route WebSocket connections
Page.route_web_socket(page, "/api/ws", fn ws ->
  ws.onMessage(fn message ->
    IO.inspect(message)
  end)
  
  ws.onClose(fn ->
    IO.puts("WebSocket closed")
  end)
end)
```

### Page Introspection

```elixir
alias Playwright.Page

# Get console messages
messages = Page.console_messages(page)

# Get page errors
errors = Page.page_errors(page)

# Get all requests
requests = Page.requests(page)

# Get cookies
cookies = Page.context(page) |> BrowserContext.cookies(page)
```

## Configuration

### Launch Options

Configure browser launch behavior:

```elixir
config :playwright, Playwright.SDK.Config.Types.LaunchOptions,
  headless: false,                    # Show browser window
  slow_mo: 100,                       # Slow down operations (ms)
  args: ["--disable-blink-features=AutomationControlled"],
  channel: "chromium"                 # or "firefox", "webkit"
```

### Context Options

Configure page context defaults:

```elixir
context = Browser.new_context(browser, %{
  viewport: %{width: 1280, height: 720},
  locale: "en-US",
  timezone_id: "America/New_York",
  permissions: ["geolocation"],
  geolocation: %{latitude: 37.7749, longitude: -122.4194}
})
```

### Custom Driver Path

Use a custom Playwright driver:

```elixir
config :playwright, Playwright.SDK.Config.Types.LaunchOptions,
  driver_path: "/path/to/custom/cli.js"
```

## Troubleshooting

### "Cannot find module 'playwright'"

The Node.js dependencies were not installed. Run:

```bash
cd priv/static
npm install
```

### "Browser not found"

Browser binaries are missing. Install them:

```bash
cd priv/static
npx playwright install
```

### "Cannot connect to WebSocket"

Verify the WebSocket endpoint is correct and the server is running:

```bash
# Test local server
npx playwright server
# Should listen on ws://localhost:3000

# Check configuration
config :playwright, PlaywrightTest,
  transport: :websocket,
  ws_endpoint: "ws://localhost:3000"
```

### Tests timing out

Increase timeout values:

```elixir
# In test
use PlaywrightTest.Case, timeout: 30_000  # 30 seconds

# Or in config
config :playwright, Playwright.SDK.Config.Types.LaunchOptions,
  timeout: 30_000
```

### Performance issues

Optimize with these settings:

```elixir
# Use headless mode (default)
config :playwright, Playwright.SDK.Config.Types.LaunchOptions,
  headless: true

# Disable unnecessary features
config :playwright, Playwright.SDK.Config.Types.LaunchOptions,
  args: [
    "--disable-extensions",
    "--disable-sync",
    "--no-first-run"
  ]

# Use parallel tests
# In mix.exs
def project do
  [
    # ...
    test_coverage: [tool: :cover],
    preferred_cli_env: [
      "test": :test
    ]
  ]
end
```

### Connection refused errors

Check Node.js and port availability:

```bash
# Verify Node.js is installed
node --version  # Should be v22+

# Check port availability
lsof -i :3000   # For port 3000

# Try a different port
npx playwright server --port 3001
```

## Further Reading

- [Getting Started Guide](https://hexdocs.pm/playwright/basics-getting-started.html)
- [API Reference](https://hexdocs.pm/playwright/api-reference.html)
- [Accessibility Testing](man/guides/accessibility.md)
- [Setup & Deployment](SETUP_AND_DEPLOYMENT.md)
- [Official Playwright Docs](https://playwright.dev/)
