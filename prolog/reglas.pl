:- encoding(utf8).

% ------------------------------------------------------------
% Reglas clinicas (encadenamiento hacia adelante, un paso).
% Las premisas son sintomas canonicos PRESENTES.
% Un sintoma no reportado no se interpreta como ausente.
% Las conclusiones son hipotesis de compatibilidad, no diagnosticos.
% No hay encadenamiento entre conclusiones, por lo que no hay ciclos.
% ------------------------------------------------------------

% regla(Id, Enfermedad, Premisas, Conclusion, Justificacion, IdFuente).

regla(r_cdv_respiratorio_neurologico,
      moquillo_canino,
      [tos, secrecion_ocular, mioclonias],
      hipotesis_compatible(moquillo_canino),
      'La combinacion de signos respiratorios con mioclonias es un patron clasico de moquillo, no una confirmacion.',
      merck_cdv).

regla(r_cdv_hard_pad_neuro,
      moquillo_canino,
      [hiperqueratosis_nasodigital, convulsiones],
      hipotesis_compatible(moquillo_canino),
      'La hiperqueratosis nasodigital con signos neurologicos se describe en distemper canino.',
      merck_cdv).

regla(r_cpv_enteritis_aguda,
      parvovirus_canino,
      [diarrea_hemorragica, vomito, letargo],
      hipotesis_compatible(parvovirus_canino),
      'El cuadro de enteritis aguda con diarrea hemorragica, vomito y letargo es compatible con parvovirosis.',
      merck_cpv).

regla(r_lepto_hepatorrenal,
      leptospirosis,
      [fiebre, ictericia, poliuria],
      hipotesis_compatible(leptospirosis),
      'Fiebre con ictericia y alteracion urinaria encaja con el patron hepatorrenal de leptospirosis.',
      merck_lepto).

regla(r_leish_cutaneo_sistemico,
      leishmaniosis_canina,
      [dermatitis_exfoliativa, linfadenopatia, perdida_peso],
      hipotesis_compatible(leishmaniosis_canina),
      'Dermatitis exfoliativa, linfadenopatia y perdida de peso forman el patron clinico frecuente de leishmaniosis canina.',
      merck_leish).

regla(r_cirdc_tos_paroxistica,
      tos_de_las_perreras,
      [tos_seca_paroxistica, arcadas_post_tos],
      hipotesis_compatible(tos_de_las_perreras),
      'La tos paroxistica seguida de arcadas, con pocos signos sistemicos, es el cuadro tipico de CIRDC.',
      merck_cirdc).

regla(r_ehrlichia_febril_hemorragico,
      erliquiosis_canina,
      [fiebre, epistaxis, letargo],
      hipotesis_compatible(erliquiosis_canina),
      'Fiebre, letargo y epistaxis son compatibles con erliquiosis aguda; la trombocitopenia lo reforzaria, pero no confirma.',
      merck_ehrlichia).

regla(r_rabia_encefalitica,
      rabia,
      [cambio_comportamiento, sialorrea, paralisis],
      hipotesis_compatible(rabia),
      'Cambio de comportamiento, sialorrea y paralisis progresiva son compatibles con rabia. Es una urgencia de salud publica y no un diagnostico de consultorio.',
      cdc_rabia).

regla(r_ckd_uremico,
      insuficiencia_renal_cronica,
      [poliuria, polidipsia, halitosis_uremica],
      hipotesis_compatible(insuficiencia_renal_cronica),
      'PU/PD con aliento uremico orientan a enfermedad renal cronica, pendiente de azotemia e isostenuria.',
      merck_ckd).

regla(r_dm_tetrada_clasica,
      diabetes_mellitus,
      [polidipsia, poliuria, polifagia, perdida_peso],
      hipotesis_compatible(diabetes_mellitus),
      'Polidipsia, poliuria, polifagia y perdida de peso constituyen la tetrada clasica de diabetes mellitus en el perro.',
      merck_dm).

regla(r_ich_ojo_azul,
      hepatitis_canina_infecciosa,
      [edema_corneal, fiebre],
      hipotesis_compatible(hepatitis_canina_infecciosa),
      'El edema corneal (ojo azul) junto con fiebre es un hallazgo muy orientativo de CAV-1, no una prueba definitiva.',
      merck_ich).

regla(r_gastritis_cronica_digestiva,
      gastritis_cronica,
      [vomito_cronico, dolor_abdominal],
      hipotesis_compatible(gastritis_cronica),
      'Vomito cronico con dolor abdominal es compatible con gastritis cronica y con otras enteropatias; requiere exclusion diagnostica.',
      merck_gastritis).
