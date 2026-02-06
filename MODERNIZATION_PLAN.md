# Playwright Elixir Modernization Plan

## Summary of Issues Found

### 1. **Removed `page.accessibility` API (Critical)**
- **Problem**: The old `page.accessibility.snapshot()` method was deprecated in Playwright v1.25 (Aug 2022) and completely removed in v1.26
- **Current Status**: Library is still using this removed API, causing "Unknown scheme" errors
- **Impact**: All 5 accessibility snapshot tests are failing
- **Timeline**: This API has been gone for ~2 years (from v1.26 to v1.58.1)

### 2. **New Aria Snapshots API (Modern Replacement)**
- Playwright introduced a modern replacement: ARIA snapshots with `locator.ariaSnapshot()` 
- Uses YAML format for accessibility tree representation
- Integrated with test assertions via `expect(locator).toMatchAriaSnapshot()`
- More standards-compliant and better integrated with the test framework

### 3. **Dependency Status**
- All Elixir dependencies are up-to-date
- Playwright Node.js library is at v1.58.1 (latest)
- All other libraries are current

## Required Changes

### Phase 1: Remove Deprecated Accessibility Module
1. Mark `Playwright.Page.Accessibility` as removed
2. Update tests to use new ARIA snapshot approach
3. Document migration path for users

### Phase 2: Implement New ARIA Snapshot Support  
1. Add `ariaSnapshot()` method to `Locator`
2. Add support for aria snapshot test assertions
3. Implement YAML snapshot format handling

### Phase 3: Test Migration
1. Rewrite accessibility tests using new API
2. Ensure all 5 accessibility tests pass
3. Update Clock test timing issue (minor bug - timing tolerance)

### Phase 4: Additional API Updates
Review and implement any major new features from Playwright v1.49.1 → v1.58.1:
- WebSocket routing (`page.routeWebSocket()`)
- New locator methods (`locator.contentFrame()`)
- Improved event handling
- Enhanced error messages
- New methods for page inspection (`page.consoleMessages()`, `page.pageErrors()`, `page.requests()`)

## Breaking Changes Between v1.49.1 and v1.58.1

1. **Removed**: `page.accessibility` - use other libraries (Axe) or new aria snapshots
2. **Removed**: `_react` and `_vue` selectors - use standard CSS locators
3. **Removed**: `:light` selector engine suffix
4. **Removed**: `devtools` option from `browserType.launch()`
5. **Deprecated**: `Node.js 16` support (already gone)
6. **Deprecated**: `Node.js 18` support (will be removed soon)

## Testing Strategy

1. **Before Changes**: Review complete test suite
2. **Incremental Updates**: Fix one module at a time
3. **Regression Testing**: Run full test suite after each change
4. **Documentation**: Update all accessibility-related guides

## Migration Path for Users

Users currently using `page.accessibility.snapshot()` should:
1. Migrate to `locator.ariaSnapshot()` for programmatic access
2. Use `expect(locator).toMatchAriaSnapshot()` for test assertions
3. For complex accessibility testing, integrate with Axe library

See: https://playwright.dev/docs/aria-snapshots
