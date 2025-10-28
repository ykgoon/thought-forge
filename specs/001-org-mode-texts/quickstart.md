# Quickstart Guide: Org-TF Package

## Overview
This guide will help you get started with the thought-forge Emacs package for extracting org-mode texts by date, scoring them for novelty, and generating blog content.

## Installation

### From MELPA (Recommended)
1. Ensure you have MELPA configured as a package archive
2. Install with `M-x package-install RET thought-forge RET`

### From Source
1. Clone the repository
2. Add the source directory to your load path
3. Install dependencies: `org-mode`, `gptel`, `s`, `dash`

## Prerequisites
- Emacs v30 or compatible
- Org-mode package
- GPTel package configured with an LLM provider

## Basic Usage

### 1. Running the Command
1. Open Emacs
2. Run the command with `M-x org-tf` or bind it to a key
3. You will be prompted for a date range

### 2. Providing Date Range
1. When prompted, enter the start date in org-mode timestamp format (e.g., `2023-10-01`, `<2023-10-01>`)
2. Optionally enter the end date (defaults to the start date)
3. The system will collect org-mode entries within this date range

### 3. Reviewing and Scoring
1. A new buffer will open showing all org-mode entries from the date range
2. Each entry will have a novelty score displayed next to it
3. The scores range from 0-100, with higher scores indicating more novel content

### 4. Selecting Entries
1. Use the interactive interface to select entries you want to enhance
2. Options may include:
   - Select individual entries
   - Select all entries above a certain score threshold
   - Deselect entries

### 5. Generating Blog Content
1. Once you select entries, the system will use LLM to enhance them
2. A new markdown buffer will be created with the enhanced content
3. Review and edit the content as needed
4. Save the markdown buffer as a blog post

## Configuration

### GPTel Setup
The package relies on GPTel for LLM integration. Ensure you have:

1. A configured LLM provider in GPTel
2. Proper API keys set up
3. Default parameters configured (temperature, model, etc.)

Example configuration in your Emacs init file:
```elisp
(setq gptel-backend (gptel-make-openai "OpenAI"
                   :key (lambda () (getenv "OPENAI_API_KEY"))
                   :host "api.openai.com"))
```

### Org-mode Configuration
The package will use your existing org-mode configuration to find org-mode files. By default, it will search in locations specified by org-mode settings.

## Common Examples

### Example 1: Single Day Analysis
- Command: `M-x org-tf`
- Date range: `2023-10-01` (end date defaults to the same day)
- Result: All entries from October 1, 2023 are collected and scored

### Example 2: Multi-day Analysis
- Command: `M-x org-tf`
- Date range: `2023-10-01` to `2023-10-03`
- Result: All entries from October 1-3, 2023 are collected and scored

## Troubleshooting

### No Entries Found
- Check that your org-mode files contain entries with proper timestamps
- Verify that the date range is correct
- Ensure org-mode files are in locations searched by the system

### LLM Processing Fails
- Verify your GPTel configuration and API keys
- Check your internet connection
- Confirm that your LLM provider is accessible and not rate-limiting

### Slow Performance
- Large numbers of entries may take time to process
- LLM calls can take time depending on provider response times
- Consider narrowing the date range if processing many entries