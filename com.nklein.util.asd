(asdf:defsystem :com.nklein.util
    :components ((:file "package")
		 (:file "with-argtypes" :depends-on ("package"))
		 (:file "vec-math" :depends-on ("with-argtypes" "package"))))
