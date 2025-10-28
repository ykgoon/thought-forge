# Quickstart: Org-Mode Text Processing for Blog Creation

## Installation

1. Install the `thought-forge` package from MELPA:
   ```
   M-x package-refresh-contents
   M-x package-install RET thought-forge RET
   ```

2. Ensure you have the required dependencies:
   - `org-mode` (usually included with Emacs)
   - `gptel` (install via package manager if not already installed)

3. Install `skeletor` if you want to contribute to development:
   ```
   M-x package-install RET skeletor RET
   ```

## Configuration

1. Configure gptel with your preferred LLM backend:
   ```elisp
   (require 'gptel)
   (setq gptel-backend (gptel-make-backend "OpenAI"
                   :key "your-api-key"
                   :stream t
                   :url "https://api.openai.com/v1/chat/completions"
                   :models '("gpt-3.5-turbo" "gpt-4")))
   ```

## Basic Usage

1. Run the main command:
   ```
   M-x org-tf
   ```

2. When prompted, enter the start date in org-mode timestamp format (e.g., `2023-10-01` or `<2023-10-01>`)

3. Optionally enter the end date (defaults to the start date if left empty)

4. The system will collect org-mode entries from your configured org files within the date range

5. A selection buffer will appear with entries and their novelty scores

6. Select the entries you want to process by marking them in the buffer

7. Execute the enhancement command to process selected entries via LLM

8. The final markdown content will appear in a new buffer ready for blog creation

## Example Workflow

```
1. M-x org-tf
2. Enter start date: <2023-10-01>
3. Enter end date: <2023-10-07>
4. Review entries in selection buffer
5. Mark entries for processing
6. M-x org-tf-process-selected
7. Review enhanced content in new markdown buffer
```

## Common Issues

- **No entries found**: Check that you have org-mode files with timestamped entries in the specified date range
- **LLM processing fails**: Verify your gptel configuration and API key
- **Date format errors**: Use org-mode timestamp format (e.g., `<2023-10-01>` or `2023-10-01`)