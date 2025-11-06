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
    (should (thought-forge-date-range-p date-range))))

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

(provide 'test-thought-forge)

;;; test-thought-forge.el ends here
