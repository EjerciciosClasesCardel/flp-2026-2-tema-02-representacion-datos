#lang eopl

;; Tema 2 — Expresiones lambda representadas como listas
;; Fundamentos de Interpretación y Compilación de Lenguajes de Programación
;; Universidad del Valle, sede Tuluá
;;
;; Puntos 5 y 6. No modifique la carpeta pruebas/.

(provide var-exp lambda-exp app-exp
         var-exp? lambda-exp? app-exp?
         var-exp->id lambda-exp->id lambda-exp->exp
         app-exp->rator app-exp->rand
         occurs-free?)

;; ---------------------------------------------------------------------------
;; La interfaz del TAD (EOPL, sección 2.3)
;;
;; Las expresiones del cálculo lambda tienen tres producciones:
;;
;;   <lc-exp> ::= <identifier>                      var-exp    (id)
;;            ::= (lambda (<identifier>) <lc-exp>)  lambda-exp (id, exp)
;;            ::= (<lc-exp> <lc-exp>)               app-exp    (rator, rand)
;;
;; Un constructor por producción, un predicado para saber cuál de las tres se
;; tiene en la mano, y un extractor por cada componente:
;;
;;   var-exp         : Id            -> LcExp
;;   lambda-exp      : Id × LcExp    -> LcExp
;;   app-exp         : LcExp × LcExp -> LcExp
;;   var-exp?        : LcExp         -> Bool
;;   lambda-exp?     : LcExp         -> Bool
;;   app-exp?        : LcExp         -> Bool
;;   var-exp->id     : LcExp         -> Id
;;   lambda-exp->id  : LcExp         -> Id
;;   lambda-exp->exp : LcExp         -> LcExp
;;   app-exp->rator  : LcExp         -> LcExp
;;   app-exp->rand   : LcExp         -> LcExp
;;
;; Once operaciones, y con eso alcanza para escribir cualquier función que
;; recorra una expresión. Nadie afuera necesita saber cómo está guardada.
;;
;; Aquí la expresión se representa como una lista que empieza por un símbolo
;; que dice de qué variante se trata:
;;
;;   (var-exp 'x)                  =>  (var-exp x)
;;   (lambda-exp 'x (var-exp 'x))  =>  (lambda-exp x (var-exp x))
;;
;; Los predicados miran ese primer símbolo y los extractores sacan la posición
;; que corresponde. En EOPL los extractores se llaman `var-exp->var`,
;; `lambda-exp->bound-var` y `lambda-exp->body`; aquí se dejaron los nombres
;; de la nota de clase.

;; ---------------------------------------------------------------------------
;; Punto 5: los constructores, los predicados y los extractores

;; var-exp : Id -> LcExp
;; La expresión que consiste en una sola variable.
(define var-exp
  (lambda (id)
    (eopl:error 'var-exp "sin-implementar")))

;; lambda-exp : Id × LcExp -> LcExp
;; La abstracción λid.exp, con `id` como parámetro y `exp` como cuerpo.
(define lambda-exp
  (lambda (id exp)
    (eopl:error 'lambda-exp "sin-implementar")))

;; app-exp : LcExp × LcExp -> LcExp
;; La aplicación de `rator` a `rand`.
(define app-exp
  (lambda (rator rand)
    (eopl:error 'app-exp "sin-implementar")))

;; var-exp? : LcExp -> Bool
(define var-exp?
  (lambda (exp)
    (eopl:error 'var-exp? "sin-implementar")))

;; lambda-exp? : LcExp -> Bool
(define lambda-exp?
  (lambda (exp)
    (eopl:error 'lambda-exp? "sin-implementar")))

;; app-exp? : LcExp -> Bool
(define app-exp?
  (lambda (exp)
    (eopl:error 'app-exp? "sin-implementar")))

;; var-exp->id : LcExp -> Id
;; El identificador de una expresión variable.
(define var-exp->id
  (lambda (exp)
    (eopl:error 'var-exp->id "sin-implementar")))

;; lambda-exp->id : LcExp -> Id
;; El parámetro de una abstracción.
(define lambda-exp->id
  (lambda (exp)
    (eopl:error 'lambda-exp->id "sin-implementar")))

;; lambda-exp->exp : LcExp -> LcExp
;; El cuerpo de una abstracción, que es otra expresión completa.
(define lambda-exp->exp
  (lambda (exp)
    (eopl:error 'lambda-exp->exp "sin-implementar")))

;; app-exp->rator : LcExp -> LcExp
;; El operador de una aplicación.
(define app-exp->rator
  (lambda (exp)
    (eopl:error 'app-exp->rator "sin-implementar")))

;; app-exp->rand : LcExp -> LcExp
;; El operando de una aplicación.
(define app-exp->rand
  (lambda (exp)
    (eopl:error 'app-exp->rand "sin-implementar")))

;; ---------------------------------------------------------------------------
;; Punto 6: una función que usa el TAD
;;
;; occurs-free? : LcExp × Id -> Bool
;; Responde si el identificador ocurre libre en la expresión, o sea si aparece
;; en alguna posición donde ninguna lambda que lo encierre lo tenga como
;; parámetro. En λx.(p x), p ocurre libre y x no.
;;
;; Son tres casos, uno por variante, y la recursión sigue la forma de la
;; gramática: en una variable se compara, en una abstracción se descarta el
;; parámetro y se sigue por el cuerpo, en una aplicación se pregunta por el
;; operador y por el operando.
;;
;; Escríbala usando solo las once operaciones de arriba, sin `car` ni `cadr`
;; sobre la expresión. Si se cuela un `car`, la misma función se cae en el
;; punto 8, donde ya no hay lista que abrir.
;;
;; EOPL pasa los argumentos al revés, primero el identificador; aquí va
;; primero la expresión, como en la nota de clase.
(define occurs-free?
  (lambda (exp var)
    (eopl:error 'occurs-free? "sin-implementar")))
