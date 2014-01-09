(module awful-sqlite3 (enable-db switch-to-sqlite3-database)

(import chicken scheme regex)
(use awful sqlite3)

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
                (apply map-row (append (list
                                        (lambda args args)
                                        (db-connection)
                                        q) values))
                (map-row (lambda args args) (db-connection) q))))
       (if (null? result)
           default
           result))))

  (sql-quoter (lambda (data)
                (++ "'" (string-substitute* (concat data) '(("'" . "''"))) "'")))

  (db-make-row-obj (lambda (q)
                     (error '$db-row-obj "Not implemented for sqlite3.")))
  )
) ; end module
