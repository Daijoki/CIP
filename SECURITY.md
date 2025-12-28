# Security Documentation

## innerHTML Usage Audit

This document explains the security review of `innerHTML` assignments in the codebase.

### Summary

- **Total innerHTML uses**: 53 across 11 files
- **Risk Assessment**: LOW to MEDIUM
- **Mitigation**: Escaping utilities in place, internal data sources

### Security Helpers

Located in `js/utils.js`:

```javascript
Utils.escapeHTML(str)    // Escapes HTML special characters
Utils.sanitizeHTML(str)  // Full sanitization (currently aliases escapeHTML)
```

### innerHTML Usage by Category

#### ✅ SAFE - Static HTML Templates
These use template literals with NO user input:
- `Utils.createLoadingHTML()` - Static spinner
- `Utils.createErrorHTML()` - Error message (message parameter is from internal error handling)
- Modal structures - Predefined HTML layouts

#### ✅ SAFE - Escaped Data
These properly escape user/external data before insertion:
- `document-modal-manager.js:58` - Uses `.replace(/"/g, '&quot;')` to escape titles
- `glossary.js` - Uses `this.esc()` helper function (line 113)
- `quiz.js` - Uses helper methods with escaping

#### ✅ SAFE - Internal Data Only
These insert data from JSON files bundled with the app:
- `documents.js:273` - Renders document list from `data/documents.json`
- `glossary.js:*` - Renders terms from `data/glossary.json`
- `historical.js:*` - Renders timeline from `data/historical-foundations.json`
- `quiz.js:*` - Renders questions from `data/quiz.json`

#### ⚠️ MONITOR - Icon/SVG Injection
- `starBtn.innerHTML = window.ICONS.star*` - Safe because ICONS is a controlled object
- Icon injections from `js/icons.js` - Safe because it's internal code

#### ⚠️ MONITOR - User-Generated Content
- `notes.js:*` - User notes are saved/loaded
  - **Mitigation**: Notes are stored in localStorage, not shared between users
  - **Risk**: Low - XSS would only affect the user who created the note
  - **Recommendation**: Consider adding `Utils.sanitizeHTML()` when saving notes

### Recommendations

1. **Immediate Actions Taken**:
   - ✅ Created `Utils.sanitizeHTML()` helper
   - ✅ Created `Utils.log` for environment-aware logging
   - ✅ Replaced all `console.*` with `Utils.log.*`

2. **Future Enhancements** (Not Critical):
   - Add Content Security Policy headers when deploying
   - Sanitize note content before saving (defense in depth)
   - Consider using `DOMPurify` library for rich HTML sanitization if needed

3. **Current Risk Level**: **LOW**
   - No external user input accepted
   - No server-side data rendering
   - No cross-user data sharing
   - Proper escaping where needed

### Logging Security

All console statements replaced with environment-aware logging:

- `Utils.log.debug()` - Only in development (requires `window.DEBUG = true`)
- `Utils.log.info()` - Only in development
- `Utils.log.warn()` - Always shown (important warnings)
- `Utils.log.error()` - Always shown (critical errors)

This prevents information leakage in production while maintaining debugging capabilities.

### Testing

To enable debug logging in production (for troubleshooting):
```javascript
// Open browser console and run:
window.DEBUG = true;
// Refresh the page
```

---

**Last Updated**: December 2024
**Reviewed By**: Automated code audit
**Next Review**: Before any major deployment
