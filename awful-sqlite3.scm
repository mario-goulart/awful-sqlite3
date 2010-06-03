(module awful-sqlite3 (enable-db)

(import chicken scheme regex)
(use awful sqlite3)

(define (enable-db . ignore) ;; backward compatibility: `enable-db' was a parameter

  (db-enabled? #t)

  (db-connect open-database)

  (db-disconnect finalize!)

  (db-inquirer (lambda (q #!key default)
                 (map-row (lambda args args) (db-connection) q)))

  (sql-quoter (lambda (data)
                (++ "'" (string-substitute* (concat data) '(("'" . "''"))) "'")))

  (db-make-row-obj (lambda (q)
                     (error '$db-row-obj "Not implemented for sqlite3.")))
  )
) ; end module
