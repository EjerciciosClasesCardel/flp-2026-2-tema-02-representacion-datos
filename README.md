# Tema 2 — Estrategias para representar datos

Fundamentos de Interpretación y Compilación de Lenguajes de Programación
Escuela de Ingeniería de Sistemas y Computación, Universidad del Valle
Carlos Andrés Delgado Saavedra

Ejercicio de autoseguimiento del tema 2. No se califica y no hay que
entregarlo: las pruebas le dicen solas si va bien.

Son dos TAD y cada uno se implementa dos veces, primero con listas y después
con procedimientos. El ambiente es el que sostiene todo lo que viene después:
del tema 5 en adelante, cada intérprete que escriba va a pedirle a un ambiente
el valor de una variable. Las expresiones lambda son el primer tipo de dato
recursivo del curso y el antecedente directo de la sintaxis abstracta del
tema 3.

## De qué se trata

El ambiente tiene cuatro operaciones (EOPL, sección 2.2):

```
empty-env    : ()                    -> Env
extend-env   : Var × Val × Env       -> Env
apply-env    : Env × Var             -> Val
has-binding? : Env × Var             -> Bool
```

Las expresiones del cálculo lambda tienen once, tres por cada producción de la
gramática más los extractores de sus componentes (EOPL, sección 2.3):

```
<lc-exp> ::= <identifier>                      var-exp    (id)
         ::= (lambda (<identifier>) <lc-exp>)  lambda-exp (id, exp)
         ::= (<lc-exp> <lc-exp>)               app-exp    (rator, rand)
```

```
var-exp  lambda-exp  app-exp            los constructores
var-exp? lambda-exp? app-exp?           los predicados
var-exp->id  lambda-exp->id  lambda-exp->exp
app-exp->rator  app-exp->rand           los extractores
```

Cada TAD se implementa dos veces. Con listas el dato se puede imprimir y
mirar; con procedimientos el dato *es* una función y no hay nada que mirar,
porque la información vive en lo que la clausura capturó.

Las pruebas son las mismas para las dos versiones. Ahí está lo que hay que
ver: un TAD no es su representación, es lo que sus operaciones prometen. Si
las dos pasan la misma batería, quien las use no puede distinguirlas, y esa es
exactamente la libertad que da programar contra una interfaz.

## Cómo está organizado

```
src/ambiente-listas.rkt            puntos 1 y 2
src/ambiente-procedimientos.rkt    puntos 3 y 4
src/lambda-listas.rkt              puntos 5 y 6
src/lambda-procedimientos.rkt      puntos 7 y 8
pruebas/                           las pruebas, que no se modifican
verificar/                         las reglas del curso, que tampoco
```

## Cómo empezar

1. **Haga fork.** Botón *Fork* arriba a la derecha. El fork queda en su cuenta
   y usted trabaja ahí.

2. **Active las Actions.** Al hacer fork, GitHub deja los workflows apagados.
   Entre a la pestaña *Actions* de **su** fork y pulse el botón verde
   *I understand my workflows, go ahead and enable them*. Sin esto puede hacer
   todos los push que quiera y nunca se va a correr nada.

3. **Clone su fork:**

   ```bash
   git clone https://github.com/SU-USUARIO/flp-2026-2-tema-02-representacion-datos.git
   cd flp-2026-2-tema-02-representacion-datos
   ```

4. **Resuelva** los ocho puntos.

5. **Haga push.** Cada push dispara las pruebas.

## Cómo se ejecutan las pruebas

```bash
raco test pruebas/
```

O desde DrRacket, abriendo el archivo de pruebas que le interese y pulsando
*Ejecutar*. Si necesita instalar Racket, use la distribución completa de
[racket-lang.org](https://racket-lang.org): la mínima no trae `#lang eopl`.

## El punto de partida

Al clonar hay 80 pruebas: 4 en verde y 76 en rojo. Las verdes comprueban que
los cuatro módulos cargan y exportan sus operaciones, o sea que Racket y
`eopl` quedaron bien instalados. Las otras 76 están en rojo porque cada
operación dice `eopl:error 'sin-implementar`.

Repartidas por archivo: 24 pruebas para los ambientes, 11 por representación
más 2 de carga, y 56 para las expresiones lambda, 27 por representación más 2
de carga.

## Las reglas

- Los dos TAD se construyen, no se modifican: extender un ambiente devuelve
  otro ambiente y construir una expresión devuelve otra expresión. Sin `set!`
  ni ninguna otra asignación destructiva.
- Las funciones que recorren una expresión usan las once operaciones del TAD.
  Abrir la lista con `car` y `cadr` por fuera de los extractores funciona en el
  punto 6 y se cae en el punto 8, que es justo donde se ve si programó contra
  la interfaz o contra la representación.

Cada push corre `racket verificar/reglas.rkt` además de las pruebas. Revisa la
primera regla y de paso dice qué operaciones quedan sin escribir. Lee el código
como datos, así que los comentarios no disparan falsos positivos: escribir
`;; nada de set!` no cuenta como usar `set!`.

## Los ocho puntos

### 1. `empty-env`, `extend-env`, `apply-env` con listas

El ambiente es una lista de pares. `extend-env` construye uno nuevo en vez de
modificar el que recibió, y `apply-env` lanza un error con `eopl:error` cuando
la variable no está ligada.

La forma concreta del par la elige usted: las pruebas no la miran.

### 2. `has-binding?` con listas

Responde si la variable está ligada, sin fallar cuando no lo está.

### 3. `empty-env`, `extend-env`, `apply-env` con procedimientos

Aquí el ambiente es un procedimiento. `extend-env` devuelve uno que responde
por la variable que acaba de ligar y le pasa las demás preguntas al ambiente
anterior. Es la misma cadena de búsqueda de la versión con listas, solo que
armada con clausuras en vez de con `cons`.

### 4. `has-binding?` con procedimientos

El archivo trae una sugerencia: que el procedimiento reciba un mensaje además
de la variable. Con eso `apply-env` y `has-binding?` quedan de una línea cada
una. No es la única salida; si se le ocurre otra, sirve igual mientras las
pruebas pasen.

### 5. La interfaz de las expresiones lambda con listas

Los tres constructores, los tres predicados y los cinco extractores. Cada
expresión se representa como una lista que empieza por un símbolo que dice de
qué variante se trata:

```racket
(var-exp 'x)                  ; => (var-exp x)
(lambda-exp 'x (var-exp 'x))  ; => (lambda-exp x (var-exp x))
```

Los predicados miran ese primer símbolo y los extractores sacan la posición
que corresponde.

### 6. `occurs-free?` con listas

Responde si un identificador ocurre libre en una expresión, o sea si aparece
en alguna posición donde ninguna lambda que lo encierre lo tenga como
parámetro.

```racket
(occurs-free? (lambda-exp 'x (app-exp (var-exp 'p) (var-exp 'x))) 'x)  ; => #f
(occurs-free? (lambda-exp 'x (app-exp (var-exp 'p) (var-exp 'x))) 'p)  ; => #t
```

La recursión sigue la forma de la gramática: en una variable se compara, en
una abstracción se descarta el parámetro y se sigue por el cuerpo, en una
aplicación se pregunta por el operador y por el operando.

### 7. La misma interfaz con procedimientos

Ahora la expresión es un procedimiento que devuelve sus componentes cuando se
le pide. El archivo sugiere un selector numérico, que es como aparece en la
nota de clase, pero puede despachar por mensaje como en el punto 3.

### 8. `occurs-free?` con procedimientos

Cópiela del punto 6. Si allá la escribió contra la interfaz, entra aquí sin
cambiarle una letra y pasa las mismas pruebas aunque debajo no quede ni una
lista. Que se pueda copiar es todo lo que este tema quiere mostrar.

## Cuatro cosas que las pruebas revisan y suelen olvidarse

- **La ligadura más reciente tapa a la anterior.** Después de
  `(extend-env 'x 2 (extend-env 'x 1 (empty-env)))`, buscar `x` da 2.
- **Extender no altera lo que recibió.** Si guarda un ambiente en una variable
  y lo extiende, el original tiene que seguir respondiendo lo de antes. Con
  listas sale gratis; con procedimientos también, siempre que no intente ser
  astuto con `set!`.
- **El cuerpo de una abstracción es una expresión completa.**
  `lambda-exp->exp` devuelve algo a lo que se le puede volver a preguntar, no
  un identificador suelto.
- **La misma variable puede estar ligada de un lado y libre del otro.** En
  `((λx.x) x)`, la `x` del argumento ocurre libre aunque la del cuerpo no.

## Los nombres, si va a leer el libro

EOPL llama `var-exp->var`, `lambda-exp->bound-var` y `lambda-exp->body` a tres
de los extractores, y escribe `occurs-free?` con el identificador de primer
argumento. Aquí se dejaron los nombres y el orden de la nota de clase.
