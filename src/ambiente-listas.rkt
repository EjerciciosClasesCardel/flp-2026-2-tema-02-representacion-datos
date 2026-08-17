#lang eopl

;; Tema 2 — Ambientes representados como listas
;; Fundamentos de Interpretación y Compilación de Lenguajes de Programación
;; Universidad del Valle, sede Tuluá
;;
;; Puntos 1 y 2. No modifique la carpeta pruebas/.

(provide empty-env extend-env apply-env has-binding?)

;; ---------------------------------------------------------------------------
;; La interfaz del TAD (EOPL, sección 2.2)
;;
;;   empty-env  : ()                        -> Env
;;   extend-env : Var × SchemeVal × Env     -> Env
;;   apply-env  : Env × Var                 -> SchemeVal
;;   has-binding? : Env × Var               -> Bool
;;
;; Un ambiente es una función de variables a valores, construida de a una
;; ligadura por vez. Estas cuatro operaciones son todo lo que el resto del
;; curso va a saber de él: quien lo use nunca mira por dentro.
;;
;; Aquí el ambiente se representa como una lista de pares. Es la
;; representación transparente: se puede imprimir y ver qué tiene.
;;
;;   (empty-env)                       =>  ()
;;   (extend-env 'x 3 (empty-env))     =>  ((x 3))
;;
;; Elija la forma concreta que quiera para los pares. Las pruebas no la miran,
;; solo usan las cuatro operaciones, así que la decisión es suya.

;; ---------------------------------------------------------------------------
;; Punto 1: las tres operaciones básicas

;; empty-env : () -> Env
;; Devuelve el ambiente sin ninguna ligadura.
(define empty-env
  (lambda ()
    (eopl:error 'empty-env "sin-implementar")))

;; extend-env : Var × SchemeVal × Env -> Env
;; Devuelve un ambiente nuevo, igual al recibido más la ligadura de `var` a
;; `val`. El ambiente que entra no se modifica: se construye otro.
(define extend-env
  (lambda (var val env)
    (eopl:error 'extend-env "sin-implementar")))

;; apply-env : Env × Var -> SchemeVal
;; El valor ligado a `var`. Si la variable fue ligada más de una vez, vale la
;; ligadura más reciente. Si no está ligada, se lanza un error con eopl:error.
(define apply-env
  (lambda (env var)
    (eopl:error 'apply-env "sin-implementar")))

;; ---------------------------------------------------------------------------
;; Punto 2: consultar sin fallar
;;
;; has-binding? : Env × Var -> Bool
;; Responde si la variable está ligada, sin lanzar error cuando no lo está.
;; (EOPL, ejercicio de la sección 2.2)
(define has-binding?
  (lambda (env var)
    (eopl:error 'has-binding? "sin-implementar")))
