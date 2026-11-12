:- encoding(utf8).
:- use_module(library(plunit)).

% Ejecutar desde la carpeta del proyecto:
%   swipl -q -s Vetia.pl -s pruebas.pl -g "run_tests,halt" -t "halt(1)"

:- begin_tests(vetia).

enfermedades_esperadas([
    diabetes_mellitus,
    erliquiosis_canina,
    gastritis_cronica,
    hepatitis_canina_infecciosa,
    insuficiencia_renal_cronica,
    leishmaniosis_canina,
    leptospirosis,
    moquillo_canino,
    parvovirus_canino,
    rabia,
    tos_de_las_perreras
]).

test(listado_11_sin_duplicados) :-
    listar_enfermedades(Enfermedades),
    enfermedades_esperadas(Esperadas),
    Enfermedades == Esperadas,
    length(Enfermedades, 11),
    sort(Enfermedades, Unicas),
    Unicas == Enfermedades.

test(coincidencias_correctas) :-
    coincidencias([diarrea_con_sangre, vomito, letargo, letargo],
                  parvovirus_canino, C),
    C == [diarrea_hemorragica, letargo, vomito].

test(coincidencias_sinonimo_historico) :-
    coincidencias([edema_corneal_ojo_azul, fiebre_elevada],
                  hepatitis_canina_infecciosa, C),
    C == [edema_corneal, fiebre].

test(ranking_descendente) :-
    ranking_diagnosticos([polidipsia, poliuria, polifagia, perdida_peso], Ranking),
    Ranking = [N1-diabetes_mellitus-C1|_Resto],
    N1 =:= 4,
    C1 == [perdida_peso, polidipsia, polifagia, poliuria],
    forall(append(_, [A-_-_, B-_-_|_], Ranking), A >= B).

test(empates_entre_enfermedades) :-
    ranking_diagnosticos([fiebre], Ranking),
    Ranking == [1-erliquiosis_canina-[fiebre],
                1-hepatitis_canina_infecciosa-[fiebre],
                1-leptospirosis-[fiebre],
                1-moquillo_canino-[fiebre],
                1-parvovirus_canino-[fiebre]],
    hipotesis_empatadas(Ranking, 1, Empatadas),
    length(Empatadas, 5).

test(un_solo_sintoma) :-
    coincidencias([edema_corneal], hepatitis_canina_infecciosa, C),
    C == [edema_corneal],
    ranking_diagnosticos([edema_corneal], Ranking),
    Ranking = [1-hepatitis_canina_infecciosa-[edema_corneal]].

test(lista_sintomas_vacia) :-
    ranking_diagnosticos([], []),
    \+ diagnostico([], _, _, _),
    info_insuficiente([]),
    reglas_activadas([], []).

test(sintomas_desconocidos) :-
    observaciones_analizadas([sintoma_inventado_xyz], Presentes, [],
                             [sintoma_inventado_xyz], []),
    Presentes == [sintoma_inventado_xyz],
    ranking_diagnosticos([sintoma_inventado_xyz], []),
    info_insuficiente([sintoma_inventado_xyz]).

test(sintomas_confirmados_ausentes) :-
    observaciones_analizadas([ausente(fiebre), tos_seca_paroxistica, arcadas_post_tos],
                             Presentes, Ausentes, [], []),
    Presentes == [arcadas_post_tos, tos_seca_paroxistica],
    Ausentes == [fiebre],
    coincidencias([ausente(fiebre), tos_seca_paroxistica, arcadas_post_tos],
                  hepatitis_canina_infecciosa, []),
    coincidencias([ausente(fiebre), tos_seca_paroxistica, arcadas_post_tos],
                  tos_de_las_perreras, [arcadas_post_tos, tos_seca_paroxistica]),
    reglas_activadas([ausente(fiebre), tos_seca_paroxistica, arcadas_post_tos], Reglas),
    memberchk(regla_disparada(r_cirdc_tos_paroxistica, tos_de_las_perreras, _, _, _, _),
              Reglas).

test(evidencias_contradictorias) :-
    observaciones_analizadas([fiebre, ausente(fiebre), vomito],
                             Presentes, Ausentes, [], [fiebre]),
    Presentes == [vomito],
    Ausentes == [],
    coincidencias([fiebre, ausente(fiebre)], hepatitis_canina_infecciosa, []).

test(ausencia_de_conclusiones_sin_reglas) :-
    reglas_activadas([pelaje_opaco], []),
    ranking_diagnosticos([pelaje_opaco], Ranking),
    Ranking \== [],
    \+ regla_activada([pelaje_opaco], _, _, _, _, _, _).

test(explicaciones_coherentes_con_inferencias) :-
    Obs = [diarrea_hemorragica, vomito, letargo],
    reglas_activadas(Obs, Reglas),
    memberchk(regla_disparada(r_cpv_enteritis_aguda, parvovirus_canino,
                              [diarrea_hemorragica, vomito, letargo],
                              hipotesis_compatible(parvovirus_canino), _, _),
              Reglas),
    with_output_to(string(Texto), explicar_diagnostico(Obs, parvovirus_canino)),
    sub_string(Texto, _, _, _, "parvovirus_canino"),
    sub_string(Texto, _, _, _, "r_cpv_enteritis_aguda"),
    sub_string(Texto, _, _, _, "Porcentaje de coincidencia"),
    sub_string(Texto, _, _, _, "no es probabilidad clinica"),
    !.

test(enfermedad_nueva_sin_cambiar_motor) :-
    setup_call_cleanup(
        assertz(user:sintoma_de(sintoma_artificial_xyz, enfermedad_prueba_xyz)),
        (   listar_enfermedades(Es),
            memberchk(enfermedad_prueba_xyz, Es),
            coincidencias([sintoma_artificial_xyz], enfermedad_prueba_xyz,
                          [sintoma_artificial_xyz]),
            diagnostico([sintoma_artificial_xyz], enfermedad_prueba_xyz, 1,
                        [sintoma_artificial_xyz]),
            ranking_diagnosticos([sintoma_artificial_xyz],
                                 [1-enfermedad_prueba_xyz-[sintoma_artificial_xyz]])
        ),
        retractall(user:sintoma_de(sintoma_artificial_xyz, enfermedad_prueba_xyz))
    ).

test(no_reportado_no_es_ausente) :-
    observaciones_analizadas([tos], _P, [], _D, _C),
    sintomas_ausentes_registrados([tos], moquillo_canino, []).

test(nuevos_signos_distintivos) :-
    Pares = [
        movimientos_compulsivos-moquillo_canino,
        oliguria_anuria-leptospirosis,
        dolor_lumbar-leptospirosis,
        edema_cabeza_cuello_tronco-hepatitis_canina_infecciosa,
        alopecia-leishmaniosis_canina,
        lesiones_nodulares_ulcerativas-leishmaniosis_canina,
        blefaritis-leishmaniosis_canina,
        cojera-leishmaniosis_canina,
        equimosis-erliquiosis_canina,
        ingestion_objetos_extranos-rabia,
        mandibula_caida-rabia,
        tos_graznido-tos_de_las_perreras
    ],
    forall(member(S-E, Pares),
           (sintoma_de(S,E), findall(Otra, sintoma_de(S,Otra), [E]))).

test(nuevos_signos_con_categoria_etiqueta_sistema_y_fuente) :-
    Nuevos = [movimientos_compulsivos, oliguria_anuria, dolor_lumbar,
              edema_cabeza_cuello_tronco, alopecia,
              lesiones_nodulares_ulcerativas, blefaritis, cojera, equimosis,
              ingestion_objetos_extranos, mandibula_caida, tos_graznido,
              hematemesis, mucosas_palidas, hepatomegalia],
    forall(member(S, Nuevos),
           (categoria_sintoma(S, orientativo), etiqueta_sintoma(S,_), sistema_sintoma(S,_))),
    forall((member(S, Nuevos), sintoma_de(S,E)), fuente_signo(S,E,_)).

test(signos_compartidos) :-
    sintoma_de(hematemesis, leptospirosis),
    sintoma_de(hematemesis, hepatitis_canina_infecciosa),
    sintoma_de(mucosas_palidas, leishmaniosis_canina),
    sintoma_de(mucosas_palidas, insuficiencia_renal_cronica),
    sintoma_de(hepatomegalia, leishmaniosis_canina),
    sintoma_de(hepatomegalia, diabetes_mellitus).

test(asociaciones_tramo_c) :-
    sintoma_de(petequias, hepatitis_canina_infecciosa),
    sintoma_de(secrecion_ocular, hepatitis_canina_infecciosa),
    sintoma_de(polidipsia, hepatitis_canina_infecciosa),
    sintoma_de(epistaxis, leptospirosis),
    sintoma_de(heces_oscuras, leptospirosis),
    sintoma_de(diarrea, leptospirosis),
    sintoma_de(perdida_peso, leptospirosis),
    sintoma_de(hipotermia, leptospirosis),
    sintoma_de(linfadenopatia, leptospirosis),
    sintoma_de(secrecion_ocular, leptospirosis),
    sintoma_de(heces_oscuras, erliquiosis_canina),
    sintoma_de(vomito, leishmaniosis_canina),
    sintoma_de(diarrea, leishmaniosis_canina).

test(orden_a_z_en_empate) :-
    ranking_diagnosticos([fiebre], Ranking),
    findall(E, member(1-E-_, Ranking), Enfermedades),
    sort(Enfermedades, Ordenadas),
    Enfermedades == Ordenadas,
    Enfermedades == [erliquiosis_canina, hepatitis_canina_infecciosa,
                     leptospirosis, moquillo_canino, parvovirus_canino].




:- end_tests(vetia).
