(asdf:defsystem :com.nklein.util.vec-math
    :depends-on (:com.nklein.util.general)
    :components ((:file "package")
		 (:file "vec-math" :depends-on ("package"))))
