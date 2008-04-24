(deftype float-type  ()
    "Our floating-point type of choice"
    'double-float)
(deftype vector-type ()
    "Vectors of our floats"
    '(vector float-type))

(defmacro declf (x)
    "Declare something as our floating-point type of choice"
    `(declare (type float-type ,x)))
(defmacro declv (x)
    "Declare something as a vector of our floating-point type of choice"
    `(declare (type vector-type ,x)))

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

(defun vs (scale val)
    "Scale a vector by some scaling factor"
    (declare (type float-type scale)
	     (type vector-type val))
    (mapv #'(lambda (x) (declare (type float-type x)) (thef (* x scale))) val))
