(define-module (myguix packages info)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (gnu packages texinfo))

(define-public make-texinfo
  (package
   (name "make-texinfo")
   (version "0.77")
   (source
    (origin
     (method url-fetch)
     (uri "https://www.gnu.org/software/make/manual/make.texi.tar.gz")
     (sha256
      (base32
       "1f4flzigwcyyx9zhlrlqgav0nk0cw25wi01b00yz4kzri662f465"))))
   (build-system gnu-build-system)
   (arguments
    (list
     #:phases
     #~(modify-phases %standard-phases
		      (delete 'configure)
		      (delete 'check)
		      (replace 'build
			       (lambda _
				 (invoke "makeinfo" "make.texi")))
		      (replace 'install
			       (lambda* (#:key outputs #:allow-other-keys)
				 (let* ((out (assoc-ref outputs "out"))
					(info-dir (string-append out "/share/info")))
				   (mkdir-p info-dir)
				   (for-each (lambda (file)
					       (install-file file info-dir))
					     (find-files "." "\\.info(-[0-9]+)?$"))))))))
   (native-inputs (list texinfo))
   (home-page "https://www.gnu.org/software/make/manual/")
   (synopsis "Texinfo manual for GNU Make.")
   (description "The manual for GNU Make in Texinfo format for viewing in GNU Info and Emacs.")
   (license license:fdl1.3+)))
