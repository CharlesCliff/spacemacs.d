;;; packages.el --- chenyang-php layer packages file for Spacemacs.
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
;; added to `chenyang-php-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `chenyang-php/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `chenyang-php/pre-init-PACKAGE' and/or
;;   `chenyang-php/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst  chenyang-php-packages
  '(ac-php
    company-php
    company
    php-auto-yasnippets
    (ede-php-autoload :location (recipe :fetcher github :repo "stevenremot/ede-php-autoload"))
    (php-extras :location (recipe :fetcher github :repo "arnested/php-extras"))
    php-mode
    phpcbf
    php-eldoc
    ))

;; (when (configuration-layer/layer-usedp 'auto-completion)

(defun chenyang-php/post-init-php-extras ()
  (push 'php-extras-company company-backends-php-mode))

(defun chenyang-php/post-init-ac-php ()
  (add-hook 'php-mode-hook '(lambda () (add-to-list 'ac-sources 'ac-source-php ))))

(defun chenyang-php/post-init-php-eldoc ()
  (add-hook 'php+-mode-hook
  	  '(lambda ()
  	     (set (make-local-variable 'eldoc-documentation-function) 'php-eldoc-function)
  	     (eldoc-mode))))

(defun chenyang-php/post-init-php-mode ()
  (defun cmack/php-quick-arrow ()
    "Inserts -> at point"
    (interactive)
    (insert "->"))

  (defun cmack/php-mode-hook ()
    (require 'ac-php)
    (require 'company-php)
    (require 'php-ext)
    (push 'company-ac-php-backend company-backends-php-mode)
    (push 'php-extras-company company-backends-php-mode)
    (turn-on-auto-fill)
    (yas-global-mode 1)
    ;; (electric-indent-mode)
    ;; (electric-pair-mode)
    ;; (electric-layout-mode)
    ;; (setq php-mode-force-pear t)
    ;; (setq tab-width 4
    ;;       fill-column 119
    ;;       indent-tabs-mode nil)
    (setq c-basic-offset 4)
    ;; Experiment with highlighting keys in assoc. arrays
    (font-lock-add-keywords
     'php-mode
     '(("\\s\"\^\s\([;]+\\)\\s\"\\s-+=>\\s-+" 1 'font-lock-variable-name-face t))))

  ;; (yas-reload-all)
  ;; (add-hook 'php-mode-hook #'yas-minor-mode)
  (setq php-executable "~/Develop/php/bin/php")
  (add-hook 'php-mode-hook #'cmack/php-mode-hook)
  (add-hook 'php-mode-hook 'auto-complete-mode)
  (add-hook 'php-mode-hook 'php-enable-psr2-coding-style)
  (add-hook 'php-mode-hook (lambda () (subword-mode 1)))
  ;; (add-hook 'php-mode-hook 'company-complete)
  )

;; (defun chenyang-php/init-phpcbf ()
;;   (use-package phpcbf
;;     :defer t))




(defun chenyang-php/init-ac-php ()
  (use-package ac-php
    :defer t
    :init
    ))

(defun chenyang-php/init-company-php ()
  (use-package company-php
    :defer t
    :init
    ))

(defun chenyang-php/init-php-eldoc ()
  (use-package php-eldoc
    :defer t
    :init))

(defun chenyang-php/init-ede-php-autoload-mode ()
  (use-package ede-php-autoload-mode
    :init (progn
            (spacemacs/add-to-hook  'php-mode-hook 'ede-php-autoload-mode)
            (add-hook 'php-mode-hook #'ede-php-autoload-mode))))
