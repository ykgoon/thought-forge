# API Contract: Org-TF Emacs Package

## Overview
This document specifies the public API contract for the thought-forge Emacs package that enables org-mode text processing and blog generation.

## Public Functions

### 1. `org-tf` (Main Entry Point)
**Signature**: `(org-tf)`
**Purpose**: Main command to initiate the org-mode text processing workflow
**Parameters**: None (interactively prompts user for date range)
**Return**: None (interactive function that manages the workflow)
**Behavior**:
- Prompts user for date range in minibuffer using org-time-stamp format
- Defaults second date to first date if not provided
- Collects org-mode entries within the specified date range
- Displays entries in a new buffer with novelty scores
- Initiates interactive selection process
- Processes selected entries through LLM enhancement
- Creates new markdown buffer with enhanced content

**Error Handling**:
- If no entries found in date range, shows "No org-mode entries found in specified date range" and exits gracefully
- If LLM API fails, shows error message to user and stops processing

### 2. `org-tf-collect-entries`
**Signature**: `(org-tf-collect-entries start-date &optional end-date)`
**Purpose**: Collect org-mode entries within a specified date range
**Parameters**:
- `start-date`: Starting date in time format
- `end-date`: Optional ending date in time format (defaults to start-date)
**Return**: List of OrgEntry objects
**Behavior**:
- Searches org-mode files for entries with timestamps in the specified range
- Returns entries with all necessary metadata
- Uses org-mode's built-in date parsing functions

### 3. `org-tf-score-entry`
**Signature**: `(org-tf-score-entry entry)`
**Purpose**: Calculate novelty score for a single org-mode entry
**Parameters**:
- `entry`: An OrgEntry object
**Return**: NoveltyScore object
**Behavior**:
- Performs 4-step LLM analysis process
- Calculates weighted final score
- Returns detailed scoring information
- Uses gptel for LLM communication

### 4. `org-tf-enhance-content`
**Signature**: `(org-tf-enhance-content content)`
**Purpose**: Enhance org-mode content for better coherence using LLM
**Parameters**:
- `content`: String content to be enhanced
**Return**: Enhanced content string
**Behavior**:
- Uses LLM to rewrite and expand content for better coherence
- Preserves core meaning of original content
- Returns enhanced content suitable for blog posts
- Uses gptel for LLM communication

### 5. `org-tf-create-markdown-buffer`
**Signature**: `(org-tf-create-markdown-buffer content)`
**Purpose**: Create a new markdown buffer with specified content
**Parameters**:
- `content`: Content to be placed in the markdown buffer
**Return**: Buffer object
**Behavior**:
- Creates a new buffer named "*Org-TF Blog*"
- Sets buffer mode to markdown-mode if available
- Inserts the provided content
- Switches to the new buffer

## Data Structures

### OrgEntry
A structure representing a collected org-mode entry

**Fields**:
- `id`: Unique identifier
- `content`: Raw text content
- `timestamp`: Creation timestamp
- `file`: Path to source file
- `position`: Position in source buffer
- `novelty-score`: Calculated novelty score
- `is-selected`: Selection status

### NoveltyScore
A structure representing the novelty scoring results

**Fields**:
- `entry-id`: Reference to the OrgEntry
- `cliché-score`: Score for cliché detection
- `conceptual-score`: Score for conceptual originality
- `structural-score`: Score for structural innovation
- `historical-score`: Score for historical precedent
- `synthesis-score`: Score for cross-domain synthesis
- `comparative-score`: Comparative analysis score
- `meta-evaluation-score`: Meta-evaluation score
- `consistency-check-score`: Consistency check score
- `final-score`: Weighted final score
- `confidence-level`: Confidence assessment
- `justification`: Brief explanation

## Error Handling Contract

### Expected Errors
- `org-tf-no-entries-found`: Thrown when no entries exist in the specified date range
- `org-tf-llm-api-error`: Thrown when LLM API communication fails
- `org-tf-invalid-date-range`: Thrown when date range is invalid

### Error Responses
- All error conditions should result in appropriate user-facing messages
- No system crashes or unhandled exceptions
- Graceful degradation when possible

## Performance Contract
- Collection of entries should complete within 30 seconds for typical usage
- Individual entry scoring should complete within 10 seconds
- Content enhancement should complete within 2 minutes per entry
- The system should handle any number of files and entries without imposing artificial limits