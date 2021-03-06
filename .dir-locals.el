((python-mode . ((eval . (let* ((root-dir (projectile-project-root))
                                (cov.el (expand-file-name "coverage" root-dir))
                                (cov.json (expand-file-name "coverage.json" root-dir)))
                           (when (and (require 'pycov cov.el t)
                                      (file-exists-p cov.json))
                             (setq pycov-coverage-file cov.json)
                             (pycov-mode)))))))
