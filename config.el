;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;;
;;; WARNING: THIS FILE IS MANAGED BY `config.org'
;;; Please edit the configuration there and re-tangle

;; Shhhhhhhhhhhhh (copy secret.example.el and fill in your email)
(load! "secret.el")

(defun choose-random-banner (files)
  (make-banner-path (random-choice files)))

(defun make-banner-path (file)
  (substitute-in-file-name
   (concat "$HOME/.config/doom/banners/" file)))

(defun random-choice (items)
  (let* ((size (length items))
         (index (random size)))
    (nth index items)))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Adam Zaninovich"
      user-mail-address my-gpg-email-address)

;; Sets a random banner on startup - requires choose-random-banner from functions.el
(setq my-banner-list '("doom-blue.png"
                       "doom-2-blue.png"
                       "doom-guy.png"
                       "doom-grey.png"
                       "doom-2-grey.png"
                       "doom-doc.png"
                       "doom-orange.png"
                       "doom-2-orange.png"
                       "doom-perfection.png"
                       "doom-purple.png"
                       "doom-2-purple.png"
                       "vim.png"))

(setq +doom-dashboard-banner-file (choose-random-banner my-banner-list))

;; Don't move cursor back when exiting insert mode
(setq evil-move-cursor-back nil)

;; Start maximized
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; No bars
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Don't display line numbers in Org mode and terminals
(dolist (mode '(org-mode-hook
                vterm-mode-hook
                shell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq
 doom-font (font-spec :family "FiraCode Nerd Font" :size 14 :style "Retina")
 doom-big-font (font-spec :family "FiraCode Nerd Font" :size 20 :style "Retina")
 doom-variable-pitch-font (font-spec :family "SF Pro" :size 14 :style "Medium"))

(setq doom-theme 'doom-palenight)

(require 'org-tempo)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(after! org
  (setq
   org-directory "~/projects/org/"
   org-agenda-files '("~/projects/org/agenda.org" "~/projects/org/todo.org")
   org-log-done 'time
   org-confirm-babel-evaluate nil)

  ;; Set Org Mode heading sizes
  (custom-set-faces
   '(org-level-1 ((t (:inherit outline-1 :height 1.2))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.2))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.0))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
   '(org-level-5 ((t (:inherit outline-5 :height 1.0)))))

  ;; Activate Babel Languages
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (sh         . t)
     (elixir     . t)))

  ;; Add some code block templates
  (add-to-list 'org-structure-template-alist '("el"  . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("sh"  . "src shell"))
  (add-to-list 'org-structure-template-alist '("iex" . "src elixir"))
  )

(setq
 treemacs-width 35
 treemacs-follow-mode t
 treemacs-position 'left)

(after! centaur-tabs
  (setq
   centaur-tabs-style "bar"
   centaur-tabs-set-bar 'none
   centaur-tabs-height 28)
  (centaur-tabs-change-fonts "SF Pro" 130))

;; Do not watch files because it's annoying when it asks every time
(setq lsp-enable-file-watchers nil)

(after! projectile
  (setq projectile-project-search-path '("~/projects/")))

;; Make S and s work again
(after! evil-snipe (evil-snipe-mode -1))

;; Create a buffer-local hook to run elixir-format on save, only when we enable elixir-mode.
(add-hook 'elixir-mode-hook
          (lambda () (add-hook 'before-save-hook 'elixir-format nil t)))
(add-hook 'elixir-format-hook (lambda ()
                                (if (projectile-project-p)
                                    (setq elixir-format-arguments
                                          (list "--dot-formatter"
                                                (concat (locate-dominating-file buffer-file-name ".formatter.exs") ".formatter.exs")))
                                  (setq elixir-format-arguments nil))))

(map! :desc "Open Dired here" :n "-" #'dired-jump)

(map! :desc "Next Tab" :g "s-}" #'centaur-tabs-forward)
(map! :desc "Previous Tab" :g "s-{" #'centaur-tabs-backward)

(map! :desc "Decrease current window width" :g "s-[" #'evil-window-decrease-width)
(map! :desc "Increase current window width" :g "s-]" #'evil-window-increase-width)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
