(in-package :com.nklein.util)

(defun proper-list-p (x)
    (if (consp x)
	(proper-list-p (cdr x))
	(not x)))

(defun prep-typed-vars-and-decls (arg-forms)
    (let (vars decls)
        (dolist (form arg-forms)
            (cond
		    ;; raw symbol;      x   --or--  &key
		    ;; or normal list:  (x default-x)
                ((or (atom form) (proper-list-p form))
                    (push form vars))

		    ;; dotted-entry:	(x . type)
		    ;; or          :    ((x default-x) . type)
                (t
                    (let ((var  (car form))
                          (type (cdr form)))
                        (push var vars)
			(if (consp var)
			    (push `(declare (type ,type ,(car var))) decls)
			    (push `(declare (type ,type ,var)) decls))))))
	(values (nreverse vars) decls)))

(defun with-argtypes (pre-args arg-forms post-args body)
    (multiple-value-bind (vars decls)
	    (prep-typed-vars-and-decls arg-forms)
	`(,@pre-args (,@vars) ,@post-args ,@decls ,@body)))

(defmacro defun-at (name arg-forms &body body)
    (with-argtypes `(defun ,name) arg-forms nil body))

(defun flet-one-func (form)
    (destructuring-bind (name arg-forms . body) form
	(with-argtypes `(,name) arg-forms nil body)))

(defmacro flet-at (func-forms &body body)
    `(flet (,@(mapcar #'flet-one-func func-forms))
	,@body))

(defmacro labels-at (func-forms &body body)
    `(labels (,@(mapcar #'flet-one-func func-forms))
	,@body))

(defmacro lambda-at (arg-forms &body body)
    (multiple-value-bind (vars decls)
	    (prep-typed-vars-and-decls arg-forms)
	`#'(lambda (,@vars) ,@decls ,@body)))

(defmacro let-at (arg-forms &body body)
    (with-argtypes '(let) arg-forms nil body))

(defmacro let-at* (arg-forms &body body)
    (with-argtypes '(let*) arg-forms nil body))

(defmacro do-at (arg-forms end-forms &body body)
    (with-argtypes '(do) arg-forms end-forms body))

(defmacro do-at* (arg-forms end-forms &body body)
    (with-argtypes '(do*) arg-forms end-forms body))
