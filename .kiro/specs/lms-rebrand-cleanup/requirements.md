# Requirements Document

## Introduction

This document specifies the requirements for rebranding the legal case management system from "Katneshwarkar" to "LMS" (Legal Management System), removing all Dropbox integration functionality, and ensuring a fresh start with no previous stored data. The system will maintain all core legal case management features while presenting a clean, generic brand identity suitable for any legal practice.

## Glossary

- **LMS**: Legal Management System - the new brand name for the application
- **Application**: The React/TypeScript web application for legal case management
- **Dropbox Integration**: Third-party file storage service to be removed
- **Supabase Storage**: The native file storage solution that will remain
- **Brand References**: Any text, code, or configuration that mentions "Katneshwarkar"
- **User Data**: All stored information in the database including cases, users, appointments, etc.
- **Migration Files**: SQL files in the supabase/migrations directory
- **Documentation Files**: Markdown and text files containing setup and deployment instructions

## Requirements

### Requirement 1

**User Story:** As a system administrator, I want all references to "Katneshwarkar" replaced with "LMS" throughout the application, so that the system has a generic, professional brand identity.

#### Acceptance Criteria

1. WHEN the application loads THEN the system SHALL display "LMS" or "Legal Management System" in the browser title
2. WHEN a user views the login page THEN the system SHALL display "LMS" or "Legal Management System" as the application name
3. WHEN a user views the sidebar THEN the system SHALL display "LMS" as the organization name
4. WHEN the system generates reports THEN the system SHALL include "Legal Management System" in report headers and footers
5. WHERE code comments or variable names reference "Katneshwarkar" THEN the system SHALL use generic or LMS-related naming

### Requirement 2

**User Story:** As a developer, I want all Dropbox integration code removed from the codebase, so that the application only uses Supabase native storage.

#### Acceptance Criteria

1. WHEN the application is built THEN the system SHALL NOT include any Dropbox SDK or API client code
2. WHEN a user accesses file storage features THEN the system SHALL use only Supabase Storage functionality
3. WHEN viewing the file storage interface THEN the system SHALL NOT display any Dropbox-related options or buttons
4. WHERE Dropbox Edge Functions exist THEN the system SHALL remove these functions from the deployment
5. WHEN package dependencies are installed THEN the system SHALL NOT include any Dropbox-related packages

### Requirement 3

**User Story:** As a system administrator, I want all documentation files updated to reflect the LMS brand, so that setup and deployment guides are accurate.

#### Acceptance Criteria

1. WHEN reading setup documentation THEN the system SHALL reference "LMS" or "Legal Management System" instead of "Katneshwarkar"
2. WHEN following deployment guides THEN the system SHALL provide instructions using LMS branding
3. WHERE SQL migration files contain sample data THEN the system SHALL use generic email addresses and names
4. WHEN viewing README files THEN the system SHALL describe the project as "LMS - Legal Management System"
5. WHERE documentation references Dropbox setup THEN the system SHALL remove or archive these documents

### Requirement 4

**User Story:** As a new user, I want the system to start with a completely fresh database, so that no previous data exists when I first deploy.

#### Acceptance Criteria

1. WHEN the database is initialized THEN the system SHALL create only the schema structure without sample data
2. WHEN the first admin user is created THEN the system SHALL use a generic email format like "admin@lms.local"
3. WHERE migration files exist THEN the system SHALL provide a single clean migration file for fresh installations
4. WHEN the application first loads THEN the system SHALL NOT display any pre-existing cases, clients, or appointments
5. WHILE maintaining data integrity THEN the system SHALL preserve all table structures and relationships

### Requirement 5

**User Story:** As a developer, I want the package.json and project configuration updated with LMS branding, so that the project identity is consistent.

#### Acceptance Criteria

1. WHEN viewing package.json THEN the system SHALL display "lms" or "legal-management-system" as the project name
2. WHEN viewing package.json THEN the system SHALL describe the project as "Legal Management System"
3. WHERE environment variable examples exist THEN the system SHALL use LMS-related naming conventions
4. WHEN the application is built THEN the system SHALL generate artifacts with LMS naming
5. WHERE configuration files reference the old brand THEN the system SHALL update to LMS branding

### Requirement 6

**User Story:** As a system administrator, I want obsolete Dropbox-related documentation archived or removed, so that the documentation set is clean and relevant.

#### Acceptance Criteria

1. WHEN browsing the project root THEN the system SHALL NOT display Dropbox setup guides as active documentation
2. WHERE Dropbox architecture diagrams exist THEN the system SHALL remove these files
3. WHEN viewing the file tree THEN the system SHALL show only Supabase storage documentation
4. WHERE multiple redundant setup files exist THEN the system SHALL consolidate to essential documentation only
5. WHEN a developer reviews documentation THEN the system SHALL provide clear, LMS-branded setup instructions

### Requirement 7

**User Story:** As a developer, I want the codebase cleaned of unused or redundant SQL files, so that the project structure is maintainable.

#### Acceptance Criteria

1. WHEN viewing the project root THEN the system SHALL NOT display multiple conflicting SQL setup files
2. WHERE migration files exist in supabase/migrations THEN the system SHALL provide a clear migration path
3. WHEN setting up a fresh database THEN the system SHALL use a single authoritative SQL file
4. WHERE obsolete migration files exist THEN the system SHALL archive or remove these files
5. WHEN reviewing database setup THEN the system SHALL have clear documentation on which files to use

### Requirement 8

**User Story:** As a user, I want the application interface to reflect professional LMS branding, so that the system appears polished and generic.

#### Acceptance Criteria

1. WHEN viewing any page header THEN the system SHALL display "LMS" or "Legal Management System"
2. WHEN receiving system notifications THEN the system SHALL reference "LMS" in notification text
3. WHERE user-facing text mentions the organization THEN the system SHALL use "LMS" or generic legal practice terminology
4. WHEN exporting data THEN the system SHALL include "Legal Management System" in exported file metadata
5. WHILE maintaining functionality THEN the system SHALL ensure all UI text is brand-neutral
