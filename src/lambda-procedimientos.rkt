#lang eopl

;; Tema 2 — Expresiones lambda representadas como procedimientos
;; Fundamentos de Interpretación y Compilación de Lenguajes de Programación
;; Universidad del Valle, sede Tuluá
;;
;; Puntos 7 y 8. No modifique la carpeta pruebas/.

(provide var-exp lambda-exp app-exp
         var-exp? lambda-exp? app-exp?
         var-exp->id lambda-exp->id lambda-exp->exp
         app-exp->rator app-exp->rand
         occurs-free?)

;; ---------------------------------------------------------------------------
;; La misma interfaz, otra representación (EOPL, sección 2.3)
;;
;; Las once operaciones son las del archivo de listas y las pruebas que se
;; corren aquí son las mismas. Pasó con los ambientes en los puntos 1 a 4 y
;; vuelve a pasar con las expresiones: la lista no era la expresión, era una
;; forma de guardarla.
;;
;; Aquí la expresión ES un procedimiento. Los tres componentes viven en lo que
;; la clausura capturó al construirse y salen únicamente llamándola.
;;
;; Una manera de organizarlo, si quiere seguirla: que el procedimiento reciba
;; un número, el selector, y devuelva el componente que le corresponde.
;;
;;   (exp 0)  ->  var-exp, lambda-exp o app-exp, según la variante
;;   (exp 1)  ->  el identificador, el parámetro o el operador
;;   (exp 2)  ->  el cuerpo o el operando
;;
;; Con eso los tres predicados y los cinco extractores quedan de una línea
;; cada uno y el trabajo real está en los constructores. No es la única
;; manera: puede despachar por mensaje, como en el ambiente del punto 3, o
;; pasarle a la expresión tres procedimientos y dejar que ella llame al que
;; corresponde. Cualquiera sirve mientras las pruebas pasen.

;; ---------------------------------------------------------------------------
;; Punto 7: los constructores, los predicados y los extractores

;; var-exp : Id -> LcExp
;; Devuelve un procedimiento que sabe que es una variable y cuál.
(define var-exp
  (lambda (id)
    (eopl:error 'var-exp "sin-implementar")))

;; lambda-exp : Id × LcExp -> LcExp
;; Devuelve un procedimiento que guarda el parámetro y el cuerpo.
(define lambda-exp
  (lambda (id exp)
    (eopl:error 'lambda-exp "sin-implementar")))

;; app-exp : LcExp × LcExp -> LcExp
;; Devuelve un procedimiento que guarda el operador y el operando.
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
(define var-exp->id
  (lambda (exp)
    (eopl:error 'var-exp->id "sin-implementar")))

;; lambda-exp->id : LcExp -> Id
(define lambda-exp->id
  (lambda (exp)
    (eopl:error 'lambda-exp->id "sin-implementar")))

;; lambda-exp->exp : LcExp -> LcExp
;; El cuerpo sale tal como entró, procedimiento y todo, listo para seguir
;; preguntándole.
(define lambda-exp->exp
  (lambda (exp)
    (eopl:error 'lambda-exp->exp "sin-implementar")))

;; app-exp->rator : LcExp -> LcExp
(define app-exp->rator
  (lambda (exp)
    (eopl:error 'app-exp->rator "sin-implementar")))

;; app-exp->rand : LcExp -> LcExp
(define app-exp->rand
  (lambda (exp)
    (eopl:error 'app-exp->rand "sin-implementar")))

;; ---------------------------------------------------------------------------
;; Punto 8: la misma función del punto 6
;;
;; occurs-free? : LcExp × Id -> Bool
;; Cópiela del archivo de listas. Si en el punto 6 la escribió contra la
;; interfaz, entra aquí sin cambiarle una letra y pasa las mismas pruebas
;; aunque debajo no quede ni una lista. Ese es el punto del tema: quien usa un
;; TAD programa contra lo que las operaciones prometen, no contra la forma en
;; que están hechas.
;;
;; Si no entra tal cual, mire qué se le coló: en algún lado quedó `car`,
;; `cadr` o algún otro pedazo de la representación anterior.
(define occurs-free?
  (lambda (exp var)
    (eopl:error 'occurs-free? "sin-implementar")))
