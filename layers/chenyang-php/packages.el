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
    feature-mode
    ;; drupal-mode
    ;; eldoc
    flycheck
    ggtags
    helm-gtags
    php-auto-yasnippets
    (ede-php-autoload :location (recipe :fetcher github :repo "stevenremot/ede-php-autoload"))
    ;; (semantic-php :location (recipe :fetcher github :repo "jorissteyn/semantic-php"))
    ;; (php-extras :location (recipe :fetcher github :repo "arnested/php-extras"))
    php-mode
    phpcbf))

(when (configuration-layer/layer-usedp 'auto-completion)
  (defun chenyang-php/post-init-company ()
    (spacemacs|add-company-hook php-mode))

  (defun chenyang-php/post-init-php-extras ()
    (push 'php-extras-company company-backends-php-mode))

  (defun chenyang-php/post-init-ac-php ()
    (add-hook 'php-mode-hook '(lambda () (setq ac-sources '(ac-source-php ))))
    ;; (push 'company-ac-php-backend company-backends-php-mode)
    ))

(defun chenyang-php/init-feature-mode ()
  "Initialize feature mode for Behat"
  (use-package feature-mode
    :mode (("\\.feature\\'" . feature-mode))))

;; (defun chenyang-php/init-drupal-mode ()
;;   (use-package drupal-mode
;;     :defer t))

(defun chenyang-php/init-ac-php ()
  (use-package ac-php
    :defer t
    :init
    (progn
      (use-package company-php
        :defer t)
      )
    ))

(defun chenyang-php/init-company-php ()
  (use-package company-php
    :defer t
    :init
    ))

;; (defun chenyang-php/init-semantic-php ()
;;   (use-package semantic-php
;;     ;; :init (load "~/src/jorissteyn-semantic-php/loaddefs.el")
;;     :config (add-hook 'php-mode-hook #'semantic-mode)))

(defun chenyang-php/init-ede-php-autoload-mode ()
  (use-package ede-php-autoload-mode
    :init (progn
            (spacemacs/add-to-hook  'php-mode-hook 'ede-php-autoload-mode)
            (add-hook 'php-mode-hook #'ede-php-autoload-mode))))

(defun chenyang-php/post-init-eldoc ()
  (add-hook 'php-mode-hook 'eldoc-mode)
  (when (configuration-layer/package-usedp 'ggtags)
    (spacemacs/ggtags-enable-eldoc 'php-mode)))

(defun chenyang-php/post-init-flycheck ()
  (add-hook 'php-mode-hook 'flycheck-mode))

(defun chenyang-php/post-init-ggtags ()
  (add-hook 'php-mode-hook 'ggtags-mode))

(defun chenyang-php/post-init-helm-gtags ()
  (spacemacs/helm-gtags-define-keys-for-mode 'php-mode))

(defun chenyang-php/init-php-auto-yasnippets ()
  (use-package php-auto-yasnippets
    :defer t))

(defun chenyang-php/init-php-extras ()
  (use-package php-extras
    :ensure t
    :init
    :defer t))

(defun chenyang-php/init-php-mode ()
  (use-package php-mode
    :ensure t
    :bind ("C--" . cmack/php-quick-arrow)
    :init
    :config
    (progn
      (use-package ac-php
        :init
        :defer
        :config)
      (defun cmack/php-quick-arrow ()
        "Inserts -> at point"
        (interactive)
        (insert "->"))

      (defun cmack/php-mode-hook ()
        ;; (emmet-mode 1)
        ;; (flycheck-mode 1)
        ;; (ggtags-mode 1)
        ;; (turn-on-auto-fill)
        ;; (electric-indent-mode)
        ;; (electric-pair-mode)
        ;; (electric-layout-mode)

        ;; Experiment with highlighting keys in assoc. arrays
        (font-lock-add-keywords
         'php-mode
         '(("\\s\"\^\s\([;]+\\)\\s\"\\s-+=>\\s-+" 1 'font-lock-variable-name-face t))))

      (setq php-executable "~/Develop/php/bin/php")
      (setq php-mode-coding-style 'psr2)
      (setq tab-width 4
            fill-column 119
            indent-tabs-mode nil)

      (add-hook 'php-mode-hook #'cmack/php-mode-hook)
      (add-hook 'php-mode-hook 'auto-complete-mode)
      (add-hook 'php-mode-hook 'company-complete))
    :defer t
    :mode ("\\.php\\'" . php-mode)
    )) 
(defun chenyang-php/init-phpcbf ()
  (use-package phpcbf
    :defer t))

(defun chenyang-php/init-phpunit ()
  (use-package phpunit
    :defer t))

