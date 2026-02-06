defmodule Playwright.Page.AccessibilityTest do
  use Playwright.TestCase, async: true
  alias Playwright.{Page, Locator}

  describe "ARIA snapshots - replaces deprecated Page.Accessibility.snapshot" do
    test "basic button snapshot", %{page: page} do
      Page.set_content(page, "<button>Click me</button>")
      locator = Page.locator(page, "button")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
      assert String.contains?(snapshot, "button")
      assert String.contains?(snapshot, "Click me")
    end

    test "input element snapshot", %{page: page} do
      Page.set_content(page, "<input placeholder='Enter text' title='My Input' />")
      locator = Page.locator(page, "input")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
      assert String.contains?(snapshot, "textbox")
    end

    test "heading element snapshot", %{page: page} do
      Page.set_content(page, "<h1>My Heading</h1>")
      locator = Page.locator(page, "h1")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
      assert String.contains?(snapshot, "heading")
      assert String.contains?(snapshot, "My Heading")
    end

    test "text content snapshot", %{page: page} do
      Page.set_content(page, "<div>Hello World</div>")
      locator = Page.locator(page, "div")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
      assert String.contains?(snapshot, "Hello World")
    end

    test "complex form elements", %{page: page} do
      Page.set_content(page, """
      <form>
        <label>Name: <input type="text" /></label>
        <label>Email: <input type="email" /></label>
        <button type="submit">Submit</button>
      </form>
      """)

      locator = Page.locator(page, "form")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
      assert String.contains?(snapshot, "Submit")
    end

    test "with ARIA attributes (roledescription)", %{page: page} do
      Page.set_content(page, "<p aria-roledescription='custom role'>Content</p>")
      locator = Page.locator(page, "p")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
    end

    test "with ARIA attributes (autocomplete)", %{page: page} do
      Page.set_content(page, "<div role='textbox' aria-autocomplete='list'>Autocomplete field</div>")
      locator = Page.locator(page, "div")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
      assert String.contains?(snapshot, "textbox")
    end

    test "with readonly attribute", %{page: page} do
      Page.set_content(page, "<input type='text' readonly value='read-only' />")
      locator = Page.locator(page, "input")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
    end

    test "with disabled attribute", %{page: page} do
      Page.set_content(page, "<input type='text' disabled />")
      locator = Page.locator(page, "input")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
    end

    test "with tab structure", %{page: page} do
      Page.set_content(page, """
      <div role="tablist">
        <div role="tab" aria-selected="true">Tab 1</div>
        <div role="tab">Tab 2</div>
      </div>
      """)

      locator = Page.locator(page, "div[role='tablist']")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
      assert String.contains?(snapshot, "tab")
    end

    test "with menu structure", %{page: page} do
      Page.set_content(page, """
      <div role="menu" title="My Menu">
        <div role="menuitem">First Item</div>
        <div role="menuitem">Second Item</div>
      </div>
      """)

      locator = Page.locator(page, "div[role='menu']")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
      assert String.contains?(snapshot, "menu")
    end

    test "with contenteditable", %{page: page} do
      Page.set_content(page, "<div contenteditable='plaintext-only'>Editable text</div>")
      locator = Page.locator(page, "div")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
    end

    test "with aria-hidden elements", %{page: page} do
      Page.set_content(page, """
      <div>Visible</div>
      <div aria-hidden="true">Hidden</div>
      """)

      locator = Page.locator(page, "div:first-child")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
      assert String.contains?(snapshot, "Visible")
    end

    test "with aria-label", %{page: page} do
      Page.set_content(page, "<button aria-label='Close dialog'>✕</button>")
      locator = Page.locator(page, "button")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
      assert String.contains?(snapshot, "Close dialog")
    end

    test "with aria-describedby", %{page: page} do
      Page.set_content(page, """
      <div id="description">This is a description</div>
      <input aria-describedby="description" />
      """)

      locator = Page.locator(page, "input")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
    end

    test "checkbox with aria-checked", %{page: page} do
      Page.set_content(page, """
      <div role="checkbox" aria-checked="true" aria-label="Accept">
        Accept terms
      </div>
      """)

      locator = Page.locator(page, "div[role='checkbox']")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
      assert String.contains?(snapshot, "checkbox")
    end

    test "with aria-orientation", %{page: page} do
      Page.set_content(page, "<a href='' role='slider' aria-orientation='vertical' aria-label='Volume'>20</a>")
      locator = Page.locator(page, "a")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
    end

    test "with aria-multiselectable", %{page: page} do
      Page.set_content(page, "<div role='grid' aria-multiselectable='true'>Grid</div>")
      locator = Page.locator(page, "div[role='grid']")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
    end

    test "with aria-keyshortcuts", %{page: page} do
      Page.set_content(page, "<div role='menuitem' aria-keyshortcuts='Alt+S'>Save</div>")
      locator = Page.locator(page, "div[role='menuitem']")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
    end

    test "list structure with role", %{page: page} do
      Page.set_content(page, """
      <ul>
        <li>Item 1</li>
        <li>Item 2</li>
        <li>Item 3</li>
      </ul>
      """)

      locator = Page.locator(page, "ul")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
    end

    test "nested structure", %{page: page} do
      Page.set_content(page, """
      <div>
        <h2>Title</h2>
        <p>Paragraph text</p>
        <button>Action</button>
      </div>
      """)

      locator = Page.locator(page, "div")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
      assert String.contains?(snapshot, "Title")
    end

    test "empty element", %{page: page} do
      Page.set_content(page, "<div></div>")
      locator = Page.locator(page, "div")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
    end

    test "with data attributes (should not affect ARIA)", %{page: page} do
      Page.set_content(page, "<button data-test='my-button'>Click</button>")
      locator = Page.locator(page, "button")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
      assert String.contains?(snapshot, "button")
      assert String.contains?(snapshot, "Click")
    end

    test "full page accessibility tree", %{page: page} do
      Page.set_content(page, """
      <html>
        <head><title>Test Page</title></head>
        <body>
          <h1>Main Title</h1>
          <p>Introduction paragraph</p>
          <button>Submit</button>
        </body>
      </html>
      """)

      locator = Page.locator(page, "body")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
      assert String.contains?(snapshot, "Main Title")
    end

    test "inline elements", %{page: page} do
      Page.set_content(page, "<p>This is <strong>bold</strong> and <em>italic</em> text.</p>")
      locator = Page.locator(page, "p")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
    end

    test "with image alt text", %{page: page} do
      Page.set_content(page, "<img src='test.jpg' alt='Test image description' />")
      locator = Page.locator(page, "img")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
    end

    test "link element", %{page: page} do
      Page.set_content(page, "<a href='https://example.com'>Click here</a>")
      locator = Page.locator(page, "a")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
      assert String.contains?(snapshot, "link")
    end

    test "select dropdown", %{page: page} do
      Page.set_content(page, """
      <select>
        <option>Option 1</option>
        <option>Option 2</option>
      </select>
      """)

      locator = Page.locator(page, "select")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
    end

    test "textarea element", %{page: page} do
      Page.set_content(page, "<textarea placeholder='Enter text'></textarea>")
      locator = Page.locator(page, "textarea")
      snapshot = Locator.aria_snapshot(locator)

      assert is_binary(snapshot)
    end
  end

  describe "Page.locator with aria_snapshot" do
    test "locator.aria_snapshot returns string format", %{page: page} do
      Page.set_content(page, """
      <div>
        <h1>Accessibility Test</h1>
        <p>This is a paragraph</p>
      </div>
      """)

      locator = Page.locator(page, "div")
      snapshot = Locator.aria_snapshot(locator)

      # ARIA snapshots are returned as YAML strings
      assert is_binary(snapshot)
      assert String.length(snapshot) > 0
    end
  end

  # NOTE: Migration guidance for users currently using Page.Accessibility.snapshot
  #
  # OLD API (Removed in Playwright v1.26):
  #   snapshot = Page.Accessibility.snapshot(page)
  #   # Returns: map with :role, :name, :children, etc.
  #
  # NEW API (Current):
  #   locator = Page.locator(page, selector)
  #   snapshot = Locator.aria_snapshot(locator)
  #   # Returns: binary (YAML string) with accessibility tree
  #
  # For more complex accessibility testing, consider:
  #   1. Parse the YAML snapshot for specific assertions
  #   2. Use expect(locator).toMatchAriaSnapshot() in JavaScript
  #   3. Integrate with accessibility testing libraries (e.g., Axe)
  #
  # See: https://playwright.dev/docs/aria-snapshots
end
