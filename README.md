# Thought Forge

An Emacs package for extracting org-mode texts by date, scoring them for novelty, and generating blog content.

## Features

- Extract org-mode entries within a specified date range
- Score entries for novelty using LLM analysis
- Enhance selected entries into coherent blog content
- Generate markdown output suitable for blog posts

## Installation

### From MELPA (Recommended)
1. Ensure you have MELPA configured as a package archive
2. Install with `M-x package-install RET thought-forge RET`

### From Source
1. Clone the repository
2. Add the source directory to your load path
3. Install dependencies: `org-mode`, `gptel`, `s`, `dash`

## Usage

Run the command with `M-x org-tf` or bind it to a key. You will be prompted for a date range in org-mode timestamp format. The system will collect org-mode entries within this date range, score them for novelty, and allow you to select entries for enhancement into blog-ready markdown content.

After the entries are displayed in the selection buffer:
- Click on "UNSELECTED"/"SELECTED" buttons to toggle selection status of entries
- Use `C-c C-c` to process selected entries and create a markdown blog buffer
- Use `q` to quit the buffer

## Configuration

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

## Dependencies

- org-mode
- gptel
- s (string manipulation)
- dash (functional programming)

## License

GPL-3.0-or-later
