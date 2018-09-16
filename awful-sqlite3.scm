(module awful-sqlite3 (enable-db switch-to-sqlite3-database)

(import scheme)
(cond-expand
 (chicken-4
  (import chicken)
  (use awful sqlite3))
 (chicken-5
  (import (chicken base))
  (import awful sqlite3))
 (else
  (error "Unsupported CHICKEN version.")))

(define (enable-db . ignore) ;; backward compatibility: `enable-db' was a parameter
  (switch-to-sqlite3-database))

(define (switch-to-sqlite3-database)

  (db-enabled? #t)

  (db-connect open-database)

  (db-disconnect finalize!)

  (db-inquirer
   (lambda (q #!key (default '()) values)
     (let ((result
            (if values
                (apply map-row (append (list (lambda args args)
                                             (db-connection)
                                             ((db-query-transformer) q))
                                       values))
                (map-row (lambda args args)
                         (db-connection)
                         ((db-query-transformer) q)))))
       (if (null? result)
           default
           result))))

  (db-make-row-obj (lambda (q)
                     (error '$db-row-obj "Not implemented for sqlite3.")))
  )
) ; end module
