;;; packages.el --- chenyang-xcode layer packages file for Spacemacs.
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
;; added to `chenyang-xcode-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `chenyang-xcode/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `chenyang-xcode/pre-init-PACKAGE' and/or
;;   `chenyang-xcode/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst chenyang-xcode-packages
  '(
    company-sourcekit
    swift-mode
    )
  )

(defun chenyang-xcode/init-company-sourcekit ()
  (use-package company-sourcekit
    :defer t
    :init))

(defun chenyang-xcode/post-init-company-sourcekit ()
  (add-to-list 'company-backends 'company-sourcekit))

(defun chenyang-xcode/post-init-swift-mode ()
  (defun my-swift-mode-hook ()
    (require 'company-sourcekit))
  (add-hook 'swift-mode-hook 'my-swift-mode-hook)
  (add-hook 'swift-mode-hook 'company-mode)
  )
