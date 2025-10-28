# Data Model: Org-Mode Text Processing for Blog Creation

## Overview
This document describes the data structures and entities used in the org-mode text processing system.

## Core Entities

### 1. OrgEntry
Represents a single org-mode text entry with metadata

- **id**: Unique identifier for the entry (string)
- **content**: The raw text content of the org-mode entry (string)
- **timestamp**: The date/time when the entry was created (time object)
- **startDate**: Start date of the entry (time object)
- **endDate**: End date of the entry (time object, optional)
- **file**: Path to the org-mode file containing this entry (string)
- **position**: Position in the buffer where the entry was found (number)
- **noveltyScore**: Calculated novelty score (0-100, number)
- **confidenceLevel**: Confidence level of the novelty score (string: 'low', 'medium', 'high')
- **isSelected**: Whether the user has selected this entry for processing (boolean)

### 2. DateRange
Represents a range of dates for filtering org-mode entries

- **startDate**: Beginning of the date range (time object)
- **endDate**: End of the date range (time object)
- **defaultEndEqualsStart**: Whether the end date defaults to the start date (boolean)

### 3. NoveltyScore
Represents the detailed scoring of an entry's novelty

- **entryId**: Reference to the OrgEntry being scored (string)
- **multiDimensionalScore**: Score from multi-dimensional analysis (0-100, number)
- **clichéScore**: Score for cliché detection (0-100, number)
- **conceptualScore**: Score for conceptual originality (0-100, number)
- **structuralScore**: Score for structural innovation (0-100, number)
- **historicalScore**: Score for historical precedent (0-100, number)
- **synthesisScore**: Score for cross-domain synthesis (0-100, number)
- **comparativeScore**: Score from comparative analysis (0-100, number)
- **metaEvaluationScore**: Score from meta-evaluation (0-100, number)
- **consistencyCheckScore**: Score from consistency check (0-100, number)
- **finalScore**: Weighted final score (0-100, number)
- **confidenceLevel**: Confidence level of the assessment (string: 'low', 'medium', 'high')
- **justification**: Brief explanation for the scores (string)

### 4. ProcessingResult
Represents the result after LLM enhancement

- **entryId**: Reference to the original OrgEntry (string)
- **originalContent**: Original content before enhancement (string)
- **enhancedContent**: Content after LLM enhancement (string)
- **processingTime**: Time taken for enhancement (number in seconds)
- **llmModelUsed**: Which LLM model was used (string)
- **processingStatus**: Status of the enhancement (string: 'success', 'error', 'timeout')

## Relationships

### OrgEntry and NoveltyScore
- One OrgEntry can have one NoveltyScore (1:1)
- The relationship is mandatory when scoring has been performed

### DateRange and OrgEntry
- One DateRange can contain many OrgEntries (1:many)
- OrgEntries are filtered by their timestamp falling within the DateRange

### OrgEntry and ProcessingResult
- One OrgEntry can have one ProcessingResult after enhancement (1:1)
- This relationship is optional until enhancement is performed

## State Transitions

### OrgEntry States
- `COLLECTED`: Entry has been found within the date range
- `SCORED`: Entry has received a novelty score
- `SELECTED`: User has selected this entry for enhancement
- `PROCESSED`: Entry has been enhanced by LLM
- `OUTPUT_READY`: Enhanced content is ready in markdown buffer

## Validation Rules

### DateRange Validation
- startDate must be before or equal to endDate
- Both dates must be valid org-mode timestamp format
- Range must not exceed system limits (if any)

### NoveltyScore Validation
- All individual scores must be between 0 and 100
- Final score must be calculated using the weighted formula
- Final score must not exceed 100
- Confidence level must be one of 'low', 'medium', 'high'

### OrgEntry Validation
- Content must not be empty when selected for processing
- Timestamp must be a valid time value
- File path must point to an existing org-mode file