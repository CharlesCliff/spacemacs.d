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
(spacemacs|defvar-company-backends php-mode)

(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
(configuration-layer//auto-mode 'chenyang-php 'php-mode)

