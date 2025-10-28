# Feature Specification: Org-Mode Text Processing for Blog Creation

**Feature Branch**: `001-org-mode-texts`  
**Created**: Tuesday, October 28, 2025
**Status**: Draft  
**Input**: User description: "This is an emacs package. The objective is to find org-modes texts written on a given date, extract novel ideas, expand them to make it coherent, then create a markdown blog post for them. End-user shall run `org-tf`. Minibuffer would prompt user to supply a date-range. Dates are provided the same way `org-time-stamp` does. Second date would have the default value of the the first date. Thought Forge would do the processing. It look for org-mode texts written between these dates. These texts are placed in a new buffer. User selects the texts wanted and issues a command. Each texts are then scored for their novelty. Scores are presented next to the texts. User further selects the texts that he is interested in. Thought Forge takes the selected texts, rewrite or expand them with more coherence (using LLM), then place the new writing into a new markdown buffer. User uses this new buffer to create a new blog post."

## Clarifications

### Session 2025-10-28

- Q: How should duplicate content across files be handled? → A: Skip duplicate detection entirely, process all entries as-is
- Q: What are the scalability limits for number of files and entries? → A: No limits - process any number of files/entries that user has
- Q: Define security and privacy requirements for processing org-mode files → A: No special security measures needed beyond standard file access permissions
- Q: Where should the system look for org-mode files? → A: The default directory is provided by emacs org settings. Check from there rather than using ~/org.
- Q: What accessibility requirements should be considered for users with disabilities? → A: No accessibility requirements needed beyond standard emacs functionality
- Q: How should the system handle LLM API failures, rate limits, or billing issues? → A: Show error message to user and stop processing when API fails
- Q: What logging or metrics should be implemented for monitoring system usage and errors? → A: Basic error logging only
- Q: How should the system behave when no entries exist within the date range? → A: Show message 'No org-mode entries found in specified date range' and exit gracefully
- Q: Should users be able to customize the LLM parameters (temperature, model, etc.)? → A: Use default LLM parameters, no user customization

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Extract and Score Org-Mode Texts by Date Range (Priority: P1)

A user wants to find ideas they captured in org-mode files during a specific time period and identify the most novel ones to develop into blog content. The user runs the `org-tf` command, specifies a date range (with the end date defaulting to the start date), and sees all org-mode entries from that period. The system then scores each text for novelty, presenting the scores for user review.

**Why this priority**: This is the foundational functionality that enables the entire workflow - without identifying and scoring texts by date, the rest of the feature cannot work.

**Independent Test**: Can be fully tested by running the command with a date range and verifying that org-mode entries from that time period are correctly identified and scored for novelty, delivering the core value of finding potential blog content.

**Acceptance Scenarios**:

1. **Given** a user has org-mode files with timestamped entries, **When** the user runs `org-tf` and specifies a date range, **Then** all org-mode entries within that date range are collected and displayed in a new buffer
2. **Given** org-mode entries are displayed in a buffer, **When** the system applies novelty scoring, **Then** each entry has a novelty score displayed next to it

---

### User Story 2 - Generate Coherent Markdown Blog Content from Selected Ideas (Priority: P1)

After identifying novel ideas from the date range, a user selects specific entries and requests the system to enhance them into coherent blog content. The system uses intelligent processing to expand and refine the selected ideas, then presents the enhanced content in a new markdown buffer ready for blog creation.

**Why this priority**: This delivers the core value proposition of transforming raw ideas into publishable blog content.

**Independent Test**: Can be fully tested by selecting org-mode entries that have been scored and verifying that the system generates well-structured, coherent markdown content in a new buffer.

**Acceptance Scenarios**:

1. **Given** a buffer with org-mode entries and novelty scores, **When** a user selects specific entries and requests intelligent enhancement, **Then** a new markdown buffer is created with expanded and coherent content based on the selected entries
2. **Given** selected org-mode entries, **When** the system processes them with intelligent enhancement, **Then** the output in the markdown buffer maintains the core ideas while improving coherence and readability

---

### User Story 3 - Interactive Text Selection and Processing Workflow (Priority: P2)

A user wants an interactive workflow to efficiently identify, review, and process org-mode entries. The user runs the command, reviews the collected entries, optionally filters or re-scores them, selects ones for expansion, and generates the final blog content.

**Why this priority**: This provides the complete user experience that connects all the individual capabilities into a cohesive workflow.

**Independent Test**: Can be fully tested by completing the entire workflow from date range selection to final markdown output, demonstrating the complete value proposition.

**Acceptance Scenarios**:

1. **Given** the user has run the `org-tf` command and specified a date range, **When** the user interacts with the buffer to select specific entries, **Then** only the selected entries proceed to the LLM enhancement phase
2. **Given** entries have been processed by the LLM, **When** the user reviews the output buffer, **Then** the buffer contains properly formatted markdown suitable for a blog post

---

### Edge Cases

- What happens when no org-mode entries exist within the specified date range? The system will show a message 'No org-mode entries found in specified date range' and exit gracefully.
- How does the system handle malformed date ranges (end date before start date)?
- What if the LLM enhancement process fails for some entries? The system will show an error message to the user and stop processing when API fails.
- How does the system handle extremely long org-mode entries that might exceed LLM token limits?
- What happens if org-mode files are in different locations or require special access permissions?

## Requirements *(mandatory)*

### Functional Requirements

### Novelty Scoring Implementation Requirements

- **NS-001**: System MUST implement the LLM-Only Novelty Score methodology with 4-step analysis process
- **NS-002**: System MUST perform multi-dimensional novelty analysis across 5 dimensions: Cliché Detection, Conceptual Originality, Structural Innovation, Historical Precedent, and Cross-Domain Synthesis
- **NS-003**: System MUST provide comparative analysis against established novelty level examples (0-20: cliché, 30-40: common, 50-60: creative, 70-80: unusual, 90+: groundbreaking)
- **NS-004**: System MUST perform meta-evaluation to validate initial assessment scores
- **NS-005**: System MUST include consistency check to identify precedents and validate originality claims
- **NS-006**: System MUST implement weighted average calculation (Multi-dimensional: 35%, Comparative: 25%, Meta-evaluation: 30%, Consistency check: 10%) for final novelty score
- **NS-007**: System MUST use gptel package to make LLM calls for novelty scoring
- **NS-008**: System MUST cap final novelty scores at 100 points
- **NS-009**: System MUST provide confidence level (low/medium/high) with each novelty assessment

- **FR-001**: System MUST allow users to run the `org-tf` command to initiate the process
- **FR-002**: System MUST prompt the user in the minibuffer to supply a date range in the org-time-stamp format
- **FR-003**: System MUST default the end date to the start date if no end date is provided by the user
- **FR-004**: System MUST search for org-mode entries within the specified date range
- **FR-005**: System MUST collect all found org-mode entries and display them in a new buffer
- **FR-006**: System MUST score each displayed text entry for novelty and present the scores next to the entries
- **FR-007**: System MUST allow users to select which entries they want to process further
- **FR-008**: System MUST use intelligent processing to rewrite or expand the selected entries for better coherence
- **FR-009**: System MUST place the enhanced content into a new markdown buffer
- **FR-010**: System MUST ensure the output markdown buffer is structured appropriately for blog posts
- **FR-011**: System MUST handle org-mode files that use the standard `org-time-stamp` date format
- **FR-012**: System MUST preserve the core meaning of original entries during enhancement process
- **FR-013**: System MUST use gptel package to make LLM calls for novelty scoring
- **FR-014**: System MUST implement 4-step novelty analysis process (Multi-dimensional, Comparative, Meta-evaluation, Consistency check)
- **FR-015**: System MUST cap final novelty scores at 100 points

### Key Entities

- **Org-Mode Entries**: Text content captured in org-mode format with associated timestamps indicating when they were written
- **Date Range**: A period defined by start and end dates, specified in org-mode timestamp format, used to filter relevant entries
- **Novelty Score**: A quantitative measure assigned to each entry indicating its originality or uniqueness relative to other content
- **Selection**: A subset of entries chosen by the user for further processing and enhancement
- **Enhanced Content**: The LLM-processed version of the original entries, improved for coherence and readability
- **Markdown Buffer**: A temporary output buffer containing properly formatted markdown content suitable for blog creation

## Success Criteria *(mandatory)*

### Measurable Outcomes

### Novelty Scoring Specific Criteria

- **NSC-001**: Each org-mode entry receives a novelty score between 0-100 within 10 seconds of analysis
- **NSC-002**: The 4-step LLM analysis process completes successfully for 95% of entries
- **NSC-003**: Novelty scores demonstrate meaningful differentiation between different levels of originality as validated by manual review
- **NSC-004**: The system provides confidence level assessment (low/medium/high) for each novelty score
- **NSC-005**: False positive rate for high novelty scores (80+ points) is less than 10% when validated against existing content

## Implementation Details

### LLM-Only Novelty Score Methodology

After passages have been extracted in an org-mode buffer, proceed to give each of them a score. This is the process of scoring them.

# LLM-Only Novelty Score Methodology

Yes, absolutely! Here's a streamlined version using only LLM calls:

## Simplified LLM-Based Pipeline

### Step 1: Multi-Dimensional Analysis (Single LLM Call)
**Prompt Template:**
```
Analyze this passage for novelty across multiple dimensions:

Passage: [INSERT PASSAGE]

Provide scores (0-100) for each dimension:

1. CLICHÉ DETECTION: How clichéd or overused are the phrases and ideas?
   (0=extremely clichéd, 100=no clichés at all)

2. CONCEPTUAL ORIGINALITY: How original is the combination of concepts?
   (0=extremely common combination, 100=never seen before)

3. STRUCTURAL INNOVATION: How unique is the way ideas are expressed?
   (0=conventional expression, 100=highly unusual structure/style)

4. HISTORICAL PRECEDENT: How new is this idea in human history?
   (0=ancient/well-known idea, 100=genuinely unprecedented)

5. CROSS-DOMAIN SYNTHESIS: Does it combine ideas from different fields in new ways?
   (0=single domain or common combination, 100=unexpected fusion)

Format your response as:
- Cliché Score: [number]
- Conceptual Score: [number]
- Structural Score: [number]
- Historical Score: [number]
- Synthesis Score: [number]
- Brief justification for each score
```

### Step 2: Comparative Analysis (Second LLM Call)
**Prompt Template:**
```
Given this passage: [INSERT PASSAGE]

Compare it to these examples of different novelty levels:
- Novelty 0-20: "Every cloud has a silver lining" (pure cliché)
- Novelty 30-40: "AI will change how we work" (common observation)
- Novelty 50-60: "Memories might be quantum entangled across neurons" (creative but builds on existing ideas)
- Novelty 70-80: "Consciousness emerges from the gaps between thoughts, not the thoughts themselves" (unusual perspective)
- Novelty 90+: [Would be a genuinely groundbreaking scientific or philosophical insight]

Where does the given passage fall on this scale? Provide a score 0-100.
```

### Step 3: Meta-Evaluation (Third LLM Call)
**Prompt Template:**
```
Review these novelty assessments for the passage: [INSERT PASSAGE]

Assessment 1 scores:
- Cliché: [X]
- Conceptual: [X]
- Structural: [X]
- Historical: [X]
- Synthesis: [X]

Assessment 2 comparative score: [X]

Consider:
1. Is there anything genuinely surprising or unprecedented here?
2. Would experts in relevant fields find this novel?
3. Could this idea have been expressed 100 years ago, or does it require modern context?
4. Is this just rewording known ideas or creating new connections?

Provide:
- Final novelty score (0-100)
- Confidence level (low/medium/high)
- One-line justification
```

### Step 4: Consistency Check (Optional Fourth LLM Call)
**Prompt Template:**
```
You are a harsh critic of originality. Your job is to find precedents.

For this passage: [INSERT PASSAGE]
With proposed novelty score: [SCORE]

Try to:
1. Find similar ideas that already exist
2. Identify which parts are truly original vs derivative
3. Suggest a more realistic score if you think [SCORE] is too high

If you cannot find good precedents, confirm the score is appropriate.
```

## Emacs Lisp Implementation

The implementation MUST use the `gptel` package to make calls to LLM. The following elisp structure should be implemented:

```elisp
(defun org-tf-calculate-novelty-score (passage)
  "Calculate novelty score for PASSAGE using 4-step LLM analysis."
  ;; Step 1: Multi-dimensional analysis
  (let* ((dimensions (org-tf-multidimensional-analysis passage))
         ;; Step 2: Comparative analysis
         (comparative (org-tf-comparative-analysis passage))
         ;; Step 3: Meta-evaluation
         (meta-eval (org-tf-meta-evaluation passage dimensions comparative))
         ;; Step 4: Consistency check
         (critic-eval (org-tf-consistency-check passage (plist-get meta-eval :score))))
    
    ;; Weighted average calculation
    (let ((final-score (+ (* (org-tf-average-scores dimensions) 0.35)
                          (* (plist-get comparative :score) 0.25)
                          (* (plist-get meta-eval :score) 0.30)
                          (* (plist-get critic-eval :score) 0.10))))
      ;; Cap at 100
      (min 100 final-score))))
```

- **SC-001**: Users can identify and process org-mode entries from a specified date range within 30 seconds of initiating the command
- **SC-002**: At least 80% of org-mode entries within a given date range are successfully located and displayed for user review
- **SC-003**: The LLM enhancement process produces coherent, readable content that maintains the original meaning for 90% of selected entries
- **SC-004**: Users can generate a blog-ready markdown buffer from selected entries within 2 minutes of selecting those entries
- **SC-005**: The system correctly handles date ranges including boundary cases (single-day ranges, ranges spanning multiple files) 95% of the time