<!-- 
SYNC IMPACT REPORT
Version change: 1.0.0 → 0.1.0
Modified principles: Downgraded version for pre-release status
Added sections: None
Removed sections: None
Templates requiring updates: 
  - ✅ plan-template.md: Constitution Check section still aligns with principles
  - ✅ spec-template.md: Requirements section still compatible with principles
  - ✅ tasks-template.md: Task structure still supports test-first development
  - ✅ command files: No outdated references requiring updates
Follow-up TODOs: 
  - ⚠ RATIFICATION_DATE: Original adoption date unknown, marked as TODO
-->
# thought-forge Constitution

## Core Principles

### I. Test-First Development (NON-NEGOTIABLE)
Automated tests must be created before implementation. This ensures code quality, reduces bugs, and provides confidence during refactoring. No feature or bug fix should be implemented without corresponding tests being written first.

### II. Emacs Compatibility
Project must run successfully on emacs v30. All tools, scripts, and development workflows must be compatible with emacs v30 to ensure consistent development environments across the team.

### III. Code Review Process
All code changes must undergo peer review before being merged. At least one team member must approve each pull request. Critical changes require approval from multiple team members.

### IV. Documentation Standards
All public APIs, complex algorithms, and architectural decisions must be documented. Documentation should be updated whenever code changes affect public interfaces or documented behavior.

### V. Performance Standards
Performance requirements must be met before release. All performance benchmarks must pass without degradation. Significant performance improvements or fixes should be documented in release notes.

## Development Workflow

All development follows GitFlow methodology with feature branches, pull requests, and release tags. Major changes require design documents approved by the technical lead before implementation begins.

## Quality Assurance

Automated testing includes unit tests, integration tests, and end-to-end tests. All tests must pass before merging. Code coverage targets are maintained at 80% minimum for new code.

## Governance

This constitution governs all development practices for the thought-forge project. All team members are expected to adhere to these principles. Changes to this constitution must be approved by a majority of the senior development team.

**Version**: 0.1.0 | **Ratified**: TODO(RATIFICATION_DATE): Original adoption date unknown | **Last Amended**: 2025-10-28