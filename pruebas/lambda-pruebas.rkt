#lang racket

;; Pruebas del tema 2, expresiones lambda. No modifique este archivo.
;;
;; Igual que con los ambientes: una sola batería que se corre dos veces, una
;; contra cada representación. Las pruebas solo usan las once operaciones de
;; la interfaz, así que no pueden distinguir la lista del procedimiento.
;;
;; Se corren con `raco test pruebas/` desde la raíz del repositorio, o desde
;; DrRacket abriendo este archivo y pulsando Ejecutar.

(require rackunit
         rackunit/text-ui
         (prefix-in lista: "../src/lambda-listas.rkt")
         (prefix-in proc:  "../src/lambda-procedimientos.rkt"))

;; Una llamada sin implementar falla con un mensaje legible en vez de tumbar
;; la corrida entera.
(define-syntax-rule (verificar nombre esperado expresion)
  (test-case nombre
    (check-equal? (with-handlers ([exn:fail? (lambda (e) (list 'sin-implementar))])
                    expresion)
                  esperado)))

(define (bateria etiqueta
                 var-exp lambda-exp app-exp
                 var-exp? lambda-exp? app-exp?
                 var-exp->id lambda-exp->id lambda-exp->exp
                 app-exp->rator app-exp->rand
                 occurs-free?)
  (test-suite
   etiqueta

   ;; --- los predicados distinguen las tres variantes ---

   (verificar "var-exp? reconoce una variable"
              #t (var-exp? (var-exp 'x)))

   (verificar "var-exp? no toma una abstracción por una variable"
              #f (var-exp? (lambda-exp 'x (var-exp 'x))))

   (verificar "var-exp? no toma una aplicación por una variable"
              #f (var-exp? (app-exp (var-exp 'f) (var-exp 'x))))

   (verificar "lambda-exp? reconoce una abstracción"
              #t (lambda-exp? (lambda-exp 'x (var-exp 'x))))

   (verificar "lambda-exp? no toma una variable por una abstracción"
              #f (lambda-exp? (var-exp 'x)))

   (verificar "app-exp? reconoce una aplicación"
              #t (app-exp? (app-exp (var-exp 'f) (var-exp 'x))))

   (verificar "app-exp? no toma una abstracción por una aplicación"
              #f (app-exp? (lambda-exp 'x (var-exp 'x))))

   ;; --- los extractores devuelven cada componente ---

   (verificar "var-exp->id devuelve el identificador"
              'x (var-exp->id (var-exp 'x)))

   (verificar "lambda-exp->id devuelve el parámetro"
              'x (lambda-exp->id (lambda-exp 'x (var-exp 'y))))

   (verificar "lambda-exp->exp devuelve el cuerpo, que sigue siendo una expresión"
              'y (var-exp->id (lambda-exp->exp (lambda-exp 'x (var-exp 'y)))))

   (verificar "app-exp->rator devuelve el operador"
              'f (var-exp->id (app-exp->rator (app-exp (var-exp 'f) (var-exp 'x)))))

   (verificar "app-exp->rand devuelve el operando"
              'x (var-exp->id (app-exp->rand (app-exp (var-exp 'f) (var-exp 'x)))))

   (verificar "el cuerpo de una abstracción puede ser otra abstracción"
              'y (lambda-exp->id
                  (lambda-exp->exp (lambda-exp 'x (lambda-exp 'y (var-exp 'x))))))

   (verificar "el operador de una aplicación puede ser una abstracción"
              #t (lambda-exp?
                  (app-exp->rator (app-exp (lambda-exp 'x (var-exp 'x)) (var-exp 'y)))))

   ;; --- occurs-free? ---

   (verificar "una variable ocurre libre en sí misma"
              #t (occurs-free? (var-exp 'x) 'x))

   (verificar "otra variable no"
              #f (occurs-free? (var-exp 'y) 'x))

   (verificar "el parámetro queda ligado en el cuerpo: λx.x"
              #f (occurs-free? (lambda-exp 'x (var-exp 'x)) 'x))

   (verificar "lo que no es el parámetro sigue libre: λx.y"
              #t (occurs-free? (lambda-exp 'x (var-exp 'y)) 'y))

   (verificar "libre en el operador de una aplicación"
              #t (occurs-free? (app-exp (var-exp 'f) (var-exp 'x)) 'f))

   (verificar "libre en el operando de una aplicación"
              #t (occurs-free? (app-exp (var-exp 'f) (var-exp 'x)) 'x))

   (verificar "en λx.(p x), x está ligada"
              #f (occurs-free? (lambda-exp 'x (app-exp (var-exp 'p) (var-exp 'x))) 'x))

   (verificar "en λx.(p x), p es libre"
              #t (occurs-free? (lambda-exp 'x (app-exp (var-exp 'p) (var-exp 'x))) 'p))

   (verificar "la ligadura alcanza las abstracciones de más adentro: λx.λy.x"
              #f (occurs-free? (lambda-exp 'x (lambda-exp 'y (var-exp 'x))) 'x))

   (verificar "λy.λz.(x (y z)): x es libre"
              #t (occurs-free? (lambda-exp 'y
                                (lambda-exp 'z
                                 (app-exp (var-exp 'x)
                                          (app-exp (var-exp 'y) (var-exp 'z)))))
                               'x))

   (verificar "λy.λz.(x (y z)): y no lo es"
              #f (occurs-free? (lambda-exp 'y
                                (lambda-exp 'z
                                 (app-exp (var-exp 'x)
                                          (app-exp (var-exp 'y) (var-exp 'z)))))
                               'y))

   (verificar "el argumento de una aplicación queda fuera del alcance: ((λx.x) y)"
              #t (occurs-free? (app-exp (lambda-exp 'x (var-exp 'x)) (var-exp 'y)) 'y))

   (verificar "una misma variable puede estar ligada de un lado y libre del otro: ((λx.x) x)"
              #t (occurs-free? (app-exp (lambda-exp 'x (var-exp 'x)) (var-exp 'x)) 'x))))

(define (interfaz-completa? var-exp lambda-exp app-exp
                            var-exp? lambda-exp? app-exp?
                            var-exp->id lambda-exp->id lambda-exp->exp
                            app-exp->rator app-exp->rand
                            occurs-free?)
  (andmap procedure?
          (list var-exp lambda-exp app-exp
                var-exp? lambda-exp? app-exp?
                var-exp->id lambda-exp->id lambda-exp->exp
                app-exp->rator app-exp->rand
                occurs-free?)))

(define suite-entorno
  (test-suite
   "Entorno"
   (test-case "el módulo de listas carga y exporta las once operaciones y occurs-free?"
     (check-true (interfaz-completa?
                  lista:var-exp lista:lambda-exp lista:app-exp
                  lista:var-exp? lista:lambda-exp? lista:app-exp?
                  lista:var-exp->id lista:lambda-exp->id lista:lambda-exp->exp
                  lista:app-exp->rator lista:app-exp->rand
                  lista:occurs-free?)))
   (test-case "el módulo de procedimientos carga y exporta las once operaciones y occurs-free?"
     (check-true (interfaz-completa?
                  proc:var-exp proc:lambda-exp proc:app-exp
                  proc:var-exp? proc:lambda-exp? proc:app-exp?
                  proc:var-exp->id proc:lambda-exp->id proc:lambda-exp->exp
                  proc:app-exp->rator proc:app-exp->rand
                  proc:occurs-free?)))))

(module+ test
  (run-tests suite-entorno)
  (run-tests (bateria "Puntos 5 y 6 — expresiones lambda como listas"
                      lista:var-exp lista:lambda-exp lista:app-exp
                      lista:var-exp? lista:lambda-exp? lista:app-exp?
                      lista:var-exp->id lista:lambda-exp->id lista:lambda-exp->exp
                      lista:app-exp->rator lista:app-exp->rand
                      lista:occurs-free?))
  (run-tests (bateria "Puntos 7 y 8 — expresiones lambda como procedimientos"
                      proc:var-exp proc:lambda-exp proc:app-exp
                      proc:var-exp? proc:lambda-exp? proc:app-exp?
                      proc:var-exp->id proc:lambda-exp->id proc:lambda-exp->exp
                      proc:app-exp->rator proc:app-exp->rand
                      proc:occurs-free?)))
