;; Reglas del tema 2. Cada entrada la lee verificar/reglas.rkt.
;;
;; Los dos TAD se construyen, no se modifican: extender un ambiente devuelve
;; otro ambiente y construir una expresión devuelve otra expresión. Con
;; asignación destructiva las pruebas de que extender no altera lo que recibió
;; se pueden burlar, así que la mutación queda descartada.
((archivos "src/ambiente-listas.rkt" "src/ambiente-procedimientos.rkt"
           "src/lambda-listas.rkt" "src/lambda-procedimientos.rkt")
 (prohibidos set! set-car! set-cdr! set-box! vector-set! vector-fill!
             hash-set! string-set! append!))
