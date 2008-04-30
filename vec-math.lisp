(in-package :com.nklein.util.vec-math)

(defun v (tt &rest vals)
    "Convert a list of numbers into a vector of a given type"
    (map 'vector #'(lambda (x) (coerce x tt)) vals))

(defmacro vector-operation (op v1 v2 &optional workspace)
    "Perform some operation on vector V1, returning a vector.  If V2 is a sequence, then the OP is performed elementwise.  If V2 is not a sequence, then it is assumed to be a constant value that can be combined with each element of V1 with the OP.  If WORKSPACE is given, it is used to hold the resulting vector.  Otherwise, a new result is consed."
    (let ((ret      (gensym))
	  (operator (gensym)))
	`(let ((,ret (or ,workspace (make-compatible-array ,v1))))
	    (if (typep ,v2 'sequence)
		(flet ((,operator (x y) (,op x y)))
		    (map-into ,ret #',operator ,v1 ,v2))
		(flet ((,operator (x) (,op x ,v2)))
		    (map-into ,ret #',operator ,v1))))))

(defun v+ (v1 v2 &optional workspace)
    "Vector addition (or add the same scalar to each component of V1)"
    (declare (optimize (speed 3) (safety 0)))
    (vector-operation + v1 v2 workspace))

(defun v- (v1 v2 &optional workspace)
    "Vector subtraction (or subtract the same scalar from each component of V1)"
    (declare (optimize (speed 3) (safety 0)))
    (vector-operation - v1 v2 workspace))

(defun v* (v1 v2 &optional workspace)
    "Elementwise vector multiplication (or scale the vector by the scalar V2)"
    (declare (optimize (speed 3) (safety 0)))
    (vector-operation * v1 v2 workspace))

(defun v/ (v1 v2 &optional workspace)
    "Elementwise vector division (or divide each component by the scalar V2)"
    (declare (optimize (speed 3) (safety 0)))
    (vector-operation / v1 v2 workspace))

(defun v. (v1 v2 &optional workspace)
    "Dot product of two vectors"
    (reduce #'+ (v* v1 v2 workspace)))

(defun vector-equal ( v1 v2 &optional workspace )
    (let ((diff (v- v1 v2 workspace)))
	(zerop (v. diff diff))))

(defun vnorm (vv)
    "Norm of a vector"
    (sqrt (v. vv vv)))

(defun normalize (vv &optional workspace)
    "Normalize a vector, taking care not to divide by zero"
    (let ((mag (vnorm vv)))
	(if (< mag 0.00001) vv (v/ vv mag workspace))))

(defun normalize* (vv &optional workspace)
    "Normalize a vector that we're sure is non-zero"
    (v/ vv (vnorm vv) workspace))

(defun random-vector (tt nn &optional state)
    (let ((ret (make-array nn :element-type tt)))
	(do ((ii 0 (+ ii 2)))
	    ((>= ii nn) ret)
	    (multiple-value-bind (aa bb) (random-gaussian state)
		(setf (aref ret ii) (coerce aa tt))
		(if (< ii (- nn 1))
		    (setf (aref ret (1+ ii)) (coerce bb tt)))))))
