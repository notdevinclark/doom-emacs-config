;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; NOTE: `config.el' is now generated from `config.org'. Please edit that file
;;;       in Emacs and `config.el' will be generated automatically!

(load! "secret.el")

(setq user-full-name me/full-name
      user-mail-address me/mail-address)

(setq-default delete-by-moving-to-trash t
              window-combination-resize t
              x-stretch-cursor t)

(setq undo-limit (* 80 1024 1024)
      evil-want-fine-undo t
      auto-save-default t
      truncate-string-ellipsis "…")

(setq evil-move-cursor-back nil)

(global-auto-revert-mode t)

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(after! doom-ui
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (tooltip-mode -1)
  (menu-bar-mode -1))

(setq display-line-numbers-type 'absolute)

(setq-default frame-title-format '(""))

;; (setq me/fixed-width-font '(:family "FiraCode Nerd Font" :style "Retina")
(setq me/fixed-width-font '(:family "ComicCodeLigatures Nerd Font" :style "Retina")
      me/variable-pitch-font '(:family "Overpass" :style "Regular"))
;; me/variable-pitch-serif-font '(:family "Bookerly" :style "Regular"))

(setq me/org-font-family (plist-get me/variable-pitch-font :family))
;; me/ebook-font-family (plist-get me/variable-pitch-serif-font :family))

(setq doom-emoji-fallback-font-families nil)
(setq doom-symbol-fallback-font-families nil)

(setq doom-font
      (font-spec :family (plist-get me/fixed-width-font :family)
                 :style  (plist-get me/fixed-width-font :style)
                 :size   15)
      doom-big-font
      (font-spec :family (plist-get me/fixed-width-font :family)
                 :style  (plist-get me/fixed-width-font :style)
                 :size   20)
      doom-variable-pitch-font
      (font-spec :family (plist-get me/variable-pitch-font :family)
                 :style  (plist-get me/variable-pitch-font :style)
                 :size   16))

(setq doom-theme 'doom-nord)

;; (defun me/setup-indent (n)
;;   ;; java/c/c++
;;   (setq-local c-basic-offset n)

;;   ;; shell
;;   (setq-local sh-set-indent n)

;;   ;; web development
;;   (setq-local coffee-tab-width n) ; coffeescript
;;   (setq-local javascript-indent-level n) ; javascript-mode
;;   (setq-local js-indent-level n) ; js-mode
;;   (setq-local js2-basic-offset n) ; js2-mode, in latest js2-mode, it's alias of js-indent-level
;;   (setq-local web-mode-markup-indent-offset n) ; web-mode, html tag in html file
;;   (setq-local web-mode-css-indent-offset n) ; web-mode, css in html file
;;   (setq-local web-mode-code-indent-offset n) ; web-mode, js code in html file
;;   (setq-local css-indent-offset n) ; css-mode
;;   )

;; (defun me/office-code-style ()
;;   (interactive)
;;   (message "Office code style!")
;;   ;; use tab instead of space
;;   (setq-local indent-tabs-mode t)
;;   ;; indent 4 spaces width
;;   (me/setup-indent 4))

;; (defun me/personal-code-style ()
;;   (interactive)
;;   (message "My personal code style!")
;;   ;; use space instead of tab
;;   (setq indent-tabs-mode nil)
;;   ;; indent 2 spaces width
;;   (me/setup-indent 2))

;; (defun me/setup-develop-environment ()
;;   (interactive)
;;   (me/personal-code-style))

;; ;; How to do this dynamically based on project name:
;; ;; (defun me/setup-develop-environment ()
;; ;;   (interactive)
;; ;;   (let ((proj-dir (file-name-directory (buffer-file-name))))
;; ;;     ;; if hobby project path contains string "hobby-proj1"
;; ;;     (if (string-match-p "hobby-proj1" proj-dir)
;; ;;         (me/personal-code-style))
;; ;;     ;; if commericial project path contains string "commerical-proj"
;; ;;     (if (string-match-p "commerical-proj" proj-dir)
;; ;;         (me/office-code-style))))

;; ;; prog-mode-hook requires emacs24+
;; (add-hook 'prog-mode-hook 'me/setup-develop-environment)
;; ;; a few major-modes does NOT inherited from prog-mode
;; (add-hook 'web-mode-hook 'me/setup-develop-environment)

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
   org-directory "~/Documents/Code/org/"
   org-agenda-files '("~/Documents/Code/org/agenda.org"
                      "~/Documents/Code/org/todo.org")
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
   doom-modeline-height 30
   doom-modeline-persp-name t))

(setq display-time-day-and-date nil
      display-time-default-load-average nil
      display-time-24hr-format 1)

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

(setq-default flycheck-disabled-checkers '(proselint))

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs 0
          treemacs-wide-toggle-width 50
          treemacs-width 25
          doom-themes-treemacs-theme "doom-colors")
    (treemacs-resize-icons 44)
    (treemacs-git-mode -1)
  ))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(after! centaur-tabs
  (centaur-tabs-group-by-projectile-project)
  (setq
   centaur-tabs-style "bar"
   centaur-tabs-set-bar 'none
   centaur-tabs-bar-height 30
   centaur-tabs-height 28)

  (centaur-tabs-change-fonts (plist-get me/variable-pitch-font :family) 150))

(after! projectile
  (add-hook 'projectile-after-switch-project-hook (lambda ()
        (if (s-suffix? "printserver/" (projectile-project-root))
            (setq-local lsp-elixir-project-dir "printserver/packages/ex_printserver/"))))
  (setq projectile-ignored-projects '("~/" "/tmp/" "~/.emacs.d/" "/opt/homebrew/"))
  (setq projectile-project-search-path '("~/Documents/Code/")))

(remove-hook 'doom-first-input-hook #'evil-snipe-mode)

(setq lsp-enable-file-watchers nil)

(setq company-idle-delay 0.5)

;; Enable format and iex reload on save
;; (after! lsp
;;   (add-hook 'elixir-mode-hook
;;             (lambda ()
;;               (add-hook 'before-save-hook 'elixir-format nil t)
;;               (add-hook 'after-save-hook 'alchemist-iex-reload-module))))

;; (add-hook 'elixir-format-hook (lambda ()
;;                                 (if (projectile-project-p)
;;                                     (setq elixir-format-arguments
;;                                           (list "--dot-formatter"
;;                                                 (concat (locate-dominating-file buffer-file-name ".formatter.exs") ".formatter.exs")))
;;                                   (setq elixir-format-arguments nil))))

;; (use-package! polymode
;;   :mode ("\.ex$" . poly-elixir-web-mode)
;;   :config
;;   (define-hostmode poly-elixir-hostmode :mode 'elixir-mode)
;;   (define-innermode poly-liveview-expr-elixir-innermode
;;     :mode 'web-mode
;;     :head-matcher (rx line-start (* space) "~L" (= 3 (char "\"'")) line-end)
;;     :tail-matcher (rx line-start (* space) (= 3 (char "\"'")) line-end)
;;     :head-mode 'host
;;     :tail-mode 'host
;;     :allow-nested nil
;;     :keep-in-mode 'host
;;     :fallback-mode 'host)
;;   (define-polymode poly-elixir-web-mode
;;     :hostmode 'poly-elixir-hostmode
;;     :innermodes '(poly-liveview-expr-elixir-innermode)))

;; (after! web-mode
;;   (dolist (tuple '(("elixir" . "\\.ex\\'")
;;                    ("elixir" . "\\.eex\\'")
;;                    ("elixir" . "\\.leex\\'")))
;;     (add-to-list 'web-mode-engines-alist tuple)))

;; This is a temporary fix. Doom currently adds support for web-mode in eex
;; files, but does not yet support leex files. This line can be removed when
;; they do.
;; (add-to-list 'auto-mode-alist '("\\.leex\\'" . web-mode))

(setq tramp-default-method "ssh")
(setq tramp-terminal-type "tramp")

(map! :desc "Open Dired here" :n "-" #'dired-jump)

(map! :desc "Next Tab" :g "s-}" #'centaur-tabs-forward)
(map! :desc "Previous Tab" :g "s-{" #'centaur-tabs-backward)

(map! :desc "Decrease current window width" :g "s-[" #'evil-window-decrease-width)
(map! :desc "Increase current window width" :g "s-]" #'evil-window-increase-width)
