defmodule Playwright.SDK.Helpers.URLMatcherTest do
  use ExUnit.Case, async: true
  alias Playwright.SDK.Helpers.URLMatcher

  describe "new/1" do
    test "returns a URLMatcher struct, with a compiled :regex" do
      result = URLMatcher.new(".*/path")
      assert %URLMatcher{regex: regex} = result
      assert regex.source == ".*/path"
    end

    test "given a path-glob style match" do
      result = URLMatcher.new("**/path")
      assert %URLMatcher{regex: regex} = result
      assert regex.source == ".*/path"
    end
  end
end
