;;; packages.el --- chenyang-org layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author:  ChenYang <charlescliff@foxmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `chenyang-org-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `chenyang-org/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `chenyang-org/pre-init-PACKAGE' and/or
;;   `chenyang-org/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst chenyang-org-packages
  '(org
    org-mac-link
    org-pomodoro
    org-octopress
    deft
    )
  )
(defun chenyang-org/post-init-org ()
  (with-eval-after-load 'org
    (progn
      (spacemacs|disable-company org-mode)
      (spacemacs/set-leader-keys-for-major-mode 'org-mode
        "," 'org-priority)
      (require 'org-compat)
      (require 'org)
      (require 'org-habit)
      (add-to-list 'org-modules 'org-habit)
      (setq org-refile-use-outline-path 'file)
      (setq org-outline-path-complete-in-steps nil)
      (setq org-refile-targets
            '((nil :maxlevel . 4)
              (org-agenda-files :maxlevel . 4)))
      (setq org-agenda-inhibit-startup t)
      (setq org-agenda-use-tag-inheritance nil)
      (setq org-log-done t)

      (with-eval-after-load 'org-agenda
        (define-key org-agenda-mode-map (kbd "P") 'org-pomodoro)
        (spacemacs/set-leader-keys-for-major-mode 'org-agenda-mode
          "." 'spacemacs/org-agenda-transient-state/body)
        )

      )))

(defun chenyang-org/init-org-mac-link()
  (use-package org-mac-link
    :commands org-mac-grab-link
    :init
    (progn
      (add-hook 'org-mode-hook
                (lambda ()
                  (define-key org-mode-map (kbd "C-c g") 'org-mac-grab-link))))
    :defer t))

(defun chenyang-org/post-init-deft ()
  (progn
    (setq deft-use-filter-string-for-filename t)
    (spacemacs/set-leader-keys-for-major-mode 'deft-mode "q" 'quit-window)
    (setq deft-recursive t)
    (setq deft-extension "org")
    (setq deft-directory "~/org-notes")))
;;; packages.el ends here
