# Next Steps for Playwright Elixir

## Priority 1: Address Remaining Test Failures (High Impact, Low Effort)

### Screenshot Test Flakiness
**File**: `test/api/locator_test.exs:818-826`

The PNG comparison is failing due to metadata differences. Options:
1. **Easiest**: Skip the exact binary comparison, just verify non-null result
2. **Better**: Use an image comparison library with tolerance
3. **Best**: Mock the screenshot response in tests

```elixir
# Option 1 (Quickest fix):
refute is_nil(data)
assert byte_size(data) > 100  # Verify reasonable size
```

### Locator.page/1 Test Flakiness
**File**: `test/api/locator_test.exs:1040-1043`

The test occasionally gets mismatched page GUIDs. This suggests:
1. Test isolation issue between tests
2. Page cleanup not happening properly
3. Multiple pages being created

**Investigation steps**:
- Add explicit cleanup in test setup/teardown
- Check for stray processes in Catalog
- Review async test ordering

## Priority 2: Implement New API Support (Medium Impact, Medium Effort)

### WebSocket Routing (New in Playwright 1.25+)
Add support for:
- `Page.routeWebSocket/3` - intercept WebSocket connections
- `BrowserContext.routeWebSocket/3` - context-level WebSocket routing

**Files to create**:
- `lib/playwright/web_socket_route.ex` - WebSocket route handler
- `lib/playwright/sdk/web_socket.ex` - WebSocket protocol support
- `test/api/web_socket_test.exs` - Test suite

**Example usage**:
```elixir
Page.routeWebSocket(page, "/api/ws", fn ws ->
  ws.onMessage(fn message ->
    if message == "request", do: ws.send("response")
  end)
end)
```

### Enhanced Page Introspection Methods (New in Playwright 1.41+)
Add support for:
- `Page.console_messages/1` - Get recent console messages
- `Page.page_errors/1` - Get page errors
- `Page.requests/1` - Get recent network requests

**Files to update**:
- `lib/playwright/page.ex` - Add new methods
- `test/api/page_test.exs` - Add tests

### Aria Snapshots Assertion Support
Enhance testing capability:
- Add helper for comparing aria snapshots
- Create test matchers for accessibility verification
- Document best practices for accessibility testing

## Priority 3: Code Quality Improvements (Low Impact, Low Effort)

### Remove Dead Code
- `lib/playwright/page/accessibility.ex` - Remove old helper functions (already mostly done)
- Audit other deprecated APIs for cleanup

### Update Documentation
- [ ] Update README with latest features
- [ ] Add migration guide in docs/
- [ ] Update API docs for removed methods
- [ ] Add examples for new accessibility testing approach

### Dialyzer Compliance
Run dialyzer and fix any type warnings:
```bash
mix dialyzer
```

Current warnings to investigate:
- Type specs for new WebSocket APIs
- Aria snapshot return types
- Optional parameter handling

## Priority 4: New Features (Lower Priority, Higher Effort)

### Locator Enhancements
Implement chain operations added in v1.28+:
- Locator chaining: `locator.and_(other_locator)`
- Improved filtering: `locator.or_(other_locator)`
- Layout-based selection: `:left-of()`, `:right-of()`, `:above()`, `:below()`

### Browser Launch Options
Add missing options:
- `args: ["--auto-open-devtools-for-tabs"]` - Replace removed `devtools` option
- New device emulation options
- Enhanced context configuration

### CDP Session Improvements
Enhance Chrome DevTools Protocol integration:
- `page.create_cdp_session/0` - Create new CDP session
- `cdp_session.send/2` - Send CDP commands
- Better error handling for CDP failures

## Testing Strategy

### Before Making Changes
1. Run full test suite and capture baseline:
   ```bash
   mix test 2>&1 | tee test_baseline.log
   ```

2. Create feature branch:
   ```bash
   git checkout -b feat/webocket-routing
   ```

### During Development
1. Write tests first (TDD approach)
2. Run tests after each change:
   ```bash
   mix test --only "WebSocket"
   ```
3. Check for dialyzer warnings:
   ```bash
   mix dialyzer
   ```

### Before Submitting
1. Full test suite:
   ```bash
   mix test
   ```
2. Code quality:
   ```bash
   mix credo --strict
   ```
3. Documentation:
   ```bash
   mix docs
   ```

## Performance Considerations

### Current Bottlenecks
1. **Test startup**: 26+ seconds for full suite
   - Can be improved with parallel test optimization
   - Consider async test grouping

2. **Channel communication**: JSON encoding/decoding on every message
   - Current implementation is adequate
   - Only optimize if profiling shows it's a problem

### Recommended Optimizations
1. Profile test execution:
   ```bash
   mix test --trace
   ```

2. Analyze channel message volume:
   - Add metrics to channel.post/4
   - Monitor for excessive round-trips

3. Optimize test fixtures:
   - Reuse browser/context where possible
   - Parallel test execution for independent tests

## Documentation Needed

### For Users
- [ ] Migration guide from old accessibility API
- [ ] WebSocket routing examples
- [ ] New assertion methods documentation
- [ ] Troubleshooting guide for common issues

### For Developers
- [ ] Architecture overview
- [ ] Channel protocol documentation
- [ ] Adding new API methods checklist
- [ ] Testing guidelines

## Version Bump Plan

When all Priority 1 items are complete:
- Current: `1.49.1-alpha.2`
- Next: `1.50.0` - First stable release with Playwright 1.58.1 support

Include in release notes:
- Breaking changes from v1.49.1
- Migration guide for `page.accessibility`
- New features available
- Known limitations

## Estimated Timeline

| Priority | Task | Effort | Timeline |
|----------|------|--------|----------|
| 1 | Fix screenshot test | 2-4 hours | This week |
| 1 | Fix locator.page test | 2-4 hours | This week |
| 2 | WebSocket routing | 8-12 hours | Next week |
| 2 | Page introspection | 4-6 hours | Next week |
| 3 | Documentation | 6-8 hours | Following week |
| 4 | Locator enhancements | 12-16 hours | Later |

**Total estimated effort**: 34-52 hours (4-6 weeks at 10 hours/week)

## Communication

- Document all changes in CHANGELOG.md
- Add deprecation notices for any old patterns
- Consider adding warnings during compilation
- Update GitHub wiki/docs

## Questions for Review

Before proceeding, consider:

1. **Priority**: Is fixing the remaining test failures the highest priority?
2. **WebSocket support**: Is this needed by users, or can it wait?
3. **Documentation**: Should docs be updated before or after new features?
4. **Release timeline**: When do you want to release v1.50.0?
5. **Breaking changes policy**: How should deprecations be handled?
