#lang racket

;; Pruebas del tema 2. No modifique este archivo.
;;
;; La misma batería se corre dos veces, una contra cada representación. Ese es
;; el punto del tema: si el TAD está bien hecho, las pruebas no distinguen una
;; de otra.
;;
;; Se corren con `raco test pruebas/` desde la raíz del repositorio, o desde
;; DrRacket abriendo este archivo y pulsando Ejecutar.

(require rackunit
         rackunit/text-ui
         (prefix-in lista: "../src/ambiente-listas.rkt")
         (prefix-in proc:  "../src/ambiente-procedimientos.rkt"))

;; Una llamada sin implementar falla con un mensaje legible en vez de tumbar
;; la corrida entera.
(define-syntax-rule (verificar nombre esperado expresion)
  (test-case nombre
    (check-equal? (with-handlers ([exn:fail? (lambda (e) (list 'sin-implementar))])
                    expresion)
                  esperado)))

;; Para los casos que deben fallar no basta con que salte un error: el cuerpo
;; sin implementar también lanza uno. Se exige que el error sea otro.
(define-syntax-rule (verificar-error nombre expresion)
  (test-case nombre
    (define resultado
      (with-handlers ([exn:fail? (lambda (e) (cons 'error (exn-message e)))])
        (list 'sin-error expresion)))
    (cond
      [(not (pair? resultado)) (fail "resultado inesperado")]
      [(eq? (car resultado) 'sin-error)
       (fail (format "se esperaba un error y devolvió ~s" (cadr resultado)))]
      [(regexp-match? #rx"sin-implementar" (cdr resultado))
       (fail "la operación todavía está sin implementar")]
      [else (check-true #t)])))

(define (bateria etiqueta empty-env extend-env apply-env has-binding?)
  (test-suite
   etiqueta

   (verificar "una sola ligadura"
              3 (apply-env (extend-env 'x 3 (empty-env)) 'x))

   (verificar "varias variables, se encuentra la del fondo"
              1 (apply-env (extend-env 'z 3 (extend-env 'y 2 (extend-env 'x 1 (empty-env)))) 'x))

   (verificar "varias variables, se encuentra la de encima"
              3 (apply-env (extend-env 'z 3 (extend-env 'y 2 (extend-env 'x 1 (empty-env)))) 'z))

   (verificar "la ligadura más reciente tapa a la anterior"
              2 (apply-env (extend-env 'x 2 (extend-env 'x 1 (empty-env))) 'x))

   (verificar "el valor ligado puede ser cualquier cosa"
              '(1 2 3) (apply-env (extend-env 'xs '(1 2 3) (empty-env)) 'xs))

   (test-case "extender no altera el ambiente que recibió"
     (define e1 (with-handlers ([exn:fail? (lambda (e) #f)])
                  (extend-env 'x 1 (empty-env))))
     (check-equal?
      (with-handlers ([exn:fail? (lambda (e) (list 'sin-implementar))])
        (let ([_ (extend-env 'x 2 e1)])
          (apply-env e1 'x)))
      1))

   (verificar-error "variable ausente en un ambiente con ligaduras"
                    (apply-env (extend-env 'x 1 (empty-env)) 'y))

   (verificar-error "cualquier variable en el ambiente vacío"
                    (apply-env (empty-env) 'x))

   (verificar "has-binding? encuentra la que está"
              #t (has-binding? (extend-env 'y 2 (extend-env 'x 1 (empty-env))) 'x))

   (verificar "has-binding? no inventa la que no está"
              #f (has-binding? (extend-env 'x 1 (empty-env)) 'y))

   (verificar "has-binding? sobre el ambiente vacío"
              #f (has-binding? (empty-env) 'x))))

(define suite-entorno
  (test-suite
   "Entorno"
   (test-case "el módulo de listas carga y exporta las cuatro operaciones"
     (check-true (and (procedure? lista:empty-env) (procedure? lista:extend-env)
                      (procedure? lista:apply-env) (procedure? lista:has-binding?))))
   (test-case "el módulo de procedimientos carga y exporta las cuatro operaciones"
     (check-true (and (procedure? proc:empty-env) (procedure? proc:extend-env)
                      (procedure? proc:apply-env) (procedure? proc:has-binding?))))))

(module+ test
  (run-tests suite-entorno)
  (run-tests (bateria "Puntos 1 y 2 — ambiente como lista"
                      lista:empty-env lista:extend-env lista:apply-env lista:has-binding?))
  (run-tests (bateria "Puntos 3 y 4 — ambiente como procedimiento"
                      proc:empty-env proc:extend-env proc:apply-env proc:has-binding?)))
