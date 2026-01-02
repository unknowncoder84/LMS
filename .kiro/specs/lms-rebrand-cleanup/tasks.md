# Implementation Plan

- [-] 1. Remove Dropbox integration code

  - Delete `src/lib/dropbox.ts` file completely
  - Remove any Dropbox edge functions from `supabase/functions/` directory
  - Verify no Dropbox packages in `package.json` dependencies
  - _Requirements: 2.1, 2.4, 2.5_

- [ ] 1.1 Write property test to verify no Dropbox imports
  - **Property 7: No Dropbox code in codebase**
  - **Validates: Requirements 2.1**


- [ ] 2. Update UI components with LMS branding
  - Update `index.html` title tag to "LMS - Legal Management System"
  - Update `src/components/Sidebar.tsx` organization name to "LMS"
  - Update `src/pages/LoginPage.tsx` heading to "LMS"
  - Remove hardcoded "PR Katneshwarkar" reference in `src/pages/CaseDetailsPage.tsx` timeline
  - _Requirements: 1.1, 1.2, 1.3_

- [ ] 2.1 Write unit tests for UI branding
  - Test LoginPage displays "LMS"
  - Test Sidebar displays "LMS"
  - Test browser title is correct
  - _Requirements: 1.1, 1.2, 1.3_

- [ ] 2.2 Write property test for page headers
  - **Property 8: Page headers display correct branding**
  - **Validates: Requirements 8.1**


- [ ] 3. Update utility functions and exports
  - Update `src/utils/exportData.ts` report header to "LMS - Case Management Report"
  - Update `src/utils/exportData.ts` report footer to "Legal Management System"
  - Update `src/lib/userManagement.ts` email fallback from `@katneshwarkar.com` to `@lms.local`
  - _Requirements: 1.4, 8.4_

- [ ] 3.1 Write property test for report generation
  - **Property 1: Report generation includes correct branding**
  - **Validates: Requirements 1.4**

- [ ] 3.2 Write property test for exported data
  - **Property 10: Exported data includes correct branding**


  - **Validates: Requirements 8.4**

- [ ] 4. Update project configuration files
  - Update `package.json` name to "lms-legal-management"
  - Update `package.json` description to "LMS - Legal Management System"
  - Verify `vite.config.ts` has no old brand references
  - _Requirements: 5.1, 5.2, 5.4, 5.5_

- [ ] 4.1 Write property test for configuration branding
  - **Property 6: Configuration files use LMS branding**
  - **Validates: Requirements 5.1, 5.2, 5.5**

- [ ] 5. Update documentation files
  - Update all `.md` files in root directory to replace "Katneshwarkar" with "LMS"
  - Update README files to describe project as "LMS - Legal Management System"
  - Archive Dropbox documentation files: move `DROPBOX_*.md` files to `docs/archive/` directory
  - _Requirements: 3.1, 3.4, 3.5, 6.1, 6.2, 6.3_

- [ ] 5.1 Write property test for documentation scanning
  - **Property 4: Documentation contains no old brand references**
  - **Validates: Requirements 3.1**

- [ ] 6. Clean up and consolidate SQL files
  - Create `supabase/migrations/archive/` directory
  - Move all root-level `.sql` files to archive directory
  - Create clean `supabase/migrations/001_initial_schema.sql` with schema only (no sample data)
  - Create `supabase/migrations/002_create_admin.sql` with generic admin user (admin@lms.local)
  - Update all SQL files to replace "katneshwarkar.com" emails with "lms.local"
  - _Requirements: 3.3, 4.1, 4.2, 4.3, 7.1, 7.3, 7.4_

- [ ] 6.1 Write property test for SQL email validation
  - **Property 5: SQL files use generic email addresses**
  - **Validates: Requirements 3.3**

- [ ] 6.2 Write unit test for fresh database setup
  - Test database initialization creates schema without sample data
  - Test admin user has correct email format
  - Test all tables exist with correct relationships
  - _Requirements: 4.1, 4.2, 4.4, 4.5_

- [ ] 7. Verify file storage functionality
  - Review `src/pages/StoragePage.tsx` and remove any Dropbox UI elements
  - Ensure all file operations use `src/lib/fileStorage.ts` (Supabase Storage only)
  - Test file upload, download, and delete operations
  - _Requirements: 2.2, 2.3_

- [ ] 7.1 Write property test for file operations
  - **Property 2: File operations use only Supabase Storage**
  - **Validates: Requirements 2.2**

- [ ] 8. Scan codebase for remaining brand references
  - Run search for "Katneshwarkar" across all source files
  - Run search for "katneshwarkar" across all source files
  - Run search for "dropbox" imports across all source files
  - Fix any remaining references found
  - _Requirements: 1.5, 5.5, 8.3_

- [ ] 8.1 Write property test for source code scanning
  - **Property 3: Source code contains no old brand references**
  - **Validates: Requirements 1.5, 5.5, 8.3**

- [ ] 8.2 Write property test for notification branding
  - **Property 9: Notifications use correct branding**
  - **Validates: Requirements 8.2**

- [ ] 9. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 10. Build and run application locally
  - Run `npm install` to ensure dependencies are correct
  - Run `npm run build` to verify build succeeds
  - Run `npm run dev` to start development server
  - Manually verify LMS branding appears correctly in browser
  - Test file upload/download functionality
  - Verify no console errors related to Dropbox
  - _Requirements: All_

- [ ] 11. Final verification and documentation
  - Create a summary document of all changes made
  - Update main README with fresh setup instructions
  - Document the new database migration process
  - Verify all acceptance criteria are met
  - _Requirements: All_
