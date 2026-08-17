#lang eopl

;; Tema 2 — Ambientes representados como procedimientos
;; Fundamentos de Interpretación y Compilación de Lenguajes de Programación
;; Universidad del Valle, sede Tuluá
;;
;; Puntos 3 y 4. No modifique la carpeta pruebas/.

(provide empty-env extend-env apply-env has-binding?)

;; ---------------------------------------------------------------------------
;; La misma interfaz, otra representación (EOPL, sección 2.2.3)
;;
;; Las cuatro operaciones son las mismas del archivo de listas y las pruebas
;; que se corren aquí son exactamente las mismas. Ahí está lo que hay que ver:
;; el ambiente no es la lista ni es el procedimiento, es lo que las cuatro
;; operaciones prometen. La representación se puede cambiar por debajo sin que
;; nadie afuera se entere.
;;
;; Aquí el ambiente ES un procedimiento. No hay lista que inspeccionar: la
;; información está guardada en las variables que el procedimiento capturó al
;; construirse, y la única forma de sacarla es llamándolo.
;;
;; Una manera de organizarlo, si quiere seguirla: que el procedimiento reciba
;; dos argumentos, un mensaje y la variable buscada.
;;
;;   (env 'buscar  var)   ->  el valor ligado, o un error si no hay ninguno
;;   (env 'ligada? var)   ->  #t o #f
;;
;; Con eso, `apply-env` y `has-binding?` quedan de una línea cada una, y el
;; trabajo real está en `extend-env`. No es la única manera; si prefiere otra,
;; adelante. Esta forma de despachar por mensaje reaparece en el último tema
;; del curso, cuando aparezcan los objetos.

;; ---------------------------------------------------------------------------
;; Punto 3: las tres operaciones básicas

;; empty-env : () -> Env
;; El ambiente vacío, que no tiene ninguna ligadura que ofrecer.
(define empty-env
  (lambda ()
    (eopl:error 'empty-env "sin-implementar")))

;; extend-env : Var × SchemeVal × Env -> Env
;; Devuelve un procedimiento que responde por `var` con `val`, y que para
;; cualquier otra variable le pasa la pregunta al ambiente que recibió.
(define extend-env
  (lambda (var val env)
    (eopl:error 'extend-env "sin-implementar")))

;; apply-env : Env × Var -> SchemeVal
;; El valor ligado a `var`, o un error con eopl:error si no está ligada.
(define apply-env
  (lambda (env var)
    (eopl:error 'apply-env "sin-implementar")))

;; ---------------------------------------------------------------------------
;; Punto 4: consultar sin fallar

;; has-binding? : Env × Var -> Bool
(define has-binding?
  (lambda (env var)
    (eopl:error 'has-binding? "sin-implementar")))
