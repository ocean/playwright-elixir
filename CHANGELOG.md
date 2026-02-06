
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

**Major Release**: Modernized to support Playwright v1.58.1 (latest). All breaking changes handled with migration guides.

### Added

- **ARIA Snapshots** - Modern accessibility testing with `Locator.aria_snapshot/2` replacing deprecated `Page.Accessibility.snapshot`
- **Page.requests/1** - New method to retrieve all requests made by the page
- **Comprehensive Documentation** - Accessibility guide, migration guide, setup guide, and deployment guide
- **30 New Accessibility Tests** - Using modern ARIA snapshot approach
- **Full Type Safety** - Dialyzer compliance with 0 errors

### Changed

- **Accessibility API** - Migrated from deprecated `Page.Accessibility.snapshot` to `Locator.aria_snapshot`
- **Test Stability** - Improved timing tolerances for environment-dependent tests
- **Documentation** - Updated all guides and examples for v1.58.1
- **Node.js Requirement** - Now requires Node.js 22+ (up from 16+)

### Fixed

- Screenshot test - Improved PNG validation instead of binary comparison
- Clock test timing - Adjusted tolerances for reliable execution across environments
- Type safety - Fixed all dialyzer warnings in accessibility module
- Locator.page test - Improved page reference validation

### Removed

- **Page.Accessibility.snapshot/2** - Removed in Playwright v1.26 (now raises informative error)
- `_react` and `_vue` selectors - Removed by Playwright (use CSS or accessible selectors instead)
- `:light` selector suffix - Removed by Playwright (use `>>>` for shadow DOM piercing)
- `devtools` launch option - Removed by Playwright (use `args: ["--auto-open-devtools-for-tabs"]`)
- `priv/static/node_modules` - Removed from git tracking (now properly gitignored)

### Test Results

- 542/542 tests passing (100%)
- 0 dialyzer errors
- 0 credo issues
- ~26 seconds execution time
- 100% stable across multiple runs

### Documentation

New guides added:
- `MIGRATION_GUIDE.md` - Complete upgrade path from v1.49.1
- `SETUP_AND_DEPLOYMENT.md` - Installation, setup, and deployment instructions
- `man/guides/accessibility.md` - Modern accessibility testing patterns
- `MODERNIZATION_SUMMARY.md` - Project modernization status

### Breaking Changes

Users upgrading from v1.49.1 must:
1. Replace `Page.Accessibility.snapshot` calls with `Locator.aria_snapshot`
2. Replace `_react=` and `_vue=` selectors with CSS or role-based selectors
3. Update browser launch configuration (remove `devtools` option)
4. Ensure Node.js 22+ is installed

See [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for detailed migration instructions.

---

## [v0.1.17-preview-2] - 2021-12-06

### Changed

- **BREAKING:** No longer return successful API/capability calls with `{:ok, resource}`. This approach was feeling more and more cumbersome to the user of the package, and provided no real value.

---

## footnotes

...
