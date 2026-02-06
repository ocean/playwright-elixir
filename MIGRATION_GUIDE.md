# Migration Guide: Playwright Elixir v1.50.0

This guide helps you upgrade to Playwright Elixir v1.50.0, which supports Playwright v1.58.1.

## Breaking Changes

### Removed: `Page.Accessibility.snapshot/2` (Removed in Playwright v1.26)

The `Page.Accessibility.snapshot/2` method has been completely removed from Playwright as of v1.26 (August 2022). This library no longer provides functional support for this API.

#### Before (Old Code - No Longer Works)

```elixir
alias Playwright.Page

snapshot = Page.Accessibility.snapshot(page)
# Returns: %{role: "WebArea", name: "...", children: [...]}
# Now raises: "Page.Accessibility.snapshot/2 has been removed in Playwright v1.26+"
```

#### After (New Code - Recommended)

Use `Locator.aria_snapshot/2` to capture the accessibility tree:

```elixir
alias Playwright.{Page, Locator}

# Method 1: Get ARIA snapshot of an element
locator = Page.locator(page, "body")
snapshot = Locator.aria_snapshot(locator)
# Returns: binary (YAML string) with accessibility tree

# Method 2: Use accessible locators for testing (Recommended for most cases)
button = Page.get_by_role(page, "button", %{name: "Submit"})
assert Locator.is_visible(button)

# Method 3: Combine with Axe for detailed accessibility reports
# See: https://www.deque.com/axe/
```

### Removed: `_react` and `_vue` Selectors

These special selectors for component frameworks have been removed from Playwright.

#### Before

```elixir
locator = Page.locator("_react=MyComponent")
```

#### After

Use standard CSS or accessibility-based selectors:

```elixir
# Use CSS selectors
locator = Page.locator("[data-testid='my-component']")

# Or use accessible selectors (Recommended)
locator = Page.get_by_role("button", %{name: "Submit"})
```

### Removed: `:light` Selector Suffix

The `:light` selector engine suffix has been removed.

#### Before

```elixir
locator = Page.locator("button:light")
```

#### After

Use the shadow DOM piercer `>>>` if needed:

```elixir
locator = Page.locator("button >>> span")
```

### Removed: `devtools` Option in Browser Launch

The `devtools` option is no longer available in `browserType.launch()`.

#### Before

```elixir
browser = Playwright.Chromium.launch(%{devtools: true})
```

#### After

Use command-line arguments instead:

```elixir
browser = Playwright.Chromium.launch(%{
  args: ["--auto-open-devtools-for-tabs"]
})
```

## New Features Available

### ARIA Snapshots (Recommended for Accessibility Testing)

```elixir
locator = Page.locator("button")
snapshot = Locator.aria_snapshot(locator)
# Returns YAML string with accessibility tree
```

### WebSocket Routing

```elixir
Page.route_web_socket(page, "/api/ws", fn ws ->
  ws.onMessage(fn message ->
    IO.inspect(message)
  end)
end)
```

### Page Introspection Methods

```elixir
# Get all console messages from the page
messages = Page.console_messages(page)

# Get all page errors
errors = Page.page_errors(page)

# Get all requests made by the page
requests = Page.requests(page)
```

### Locator Chain Operations

```elixir
# Combine locators with AND operation
locator = Page.locator(".foo") |> Locator.and_(Page.locator(".bar"))

# Combine locators with OR operation
locator = Page.locator(".foo") |> Locator.or_(Page.locator(".bar"))
```

## Checklist for Upgrading

- [ ] Remove any usage of `Page.Accessibility.snapshot/2`
- [ ] Replace with `Locator.aria_snapshot/2` if you need accessibility snapshots
- [ ] Update selectors: Replace `_react=` and `_vue=` with CSS or accessible selectors
- [ ] Update browser launch options: Replace `devtools: true` with `args: ["--auto-open-devtools-for-tabs"]`
- [ ] Test your application thoroughly
- [ ] Review accessibility tests and update to use new ARIA snapshot approach

## Testing Strategy

1. **Find & Replace**: Search for `Page.Accessibility.snapshot` and update occurrences
2. **Update Selectors**: Replace framework-specific selectors with CSS or role-based selectors
3. **Test Accessibility**: Run your accessibility tests with new ARIA snapshot approach
4. **Verify Functionality**: Run full test suite to ensure no regressions
5. **Deploy**: Update to v1.50.0 with confidence

## Support and Documentation

For more information, see:
- [Accessibility Testing Guide](man/guides/accessibility.md)
- [Playwright Documentation](https://playwright.dev/)
- [ARIA Snapshots Documentation](https://playwright.dev/docs/aria-snapshots)
- [GitHub Issues](https://github.com/ocean/playwright-elixir/issues)

## Version History

| Version | Playwright | Status | Notes |
|---------|-----------|--------|-------|
| 1.50.0 | 1.58.1 | Stable | Modern accessibility API, all tests passing |
| 1.49.1 | 1.49.1 | Deprecated | Old accessibility API, no longer supported |
| 1.26+ | 1.26+ | Unsupported | `Page.Accessibility` removed from Playwright |

## Need Help?

If you encounter issues during migration:

1. Check the [Accessibility Testing Guide](man/guides/accessibility.md)
2. Review the [test examples](test/api/page/accessibility_test.exs)
3. File an issue on [GitHub](https://github.com/ocean/playwright-elixir/issues)
