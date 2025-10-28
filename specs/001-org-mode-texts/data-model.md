# Data Model: Org-Mode Text Processing for Blog Creation

## Entities

### Org-Mode Entry
- **id**: string (identifier derived from file location and line number)
- **content**: text (the actual text content of the org-mode entry)
- **timestamp**: time (the org-mode timestamp converted to Emacs time value)
- **file_path**: string (path to the org-mode file containing this entry)
- **position**: integer (line position within the file)
- **novelty_score**: float (calculated novelty score between 0.0 and 1.0)

### Date Range
- **start_date**: time (start of the range in Emacs time value)
- **end_date**: time (end of the range in Emacs time value, defaults to start_date)

### Selection
- **selected_entries**: list of Org-Mode Entry (the entries selected by the user for processing)
- **selection_buffer**: buffer (the buffer containing the display of entries with scores)
- **user_choices**: list of identifiers (IDs of the entries the user selected via interactive interface)

### Enhanced Content
- **original_entry_id**: string (reference to the original Org-Mode Entry)
- **enhanced_text**: text (the LLM-generated enhanced version of the original content)
- **processing_metadata**: hash (information about the enhancement process, like time taken, model used)

### Output Buffer
- **buffer_name**: string (name of the markdown buffer created)
- **content**: text (the final markdown content)
- **creation_time**: time (when the buffer was created)
- **is_markdown**: boolean (flag indicating this is a markdown buffer)