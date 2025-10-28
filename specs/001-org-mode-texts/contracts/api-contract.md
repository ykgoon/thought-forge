# API Contract: Org-Mode Text Processing for Blog Creation

## Public Functions

### `org-tf` (Main entry point)
**Description**: Main command to initiate the org-mode text processing workflow
**Parameters**: None (prompts user for date range interactively)
**Returns**: None (creates buffers and manages workflow)
**Side Effects**: Creates a selection buffer, processes org-mode files, may create output buffer

### `org-tf-extract-entries-by-date` 
**Description**: Extract org-mode entries within a specified date range
**Parameters**: 
- start-date: string in org-timestamp format
- end-date: string in org-timestamp format (defaults to start-date)
**Returns**: list of Org-Mode Entry objects
**Side Effects**: None

### `org-tf-score-entries-for-novelty`
**Description**: Score a list of org-mode entries for novelty
**Parameters**: 
- entries: list of Org-Mode Entry objects
**Returns**: list of Org-Mode Entry objects with updated novelty_score
**Side Effects**: None

### `org-tf-create-selection-buffer`
**Description**: Create an interactive buffer for users to select entries
**Parameters**: 
- entries: list of Org-Mode Entry objects with scores
**Returns**: buffer object
**Side Effects**: Creates a new Emacs buffer

### `org-tf-process-selected-entries`
**Description**: Process user-selected entries through LLM enhancement
**Parameters**: 
- selected-entries: list of Org-Mode Entry objects
- llm-backend: gptel backend specification
**Returns**: list of Enhanced Content objects
**Side Effects**: Makes calls to LLM service

### `org-tf-create-markdown-buffer`
**Description**: Create a markdown buffer with enhanced content
**Parameters**: 
- enhanced-content: list of Enhanced Content objects
**Returns**: buffer object
**Side Effects**: Creates a new Emacs buffer with markdown-mode

## Error Handling

### `org-tf-error-no-entries-found`
**Description**: Raised when no org-mode entries exist within the specified date range
**Recovery**: User can try a different date range

### `org-tf-error-llm-failure`
**Description**: Raised when the LLM enhancement process fails
**Recovery**: User can retry the enhancement operation

### `org-tf-error-invalid-date-range`
**Description**: Raised when the user provides an invalid date range
**Recovery**: User must provide a valid date range