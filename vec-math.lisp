(in-package :com.nklein.util.vec-math)

(deftype float-type  ()
    "Our floating-point type of choice"
    'double-float)
(deftype vector-type ()
    "Vectors of our floats"
    'vector)

(defmacro thef (&rest what)
    "Declare something as returning our floating-point type of choice"
    `(the float-type ,@what))

(defmacro thev (&rest what)
    "Declare something as returning our vector-type"
    `(the vector-type ,@what))

(declaim (inline coercef))
(defun coercef (x)
    "Force a number to be our floating-point type of choice"
    (coerce x 'float-type))

(declaim (inline mapv))
(defun mapv (func vecs)
    "Apply a function to a list of vectors to get back a vector"
    (map 'vector-type func vecs))

(defun v (&rest vals)
    "Convert a list of numbers into a vector"
    (mapv #'coercef vals))

(defun vs-no-types (scale val)
    "Scale a vector by some scaling factor"
    (declare (optimize (speed 3) (safety 0)))
    (mapv #'(lambda (x) (* x scale)) val))
(defun-at vs-at ( (scale . float-type) (val . vector-type) )
    (declare (optimize (speed 3) (safety 0)))
    (flet-at ((scaler ((x . float-type)) (* x scale)))
	(mapv #'scaler val)))
(defun-at vs-lambda-at ( (scale . float-type) (val . vector-type) )
    (declare (optimize (speed 3) (safety 0)))
    (mapv (lambda-at ((x . float-type)) (* x scale)) val))

(defun-at vs ( (scale . float-type) (val . vector-type) )
    (declare (optimize (speed 3) (safety 0)))
    (let ((ret (make-array (length val) :element-type 'float-type)))
	(flet-at ((scaler ((x . float-type)) (* x scale)))
	    (map-into ret #'scaler val))))
