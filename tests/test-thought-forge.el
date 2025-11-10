;;; test-thought-forge.el --- Tests for thought-forge package -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Y.K. Goon

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Tests for the thought-forge package.

;;; Code:

(ert-deftest test-thought-forge-org-entry-creation ()
  "Test creation of thought-forge-org-entry structure."
  (let ((entry (thought-forge-make-org-entry
                :id "test-id"
                :content "Test content"
                :timestamp (current-time))))
    (should (thought-forge-org-entry-p entry))
    (should (string= (thought-forge-org-entry-id entry) "test-id"))
    (should (string= (thought-forge-org-entry-content entry) "Test content"))))

(ert-deftest test-thought-forge-date-range-creation ()
  "Test creation of thought-forge-date-range structure."
  (let ((date-range (thought-forge-make-date-range
                     :start-date (current-time)
                     :end-date (current-time))))
    (should (thought-forge-date-range-p date-range)))
  (let* ((start-date (current-time))
         (end-date (time-add start-date (* 2 86400)))  ; Add 2 days (2 * 24 * 60 * 60 seconds)
         (date-range (thought-forge-make-date-range
                      :start-date start-date
                      :end-date end-date)))
    (should (thought-forge-date-range-p date-range))
    (should (time-equal-p (thought-forge-date-range-start-date date-range) start-date))
    (should (time-equal-p (thought-forge-date-range-end-date date-range) end-date))
    (should (time-less-p (thought-forge-date-range-start-date date-range)
                         (thought-forge-date-range-end-date date-range)))))

(ert-deftest test-thought-forge-parse-org-timestamp ()
  "Test parsing of org-mode timestamps."
  (let ((result (thought-forge-parse-org-timestamp "<2023-10-01>")))
    (should (listp result))  ; time values in Emacs are lists of integers
    (should (or (= (length result) 2) (= (length result) 3)))  ; time values have 2 or 3 elements
    (should (integerp (nth 0 result)))  ; First element should be integer
    (should (or (null (nth 2 result)) (integerp (nth 1 result))))))  ; Second element should be integer or nil

(ert-deftest test-thought-forge-collect-entries ()
  "Test collecting entries from date range."
  (let* ((start-date (date-to-time "2025-10-28"))
         (end-date (date-to-time "2025-10-30"))
         ;; Temporarily modify the function to look in the test directory
         (mock-get-org-files (lambda ()
                               (directory-files-recursively
                                (expand-file-name "tests/org" default-directory)
                                "\\.org$"))))
    ;; Override the function temporarily using cl-letf
    (cl-letf (((symbol-function 'thought-forge-get-org-files) mock-get-org-files))
      (let ((entries (thought-forge-collect-entries start-date end-date)))
        (should (listp entries))
        (should (= (length entries) 4))  ; We expect exactly 4 entries

        ;; Extract content from entries
        (let* ((contents (mapcar #'thought-forge-org-entry-content entries))
               (content-strings (mapcar (lambda (content)
                                          (s-trim (s-collapse-whitespace content)))
                                        contents)))

          ;; Verify that all expected content strings are present (after whitespace collapse)
          (should (cl-some (lambda (content)
                             (string-match-p "Etiam laoreet quam sed arcu\\. Nullam tristique diam non turpis\\." content))
                           content-strings))
          (should (cl-some (lambda (content)
                             (string-match-p "suscipit ligula\\. Donec posuere augue in quam\\." content))
                           content-strings))
          (should (cl-some (lambda (content)
                             (string-match-p "Proin neque massa, cursus ut, gravida ut," content))
                           content-strings))
          (should (cl-some (lambda (content)
                             (string-match-p "dignissim in, mollis nec, sagittis eu, wisi\\." content))
                           content-strings)))))))

(ert-deftest test-thought-forge-multidimensional-analysis ()
  "Test multidimensional analysis function."
  (let ((scores (thought-forge-multidimensional-analysis "Test passage")))
    (should (listp scores))
    (should (numberp (plist-get scores :cliche)))
    ;; The function should return the expected placeholder values
    (should (= (plist-get scores :cliche) 70))
    (should (= (plist-get scores :conceptual) 65))
    (should (= (plist-get scores :structural) 75))
    (should (= (plist-get scores :historical) 60))
    (should (= (plist-get scores :synthesis) 80))))

(ert-deftest test-thought-forge-average-scores ()
  "Test average scores calculation."
  (let ((scores (list :cliche 50 :conceptual 60 :structural 70 :historical 80 :synthesis 90)))
    (should (= (thought-forge-average-scores scores) 70.0))))

(ert-deftest test-thought-forge-find-entry-start ()
  "Test finding entry start position after timestamp."
  (let ((test-file (expand-file-name "tests/org/test1.org" default-directory)))
    (with-temp-buffer
      (insert-file-contents test-file)
      (goto-char (point-min))

      ;; Search for the specific timestamp <2025-10-26 Sun>
      (should (re-search-forward "<2025-10-26 Sun>" nil t))

      ;; Call the function to find entry start
      (let ((start-pos (thought-forge-find-entry-start)))
        ;; The expected position is at line 9, which should be the line with "Etiam vel tortor sodales tellus ultricies commodo."
        ;; Calculate the expected position by going to line 9
        (goto-char (point-min))
        (forward-line 8)  ; Line 9 is 8 lines after point-min (0-indexed)
        (let ((expected-pos (line-beginning-position)))
          (should (= start-pos expected-pos)))

        ;; Also verify that the content at this position is what we expect
        (goto-char start-pos)
        (should (looking-at "Etiam vel tortor sodales tellus ultricies commodo."))))))

(ert-deftest test-thought-forge-find-entry-end ()
  "Test finding entry end position after timestamp <2025-10-26 Sun>."
  (let ((test-file (expand-file-name "tests/org/test1.org" default-directory)))
    (with-temp-buffer
      (insert-file-contents test-file)
      (goto-char (point-min))

      ;; Search for the specific timestamp <2025-10-26 Sun>
      (should (re-search-forward "<2025-10-26 Sun>" nil t))

      ;; The function should return the end position of the content line (line 9)
      (let ((end-pos (thought-forge-find-entry-end)))
        ;; The content line is "Etiam vel tortor sodales tellus ultricies commodo." on line 9
        ;; The end of this line is the expected position
        (goto-char (point-min))
        (forward-line 8)  ; Go to line 9 (0-indexed: 8)
        (let ((expected-end-pos (line-end-position)))  ; End position of line 9
          (should (= end-pos expected-end-pos)))

        ;; Also verify that we're at the end of the right line by moving back to the beginning of the line
        (goto-char end-pos)
        (beginning-of-line)
        (should (looking-at "Etiam vel tortor sodales tellus ultricies commodo\\."))))))

(ert-deftest test-thought-forge-get-org-files ()
  "Test getting org mode files."
  (let ((current-file buffer-file-name))
    ;; Test when current buffer is an org file
    (with-temp-buffer
      (setq buffer-file-name "test.org")
      (let ((org-files (thought-forge-get-org-files)))
        (should (listp org-files))
        (should (member "test.org" org-files))))

    ;; Test when current buffer is not an org file (should look for ORG_DIRECTORY)
    (let* ((temp-org-dir (make-temp-file "test-org-dir" 'directory))
           (temp-org-file (expand-file-name "test-temp.org" temp-org-dir)))
      ;; Create the temp org file
      (with-temp-file temp-org-file (insert "Test org file for testing"))

      ;; Temporarily set ORG_DIRECTORY to point to our temp directory
      (cl-letf (((symbol-function 'getenv) (lambda (var)
                                             (if (string= var "ORG_DIRECTORY")
                                                 temp-org-dir
                                               (funcall (symbol-function 'getenv) var)))))
        (let ((org-files (thought-forge-get-org-files)))
          (should (member temp-org-file org-files))))

      ;; Clean up
      (delete-file temp-org-file)
      (delete-directory temp-org-dir))))

(ert-deftest test-thought-forge-score-entry ()
  "Test scoring an entry."
  (let* ((entry (thought-forge-make-org-entry
                 :id "test-entry"
                 :content "This is a test content for scoring."
                 :timestamp (current-time)))
         (score (thought-forge-score-entry entry)))
    (should (thought-forge-novelty-score-p score))
    (should (string= (thought-forge-novelty-score-entry-id score) "test-entry"))
    (should (numberp (thought-forge-novelty-score-final-score score)))
    (should (>= (thought-forge-novelty-score-final-score score) 0))
    (should (<= (thought-forge-novelty-score-final-score score) 100))))

(ert-deftest test-thought-forge-comparative-analysis ()
  "Test comparative analysis function."
  (let ((result (thought-forge-comparative-analysis "Test passage for comparative analysis")))
    (should (listp result))
    (should (numberp (plist-get result :score)))
    (should (>= (plist-get result :score) 0))
    (should (<= (plist-get result :score) 100))))

(ert-deftest test-thought-forge-meta-evaluation ()
  "Test meta evaluation function."
  (let* ((scores (list :cliche 70 :conceptual 65 :structural 75 :historical 60 :synthesis 80))
         (comparative (list :score 68))
         (result (thought-forge-meta-evaluation "Test passage" scores comparative)))
    (should (listp result))
    (should (numberp (plist-get result :score)))
    (should (stringp (plist-get result :justification)))
    (should (or (string= (plist-get result :confidence) "low")
                (string= (plist-get result :confidence) "medium")
                (string= (plist-get result :confidence) "high")))))

(ert-deftest test-thought-forge-consistency-check ()
  "Test consistency check function."
  (let ((result (thought-forge-consistency-check "Test passage" 75)))
    (should (listp result))
    (should (numberp (plist-get result :score)))
    (should (>= (plist-get result :score) 0))
    (should (<= (plist-get result :score) 100))))

(ert-deftest test-thought-forge-create-selection-buffer ()
  "Test creating selection buffer with entries."
  (let* ((entry1 (thought-forge-make-org-entry
                  :id "entry-1"
                  :content "First test entry"
                  :timestamp (current-time)
                  :novelty-score 85.0))
         (entry2 (thought-forge-make-org-entry
                  :id "entry-2"
                  :content "Second test entry"
                  :timestamp (current-time)
                  :novelty-score 72.5))
         (entries (list entry1 entry2)))
    (thought-forge-create-selection-buffer entries)
    (let ((buffer (get-buffer "*Org-TF Selection*")))
      (should buffer)
      (with-current-buffer buffer
        (should (string-match-p "entry-1" (buffer-string)))
        (should (string-match-p "entry-2" (buffer-string)))
        (should (string-match-p "85.0" (buffer-string)))
        (should (string-match-p "72.5" (buffer-string)))
        (should (string-match-p "First test entry" (buffer-string)))
        (should (string-match-p "Second test entry" (buffer-string)))))))

(ert-deftest test-thought-forge-toggle-entry-selection ()
  "Test toggling entry selection."
  (let* ((entry (thought-forge-make-org-entry
                 :id "toggle-test"
                 :content "Test entry for toggle"
                 :timestamp (current-time)))
         (buffer (get-buffer-create "*Test-Toggle-Selection*")))
    (with-current-buffer buffer
      (erase-buffer)
      (insert "Status: ")
      ;; Create a button to test with
      (let ((button-start (point)))
        (insert-text-button "UNSELECTED"
                            'action (lambda (button)
                                      (thought-forge-toggle-entry-selection button))
                            'entry entry
                            'face '(:background "red" :foreground "white")
                            'entry-selected nil)
        (let ((button (button-at button-start)))
          ;; Test initial state
          (should (string= (button-label button) "UNSELECTED"))
          (should (not (button-get button 'entry-selected)))
          (should (not (thought-forge-org-entry-is-selected entry)))

          ;; Toggle the selection - this replaces the button with a new one
          (thought-forge-toggle-entry-selection button)

          ;; Since the button was replaced, we need to get the new one at the same position
          (let ((new-button (button-at button-start)))
            (should (string= (button-label new-button) "SELECTED"))
            (should (button-get new-button 'entry-selected))
            (should (thought-forge-org-entry-is-selected entry)))

          ;; Toggle back
          (let ((current-button (button-at button-start)))
            (thought-forge-toggle-entry-selection current-button))

          ;; Check it's back to initial state
          (let ((final-button (button-at button-start)))
            (should (string= (button-label final-button) "UNSELECTED"))
            (should (not (button-get final-button 'entry-selected)))
            (should (not (thought-forge-org-entry-is-selected entry)))))))))

(ert-deftest test-thought-forge-enhance-content ()
  "Test enhancing content."
  (let ((original-content "This is a test content that needs enhancement.")
        (enhanced-content (thought-forge-enhance-content "This is a test content that needs enhancement.")))
    (should (stringp enhanced-content))
    (should (string-match-p "This is a test content that needs enhancement\\." enhanced-content))
    (should (string-match-p "Enhanced by LLM" enhanced-content))))

(ert-deftest test-thought-forge-create-markdown-buffer ()
  "Test creating markdown buffer."
  (let ((content "Test content for markdown buffer"))
    (let ((buffer (thought-forge-create-markdown-buffer content)))
      (should (bufferp buffer))
      (should (buffer-live-p buffer))
      (with-current-buffer buffer
        (should (string-match-p "Test content for markdown buffer" (buffer-string)))
        ;; Check if it's in the correct mode depending on availability
        (should (or (eq major-mode 'markdown-mode)
                    (eq major-mode 'fundamental-mode)))))))

(ert-deftest test-thought-forge-process-selected-entries ()
  "Test processing selected entries."
  (let* ((entry1 (thought-forge-make-org-entry
                  :id "proc-test-1"
                  :content "First content to process"
                  :timestamp (current-time)))
         (entry2 (thought-forge-make-org-entry
                  :id "proc-test-2"
                  :content "Second content to process"
                  :timestamp (current-time)))
         (selected-entries (list entry1 entry2))
         (results (thought-forge-process-selected-entries selected-entries)))
    (should (listp results))
    (should (= (length results) 2))

    ;; Check that results contain the expected entries (note: order may be reversed due to push)
    (let ((result-ids (mapcar #'thought-forge-processing-result-entry-id results)))
      (should (member "proc-test-1" result-ids))
      (should (member "proc-test-2" result-ids)))

    ;; Check that we have the expected content regardless of order
    (let ((result-contents (mapcar #'thought-forge-processing-result-original-content results)))
      (should (member "First content to process" result-contents))
      (should (member "Second content to process" result-contents)))

    ;; Check that both results have enhanced content
    (dolist (result results)
      (should (thought-forge-processing-result-p result))
      (should (string-match-p "Enhanced by LLM" (thought-forge-processing-result-enhanced-content result))))))

(ert-deftest test-org-tf ()
  "Test the main org-tf command function."
  ;; We can't easily test the interactive parts (read-string) directly
  ;; So we'll test the underlying functionality by calling internal functions
  (let ((start-date (current-time))
        (entry (thought-forge-make-org-entry
                :id "test-main"
                :content "Test content for main function"
                :timestamp (current-time))))
    ;; Just make sure the function is defined and callable
    (should (fboundp 'org-tf))))

(ert-deftest test-org-tf-process-selected-entries ()
  "Test processing selected entries command."
  ;; We'll test the function by simulating the selected entries
  (with-temp-buffer
    (let ((inhibit-read-only t))
      ;; Create a mock selection buffer
      (insert "Mock selection buffer for testing\n")
      (goto-char (point-min)))
    (should (fboundp 'org-tf-process-selected-entries))

    ;; Test the underlying functionality
    (let* ((entry (thought-forge-make-org-entry
                   :id "sample-1"
                   :content "This is a sample org-mode entry that needs enhancement."
                   :timestamp (current-time)))
           (results (thought-forge-process-selected-entries (list entry))))
      (should (= (length results) 1))
      (let ((result (car results)))
        (should (thought-forge-processing-result-p result))
        (should (string= (thought-forge-processing-result-entry-id result) "sample-1"))
        (should (string-match-p "Enhanced by LLM" (thought-forge-processing-result-enhanced-content result)))))))

(provide 'test-thought-forge)

;;; test-thought-forge.el ends here
