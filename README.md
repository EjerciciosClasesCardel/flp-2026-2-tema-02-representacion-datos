# Tema 2 — Ambientes: dos representaciones del mismo TAD

Fundamentos de Interpretación y Compilación de Lenguajes de Programación
Escuela de Ingeniería de Sistemas y Computación, Universidad del Valle
Carlos Andrés Delgado Saavedra

Ejercicio de autoseguimiento del tema 2. No se califica y no hay que
entregarlo: las pruebas le dicen solas si va bien.

El ambiente es el TAD que sostiene todo lo que viene después. Del tema 5 en
adelante, cada intérprete que escriba va a pedirle a un ambiente el valor de
una variable, y conviene tenerlo resuelto y entendido antes de esa clase.

## De qué se trata

Va a implementar la misma interfaz dos veces (EOPL, sección 2.2):

```
empty-env    : ()                    -> Env
extend-env   : Var × Val × Env       -> Env
apply-env    : Env × Var             -> Val
has-binding? : Env × Var             -> Bool
```

Primero con listas, donde el ambiente es un dato que se puede imprimir y
mirar. Después con procedimientos, donde el ambiente *es* una función y no hay
nada que mirar: la información vive en lo que la clausura capturó.

Las pruebas son las mismas para las dos. Ahí está lo que hay que ver: un TAD
no es su representación, es lo que sus operaciones prometen. Si las dos
versiones pasan la misma batería, quien las use no puede distinguirlas, y esa
es exactamente la libertad que da programar contra una interfaz.

## Cómo está organizado

```
src/ambiente-listas.rkt           puntos 1 y 2
src/ambiente-procedimientos.rkt   puntos 3 y 4
pruebas/ambientes-pruebas.rkt     las pruebas, que no se modifican
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
   git clone https://github.com/SU-USUARIO/flp-2026-2-tema-02-ambientes.git
   cd flp-2026-2-tema-02-ambientes
   ```

4. **Resuelva** los cuatro puntos.

5. **Haga push.** Cada push dispara las pruebas.

## Cómo se ejecutan las pruebas

```bash
raco test pruebas/
```

O desde DrRacket, abriendo `pruebas/ambientes-pruebas.rkt` y pulsando
*Ejecutar*. Si necesita instalar Racket, use la distribución completa de
[racket-lang.org](https://racket-lang.org): la mínima no trae `#lang eopl`.

## El punto de partida

Al clonar hay 24 pruebas: 2 en verde y 22 en rojo. Las verdes comprueban que
los dos módulos cargan y exportan las cuatro operaciones, o sea que Racket y
`eopl` quedaron bien instalados.

## Los cuatro puntos

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

## Dos cosas que las pruebas revisan y suelen olvidarse

- **La ligadura más reciente tapa a la anterior.** Después de
  `(extend-env 'x 2 (extend-env 'x 1 (empty-env)))`, buscar `x` da 2.
- **Extender no altera lo que recibió.** Si guarda un ambiente en una variable
  y lo extiende, el original tiene que seguir respondiendo lo de antes. Con
  listas sale gratis; con procedimientos también, siempre que no intente ser
  astuto con `set!`.
