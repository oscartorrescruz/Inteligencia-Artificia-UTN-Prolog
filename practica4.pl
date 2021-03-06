% 1. Hacer un programa que permita definir las cuentas a pagar del mes (luz, agua, alquiler,
% teléfono, cable, supermercado, etc.) de un grupo de personas.
% A su vez, deberá permitir ingresar el nombre de una de ellas e informar de todos sus gastos.
% calcular gasto mensual promedio por persona
% cuenta(matias,luz,mes,2000).

guardar :-
  tell('./db/cuentas-db.pl'),
  listing(cuenta),
  told.

abrir :-
  retractall(cuenta(_,_,_,_)),
  consult('./db/cuentas-db.pl').

% Listar cuentas a pagar por una persona
opcion(1) :-
  writeln('Nombre:'),
  read(Persona),
  writeln('Servicio:'),
  read(Servicio),
  writeln('Mes (num):'),
  read(Mes),
  writeln('Monto:'),
  read(Monto),
  assertz(cuenta(Persona,Mes,Servicio,Monto)).

opcion(2) :-
  writeln('Nombre:'),
  read(Persona),
  writeln('Mes (num):'),
  read(Mes),
  pago_mensual(Persona,Mes,S,_),
  writeln(S).

opcion(3) :-
  writeln('Nombre:'),
  read(Persona),
  writeln('Mes (num):'),
  read(Mes),
  pago_mensual(Persona,Mes,S,C),
  P is S/C,
  writeln(P).

opcion(4) :-
  guardar.

menu :-
  abrir,
  format('~t<-oO MENU Oo->~t~72|~n~n'),
  format('Opciones:
    0  Salir y Guardar.
    1  Agregar cuenta
    2  Listar cuentas a pagar en un mes por una persona.
    3  Listar gasto mensul promedio para una persona.
    4  Guardar.
  '),
  read(OPC),
  format('Opcion elegida: [~w] ~n', [OPC]),
  OPC \= 0,
  opcion(OPC), nl,
  menu.

menu :-
  writeln('adios'),
  guardar,
  halt.

pago_mensual(Nombre,Mes,S,C) :-
  retract(cuenta(Nombre,Mes,_,I)),
  pago_mensual(Nombre,Mes,SP,CP),
  S is SP + I,
  C is CP + 1.
pago_mensual(_,_,0,0).


% 2. Hacer un programa que defina una Base de datos de personas de la
% siguiente forma:
% personas(codigo,nombre,edad).
% El programa debe permitir ingresar un código y verificar si el mismo está
% definido en la BBDD. De estarlo deberá informar a quién corresponde, de lo
% contrario deberá solicitar ingresar un nombre y registrar entonces la persona en la BBDD.
% a. Dada una edad devolver una lista con los nombres que tenga una edad mayor ala dada

% persona(cod,mombre,edad).

lista_x_edad(E) :-
  lista_x_edad(E,Rta),
  write(Rta).

lista_x_edad(E,[H|T]) :-
  persona(_,H,EP),
  EP > E,
  retract(persona(_,H,EP)),
  lista_x_edad(E,T).

lista_x_edad(_,[]).

abrir_db_personas :-
  retractall(persona(_,_,_)),
  consult('./db/personas-db.pl').

buscar(Cod) :-
  abrir_db_personas,
  persona(Cod,Nombre,_),
  writeln(Nombre).
buscar(Cod) :-
  writeln('No esta'),
  writeln('Nombre:'),
  read(Nombre),
  writeln('Edad:'),
  read(Edad),
  assertz(persona(Cod,Nombre,Edad)),
  tell('./db/personas-db.pl'),
  listing(persona),
  told.

% 3. Desarrollar un programa que permita definir los hábitos de:
%      • alimentación (comida, cantidad)
%      • bebida (bebida, cantidad)
%      • reproducción (época de reproducción, período de gestación)
%      • horas de sueño
%
% de un conjunto de animales de un Zoo.
% Dicha información se guardará en una base de datos.
% El programa, deberá permitir:

% alimentacion(comida, cantidad)
% bebida(bebida, cantidad)
% reproduccion(epoca,gestacion)
% horas_sueno(horas)

guardarAnimalesDB :-
  tell('./db/animales-db.pl'),
  listing(animal),
  told.

abrirAnimalesDB :-
  retractall(animal(_, _)),
  consult('./db/animales-db.pl').

% a. Ingresar el nombre de un animal e informar de todos sus hábitos.
datos_animal(Animal) :-
  animal(Animal, Functor),
  writeln(Functor),
  retract(animal(Animal, Functor)),
  datos_animal(Animal).
datos_animal(_) :-
  abrirAnimalesDB.

% b. Ingresar un hábito e informar todos los animales que lo tienen.
% habito_animal(bebida(_, _)).
habito_animal(Habito) :-
  animal(Animal, Habito),
  writeln([Animal, Habito]),
  retract(animal(Animal, Habito)),
  fail.
habito_animal(_) :-
  abrirAnimalesDB.

% c) Listar los animales que tenga almenos dos habitos de alimentacion distintos
list_animlaes_habitos() :-
  animal(Animal, alimentacion(_, _)),
  retractall(animal(Animal, alimentacion(_, _))),
  writeln(Animal),
  list_animlaes_habitos().
list_animlaes_habitos() :-
  abrirAnimalesDB.

% d) Dado un animal cuantos habitos de reproduccion tiene
datos_reproduccion(Animal, Count) :-
  animal(Animal, reproduccion(Epoca, Periodo)),
  retract(animal(Animal, reproduccion(_, _))),
  writeln([Animal,Epoca,Periodo]),
  datos_reproduccion(Animal, C),
  Count is C + 1.
datos_reproduccion(_, 0) :-
  abrirAnimalesDB.

% 4. Ampliar el ejercicio 1 a través del uso de functores. Por ejemplo:
%   gasto(maria, super(coto,500)).
%   gasto(omar, tel(fijo,telecom,150)).
%   gasto(maria,tel(movil,personal,100)).
abrirEj4 :-
  retractall(gasto(_, _)),
  consult('./db/gastos-db.pl').
guardarEj4 :-
  tell('./db/gastos-db.pl'),
  listing(gasto),
  told.

% a. Ingresar un gasto (por ej. super) e informar todas las personas que
% tienen dicho gasto.
list_personas_con_gasto(Gasto) :-
  gasto(Persona, Gasto),
  writeln([Persona, Gasto]),
  retract(gasto(Persona, _)),
  fail.
list_personas_con_gasto(_) :-
  abrirEj4.

% XXX:Nota Conosco los echos, aridad  y fus functores de ante mano?
% b. Informar las personas que tienen un consumo superior a los $150 en un
% cierto gasto (dato de entrada).
% list_personas_gato_mayor_150(tel(_, _, _)).
list_personas_gato_mayor_150(Gasto) :-
  % functor(Gasto, A, B), writeln([Gasto, A, B]),
  gasto(Persona, Gasto),
  get_cost(Gasto, Cost),
  Cost > 150,
  writeln(Persona),
  retract(gasto(Persona, Gasto)),
  fail.
list_personas_gato_mayor_150(_) :-
  abrirEj4.

/*
get_cost(Gasto, Cost) :-
  functor(Gasto, F, A),
  A1 is A - 1,
  arg(Gasto, A1, Cost).
*/
get_cost(luz(_, Cost), Cost).
get_cost(gas(_, Cost), Cost).
get_cost(super(_, Cost), Cost).
get_cost(tel(_, _, Cost), Cost).

get_persona_gasto(Gasto, Persona) :-
  gasto(Persona, Gasto),
  writeln(Persona),
  retractall(gasto(Persona, _)),
  get_persona_gasto(_, Persona),
  fail.

get_persona_gasto(_, _) :-
  abrirEj4.

% XXX:Nota Conosco los echos y fus functores de ante mano?
% c. Calcular gasto promedio para una determinada persona (dato de entrada).
calc_avg_for_person(Persona) :-
  calc_avg_for_person(Persona, Cost, Count),
  Avg is Cost rdiv Count,
  format('~w gasta en promedio ~4f', [Persona, Avg]).

calc_avg_for_person(Persona, Cost, Length) :-
  gasto(Persona, Gasto),
  get_cost(Gasto, Cost1),
  retractall(gasto(Persona, Gasto)),
  calc_avg_for_person(Persona, Cost2, Length1),
  Cost is Cost2 + Cost1,
  Length is Length1 + 1.
calc_avg_for_person(_, 0, 0) :-
  abrirEj4.


% 5. Hacer un programa que permita realizar altas, bajas y consultas a la base
% de datos de una librería. De cada libro se registran los siguientes datos:
%   • Nro. de libro (auto numérico)
%   • Titulo
%   • Autor
%   • Editorial
%   • Precio
%
% La base datos debe guardarse en disco.
% Calcular además el precio promedio de los libros de un determinado autor.

open_libreriaDB :-
  retractall(libro(_,_,_,_,_)),
  consult('./db/libreria-db.pl').
save_libreriaDB :-
  tell('./db/libreria-db.pl'),
  listing(libro),
  told.

avg_price_by_autor(Autor, AvgCost) :-
  avg_price_by_autor(Autor, Cost, CountBook),
  AvgCost is Cost rdiv CountBook,
  open_libreriaDB.
avg_price_by_autor(Autor, Cost, CountBook) :-
  libro(_, _, Autor, _, Price),
  retract(libro(_, _, Autor, _, Price)),
  avg_price_by_autor(Autor, C, CB),
  CountBook is CB + 1,
  Cost is C + Price.
avg_price_by_autor(_, 0, 0).


libreria :-
  format('~n~t<-oO Libreria ABC Oo->~t~72|~n'),
  format('Opciones:
    0  Salir.
    1  Alta libro.
    2  Baja libro.
    3  Consulta.
  '),
  read(OPC),
  format('Opcion elegida: [~w] ~n', [OPC]),
  OPC \= 0,
  libreria_option(OPC), nl,
  libreria.

libreria :-
  writeln('¿Desea guardar los cambios [s/n]?'),
  read(OPC),
  format('Opcion elegida: [~w] ~n', [OPC]),
  OPC \= n,
  libreria_option(4),
  halt.

libreria :-
  writeln('Adios'),
  halt.

% 1  Alta libro.
libreria_option(1) :-
  writeln('NOTA: No usar mayuscula.'),
  writeln('Titulo:'),
  read(Title),
  writeln('Autor:'),
  read(Autor),
  writeln('Editorial:'),
  read(Editorial),
  writeln('Precio:'),
  read(Price),
  add_book(Title, Autor, Editorial, Price).

% 2  Baja libro.
libreria_option(2) :-
  writeln('¿Conoce el ID del libro? [s/n]'),
  read(OPC),
  format('Opcion elegida: [~w] ~n', [OPC]),
  OPC \= n,
  writeln('ID del libro a borrar:'),
  read(ID),
  retract(libro(ID, _, _, _, _)),
  save_libreriaDB,
  writeln('Libro borrado.').
libreria_option(2) :-
  writeln('[INFO] En el menu consulta puedes obtener el ID.').

% 3  Consulta.
libreria_option(3) :-
  format('Por que atributo quieres buscar:
    0 Salir al menu.
    1 Nro. de libro (ID).
    2 Titulo.
    3 Autor.
    4 Editorial.
    5 Precio.
  '),
  read(OPC),
  format('Opcion elegida: [~w] ~n', [OPC]),
  OPC \= 0,
  libreria_option_submenu(3, OPC).
libreria_option(3). % Evita que falle el menu

% 4  Guardar.
libreria_option(4) :-
  save_libreriaDB,
  writeln('Guardado con exito...').

% 1 Nro. de libro (ID).
libreria_option_submenu(3, 1) :-
  writeln('ID del libro:'),
  read(ID),
  show_book(ID, _, _, _, _).
% 2 Titulo.
libreria_option_submenu(3, 2) :-
  writeln('Titulo:'),
  read(T),
  show_book(_, T, _, _, _).
% 3 Autor.
libreria_option_submenu(3, 3) :-
  writeln('Autor:'),
  read(A),
  show_book(_, _, A, _, _).
% 4 Editorial.
libreria_option_submenu(3, 4) :-
  writeln('Editorial:'),
  read(E),
  show_book(_, _, _, E, _).
% 5 Precio.
libreria_option_submenu(3, 5) :-
  writeln('Precio:'),
  read(P),
  show_book(_, _, _, _, P).

show_book(ID, T, A, E, P) :-
  libro(ID, T, A, E, P),
  format('
  Detalles del libro:
  =============================
  1 Nro. de libro:  ~w
  2 Titulo:         ~w
  3 Autor:          ~w
  4 Editorial:      ~w
  5 Precio:         ~2f
  -----------------------------
  ', [ID, T, A, E, P]),
  retract(libro(ID, T, A, E, P)),
  fail.

show_book(_, _, _, _, _) :-
  open_libreriaDB.

add_book(Title, Autor, Editorial, Price) :-
  count_book(Count),
  ID is Count + 1,
  assertz(libro(ID, Title, Autor, Editorial, Price)),
  save_libreriaDB.

count_book(Count) :-
  libro(ID, _, _, _, _),
  retract(libro(ID, _, _, _, _)),
  count_book(C),
  Count is C + 1.
count_book(0) :-
  open_libreriaDB.

% 6. Hacer un programa que permita registrar en una Base de Datos recetas
% de cocina. De cada receta se registran los siguientes datos:
%       • Código de receta
%       • Nombre de la receta
% Y por cada ingrediente que contenga la receta:
%       • Nombre del ingrediente
%       • Cantidad
% A su vez, permitir ingresar dos (2) ingredientes e informar de todas las
% recetas (Código y Nombre) que poseen ambos ingredientes.
%
% Por otro lado, para un ingrediente en particular y una cierta cantidad del
% mismo, determinar aquellas recetas que llevan ese ingrediente y NO superan
% dicha cantidad.

abrir_recetasDB :-
  retractall(receta(_, _, _)),
  consult('./db/recetas-db.pl').
guardar_recetasDB :-
  tell('./db/recetas-db.pl'),
  listing(receta(_, _, _)),
  told.

add_receta() :-
  aggregate_all(count, receta(_, _, _), Count),
  Cod is Count + 1,
  writeln('Nombre'),
  read(Nombre),
  add_ingredientes(List),
  writeln([Cod, Nombre, List]),
  assertz(receta(Cod, Nombre, List)),
  guardar_recetasDB.

add_ingredientes([ingrediente(Ing, Cant)|List]) :-
  writeln('¿Agregar ingrediente? [s/n]'), read(Opc),
  Opc \= n,
  writeln('Ingrediente:'), read(Ing),
  writeln('Cantidad:'), read(Cant),
  add_ingredientes(List).
add_ingredientes([]).

pertenece(Ele, [Ele|_]).
pertenece(Ele, [_|List]) :-
  pertenece(Ele, List).

recetas_con_ingretiente() :-
  writeln('Ingrediente:'), read(Ing),
  writeln('Cantidad:'), read(Cant),
  recetas_con_ingretiente(Ing, Cant).
recetas_con_ingretiente(Ing, Cant) :-
  receta(Cod, Nombre, Ingredientes),
  pertenece(ingrediente(Ing, Cant), Ingredientes),
  writeln([Cod, Nombre, Ingredientes]),
  retract(receta(Cod, _, _)),
  fail.
recetas_con_ingretiente(_, _) :-
  abrir_recetasDB.

recetas_con_ingretientes() :-
  writeln('1) Ingrediente:'), read(Ing1),
  writeln('1) Cantidad:'), read(Cant1),
  writeln('2) Ingrediente:'), read(Ing2),
  writeln('2) Cantidad:'), read(Cant2),
  recetas_con_ingretiente(Ing1, Cant1, Ing2, Cant2).

recetas_con_ingretiente(Ing1, Cant1, Ing2, Cant2) :-
  receta(Cod, Nombre, Ingredientes),
  pertenece(ingrediente(Ing1, Cant1), Ingredientes),
  pertenece(ingrediente(Ing2, Cant2), Ingredientes),
  writeln([Cod, Nombre, Ingredientes]),
  retract(receta(Cod, _, _)),
  fail.
recetas_con_ingretiente(_, _, _, _) :-
  abrir_recetasDB.

recetas_para_hacer() :-
  writeln('Ingrediente:'), read(Ing),
  writeln('Cantidad:'), read(Cant),
  recetas_con_ingretiente_menos(Ing, Cant).
recetas_con_ingretiente_menos(Ing, Cant) :-
  receta(Cod, Nombre, Ingredientes),
  pertenece(ingrediente(Ing, _), Ingredientes),
  format('
  Detalles de la receta
  =============================
  Cod:    ~w
  Nombre: ~w
  Ingredientes:
  ~w
  -----------------------------
  ', [Cod, Nombre, Ingredientes]),
  comprobar_cantidad(Cant, Ingredientes),
  retract(receta(Cod, _, _)),
  fail.
recetas_con_ingretiente_menos(_, _) :-
  abrir_recetasDB.
comprobar_cantidad(Cant, [Ingrediente|_]) :-
  ingrediente(_, IngC) = Ingrediente,
  IngC =< Cant.
comprobar_cantidad(Cant, [_|T]) :-
  comprobar_cantidad(Cant, T).
comprobar_cantidad(_, []) :-
  % writeln('No hay recetas :('),
  fail.

% ------------------------------------------------------------------------ %
% Para tener todas la DB cargas desdel el principo
openAllDB :-
  write('Open all DB...'),
  abrir,
  abrir_db_personas,
  abrirAnimalesDB,
  abrirEj4,
  open_libreriaDB,
  abrir_recetasDB,
  writeln('OK.').
?- openAllDB.

% ?- functor(T,N,3), T =.. List.
% ?- functor(T, tel, 3), gasto(matias,T).
%
% add(X,Y,Sum):- Sum is X+Y.
% sum(Xs,Sum):- foldl(add,Xs,0,Sum).
%
% ?- sum([1,2,3],S). % S = 6.
