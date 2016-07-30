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
    blog-admin
    org-page
    emacs-ctable
    )
  )


(defun zilongshanren-org/post-init-org-pomodoro ()
  (progn
    (add-hook 'org-pomodoro-finished-hook '(lambda () (zilongshanren/growl-notification "Pomodoro Finished" "☕️ Have a break!" t)))
    (add-hook 'org-pomodoro-short-break-finished-hook '(lambda () (zilongshanren/growl-notification "Short Break" "🐝 Ready to Go?" t)))
    (add-hook 'org-pomodoro-long-break-finished-hook '(lambda () (zilongshanren/growl-notification "Long Break" " 💪 Ready to Go?" t)))
    ))

(defun chenyang-org/post-init-org ()
  (add-hook 'org-mode-hook (lambda () (spacemacs/toggle-line-numbers-off)) 'append)
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
      (setq org-agenda-window-setup 'current-window)
      (setq org-log-done t)
      (setq org-todo-keywords
            (quote ((sequence "TODO(t)" "STARTED(s)" "|" "DONE(d!/!)")
                    (sequence "WAITING(w@/!)" "SOMEDAY(S)" "|" "CANCELLED(c@/!)" "MEETING(m)" "PHONE(p)"))))

      ;; Change task state to STARTED when clocking in
      (setq org-clock-in-switch-to-state "STARTED")
      ;; Save clock data and notes in the LOGBOOK drawer
      (setq org-clock-into-drawer t)
      ;; Removes clocked tasks with 0:00 duration
      (setq org-clock-out-remove-zero-time-clocks t) ;; Show the clocked-in task - if any - in the header line

      (setq org-tags-match-list-sublevels nil)

      ;; http://wenshanren.org/?p=327
      ;; change it to ivy
      (defun zilongshanren/org-insert-src-block (src-code-type)
        "Insert a `SRC-CODE-TYPE' type source code block in org-mode."
        (interactive
         (let ((src-code-types
                '("emacs-lisp" "python" "C" "sh" "java" "js" "clojure" "C++" "css"
                  "calc" "asymptote" "dot" "gnuplot" "ledger" "lilypond" "mscgen"
                  "octave" "oz" "plantuml" "R" "sass" "screen" "sql" "awk" "ditaa"
                  "haskell" "latex" "lisp" "matlab" "ocaml" "org" "perl" "ruby"
                  "scheme" "sqlite")))
           (list (ido-completing-read "Source code type: " src-code-types))))
        (progn
          (newline-and-indent)
          (insert (format "#+BEGIN_SRC %s\n" src-code-type))
          (newline-and-indent)
          (insert "#+END_SRC\n")
          (previous-line 2)
          (org-edit-src-code)))

      (add-hook 'org-mode-hook '(lambda ()
                                  ;; keybinding for editing source code blocks
                                  ;; keybinding for inserting code blocks
                                  (local-set-key (kbd "C-c i s")
                                                 'zilongshanren/org-insert-src-block)))
      ;;reset subtask
      (setq org-default-properties (cons "RESET_SUBTASKS" org-default-properties))

      (defun org-reset-subtask-state-subtree ()
        "Reset all subtasks in an entry subtree."
        (interactive "*")
        (if (org-before-first-heading-p)
            (error "Not inside a tree")
          (save-excursion
            (save-restriction
              (org-narrow-to-subtree)
              (org-show-subtree)
              (goto-char (point-min))
              (beginning-of-line 2)
              (narrow-to-region (point) (point-max))
              (org-map-entries
               '(when (member (org-get-todo-state) org-done-keywords)
                  (org-todo (car org-todo-keywords))))))))

      (defun org-reset-subtask-state-maybe ()
        "Reset all subtasks in an entry if the `RESET_SUBTASKS' property is set"
        (interactive "*")
        (if (org-entry-get (point) "RESET_SUBTASKS")
            (org-reset-subtask-state-subtree)))

      (defun org-subtask-reset ()
        (when (member org-state org-done-keywords) ;; org-state dynamically bound in org.el/org-todo
          (org-reset-subtask-state-maybe)
          (org-update-statistics-cookies t)))

      ;; (add-hook 'org-after-todo-state-change-hook 'org-subtask-reset)

      (setq org-plantuml-jar-path
            (expand-file-name "~/.spacemacs.d/plantuml.jar"))
      (setq org-ditaa-jar-path "~/.spacemacs.d/ditaa.jar")

      (org-babel-do-load-languages
       'org-babel-load-languages
       '((perl . t)
         (ruby . t)
         (sh . t)
         (js . t)
         (latex .t)
         (python . t)
         (emacs-lisp . t)
         (plantuml . t)
         (C . t)
         (ditaa . t)))


      ;; define the refile targets
      (setq org-agenda-files (quote ("~/org-notes" )))
      (setq org-default-notes-file "~/org-notes/gtd.org")

      (with-eval-after-load 'org-agenda
        (define-key org-agenda-mode-map (kbd "P") 'org-pomodoro)
        (spacemacs/set-leader-keys-for-major-mode 'org-agenda-mode
          "." 'spacemacs/org-agenda-transient-state/body)
        )


      ;; the %i would copy the selected text into the template
      ;;http://www.howardism.org/Technical/Emacs/journaling-org.html
      ;;add multi-file journal
      (setq org-capture-templates
            '(("t" "Todo" entry (file+headline "~/org-notes/gtd.org" "Workspace")
               "* TODO [#B] %?\n  %i\n"
               :empty-lines 1)
              ("n" "notes" entry (file+headline "~/org-notes/!notes.org" "Quick notes")
               "* %?\n  %i\n %U"
               :empty-lines 1)
              ("b" "Blog Ideas" entry (file+headline "~/org-notes/!notes.org" "Blog Ideas")
               "* TODO [#B] %?\n  %i\n %U"
               :empty-lines 1)
              ("s" "Code Snippet" entry
               (file "~/org-notes/snippets.org")
               "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
              ("w" "work" entry (file+headline "~/org-notes/gtd.org" "Cocos2D-X")
               "* TODO [#A] %?\n  %i\n %U"
               :empty-lines 1)
              ("c" "Chrome" entry (file+headline "~/org-notes/!notes.org" "Quick notes")
               "* TODO [#C] %?\n %(zilongshanren/retrieve-chrome-current-tab-url)\n %i\n %U"
               :empty-lines 1)
              ("l" "links" entry (file+headline "~/org-notes/!notes.org" "Quick notes")
               "* TODO [#C] %?\n  %i\n %a \n %U"
               :empty-lines 1)
              ("j" "Journal Entry"
               entry (file+datetree "~/org-notes/!journal.org")
               "* %?"
               :empty-lines 1)))

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

(defun chenyang-org/init-blog-admin ()
  (use-package blog-admin
    :init
    (add-hook 'blog-admin-backend-after-new-post-hook 'find-file)
    (setq blog-admin-backend-path "~/blog")
    (setq blog-admin-backend-type 'hexo)
    (setq blog-admin-backend-new-post-in-drafts t) ;; create new post in drafts by default
    (setq blog-admin-backend-new-post-with-same-name-dir t) ;; create same-name directory with new post
    (setq blog-admin-backend-hexo-config-file "_config.yml") ;; default assumes _config.yml
    :defer t))


(defun chenyang-org/init-org-octopress ()
  (use-package org-octopress
    :init
    :commands (org-octopress org-octopress-setup-publish-project)
    :config
    (progn
      (evilified-state-evilify org-octopress-summary-mode org-octopress-summary-mode-map)
      (add-hook 'org-octopress-summary-mode-hook #'(lambda () (local-set-key (kbd "q") 'bury-buffer)))
      (setq org-blog-dir "~/blog/")
      (setq org-octopress-directory-top "~/blog/source")
      (setq org-octopress-directory-posts "~/blog/source/_posts")
      (setq org-octopress-directory-org-top "~/blog/source")
      (setq org-octopress-directory-org-posts "~/blog/source/blog")
      (setq org-octopress-setup-file "~/blog/setupfile.org")
      )

    (defun chenyang/org-save-and-export ()
      (interactive)
      (org-octopress-setup-publish-project)
      (org-publish-project "octopress" t))
    
    ;; ;; rewrite in org-octopress.el
    ;; (defun org-octopress--summary-table (contents keymap) ;; 去掉 publish 这一列，因为 hexo 不需要
    ;;   (let ((param (copy-ctbl:param ctbl:default-rendering-param)))
    ;;     (ctbl:create-table-component-region
    ;;      :param param
    ;;      :width  nil
    ;;      :height nil
    ;;      :keymap keymap
    ;;      :model
    ;;      (make-ctbl:model
    ;;       :data contents
    ;;       :sort-state '(-1 2)
    ;;       :column-model
    ;;       (list (make-ctbl:cmodel
    ;;              :title "Date"
    ;;              :sorter 'ctbl:sort-string-lessp
    ;;              :min-width 10
    ;;              :align 'left)
    ;;             (make-ctbl:cmodel
    ;;              :title "Category"
    ;;              :align 'left
    ;;              :sorter 'ctbl:sort-string-lessp)
    ;;             (make-ctbl:cmodel
    ;;              :title "Title"
    ;;              :align 'left
    ;;              :min-width 40
    ;;              :max-width 140)
    ;;             )
    ;;       ))))

    ;; (defun org-octopress (&optional title)
    ;;   "Org-mode and Octopress."
    ;;   (interactive)
    ;;   (setq org-octopress-summary-buffer (get-buffer-create "Octopress"))
    ;;   (switch-to-buffer org-octopress-summary-buffer)
    ;;   (setq buffer-read-only nil)
    ;;   (erase-buffer)
    ;;   (insert (org-octopress--summary-header title))
    ;;   (save-excursion
    ;;     (setq org-octopress-component (org-octopress--summary-table
    ;;                                    (org-octopress--scan-post) org-octopress-summary-mode-map)))
    ;;   (ctbl:cp-add-click-hook
    ;;    org-octopress-component
    ;;    (lambda ()
    ;;      (find-file (nth 3 (ctbl:cp-get-selected-data-row org-octopress-component))))) ;; 这里的 4 改为 3，因为我修改了列数
    ;;   (org-octopress-summary-mode)
    ;;   (ctbl:navi-goto-cell
    ;;    (ctbl:find-first-cell (ctbl:component-dest org-octopress-component)))
    ;;   )

    ;; (defun org-octopress--scan-post ()
    ;;   (mapcar
    ;;    (lambda (filename)
    ;;      (org-jekyll-property
    ;;       '(:date
    ;;         :jekyll-categories
    ;;         :title
    ;;         :input-file)
    ;;       filename))
    ;;    (directory-files
    ;;     (expand-file-name
    ;;      org-octopress-directory-org-posts) t "^.*\\.org$"))) ;; jekyll 要求所有文章以日期开头，而 hexo 不需要

    ;; ;; rewrite in ox-jekyll.el
    ;; (defcustom org-jekyll-date ""
    ;;   "Default date used in Jekyll article."
    ;;   :group 'org-export-jekyll
    ;;   :type 'string)
    ;; (org-export-define-derived-backend'jekyll 'html
    ;;                                           :export-block '("HTML" "JEKYLL")
    ;;                                           :menu-entry
    ;;                                           '(?j "Jekyll: export to HTML with YAML front matter."
    ;;                                                ((?H "As HTML buffer" org-jekyll-export-as-html)
    ;;                                                 (?h "As HTML file" org-jekyll-export-to-html)))
    ;;                                           :translate-alist
    ;;                                           '((template . org-jekyll-template) ;; add YAML front matter.
    ;;                                             (src-block . org-jekyll-src-block)
    ;;                                             (inner-template . org-jekyll-inner-template)) ;; force body-only
    ;;                                           :options-alist
    ;;                                           '((:jekyll-layout "LAYOUT" nil org-jekyll-layout) ;; hexo-renderer-org 没有使用 JEKYLL 这个 prefix
    ;;                                             (:jekyll-categories "CATEGORIES" nil org-jekyll-categories)
    ;;                                             (:jekyll-tags "TAGS" nil org-jekyll-tags)
    ;;                                             (:date "DATE" nil org-jekyll-date)
    ;;                                             (:jekyll-published "PUBLISHED" nil org-jekyll-published)
    ;;                                             (:jekyll-comments "COMMENTS" nil org-jekyll-comments)))
    ))
