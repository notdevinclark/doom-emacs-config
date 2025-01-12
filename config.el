;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; NOTE: `config.el' is now generated from `config.org'. Please edit that file
;;;       in Emacs and `config.el' will be generated automatically!

(load! "secret.el")

(defun me/random-choice (items)
  "Returns a random item from a given list"
  (let* ((size (length items))
         (index (random size)))
    (nth index items)))

(defun me/read-lines (file)
  "Reads a file, filters out lines starting with #, and returns the lines as a list"
  (let* ((file-contents (with-temp-buffer
                          (insert-file-contents file)
                          (buffer-substring-no-properties
                           (point-min)
                           (point-max))))
         (lines (split-string file-contents "\n" t)))
    (seq-remove (lambda (line) (string-match-p "^#" line)) lines)))

(defun me/random-line-from-file (file)
  "Reads a file and returns a random line"
  (me/random-choice (me/read-lines file)))

(setq user-full-name me/full-name
      user-mail-address me/mail-address)

(let* ((banner-directory (substitute-in-file-name "$HOME/.config/doom/resources/banners"))
       (command (concat "\\ls -A1d " banner-directory "/*.png"))
       (output (shell-command-to-string command))
       (banners (split-string output "\n" t))
       (banner (me/random-choice banners)))
  (setq fancy-splash-image banner))

(setq +doom-quit-messages
      (me/read-lines
       (substitute-in-file-name
        "$HOME/.config/doom/resources/messages.txt")))

(setq-default delete-by-moving-to-trash t
              window-combination-resize t
              x-stretch-cursor t)

(setq undo-limit (* 80 1024 1024)
      evil-want-fine-undo t
      auto-save-default t
      truncate-string-ellipsis "…")

(setq evil-move-cursor-back nil)

(global-auto-revert-mode t)

(add-to-list 'initial-frame-alist '(width . (text-pixels . 1180)))
(add-to-list 'initial-frame-alist '(height . (text-pixels . 780)))
(add-to-list 'initial-frame-alist '(top . 50))
(add-to-list 'initial-frame-alist '(left . 45))

(after! doom-ui
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (tooltip-mode -1)
  (menu-bar-mode -1))

(setq display-line-numbers-type 'relative)

(setq-default frame-title-format '(""))

(setq me/fixed-width-font '(:family "FiraCode Nerd Font" :style "Retina")
      me/variable-pitch-font '(:family "Overpass" :style "Regular")
      me/variable-pitch-serif-font '(:family "Bookerly" :style "Regular"))

(setq me/org-font-family (plist-get me/variable-pitch-font :family)
      me/ebook-font-family (plist-get me/variable-pitch-serif-font :family))

(setq doom-emoji-fallback-font-families nil)
(setq doom-symbol-fallback-font-families nil)

(setq doom-font
      (font-spec :family (plist-get me/fixed-width-font :family)
                 :style  (plist-get me/fixed-width-font :style)
                 :size   14)
      doom-big-font
      (font-spec :family (plist-get me/fixed-width-font :family)
                 :style  (plist-get me/fixed-width-font :style)
                 :size   20)
      doom-variable-pitch-font
      (font-spec :family (plist-get me/variable-pitch-font :family)
                 :style  (plist-get me/variable-pitch-font :style)
                 :size   16))

(setq doom-theme 'doom-palenight)

(defun me/setup-indent (n)
  ;; java/c/c++
  (setq-local c-basic-offset n)

  ;; shell
  (setq-local sh-set-indent n)

  ;; web development
  (setq-local coffee-tab-width n) ; coffeescript
  (setq-local javascript-indent-level n) ; javascript-mode
  (setq-local js-indent-level n) ; js-mode
  (setq-local js2-basic-offset n) ; js2-mode, in latest js2-mode, it's alias of js-indent-level
  (setq-local web-mode-markup-indent-offset n) ; web-mode, html tag in html file
  (setq-local web-mode-css-indent-offset n) ; web-mode, css in html file
  (setq-local web-mode-code-indent-offset n) ; web-mode, js code in html file
  (setq-local css-indent-offset n) ; css-mode
  )

(defun me/office-code-style ()
  (interactive)
  (message "Office code style!")
  ;; use tab instead of space
  (setq-local indent-tabs-mode t)
  ;; indent 4 spaces width
  (me/setup-indent 4))

(defun me/personal-code-style ()
  (interactive)
  (message "My personal code style!")
  ;; use space instead of tab
  (setq indent-tabs-mode nil)
  ;; indent 2 spaces width
  (me/setup-indent 2))

(defun me/setup-develop-environment ()
  (interactive)
  (me/personal-code-style))

;; How to do this dynamically based on project name:
;; (defun me/setup-develop-environment ()
;;   (interactive)
;;   (let ((proj-dir (file-name-directory (buffer-file-name))))
;;     ;; if hobby project path contains string "hobby-proj1"
;;     (if (string-match-p "hobby-proj1" proj-dir)
;;         (me/personal-code-style))
;;     ;; if commericial project path contains string "commerical-proj"
;;     (if (string-match-p "commerical-proj" proj-dir)
;;         (me/office-code-style))))

;; prog-mode-hook requires emacs24+
(add-hook 'prog-mode-hook 'me/setup-develop-environment)
;; a few major-modes does NOT inherited from prog-mode
(add-hook 'web-mode-hook 'me/setup-develop-environment)

(defun me/org-font-setup ()
  (dolist (face '((:name org-level-1 :weight bold   :height 1.3)
                  (:name org-level-2 :weight bold   :height 1.2)
                  (:name org-level-3 :weight bold   :height 1.1)
                  (:name org-level-4 :weight normal :height 1.1)
                  (:name org-level-5 :weight normal :height 1.1)
                  (:name org-level-6 :weight normal :height 1.1)
                  (:name org-level-7 :weight normal :height 1.1)
                  (:name org-level-8 :weight normal :height 1.1)))

    (set-face-attribute (plist-get face :name) nil
                        :family me/org-font-family
                        :weight (plist-get face :weight)
                        :height (plist-get face :height))))

(require 'org-tempo)
(require 'org-habit)

(after! org
  (setq
   org-ellipsis " ▾"
   org-directory "~/projects/org/"
   org-agenda-files '("~/projects/org/agenda.org"
                      "~/projects/org/todo.org"
                      "~/Documents/FlatHabits/MyHabits.org")
   org-log-done 'time)

  (add-to-list 'org-structure-template-alist '("el"  . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("sh"  . "src sh"))
  (add-to-list 'org-structure-template-alist '("iex" . "src elixir"))
  (variable-pitch-mode 1)
  (me/org-font-setup))

(add-hook 'org-mode-hook (lambda ()
                           (visual-fill-column-mode 1)
                           (setq-local visual-fill-column-center-text t
                                       visual-fill-column-width 100)

                           (org-indent-mode 1)
                           (visual-line-mode 1)
                           (display-line-numbers-mode 0)))

(defun me/org-babel-tangle-config ()
  (when (member (buffer-file-name)
                (list (expand-file-name "~/.config/doom/config.org")
                      (expand-file-name "~/.config/doom/install.org")))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'me/org-babel-tangle-config)))

(after! doom-modeline
  (setq
   doom-modeline-major-mode-icon t
   doom-modeline-height 35
   doom-modeline-persp-name t))

(setq display-time-day-and-date nil
      display-time-default-load-average nil)

(display-time-mode 1)

(if (equal "Battery status not available"
           (battery))
    (display-battery-mode 0)
    (display-battery-mode 1))

(defun me/doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (and (memq (plist-get (coding-system-plist buffer-file-coding-system) :category)
                                 '(coding-category-undecided coding-category-utf-8))
                           (not (memq (coding-system-eol-type buffer-file-coding-system) '(1 2))))
                t)))

(add-hook 'after-change-major-mode-hook #'me/doom-modeline-conditional-buffer-encoding)

(after! evil-escape (evil-escape-mode -1))

(setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))

;; (use-package! org-roam
;;   :defer t
;;   :init
;;   (setq org-roam-directory "~/Documents/OrgRoam")
;;   (setq +org-roam-open-buffer-on-find-file nil))

(setq-default flycheck-disabled-checkers '(proselint))

(setq
 treemacs-width 30
 treemacs-follow-mode t
 treemacs-position 'left
 doom-themes-treemacs-theme "doom-colors")

(after! centaur-tabs
  (centaur-tabs-group-by-projectile-project)
  (setq
   centaur-tabs-style "bar"
   centaur-tabs-set-bar 'none
   centaur-tabs-bar-height 30
   centaur-tabs-height 28)

  (centaur-tabs-change-fonts (plist-get me/variable-pitch-font :family) 150)

  ;; (defun centaur-tabs-buffer-groups ()
  ;;   "`centaur-tabs-buffer-groups' control buffers' group rules.

  ;;   Group centaur-tabs with mode if buffer is derived from `eshell-mode'
  ;;   `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
  ;;   All buffer name start with * will group to \"Emacs\".
  ;;   Other buffer group by `centaur-tabs-get-group-name' with project name."
  ;;   (list
  ;;    (cond
  ;;     ((or (string-equal "*" (substring (buffer-name) 0 1))
  ;;          (memq major-mode '(magit-process-mode
  ;;                             magit-status-mode
  ;;                             magit-diff-mode
  ;;                             magit-log-mode
  ;;                             magit-file-mode
  ;;                             magit-blob-mode
  ;;                             magit-blame-mode
  ;;                             )))
  ;;      "Emacs")
  ;;     ((derived-mode-p 'eshell-mode) "EShell")
  ;;     ((derived-mode-p 'dired-mode) "Dired")
  ;;     ;; ((derived-mode-p 'emacs-lisp-mode) "Elisp")
  ;;     ;; ((memq major-mode '(org-mode org-agenda-mode diary-mode)) "OrgMode")
  ;;     (t
  ;;      (centaur-tabs-get-group-name (current-buffer))))))
  )

(after! projectile
  (add-hook 'projectile-after-switch-project-hook (lambda ()
        (if (s-suffix? "printserver/" (projectile-project-root))
            (setq-local lsp-elixir-project-dir "printserver/packages/ex_printserver/"))))
  (setq projectile-ignored-projects '("~/" "/tmp/" "~/.emacs.d/" "/opt/homebrew/"))
  (setq projectile-project-search-path '("~/projects/" "~/campaigns/")))

(remove-hook 'doom-first-input-hook #'evil-snipe-mode)

(use-package! pdf-tools
  :defer t
  :config
  (pdf-loader-install)
  (setq pdf-view-use-scaling t
        pdf-view-use-imagemagick nil))

(use-package! nov
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (map! :map nov-mode-map
        :n "R" #'nov-render-document
        :n "RET" #'nov-scroll-up)

  (defun doom-modeline-segment--nov-info ()
    (concat
     " "
     (propertize
      (cdr (assoc 'creator nov-metadata))
      'face 'doom-modeline-project-parent-dir)
     " "
     (cdr (assoc 'title nov-metadata))
     " "
     (propertize
      (format "%d/%d"
              (1+ nov-documents-index)
              (length nov-documents))
      'face 'doom-modeline-info)))

  (advice-add 'nov-render-title :override #'ignore)

  (defun +nov-mode-setup ()
    (face-remap-add-relative 'variable-pitch
                             :family me/ebook-font-family
                             :height 1.1
                             :width 'semi-expanded)
    (face-remap-add-relative 'default :height 1.1)
    (setq-local line-spacing 0.2
                next-screen-context-lines 4
                shr-use-colors nil)
    ;; (require 'visual-fill-column nil t)
    (setq-local visual-fill-column-center-text t
                visual-fill-column-width 100
                nov-text-width 90)
    (visual-fill-column-mode 1)
    (hl-line-mode -1)

    (add-to-list '+lookup-definition-functions #'+lookup/dictionary-definition)

    (setq-local mode-line-format
                `((:eval
                   (doom-modeline-segment--workspace-name))
                  (:eval
                   (doom-modeline-segment--window-number))
                  (:eval
                   (doom-modeline-segment--nov-info))
                  ,(propertize
                    " %P "
                    'face 'doom-modeline-buffer-minor-mode)
                  (:eval
                   (doom-modeline-segment--misc-info))
                  (:eval
                   (doom-modeline-segment--battery))
                  ,(propertize
                    " "
                    'face (if (doom-modeline--active) 'mode-line 'mode-line-inactive)
                    'display `((space
                                :align-to
                                (- (+ right right-fringe right-margin)
                                   ,(* (let ((width (doom-modeline--font-width)))
                                         (or (and (= width 1) 1)
                                             (/ width (frame-char-width) 1.0)))
                                       (string-width
                                        (format-mode-line (cons "" '(:eval (doom-modeline-segment--major-mode))))))))))
                  (:eval
                   (doom-modeline-segment--major-mode))
                  ))

    (nov-render-document))

  (add-hook 'nov-mode-hook #'+nov-mode-setup))

(setq lsp-enable-file-watchers nil)

(setq company-idle-delay 0.5)

;; Enable format and iex reload on save
(after! lsp
  (add-hook 'elixir-mode-hook
            (lambda ()
              (add-hook 'before-save-hook 'elixir-format nil t)
              (add-hook 'after-save-hook 'alchemist-iex-reload-module))))

;; (add-hook 'elixir-format-hook (lambda ()
;;                                 (if (projectile-project-p)
;;                                     (setq elixir-format-arguments
;;                                           (list "--dot-formatter"
;;                                                 (concat (locate-dominating-file buffer-file-name ".formatter.exs") ".formatter.exs")))
;;                                   (setq elixir-format-arguments nil))))

(use-package! polymode
  :mode ("\.ex$" . poly-elixir-web-mode)
  :config
  (define-hostmode poly-elixir-hostmode :mode 'elixir-mode)
  (define-innermode poly-liveview-expr-elixir-innermode
    :mode 'web-mode
    :head-matcher (rx line-start (* space) "~L" (= 3 (char "\"'")) line-end)
    :tail-matcher (rx line-start (* space) (= 3 (char "\"'")) line-end)
    :head-mode 'host
    :tail-mode 'host
    :allow-nested nil
    :keep-in-mode 'host
    :fallback-mode 'host)
  (define-polymode poly-elixir-web-mode
    :hostmode 'poly-elixir-hostmode
    :innermodes '(poly-liveview-expr-elixir-innermode)))

(after! web-mode
  (dolist (tuple '(("elixir" . "\\.ex\\'")
                   ("elixir" . "\\.eex\\'")
                   ("elixir" . "\\.leex\\'")))
    (add-to-list 'web-mode-engines-alist tuple)))

;; This is a temporary fix. Doom currently adds support for web-mode in eex
;; files, but does not yet support leex files. This line can be removed when
;; they do.
(add-to-list 'auto-mode-alist '("\\.leex\\'" . web-mode))

(setq tramp-default-method "ssh")
(setq tramp-terminal-type "tramp")

(map! :desc "Open Dired here" :n "-" #'dired-jump)

(map! :desc "Next Tab" :g "s-}" #'centaur-tabs-forward)
(map! :desc "Previous Tab" :g "s-{" #'centaur-tabs-backward)

(map! :desc "Decrease current window width" :g "s-[" #'evil-window-decrease-width)
(map! :desc "Increase current window width" :g "s-]" #'evil-window-increase-width)
