:- encoding(utf8).
:- use_module(library(lists)).

% Motor independiente de los hechos concretos de la base.
% Conserva las firmas: listar_enfermedades/1, coincidencias/3,
% diagnostico/4, ranking_diagnosticos/2, explicar_diagnostico/2,
% diagnosticar/1.

% -------------------- Normalizacion de observaciones --------------------

sintoma_canonico(S0, S) :-
    sinonimo_sintoma(S0, S),
    !.
sintoma_canonico(S, S).

observacion(ausente(S0), ausente, S) :-
    ground(S0),
    atom(S0),
    sintoma_canonico(S0, S).
observacion(presente(S0), presente, S) :-
    ground(S0),
    atom(S0),
    sintoma_canonico(S0, S).
observacion(S0, presente, S) :-
    ground(S0),
    atom(S0),
    S0 \== presente,
    S0 \== ausente,
    sintoma_canonico(S0, S).

hallazgo_conocido(S) :-
    sintoma_de(S, _),
    !.
hallazgo_conocido(S) :-
    prueba_asociada(S, _),
    !.
hallazgo_conocido(S) :-
    categoria_sintoma(S, _),
    !.

% observaciones_analizadas(-Presentes, -Ausentes, -Desconocidos, -Contradicciones)
observaciones_analizadas(Obs, Presentes, Ausentes, Desconocidos, Contradicciones) :-
    (   is_list(Obs)
    ->  ObsList = Obs
    ;   ObsList = []
    ),
    findall(presente-S, (member(O, ObsList), observacion(O, presente, S)), Pres0),
    findall(ausente-S, (member(O, ObsList), observacion(O, ausente, S)), Aus0),
    findall(S, member(presente-S, Pres0), Pres1),
    findall(S, member(ausente-S, Aus0), Aus1),
    sort(Pres1, PresU),
    sort(Aus1, AusU),
    findall(S, (member(S, PresU), member(S, AusU)), Contr0),
    sort(Contr0, Contradicciones),
    subtract(PresU, Contradicciones, Presentes),
    subtract(AusU, Contradicciones, Ausentes),
    findall(S,
            (member(S, Presentes), \+ hallazgo_conocido(S)),
            Desc0),
    findall(S,
            (member(S, Ausentes), \+ hallazgo_conocido(S)),
            Desc1),
    append(Desc0, Desc1, Desc2),
    sort(Desc2, Desconocidos).

observaciones_presentes(Obs, Presentes) :-
    observaciones_analizadas(Obs, Presentes, _A, _D, _C).

% -------------------- Predicados publicos --------------------

listar_enfermedades(Enfermedades) :-
    (   setof(E, S^sintoma_de(S, E), Enfermedades)
    ->  true
    ;   Enfermedades = []
    ).

sintomas_registrados(Enfermedad, Sintomas) :-
    findall(S, sintoma_de(S, Enfermedad), L),
    sort(L, Sintomas).

pruebas_registradas(Enfermedad, Pruebas) :-
    findall(P, prueba_asociada(P, Enfermedad), L),
    sort(L, Pruebas).

% coincidencias/3: sintomas clinicos presentes que estan registrados
% para la enfermedad. Sin duplicados. No usa ausencias ni pruebas.
coincidencias(SintomasObservados, Enfermedad, Coincidencias) :-
    observaciones_presentes(SintomasObservados, Presentes),
    findall(S, (sintoma_de(S, Enfermedad), member(S, Presentes)), L),
    sort(L, Coincidencias).

coincidencias_pruebas(SintomasObservados, Enfermedad, Coincidencias) :-
    observaciones_presentes(SintomasObservados, Presentes),
    findall(P, (prueba_asociada(P, Enfermedad), member(P, Presentes)), L),
    sort(L, Coincidencias).

clasificar_coincidencias([], [], []).
clasificar_coincidencias([S|Resto], Ines, Orien) :-
    clasificar_coincidencias(Resto, Ines0, Orien0),
    (   categoria_sintoma(S, orientativo)
    ->  Ines = Ines0,
        Orien = [S|Orien0]
    ;   Ines = [S|Ines0],
        Orien = Orien0
    ).

diagnostico(SintomasObservados, Enfermedad, NumCoincidencias, Coincidencias) :-
    listar_enfermedades(Enfermedades),
    (   var(Enfermedad)
    ->  member(Enfermedad, Enfermedades)
    ;   memberchk(Enfermedad, Enfermedades)
    ),
    coincidencias(SintomasObservados, Enfermedad, Coincidencias),
    length(Coincidencias, NumCoincidencias),
    NumCoincidencias > 0.

ranking_diagnosticos(SintomasObservados, Ranking) :-
    findall(
        NumCoincidencias-Enfermedad-Coincidencias,
        diagnostico(SintomasObservados, Enfermedad, NumCoincidencias, Coincidencias),
        Resultados
    ),
    predsort(comparar_ranking, Resultados, Ranking).

% Coincidencias descendentes; empate tecnico por identificador A-Z.
% El orden alfabetico estabiliza la salida, no expresa superioridad clinica.
comparar_ranking(Orden, N1-E1-_, N2-E2-_) :-
    compare(OrdenN, N2, N1),
    (   OrdenN == (=)
    ->  compare(Orden, E1, E2)
    ;   Orden = OrdenN
    ).

% -------------------- Reglas (un paso, sin ciclos) --------------------

premisas_satisfechas(Premisas, Presentes, Ausentes) :-
    Premisas \== [],
    forall(member(P, Premisas), member(P, Presentes)),
    \+ (member(P, Premisas), member(P, Ausentes)).

regla_activada(Obs, Id, Enfermedad, Premisas, Conclusion, Justificacion, FuenteId) :-
    observaciones_analizadas(Obs, Presentes, Ausentes, _D, _C),
    regla(Id, Enfermedad, Premisas, Conclusion, Justificacion, FuenteId),
    premisas_satisfechas(Premisas, Presentes, Ausentes).

reglas_activadas(Obs, Reglas) :-
    findall(
        regla_disparada(Id, Enfermedad, Premisas, Conclusion, Justificacion, FuenteId),
        regla_activada(Obs, Id, Enfermedad, Premisas, Conclusion, Justificacion, FuenteId),
        L
    ),
    sort(L, Reglas).

reglas_de_enfermedad(Obs, Enfermedad, Reglas) :-
    reglas_activadas(Obs, Todas),
    findall(R,
            (member(R, Todas), R = regla_disparada(_, Enfermedad, _, _, _, _)),
            Reglas).

info_insuficiente(Obs) :-
    \+ diagnostico(Obs, _, _, _),
    \+ regla_activada(Obs, _, _, _, _, _, _).

sintomas_no_reportados(Obs, Enfermedad, Faltantes) :-
    observaciones_analizadas(Obs, Presentes, Ausentes, _D, Contr),
    sintomas_registrados(Enfermedad, Registrados),
    findall(S,
            (member(S, Registrados),
             \+ member(S, Presentes),
             \+ member(S, Ausentes),
             \+ member(S, Contr)),
            Faltantes).

sintomas_ausentes_registrados(Obs, Enfermedad, AusentesEnf) :-
    observaciones_analizadas(Obs, _P, Ausentes, _D, _C),
    sintomas_registrados(Enfermedad, Registrados),
    findall(S, (member(S, Ausentes), member(S, Registrados)), L),
    sort(L, AusentesEnf).

nombre_mostrado(Enfermedad, Nombre) :-
    (   nombre_enfermedad(Enfermedad, Nombre)
    ->  true
    ;   Nombre = Enfermedad
    ).

porcentaje_coincidencia(Num, Total, Porcentaje) :-
    integer(Total),
    Total > 0,
    Porcentaje is round((Num / Total) * 100).

% -------------------- Explicacion --------------------

explicar_diagnostico(SintomasObservados, Enfermedad) :-
    coincidencias(SintomasObservados, Enfermedad, Coincidencias),
    coincidencias_pruebas(SintomasObservados, Enfermedad, PruebasCoin),
    sintomas_registrados(Enfermedad, TodosSintomas),
    length(Coincidencias, NumCoinc),
    length(TodosSintomas, TotalSintomas),
    nombre_mostrado(Enfermedad, Nombre),
    clasificar_coincidencias(Coincidencias, Ines, Orien),
    reglas_de_enfermedad(SintomasObservados, Enfermedad, Reglas),
    sintomas_no_reportados(SintomasObservados, Enfermedad, Faltantes),
    sintomas_ausentes_registrados(SintomasObservados, Enfermedad, AusEnf),
    format('~n--- Enfermedad: ~w ---~n', [Nombre]),
    format('Identificador: ~w~n', [Enfermedad]),
    (   TotalSintomas > 0
    ->  porcentaje_coincidencia(NumCoinc, TotalSintomas, Porcentaje),
        format('Coincidencias: ~w de ~w sintomas clinicos registrados.~n',
               [NumCoinc, TotalSintomas]),
        format('Porcentaje de coincidencia: ~w% (no es probabilidad clinica).~n',
               [Porcentaje])
    ;   format('Coincidencias: ~w. No hay sintomas clinicos registrados.~n', [NumCoinc])
    ),
    format('Sintomas coincidentes: ~w~n', [Coincidencias]),
    format('  Inespecificos: ~w~n', [Ines]),
    format('  Orientativos: ~w~n', [Orien]),
    format('Pruebas diagnosticas coincidentes: ~w~n', [PruebasCoin]),
    (   PruebasCoin \== []
    ->  format('  Nota: una prueba no se computa como un sintoma clinico equivalente.~n', [])
    ;   true
    ),
    (   Reglas == []
    ->  format('Reglas clinicas activadas: ninguna.~n', []),
        format('  El resultado describe compatibilidad de sintomas, no un diagnostico confirmado.~n', [])
    ;   format('Reglas clinicas activadas:~n', []),
        forall(member(regla_disparada(Id, _, Premisas, Conclusion, Just, FuenteId), Reglas),
               explicar_regla(Id, Premisas, Conclusion, Just, FuenteId))
    ),
    format('Sintomas registrados no reportados (no implica ausencia): ~w~n', [Faltantes]),
    format('Sintomas registrados marcados como ausentes: ~w~n', [AusEnf]),
    format('Limitaciones: no sustituye la evaluacion veterinaria; ', []),
    format('un hallazgo no reportado no se trata como ausente; ', []),
    format('el porcentaje de coincidencia no es una probabilidad clinica.~n', []),
    !.

explicar_regla(Id, Premisas, Conclusion, Just, FuenteId) :-
    format('  - ~w~n', [Id]),
    format('    Premisas: ~w~n', [Premisas]),
    format('    Conclusion: ~w~n', [Conclusion]),
    format('    Justificacion: ~w~n', [Just]),
    (   fuente_conocimiento(FuenteId, Ref)
    ->  format('    Fuente: ~w~n', [Ref])
    ;   format('    Fuente: ~w~n', [FuenteId])
    ).

% -------------------- Utilidad y punto de entrada --------------------

top_n(Lista, N, Top) :-
    integer(N),
    N >= 0,
    length(Lista, Len),
    (   Len =< N
    ->  Top = Lista
    ;   length(Top, N),
        append(Top, _, Lista)
    ).

hipotesis_empatadas(Ranking, MejorN, Empatadas) :-
    (   Ranking = [MejorN-_-_|_]
    ->  findall(E, member(MejorN-E-_, Ranking), Empatadas)
    ;   MejorN = 0,
        Empatadas = []
    ).

diagnosticar(SintomasObservados) :-
    observaciones_analizadas(SintomasObservados, _P, _A, Desconocidos, Contradicciones),
    ranking_diagnosticos(SintomasObservados, Ranking),
    reglas_activadas(SintomasObservados, Reglas),
    format('~n=== RESULTADOS DEL MOTOR DE INFERENCIA ===~n', []),
    format('Las hipotesis se ordenan por compatibilidad de sintomas, no por probabilidad.~n', []),
    (   Contradicciones == []
    ->  true
    ;   format('Evidencias contradictorias (presente y ausente a la vez): ~w~n',
               [Contradicciones]),
        format('  Esos hallazgos se excluyen de la inferencia hasta resolver la contradiccion.~n', [])
    ),
    (   Desconocidos == []
    ->  true
    ;   format('Sintomas desconocidos para la base: ~w~n', [Desconocidos])
    ),
    (   SintomasObservados == []
    ->  format('Lista de sintomas vacia: no hay evidencia positiva que evaluar.~n', [])
    ;   true
    ),
    (   Ranking == []
    ->  format('~nNo hay coincidencias clinicas con las enfermedades registradas.~n', [])
    ;   top_n(Ranking, 3, Top3),
        length(Top3, CantidadTop),
        format('Se muestran hasta ~w hipotesis, ordenadas por coincidencias y, en empate, A-Z.~n',
               [CantidadTop]),
        forall(
            member(_-Enfermedad-_, Top3),
            explicar_diagnostico(SintomasObservados, Enfermedad)
        ),
        (   member(regla_disparada(_, EnfFuera, _, _, _, _), Reglas),
            \+ member(_-EnfFuera-_, Top3)
        ->  format('Aviso: se activo al menos una regla clinica asociada a una hipotesis fuera del top 3.~n', [])
        ;   true
        )
    ),
    (   Reglas == []
    ->  format('~nNinguna regla clinica se activo. No hay conclusiones inferidas.~n', [])
    ;   format('~nConclusiones inferidas (separadas de los hechos originales):~n', []),
        forall(member(regla_disparada(Id, Enf, _, Conclusion, _, _), Reglas),
               format('  ~w sobre ~w => ~w~n', [Id, Enf, Conclusion]))
    ),
    (   info_insuficiente(SintomasObservados)
    ->  format('Informacion insuficiente para plantear una hipotesis fundada.~n', [])
    ;   true
    ),
    format('~nConsulte siempre a un veterinario. Este motor no confirma diagnosticos.~n', []).
