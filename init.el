;; remove the startup page

(setq inhibit-startup-message t)

;;;;; my own confis to remove menu bar , scroll bar and tool bar
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode 1)

;; ;;;; fonts and stuff

(defvar runemacs/default-font-size 130)

(set-face-attribute 'default nil :font "Hack" :height runemacs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Hack" :height 150)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 120 :weight 'regular)



;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))


;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


;; use the ivy package

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))


(use-package swiper :ensure t)


;; use doom-modeline thingy

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
;;  :custom ((doom-modeline-height 25))
  )

;; all the icons for the icons 
(use-package all-the-icons
  :ensure t)

;; doom themes 
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  ;;(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
  ;;      doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-dracula t)

  ;; Enable flashing mode-line on errors
  ;;(doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;;(doom-themes-neotree-config)
  ;; or for treemacs users
  ;;(setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  ;;(doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  ;;(doom-themes-org-config)
  )

;;(use-package rainbow-delimiters
;;  :hook (prog-mode , rainbow-delimiters-mode ))

;; which key mode
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; ivy rich mode
(use-package ivy-rich
 :init (ivy-rich-mode 1))

;; properly setting up counsel

(use-package counsel
  :bind (("M-x" . counsel-M-x)
;;       	 ("C-x b" . counsel-ibuffer)
       	 ("C-x b" . counsel-switch-buffer)
       	 ("C-x v" . counsel-describe-variable)
       	 ("C-x f" . counsel-describe-function)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	  ("C-r" . 'counsel-minibuffer-history)))

;; Evil Mode configuration

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil) ;; initiall nil
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil) ;; initially nil
;;  (setq evil-respect-visual-line-mode t)
  :config
  (evil-set-undo-system 'undo-tree) 
  (evil-mode 1)  
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))
;; yay goddamit , it is vim now . finally , i am back home .
;; das ist sehr gut damn vim ist uber alles editors 
;; now for evil collection

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; undo tree to make C-r in evil mode redo
(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode 1))


;; auto complete and stuff
(use-package auto-complete
  :ensure t
;;  :config
;;  (require 'auto-complete-config)
;;;   (ac-config-default)
  )


;; company mode


(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
	:custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.1))

(use-package company-box
  :hook (company-mode . company-box-mode))




;;;;;;; yasnepet

(use-package yasnippet
  :ensure t
  :config
    (yas-global-mode 1)
  )

;; for LaTeX


(use-package auctex
  :ensure t
  :defer t
  :hook (LaTeX-mode .
		    (lambda ()
		      (push (list 'output-pdf "Zathura")
			    TeX-view-program-selection))))

;;;;;; for org

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))



(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))



  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))



(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (efs/org-font-setup))


(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  ;; :custom
  ;; (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●"))
  )

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

;;;;; Org reveal for slideshow presentations

(use-package ox-reveal
  :ensure t)

;; virtual terminal
(use-package vterm
  :ensure t)

;; neotree to flex on vim users
(use-package neotree
  :ensure t)


;; helpful because system crafters said it was cool
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; rainbow delimiters


(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


(use-package markdown-mode 
  :ensure t)


;;lsp mode

(defun lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

;; lsp ui

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))


;; lsp treemacs
(use-package lsp-treemacs
  :ensure t
  :after lsp)

;; lsp ivy
(use-package lsp-ivy
  :ensure t)


;; projectile

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; ;; NOTE: Set this to the folder where you keep your Git repos!
  ;; (when (file-directory-p "~/Projects/Code")
  ;;   (setq projectile-project-search-path '("~/Projects/Code")))
  ;; (setq projectile-switch-project-action #'projectile-dired)
)

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package web-mode
  :ensure t)


;; fot javascript and typescript
(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

;; user defined functions (starts with my-)

;; to get the ide layout like vscode with neotree and stuff

(defun my-ide()
  "Get a modern IDE layout"
  (evil-window-split)
  (evil-window-down 1)
  (evil-window-decrease-height 10)
  (vterm)
  (neotree)
  (evil-window-right 1)
  )


 ;; (add-hook 'prog-mode-hook
 ;; 	  (local-set-key (kbd "C-i i")
 ;; 			 'my-ide)
 ;; 	  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("6c531d6c3dbc344045af7829a3a20a09929e6c41d7a7278963f7d3215139f6a7" "6c98bc9f39e8f8fd6da5b9c74a624cbb3782b4be8abae8fd84cbc43053d7c175" "8d7b028e7b7843ae00498f68fad28f3c6258eda0650fe7e17bfb017d51d0e2a2" "97db542a8a1731ef44b60bc97406c1eb7ed4528b0d7296997cbb53969df852d6" "1704976a1797342a1b4ea7a75bdbb3be1569f4619134341bd5a4c1cfb16abad4" "613aedadd3b9e2554f39afe760708fc3285bf594f6447822dd29f947f0775d6c" "0466adb5554ea3055d0353d363832446cd8be7b799c39839f387abb631ea0995" "835868dcd17131ba8b9619d14c67c127aa18b90a82438c8613586331129dda63" "23c806e34594a583ea5bbf5adf9a964afe4f28b4467d28777bcba0d35aa0872e" "cbdf8c2e1b2b5c15b34ddb5063f1b21514c7169ff20e081d39cf57ffee89bc1e" "76ed126dd3c3b653601ec8447f28d8e71a59be07d010cd96c55794c3008df4d7" "d268b67e0935b9ebc427cad88ded41e875abfcc27abd409726a92e55459e0d01" "f91395598d4cb3e2ae6a2db8527ceb83fed79dbaf007f435de3e91e5bda485fb" "028c226411a386abc7f7a0fba1a2ebfae5fe69e2a816f54898df41a6a3412bb5" "da186cce19b5aed3f6a2316845583dbee76aea9255ea0da857d1c058ff003546" "a9a67b318b7417adbedaab02f05fa679973e9718d9d26075c6235b1f0db703c8" "266ecb1511fa3513ed7992e6cd461756a895dcc5fef2d378f165fed1c894a78c" "d47f868fd34613bd1fc11721fe055f26fd163426a299d45ce69bef1f109e1e71" "1f1b545575c81b967879a5dddc878783e6ebcca764e4916a270f9474215289e5" "b5803dfb0e4b6b71f309606587dd88651efe0972a5be16ece6a958b197caeed8" "1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf" "234dbb732ef054b109a9e5ee5b499632c63cc24f7c2383a849815dacc1727cb6" "d6844d1e698d76ef048a53cefe713dbbe3af43a1362de81cdd3aefa3711eae0d" "f6665ce2f7f56c5ed5d91ed5e7f6acb66ce44d0ef4acfaa3a42c7cfe9e9a9013" "7a7b1d475b42c1a0b61f3b1d1225dd249ffa1abb1b7f726aec59ac7ca3bf4dae" "47db50ff66e35d3a440485357fb6acb767c100e135ccdf459060407f8baea7b2" default))
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
   '(typescript-mode web-mode counsel-projectile projectile company-box company helpful markdown-mode lsp-treemacs lsp-mode mastodon neotree vterm ox-reveal auctex undo-tree yasnippet org-mode doom-themes evil-collection evil counsel ivy-rich which-key rainbow-delimiters ranbow-delimeters doom-modeline swiper use-package ivy)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; to make sure line number is not displayed everywhere
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook
		vterm-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))
;; setup relative line number mode

(menu-bar--display-line-numbers-mode-relative)


