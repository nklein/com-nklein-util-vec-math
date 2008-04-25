(defpackage :com.nklein.util
    (:use :cl)
    (:export
	;; from vec-math
	    :float-type :vector-type
	    :thef :thev :coercef
	    :mapv
	    :v
	    :vs
	;; from with-argtypes
	    :with-argtypes
	    :proper-list-p
	    :defun-at :flet-at :labels-at :lambda-at
	    :let-at :let-at*
	    :do-at :do-at*
	))
