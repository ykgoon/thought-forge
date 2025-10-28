# thought-forge

Thought Forge is an Emacs package designed to help you transform your org-mode notes into polished blog content. The package extracts ideas from your org-mode files based on date ranges, scores them for novelty using LLM analysis, and enhances them into coherent markdown blog posts.

## Features

- **Date-based Org-Mode Text Extraction**: Find and extract org-mode text entries within specified date ranges
- **Novelty Scoring**: Automatically scores entries for originality using a 4-step LLM analysis process
- **Interactive Selection**: Browse and select entries based on their novelty scores
- **LLM Enhancement**: Uses LLMs to rewrite and expand selected ideas into coherent content
- **Markdown Output**: Generates blog-ready markdown content in a new buffer
- **Emacs Integration**: Seamlessly works with your existing org-mode workflow

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
- GPTel package configured with an LLM provider (OpenAI, etc.)

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

The package will use your existing org-mode configuration to find org-mode files. By default, it will search in locations specified by your org-mode settings.

## Usage

### Basic Workflow

1. Open Emacs with the thought-forge package loaded
2. Run the command with `M-x org-tf` or bind it to a key
3. You will be prompted for a date range in org-mode timestamp format (e.g., `2023-10-01` or `<2023-10-01>`)
4. Optionally enter the end date (defaults to the start date)
5. A new buffer will open showing all org-mode entries from the date range
6. Each entry will have a novelty score displayed next to it (0-100, higher scores indicate more novel content)
7. Use the interactive interface to select entries you want to enhance
8. The system will use LLM to enhance the selected entries
9. A new markdown buffer will be created with the enhanced content
10. Review and edit the content as needed, then save as a blog post

### Commands

- `org-tf`: Main command to start the process of finding, scoring, and enhancing org-mode entries

## How the Novelty Scoring Works

The system uses a 4-step LLM analysis process to score the novelty of each entry:

1. **Multi-dimensional Analysis**: Evaluates entries across 5 dimensions:
   - Cliché Detection (0-100)
   - Conceptual Originality (0-100)
   - Structural Innovation (0-100)
   - Historical Precedent (0-100)
   - Cross-Domain Synthesis (0-100)

2. **Comparative Analysis**: Compares entries to examples of different novelty levels

3. **Meta-Evaluation**: Reviews the previous assessments and provides a final score

4. **Consistency Check**: Validates the score with an additional critical review

The final score is calculated as a weighted average:
- Multi-dimensional: 35%
- Comparative: 25%
- Meta-evaluation: 30%
- Consistency check: 10%

## Architecture

The package is structured as a single Emacs Lisp file with multiple functional components:

- **Date Collection Module**: Handles parsing date ranges and finding relevant org-mode entries
- **LLM Processing Module**: Manages communication with LLM via gptel for scoring and enhancement
- **User Interaction Module**: Provides the interactive interface for selection
- **Output Module**: Formats and presents results in markdown buffers

## Development

This project uses a specification-driven development approach. Feature plans and specifications can be found in the `specs/` directory.

### Project Structure
```
specs/
└── 001-org-mode-texts/      # First feature specification
    ├── spec.md             # Detailed feature specification
    ├── plan.md             # Implementation plan
    ├── quickstart.md       # Quickstart guide
    ├── research.md         # Technical research
    ├── data-model.md       # Data model definitions
    └── contracts/          # API contracts
```

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

## License

[License information would go here]