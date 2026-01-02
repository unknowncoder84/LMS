# Design Document

## Overview

This design document outlines the technical approach for rebranding the legal case management system from "Katneshwarkar" to "LMS" (Legal Management System), removing all Dropbox integration, and providing a fresh database setup. The transformation will maintain all core functionality while presenting a clean, professional, and generic brand identity.

The system is built with React/TypeScript frontend, Supabase backend (PostgreSQL + Auth + Storage), and currently includes Dropbox integration that will be completely removed. The rebrand will touch multiple layers: UI components, configuration files, documentation, database migrations, and utility functions.

## Architecture

### Current Architecture
- **Frontend**: React 18 + TypeScript + Vite
- **Routing**: React Router v6
- **State Management**: React Context API (AuthContext, DataContext, ThemeContext)
- **Backend**: Supabase (PostgreSQL, Authentication, Storage)
- **File Storage**: Dual system (Supabase Storage + Dropbox) - Dropbox to be removed
- **Styling**: Tailwind CSS + Framer Motion

### Target Architecture
- **Frontend**: Unchanged (React 18 + TypeScript + Vite)
- **Routing**: Unchanged (React Router v6)
- **State Management**: Unchanged (React Context API)
- **Backend**: Unchanged (Supabase)
- **File Storage**: Single system (Supabase Storage only)
- **Styling**: Unchanged (Tailwind CSS + Framer Motion)

### Key Changes
1. Remove `src/lib/dropbox.ts` entirely
2. Update `src/lib/fileStorage.ts` to be the sole file storage interface
3. Remove Dropbox Edge Functions from `supabase/functions/`
4. Update all UI components with brand references
5. Consolidate and clean database migration files
6. Update project configuration files

## Components and Interfaces

### Files Requiring Brand Updates

#### 1. HTML Entry Point
- **File**: `index.html`
- **Change**: Update `<title>` tag from "Katneshwarkar Office" to "LMS - Legal Management System"

#### 2. Package Configuration
- **File**: `package.json`
- **Changes**:
  - `name`: "prks-office" → "lms-legal-management"
  - `description`: Update to "LMS - Legal Management System"

#### 3. UI Components
- **File**: `src/components/Sidebar.tsx`
- **Change**: Update organization name display from "Katneshwarkar's" to "LMS"

- **File**: `src/pages/LoginPage.tsx`
- **Change**: Update heading from "Katneshwarkar's Office" to "LMS"

#### 4. Utility Functions
- **File**: `src/utils/exportData.ts`
- **Changes**:
  - Report header: "Katneshwarkar's - Case Management Report" → "LMS - Case Management Report"
  - Report footer: "Katneshwarkar's Legal Management System" → "Legal Management System"

- **File**: `src/lib/userManagement.ts`
- **Change**: Email fallback from `@katneshwarkar.com` to `@lms.local`

- **File**: `src/pages/CaseDetailsPage.tsx`
- **Change**: Remove hardcoded timeline reference to "PR Katneshwarkar"

### Files Requiring Dropbox Removal

#### 1. Dropbox Integration Module
- **File**: `src/lib/dropbox.ts`
- **Action**: Delete entirely

#### 2. Storage Page Component
- **File**: `src/pages/StoragePage.tsx`
- **Action**: Review and remove any Dropbox-specific UI elements or imports

#### 3. Edge Functions
- **Directory**: `supabase/functions/`
- **Action**: Remove any Dropbox-related edge functions

#### 4. Package Dependencies
- **File**: `package.json`
- **Action**: Verify no Dropbox SDK packages exist (none found in current dependencies)

### Documentation Files Requiring Updates

#### Files to Update
1. All `.md` files in root directory containing "Katneshwarkar"
2. All `.sql` files containing sample data with "katneshwarkar.com" emails
3. README files with project descriptions

#### Files to Archive/Remove
1. `DROPBOX_ARCHITECTURE_DIAGRAM.md`
2. `DROPBOX_SETUP_COMPLETE_GUIDE.md`
3. `DROPBOX_TOKEN_SETUP_NOW.md`
4. Any other Dropbox-specific documentation

### Database Migration Strategy

#### Current State
- Multiple SQL files in root directory (50+ files)
- Migration files in `supabase/migrations/`
- Inconsistent sample data with old branding

#### Target State
- Single authoritative migration file: `supabase/migrations/001_initial_schema.sql`
- Clean schema with no sample data
- Generic admin user setup script: `supabase/migrations/002_create_admin.sql`
- Archive old migration files to `supabase/migrations/archive/`

## Data Models

No changes to data models are required. The existing schema will be preserved:

- `user_accounts` - User authentication and profiles
- `cases` - Legal case records
- `clients` - Client information
- `appointments` - Calendar appointments
- `expenses` - Financial tracking
- `counsel` - Legal counsel records
- `library_books` - Library management
- `case_files` - File metadata (Supabase Storage only)
- `notifications` - System notifications

The only change is ensuring `case_files` table references only Supabase Storage paths, not Dropbox paths.

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*


### Property Reflection

After analyzing all acceptance criteria, several properties can be consolidated to avoid redundancy:

- Multiple criteria about "no Katneshwarkar references" in different file types can be unified into properties that check entire categories of files
- Multiple criteria about "no Dropbox references" can be consolidated into broader verification properties
- Specific branding checks can be covered by general "correct branding present" properties

The following properties provide comprehensive coverage without redundancy:

### Correctness Properties

Property 1: Report generation includes correct branding
*For any* case data used to generate a report, the resulting HTML output should contain "Legal Management System" in both the header section and the footer section
**Validates: Requirements 1.4**

Property 2: File operations use only Supabase Storage
*For any* file operation (upload, download, delete, list), the system should only invoke Supabase Storage API calls and never invoke Dropbox API calls
**Validates: Requirements 2.2**

Property 3: Source code contains no old brand references
*For any* source file in the src/ directory, the file content should not contain the string "Katneshwarkar" (case-insensitive)
**Validates: Requirements 1.5, 5.5, 8.3**

Property 4: Documentation contains no old brand references
*For any* markdown file in the project root or documentation directories, the file content should not contain the string "Katneshwarkar" (case-insensitive)
**Validates: Requirements 3.1**

Property 5: SQL files use generic email addresses
*For any* SQL file containing INSERT statements with email addresses, those email addresses should not contain the domain "katneshwarkar.com"
**Validates: Requirements 3.3**

Property 6: Configuration files use LMS branding
*For any* configuration file (package.json, index.html, vite.config.ts, etc.), if the file contains project name or description fields, those fields should reference "LMS" or "Legal Management System" and not "Katneshwarkar"
**Validates: Requirements 5.1, 5.2, 5.5**

Property 7: No Dropbox code in codebase
*For any* TypeScript/JavaScript file in the src/ directory, the file should not import from or reference "dropbox" packages or modules
**Validates: Requirements 2.1**

Property 8: Page headers display correct branding
*For any* page component that renders a header or title element, the rendered output should contain "LMS" or "Legal Management System" and not "Katneshwarkar"
**Validates: Requirements 8.1**

Property 9: Notifications use correct branding
*For any* notification message generated by the system, if the message references the organization name, it should use "LMS" or "Legal Management System" and not "Katneshwarkar"
**Validates: Requirements 8.2**

Property 10: Exported data includes correct branding
*For any* data export operation, the generated file should include "Legal Management System" in its metadata or content and not "Katneshwarkar"
**Validates: Requirements 8.4**

## Error Handling

### File Operations
- If Dropbox code removal breaks any file operations, the system should fall back gracefully to Supabase Storage
- Missing file storage should display user-friendly error messages
- Failed uploads should not crash the application

### Database Migration
- If migration fails due to existing data, provide clear error messages
- Ensure rollback capability for failed migrations
- Validate schema integrity after migration

### Build Process
- If brand references remain after updates, build should include warnings (via linting)
- Missing configuration values should fail the build with clear messages

## Testing Strategy

### Unit Testing Approach

Unit tests will verify specific examples and critical integration points:

1. **Component Rendering Tests**
   - Verify LoginPage displays "LMS" branding
   - Verify Sidebar displays "LMS" organization name
   - Verify browser title is set correctly

2. **Configuration Tests**
   - Verify package.json has correct name and description
   - Verify index.html has correct title

3. **File System Tests**
   - Verify dropbox.ts file does not exist
   - Verify Dropbox documentation files are archived
   - Verify migration files are properly organized

4. **Database Tests**
   - Verify fresh database has no sample data
   - Verify admin user has correct email format
   - Verify all tables exist with correct schema

### Property-Based Testing Approach

Property-based tests will verify universal properties across all inputs using the **fast-check** library (already in dependencies). Each property test will run a minimum of 100 iterations.

1. **Report Generation Property Test**
   - Generate random case data
   - Verify all generated reports contain "Legal Management System" in header and footer
   - **Tag**: `Feature: lms-rebrand-cleanup, Property 1: Report generation includes correct branding`

2. **File Operations Property Test**
   - Generate random file operations (upload, download, delete)
   - Verify all operations use Supabase Storage API only
   - **Tag**: `Feature: lms-rebrand-cleanup, Property 2: File operations use only Supabase Storage`

3. **Source Code Scanning Property Test**
   - Scan all source files in src/ directory
   - Verify no files contain "Katneshwarkar"
   - **Tag**: `Feature: lms-rebrand-cleanup, Property 3: Source code contains no old brand references`

4. **Documentation Scanning Property Test**
   - Scan all markdown files
   - Verify no files contain "Katneshwarkar"
   - **Tag**: `Feature: lms-rebrand-cleanup, Property 4: Documentation contains no old brand references`

5. **SQL Email Validation Property Test**
   - Scan all SQL files for INSERT statements
   - Verify no email addresses use "katneshwarkar.com"
   - **Tag**: `Feature: lms-rebrand-cleanup, Property 5: SQL files use generic email addresses`

6. **Configuration Branding Property Test**
   - Check all configuration files
   - Verify project name/description fields use LMS branding
   - **Tag**: `Feature: lms-rebrand-cleanup, Property 6: Configuration files use LMS branding`

7. **Dropbox Import Scanning Property Test**
   - Scan all TypeScript/JavaScript files
   - Verify no files import or reference Dropbox
   - **Tag**: `Feature: lms-rebrand-cleanup, Property 7: No Dropbox code in codebase`

8. **Page Header Branding Property Test**
   - Render all page components
   - Verify headers contain "LMS" or "Legal Management System"
   - **Tag**: `Feature: lms-rebrand-cleanup, Property 8: Page headers display correct branding`

9. **Notification Branding Property Test**
   - Generate various notification scenarios
   - Verify notifications use correct branding
   - **Tag**: `Feature: lms-rebrand-cleanup, Property 9: Notifications use correct branding`

10. **Export Branding Property Test**
    - Generate various export operations
    - Verify exported files contain correct branding
    - **Tag**: `Feature: lms-rebrand-cleanup, Property 10: Exported data includes correct branding`

### Testing Framework
- **Unit Tests**: Vitest + React Testing Library (already configured)
- **Property Tests**: fast-check (already in dependencies)
- **Test Location**: `__tests__/` directory and co-located `.test.ts` files

### Test Execution
- Run tests before committing changes: `npm test`
- Run tests in CI/CD pipeline
- Ensure all tests pass before considering rebrand complete

## Implementation Notes

### Phase 1: Remove Dropbox Integration
1. Delete `src/lib/dropbox.ts`
2. Remove Dropbox edge functions
3. Update any components importing Dropbox functionality
4. Remove Dropbox documentation files

### Phase 2: Update Branding
1. Update HTML title and meta tags
2. Update package.json
3. Update UI components (Sidebar, LoginPage, etc.)
4. Update utility functions (exportData, userManagement)
5. Update all documentation files

### Phase 3: Clean Database Setup
1. Create single authoritative migration file
2. Archive old migration files
3. Update admin user creation script
4. Remove sample data from migrations

### Phase 4: Testing
1. Write unit tests for critical components
2. Write property-based tests for universal properties
3. Run full test suite
4. Manual verification of UI

### Phase 5: Documentation
1. Update README with LMS branding
2. Create fresh setup guide
3. Archive obsolete documentation
4. Update deployment guides

## Dependencies

### Existing Dependencies (No Changes Required)
- React 18.3.1
- TypeScript 5.3.0
- Vite 5.0.0
- Supabase JS 2.86.0
- Tailwind CSS 3.3.0
- Vitest 4.0.14 (for unit tests)
- fast-check 3.14.0 (for property-based tests)

### Dependencies to Remove
- None (no Dropbox packages were found in package.json)

## Deployment Considerations

### Pre-Deployment Checklist
1. All tests passing
2. No "Katneshwarkar" references in source code
3. No Dropbox code or documentation
4. Fresh database migration tested
5. Build succeeds with no warnings

### Post-Deployment Verification
1. Verify browser title shows "LMS"
2. Verify login page shows correct branding
3. Verify file upload/download works with Supabase Storage
4. Verify reports generate with correct branding
5. Verify no console errors related to Dropbox

### Rollback Plan
- Keep git history for reverting changes if needed
- Maintain backup of current database
- Document any breaking changes

## Success Criteria

The rebrand and cleanup will be considered complete when:

1. ✅ All unit tests pass
2. ✅ All property-based tests pass (100+ iterations each)
3. ✅ No "Katneshwarkar" references in active codebase
4. ✅ No Dropbox code or documentation in active codebase
5. ✅ Fresh database setup creates clean schema with no sample data
6. ✅ Application runs locally with LMS branding
7. ✅ All file operations work with Supabase Storage only
8. ✅ Documentation is clean and LMS-branded
