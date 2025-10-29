;; Initialize packages and run tests
(setq user-emacs-directory "~/.emacs.d/")
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

;; Load required libraries
(require 'cl)
(require 'org)
(require 'cl-lib)
(require 'gptel)
(require 's)
(require 'dash)

;; Load the source and test files
(load-file "src/thought-forge.el")
(load-file "tests/test-thought-forge.el")

;; Run the tests
(ert-run-tests-batch-and-exit)