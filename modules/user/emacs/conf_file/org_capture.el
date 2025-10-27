
(use-package org
  :defer t
  :init
  (global-set-key (kbd "C-c c") #'org-capture)
  :config
  (setq org-capture-templates
        '(("j"
           "=> Journal"
           entry
           (file+olp+datetree "journal.org")
           "* %?\nEntered on %U\n %i\n %a")
          ("L"
           "org-capture: URL => Journal"
           entry
           (file+olp+datetree "~/org/journal.org")
           "* %?\nEntered on %U\n [[%:link][%:description]]\n")
          ("p"
           "org-capture: selection dans une page web => Journal"
           entry
           (file+olp+datetree "~/org/journal.org")
           "* %?\nEntered on %U\n[[%:link][%:description]]\n#+BEGIN_QUOTE\n%i\n#+END_QUOTE\n"))))

(require 'org-protocol)
