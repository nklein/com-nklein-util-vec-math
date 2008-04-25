(deftype float-type  ()
    "Our floating-point type of choice"
    'double-float)
(deftype vector-type ()
    "Vectors of our floats"
    '(vector float-type))

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
    (map 'vector func vecs))

(defun v (&rest vals)
    "Convert a list of numbers into a vector"
    (mapv #'coercef vals))

;; "Scale a vector by some scaling factor"
(defun vs (scale val)
    (declare (optimize (speed 3) (safety 0)))
    (mapv #'(lambda (x) (* x scale)) val))
(defun-at vs-at ( (scale . float-type) (val . vector-type) )
    (declare (optimize (speed 3) (safety 0)))
    (flet-at ((scaler ((x . float-type)) (thef (* x scale))))
	(mapv #'scaler val)))
