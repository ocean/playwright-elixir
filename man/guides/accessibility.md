# Accessibility Testing

Playwright provides tools for testing web application accessibility. This guide covers modern accessibility testing approaches available in Playwright Elixir.

## ARIA Snapshots (Recommended)

ARIA snapshots capture the accessibility tree of a page or element as a YAML string. This is the modern, recommended approach for accessibility testing in Playwright.

### Basic Usage

To get an ARIA snapshot of an element:

```elixir
alias Playwright.{Page, Locator}

page = Browser.new_page(browser)
Page.goto(page, "https://example.com")

# Get ARIA snapshot of a specific element
locator = Page.locator(page, "button")
snapshot = Locator.aria_snapshot(locator)
IO.inspect(snapshot)
```

The `aria_snapshot/2` method returns a YAML-formatted string representing the accessibility tree.

### Snapshot Format

The ARIA snapshot output is a YAML representation of the accessibility tree, including:

- **Role**: The ARIA role (e.g., `button`, `heading`, `textbox`)
- **Name**: The accessible name of the element
- **Attributes**: ARIA attributes like `aria-label`, `aria-checked`, `aria-disabled`
- **Children**: Child elements in the accessibility tree
- **State**: Current state information (focused, checked, selected, etc.)

Example output:

```
- button "Submit"
  - list
    - listitem "Item 1"
    - listitem "Item 2"
```

### Advanced Options

The `aria_snapshot/2` function accepts options:

```elixir
# Get snapshot of a specific element
element = Page.query_selector(page, ".container")
snapshot = Locator.aria_snapshot(locator, %{root: element})
```

## Testing Accessibility with Locators

Use `Page.get_by_role/3` to find elements by their accessibility role:

```elixir
alias Playwright.Page

# Find buttons by their role
submit_button = Page.get_by_role(page, "button", %{name: "Submit"})

# Find headings
heading = Page.get_by_role(page, "heading", %{level: 1})

# Find form inputs
name_input = Page.get_by_role(page, "textbox", %{name: "Name"})

# Verify the element is visible
Locator.is_visible(submit_button)
```

## Common Accessibility Patterns

### Testing Form Accessibility

```elixir
alias Playwright.{Page, Locator}

# Test label associations
email_field = Page.get_by_role(page, "textbox", %{name: "Email"})
Locator.fill(email_field, "test@example.com")

# Test required fields
Locator.is_required(email_field)
```

### Testing Navigation

```elixir
# Test navigation landmarks
nav = Page.get_by_role(page, "navigation")

# Test links by accessible name
home_link = Page.get_by_role(page, "link", %{name: "Home"})
```

### Testing Dynamic Content

```elixir
# After an action that changes the page
Locator.click(button)

# Get current accessibility state
snapshot = Locator.aria_snapshot(Page.locator(page, "body"))
```

## Integration with External Tools

For comprehensive accessibility auditing, integrate with external tools:

### Axe DevTools

While Axe is a JavaScript library, you can use it with Playwright:

```javascript
// In your test setup:
Page.add_script_tag(page, %{path: "node_modules/axe-core/axe.min.js"})
```

See: https://www.deque.com/axe/

## Migration from Old API

If you were using the deprecated `Page.Accessibility.snapshot/2`, migrate to the new approach:

### Old Code (Removed in v1.26)

```elixir
# This no longer works!
snapshot = Page.Accessibility.snapshot(page)
```

### New Code

```elixir
# Use ARIA snapshots instead
locator = Page.locator(page, "body")
snapshot = Locator.aria_snapshot(locator)

# Or use accessible locators for testing
button = Page.get_by_role(page, "button", %{name: "Click me"})
Locator.click(button)
```

## Best Practices

1. **Use Semantic HTML**: Ensure your HTML uses proper semantic elements (`button`, `input`, `heading`, etc.)

2. **Test with Roles**: Always test using `get_by_role` to verify accessibility

3. **Check ARIA Attributes**: Verify that ARIA labels and descriptions are present where needed

4. **Test Keyboard Navigation**: Use `Locator.focus/2` and test tab order

5. **Verify Screen Reader Text**: Use ARIA snapshots to verify text presented to screen readers

## Resources

- [Playwright Accessibility Testing Guide](https://playwright.dev/docs/accessibility-testing)
- [ARIA Snapshots Documentation](https://playwright.dev/docs/aria-snapshots)
- [W3C WAI-ARIA Practices](https://www.w3.org/WAI/ARIA/apg/)
- [WebAIM Resources](https://webaim.org/)
- [Deque Axe](https://www.deque.com/axe/)
