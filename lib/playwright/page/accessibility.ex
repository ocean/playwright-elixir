defmodule Playwright.Page.Accessibility do
  @moduledoc """
  **DEPRECATED**: This module is deprecated as of Playwright v1.26.

  The `Page.Accessibility.snapshot/2` method has been removed from Playwright as of v1.26 (August 2022).
  This Elixir wrapper is provided for reference only and will not function with modern Playwright versions.

  ## Migration Guide

  For modern accessibility testing in Playwright, use one of the following approaches:

  ### 1. ARIA Snapshots (Recommended for Elixir)
  Use `Locator.aria_snapshot/2` to capture the accessibility tree in YAML format:

      locator = Page.locator(page, "body")
      snapshot = Locator.aria_snapshot(locator)

  ### 2. External Accessibility Libraries
  Integrate with [Axe](https://www.deque.com/axe/) or similar libraries for comprehensive accessibility testing.
  See https://playwright.dev/docs/accessibility-testing

  ### 3. Test Assertions with Locator Roles
  Use `Locator.get_by_role/3` and standard Playwright assertions:

      button = Page.get_by_role(page, "button", %{name: "Submit"})
      Locator.click(button)

  ## References

  - [Aria Snapshots](https://playwright.dev/docs/aria-snapshots)
  - [Accessibility Testing Guide](https://playwright.dev/docs/accessibility-testing)
  - [Deprecation Issue](https://github.com/microsoft/playwright/issues/16159)
  """

  alias Playwright.{Page, ElementHandle}

  @typedoc """
  Options given to `snapshot/2`

  - `:interesting_only` - Prune uninteresting nodes from the tree (default: true)
  - `:root` - The root DOM element for the snapshot (default: page)
  """
  @type options() ::
          %{}
          | %{
              interesting_only: boolean(),
              root: ElementHandle.t()
            }

  @typedoc """
  Snapshot result returned from `snapshot/2`

  - `:name` - A human readable name for the node
  - `:description` - An additional human readable description of the node, if applicable
  - `:role` - The role
  - `:value` - The current value of the node, if applicable
  - `:children` - Child nodes, if any, if applicable
  - `:autocomplete` - What kind of autocomplete is supported by a control, if applicable
  - `:checked` - Whether the checkbox is checked, or "mixed", if applicable
  - `:disabled` - Whether the node is disabled, if applicable
  - `:expanded` - Whether the node is expanded or collapsed, if applicable
  - `:focused` - Whether the node is focused, if applicable
  - `:haspopup` - What kind of popup is currently being shown for a node, if applicable
  - `:invalid` - Whether and in what way this node's value is invalid, if applicable
  - `:keyshortcuts` - Keyboard shortcuts associated with this node, if applicable
  - `:level` - The level of a heading, if applicable
  - `:modal` - Whether the node is modal, if applicable
  - `:multiline` - Whether the node text input supports multiline, if applicable
  - `:multiselectable` - Whether more than one child can be selected, if applicable
  - `:orientation` - Whether the node is oriented horizontally or vertically, if applicable
  - `:pressed` - Whether the toggle button is checked, or "mixed", if applicable
  - `:readonly` - Whether the node is read only, if applicable
  - `:required` - Whether the node is required, if applicable
  - `:roledescription` - A human readable alternative to the role, if applicable
  - `:selected` - Whether the node is selected in its parent node, if applicable
  - `:valuemax` - The maximum value in a node, if applicable
  - `:valuemin` - The minimum value in a node, if applicable
  - `:valuetext` - A description of the current value, if applicable
  """
  @type snapshot() :: %{
          name: String.t(),
          description: String.t(),
          role: String.t(),
          value: String.t() | number(),
          children: list(),
          autocomplete: String.t(),
          checked: boolean() | String.t(),
          disabled: boolean(),
          expanded: boolean(),
          focused: boolean(),
          haspopup: String.t(),
          invalid: String.t(),
          keyshortcuts: String.t(),
          level: number(),
          modal: boolean(),
          multiline: boolean(),
          multiselectable: boolean(),
          orientation: String.t(),
          pressed: boolean() | String.t(),
          readonly: boolean(),
          required: boolean(),
          roledescription: String.t(),
          selected: boolean(),
          valuemax: number(),
          valuemin: number(),
          valuetext: String.t()
        }

  @doc deprecated: "This method has been removed in Playwright v1.26. Use Locator.aria_snapshot/2 instead."
  @spec snapshot(Page.t(), options()) :: no_return()
  def snapshot(%Page{}, _options) do
    raise "Page.Accessibility.snapshot/2 has been removed in Playwright v1.26+. " <>
            "Use Locator.aria_snapshot/2 instead. " <>
            "See https://playwright.dev/docs/aria-snapshots"
  end
end
