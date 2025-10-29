# Thought Forge Development Guidelines

Auto-generated from all feature plans. Last updated: 2025-10-28

## Active Technologies
- Emacs Lisp (Elisp) - compatible with Emacs v30 as per constitution + org-mode, gptel (for LLM integration), skeletor (for MELPA compliance) (001-org-mode-texts)
- File-based (org-mode files), temporary buffers for processing (001-org-mode-texts)

- Emacs Lisp (Elisp) - compatible with Emacs v30 as per constitution + org-mode, gptel (as specified by user input), skeletor (for MELPA compliance) (001-org-mode-texts)

## Project Structure

```text
src/
tests/
```

## Commands

# Add commands for Emacs Lisp (Elisp) - compatible with Emacs v30 as per constitution

### Running Tests

To run the unit tests in batch mode:

```bash
emacs -batch -l ert -l test-init.el
```

For more detailed output:

```bash
emacs -batch -l ert -l test-init.el -f ert-run-tests-batch-and-exit
```

## Code Style

Emacs Lisp (Elisp) - compatible with Emacs v30 as per constitution: Follow standard conventions

When creating new .el files, include the following header information:
```
;; Copyright (C) 2025  Y.K. Goon

;; Author: Y.K. Goon <ykgoon@gmail.com>
;; Maintainer: Y.K. Goon <ykgoon@gmail.com>
```

## Recent Changes
- 001-org-mode-texts: Added Emacs Lisp (Elisp) - compatible with Emacs v30 as per constitution + org-mode, gptel (for LLM integration), skeletor (for MELPA compliance)

- 001-org-mode-texts: Added Emacs Lisp (Elisp) - compatible with Emacs v30 as per constitution + org-mode, gptel (as specified by user input), skeletor (for MELPA compliance)

<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
