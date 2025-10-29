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
  ;; This test requires setup with actual org files
  ;; For now, we'll test with a basic call that shouldn't error
  (should (listp (thought-forge-collect-entries (current-time) (current-time)))))

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

(provide 'test-thought-forge)

;;; test-thought-forge.el ends here