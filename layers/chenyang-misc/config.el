;;; packages.el --- chenyang-misc layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author:  ChenYang <chenyang@ChenYangdeMacBook-Pro.local>
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
;; added to `chenyang-misc-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `chenyang-misc/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `chenyang-misc/pre-init-PACKAGE' and/or
;;   `chenyang-misc/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(define-abbrev-table 'global-abbrev-table '(

                                            ;; math/unicode symbols
                                            ("8in" "∈")
                                            ("8nin" "∉")
                                            ("8inf" "∞")
                                            ("8luv" "♥")
                                            ("8smly" "☺")
                                            ("8en" "@~english")
                                            ("8zh" "@~chinese")
                                            ("8sp" "spacemacs")
                                            ;; email
                                            ("8me" "guanghui8827@gmail.com")

                                            ;; computing tech
                                            ("8wp" "Wikipedia")
                                            ("8ms" "Microsoft")
                                            ("8g" "Google")
                                            ("8it" "IntelliType")
                                            ("8msw" "Microsoft Windows")
                                            ("8win" "Windows")
                                            ("8ie" "Internet Explorer")
                                            ("8ahk" "AutoHotkey")
                                            ("82dx" "Cocos2D-X")

                                            ;; signature
                                            ("8zl" "zilongshanren")
                                            ;; emacs regex
                                            ("8d" "\\([0-9]+?\\)")
                                            ("8str" "\\([^\"]+?\\)\"")))


(setq user-mail-address "charlescliff@foxmail.com")
