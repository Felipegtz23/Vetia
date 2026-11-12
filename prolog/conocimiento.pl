:- encoding(utf8).
:- dynamic sintoma_de/2.
:- dynamic prueba_asociada/2.
:- discontiguous sintoma_de/2.
:- discontiguous prueba_asociada/2.
:- dynamic categoria_sintoma/2.
:- dynamic sinonimo_sintoma/2.
:- dynamic nombre_enfermedad/2.
:- dynamic fuente_conocimiento/2.
:- dynamic etiqueta_sintoma/2.
:- dynamic sistema_sintoma/2.
:- dynamic fuente_signo/3.

% ------------------------------------------------------------
% Metadatos de enfermedades.
% Los identificadores canonico se conservan en minusculas.
% listar_enfermedades/1 deriva las enfermedades desde sintoma_de/2,
% de modo que una enfermedad nueva entra sin cambiar el motor.
% ------------------------------------------------------------

nombre_enfermedad(moquillo_canino, 'Moquillo canino (CDV)').
nombre_enfermedad(parvovirus_canino, 'Parvovirus canino (CPV)').
nombre_enfermedad(leptospirosis, 'Leptospirosis').
nombre_enfermedad(leishmaniosis_canina, 'Leishmaniosis canina').
nombre_enfermedad(tos_de_las_perreras, 'Tos de las perreras (CIRDC)').
nombre_enfermedad(erliquiosis_canina, 'Erliquiosis canina (Ehrlichia canis)').
nombre_enfermedad(rabia, 'Rabia').
nombre_enfermedad(insuficiencia_renal_cronica, 'Insuficiencia renal cronica').
nombre_enfermedad(diabetes_mellitus, 'Diabetes mellitus').
nombre_enfermedad(hepatitis_canina_infecciosa, 'Hepatitis canina infecciosa (CAV-1)').
nombre_enfermedad(gastritis_cronica, 'Gastritis cronica').

% ------------------------------------------------------------
% Fuentes verificables (manuales y organismos de referencia).
% ------------------------------------------------------------

fuente_conocimiento(merck_cdv,
    'Merck Veterinary Manual: Canine Distemper').
fuente_conocimiento(merck_cpv,
    'Merck Veterinary Manual: Canine Parvovirus').
fuente_conocimiento(merck_lepto,
    'Merck Veterinary Manual: Leptospirosis in Dogs').
fuente_conocimiento(cdc_lepto,
    'CDC: Leptospirosis').
fuente_conocimiento(merck_leish,
    'Merck Veterinary Manual: Canine Leishmaniosis').
fuente_conocimiento(who_leish,
    'WHO: Leishmaniasis').
fuente_conocimiento(merck_cirdc,
    'Merck Veterinary Manual: Infectious Tracheobronchitis in Dogs').
fuente_conocimiento(merck_ehrlichia,
    'Merck Veterinary Manual: Ehrlichiosis and Related Infections').
fuente_conocimiento(merck_rabia,
    'Merck Veterinary Manual: Rabies').
fuente_conocimiento(cdc_rabia,
    'CDC: Rabies in Animals').
fuente_conocimiento(woah_rabia,
    'WOAH (OIE): Rabies').
fuente_conocimiento(merck_ckd,
    'Merck Veterinary Manual: Chronic Kidney Disease in Dogs and Cats').
fuente_conocimiento(iris_ckd,
    'IRIS: Staging of CKD').
fuente_conocimiento(merck_dm,
    'Merck Veterinary Manual: Diabetes Mellitus in Dogs').
fuente_conocimiento(merck_ich,
    'Merck Veterinary Manual: Infectious Canine Hepatitis').
fuente_conocimiento(merck_gastritis,
    'Merck Veterinary Manual: Gastritis in Small Animals').

% Fuentes adicionales verificadas para la ampliacion.
fuente_conocimiento(merck_aaha_dm,
    'AAHA 2026: Recognizing and Diagnosing Diabetes Mellitus in Dogs').
fuente_conocimiento(merck_resp_general,
    'Merck Veterinary Manual: Clinical Signs of Respiratory Disease in Animals').
fuente_conocimiento(merck_pancreatitis,
    'Merck Veterinary Manual: Pancreatitis in Dogs and Cats (referencia diferencial; no se usa para gastritis)').

% categoria_sintoma/2 distingue:
%   inespecifico        - frecuente en muchas enfermedades
%   orientativo         - mas localizador, no confirma
%   prueba_diagnostica  - hallazgo de laboratorio o prueba
% No son evidencias equivalentes.

categoria_sintoma(fiebre, inespecifico).
categoria_sintoma(letargo, inespecifico).
categoria_sintoma(anorexia, inespecifico).
categoria_sintoma(perdida_peso, inespecifico).
categoria_sintoma(vomito, inespecifico).
categoria_sintoma(diarrea, inespecifico).
categoria_sintoma(deshidratacion, inespecifico).
categoria_sintoma(pelaje_opaco, inespecifico).
categoria_sintoma(eructos, inespecifico).
categoria_sintoma(ruidos_estomacales, inespecifico).
categoria_sintoma(pica_pasto, inespecifico).
categoria_sintoma(anorexia_intermitente, inespecifico).

categoria_sintoma(diarrea_hemorragica, orientativo).
categoria_sintoma(tos, orientativo).
categoria_sintoma(tos_seca_paroxistica, orientativo).
categoria_sintoma(arcadas_post_tos, orientativo).
categoria_sintoma(secrecion_nasal, orientativo).
categoria_sintoma(secrecion_ocular, orientativo).
categoria_sintoma(disnea, orientativo).
categoria_sintoma(hiperqueratosis_nasodigital, orientativo).
categoria_sintoma(mioclonias, orientativo).
categoria_sintoma(convulsiones, orientativo).
categoria_sintoma(ataxia, orientativo).
categoria_sintoma(dolor_abdominal, orientativo).
categoria_sintoma(hipotermia, orientativo).
categoria_sintoma(ictericia, orientativo).
categoria_sintoma(poliuria, orientativo).
categoria_sintoma(polidipsia, orientativo).
categoria_sintoma(dolor_muscular, orientativo).
categoria_sintoma(uveitis, orientativo).
categoria_sintoma(linfadenopatia, orientativo).
categoria_sintoma(dermatitis_exfoliativa, orientativo).
categoria_sintoma(onicogrifosis, orientativo).
categoria_sintoma(epistaxis, orientativo).
categoria_sintoma(esplenomegalia, orientativo).
categoria_sintoma(petequias, orientativo).
categoria_sintoma(edema_miembros, orientativo).
categoria_sintoma(cambio_comportamiento, orientativo).
categoria_sintoma(agresividad, orientativo).
categoria_sintoma(sialorrea, orientativo).
categoria_sintoma(paralisis, orientativo).
categoria_sintoma(dificultad_deglucion, orientativo).
categoria_sintoma(halitosis_uremica, orientativo).
categoria_sintoma(ulceras_orales, orientativo).
categoria_sintoma(polifagia, orientativo).
categoria_sintoma(cataratas, orientativo).
categoria_sintoma(infecciones_urinarias_recurrentes, orientativo).
categoria_sintoma(debilidad_miembros_posteriores, orientativo).
categoria_sintoma(edema_corneal, orientativo).
categoria_sintoma(tonsilitis, orientativo).
categoria_sintoma(vomito_cronico, orientativo).
categoria_sintoma(heces_oscuras, orientativo).

categoria_sintoma(leucopenia, prueba_diagnostica).
categoria_sintoma(trombocitopenia, prueba_diagnostica).
categoria_sintoma(anemia, prueba_diagnostica).
categoria_sintoma(azotemia, prueba_diagnostica).
categoria_sintoma(isostenuria, prueba_diagnostica).
categoria_sintoma(hiperglucemia, prueba_diagnostica).
categoria_sintoma(glucosuria, prueba_diagnostica).
categoria_sintoma(hiperglobulinemia, prueba_diagnostica).
categoria_sintoma(pcr_cdv_positivo, prueba_diagnostica).
categoria_sintoma(antigeno_cpv_fecal_positivo, prueba_diagnostica).
categoria_sintoma(serologia_leishmania_positiva, prueba_diagnostica).
categoria_sintoma(morulas_ehrlichia, prueba_diagnostica).

% ------------------------------------------------------------
categoria_sintoma(movimientos_compulsivos, orientativo).
categoria_sintoma(oliguria_anuria, orientativo).
categoria_sintoma(dolor_lumbar, orientativo).
categoria_sintoma(edema_cabeza_cuello_tronco, orientativo).
categoria_sintoma(alopecia, orientativo).
categoria_sintoma(lesiones_nodulares_ulcerativas, orientativo).
categoria_sintoma(blefaritis, orientativo).
categoria_sintoma(cojera, orientativo).
categoria_sintoma(equimosis, orientativo).
categoria_sintoma(ingestion_objetos_extranos, orientativo).
categoria_sintoma(mandibula_caida, orientativo).
categoria_sintoma(tos_graznido, orientativo).
categoria_sintoma(hematemesis, orientativo).
categoria_sintoma(mucosas_palidas, orientativo).
categoria_sintoma(hepatomegalia, orientativo).

% Sinonimos hacia el identificador canonico.
% Incluye los atomos historicos de Vetia.pl para compatibilidad.
% ------------------------------------------------------------

sinonimo_sintoma(fiebre_elevada, fiebre).
sinonimo_sintoma(fiebre_bifasica, fiebre).
sinonimo_sintoma(letargo_y_debilidad, letargo).
sinonimo_sintoma(letargo_absoluto, letargo).
sinonimo_sintoma(letargo_postprandial, letargo).
sinonimo_sintoma(perdida_severa_apetito, anorexia).
sinonimo_sintoma(perdida_intermitente_apetito, anorexia_intermitente).
sinonimo_sintoma(perdida_peso_progresiva, perdida_peso).
sinonimo_sintoma(perdida_peso_con_comida, perdida_peso).
sinonimo_sintoma(vomitos_frecuentes, vomito).
sinonimo_sintoma(vomitos_intensos, vomito).
sinonimo_sintoma(vomitos_ocasionales, vomito).
sinonimo_sintoma(vomitos_cronicos_bilis, vomito_cronico).
sinonimo_sintoma(diarrea_con_sangre, diarrea_hemorragica).
sinonimo_sintoma(tos_persistente, tos).
sinonimo_sintoma(aumento_excesivo_sed, polidipsia).
sinonimo_sintoma(alteracion_frecuencia_orina, poliuria).
sinonimo_sintoma(apetito_voraz, polifagia).
sinonimo_sintoma(aparicion_repentina_cataratas, cataratas).
sinonimo_sintoma(halitosis_uremica_mal_aliento, halitosis_uremica).
sinonimo_sintoma(ulceras_bucales, ulceras_orales).
sinonimo_sintoma(pelaje_opaco_y_seco, pelaje_opaco).
sinonimo_sintoma(piel_seca_mal_pelaje, pelaje_opaco).
sinonimo_sintoma(deshidratacion_persistente, deshidratacion).
sinonimo_sintoma(deshidratacion_moderada, deshidratacion).
sinonimo_sintoma(dolor_abdominal_severo, dolor_abdominal).
sinonimo_sintoma(dolor_abdominal_recurrente, dolor_abdominal).
sinonimo_sintoma(inflamacion_amigdalas_ganglios, tonsilitis).
sinonimo_sintoma(edema_corneal_ojo_azul, edema_corneal).
sinonimo_sintoma(sangrado_nasal_o_encias, epistaxis).
sinonimo_sintoma(eructos_y_gases, eructos).
sinonimo_sintoma(ruidos_estomacales_constantes, ruidos_estomacales).
sinonimo_sintoma(ingesta_desesperada_pasto, pica_pasto).
sinonimo_sintoma(heces_blandas_o_oscuras, heces_oscuras).
sinonimo_sintoma(debilidad_patas_traseras, debilidad_miembros_posteriores).
sinonimo_sintoma(secrecion_oculonasal, secrecion_ocular).
sinonimo_sintoma(ojo_azul, edema_corneal).
sinonimo_sintoma(hard_pad, hiperqueratosis_nasodigital).
sinonimo_sintoma(pu_pd, poliuria).

% ============================================================
% Asociaciones clinicas: sintoma_de/2
% Solo signos clinicos. Las pruebas van en prueba_asociada/2.
% ============================================================

% --- Moquillo canino (CDV) ---
sintoma_de(fiebre, moquillo_canino).
sintoma_de(letargo, moquillo_canino).
sintoma_de(anorexia, moquillo_canino).
sintoma_de(secrecion_ocular, moquillo_canino).
sintoma_de(secrecion_nasal, moquillo_canino).
sintoma_de(tos, moquillo_canino).
sintoma_de(disnea, moquillo_canino).
sintoma_de(vomito, moquillo_canino).
sintoma_de(diarrea, moquillo_canino).
sintoma_de(hiperqueratosis_nasodigital, moquillo_canino).
sintoma_de(mioclonias, moquillo_canino).
sintoma_de(convulsiones, moquillo_canino).
sintoma_de(ataxia, moquillo_canino).

prueba_asociada(pcr_cdv_positivo, moquillo_canino).
prueba_asociada(leucopenia, moquillo_canino).

% --- Parvovirus canino ---
sintoma_de(anorexia, parvovirus_canino).
sintoma_de(letargo, parvovirus_canino).
sintoma_de(fiebre, parvovirus_canino).
sintoma_de(hipotermia, parvovirus_canino).
sintoma_de(vomito, parvovirus_canino).
sintoma_de(diarrea, parvovirus_canino).
sintoma_de(diarrea_hemorragica, parvovirus_canino).
sintoma_de(deshidratacion, parvovirus_canino).
sintoma_de(dolor_abdominal, parvovirus_canino).

prueba_asociada(leucopenia, parvovirus_canino).
prueba_asociada(antigeno_cpv_fecal_positivo, parvovirus_canino).

% --- Leptospirosis ---
sintoma_de(fiebre, leptospirosis).
sintoma_de(letargo, leptospirosis).
sintoma_de(anorexia, leptospirosis).
sintoma_de(vomito, leptospirosis).
sintoma_de(dolor_muscular, leptospirosis).
sintoma_de(poliuria, leptospirosis).
sintoma_de(polidipsia, leptospirosis).
sintoma_de(ictericia, leptospirosis).
sintoma_de(petequias, leptospirosis).
sintoma_de(uveitis, leptospirosis).

prueba_asociada(azotemia, leptospirosis).
prueba_asociada(trombocitopenia, leptospirosis).

% --- Leishmaniosis canina ---
sintoma_de(linfadenopatia, leishmaniosis_canina).
sintoma_de(dermatitis_exfoliativa, leishmaniosis_canina).
sintoma_de(perdida_peso, leishmaniosis_canina).
sintoma_de(onicogrifosis, leishmaniosis_canina).
sintoma_de(epistaxis, leishmaniosis_canina).
sintoma_de(poliuria, leishmaniosis_canina).
sintoma_de(polidipsia, leishmaniosis_canina).
sintoma_de(uveitis, leishmaniosis_canina).
sintoma_de(letargo, leishmaniosis_canina).
sintoma_de(esplenomegalia, leishmaniosis_canina).

prueba_asociada(anemia, leishmaniosis_canina).
prueba_asociada(hiperglobulinemia, leishmaniosis_canina).
prueba_asociada(serologia_leishmania_positiva, leishmaniosis_canina).

% --- Tos de las perreras (CIRDC) ---
sintoma_de(tos_seca_paroxistica, tos_de_las_perreras).
sintoma_de(tos, tos_de_las_perreras).
sintoma_de(arcadas_post_tos, tos_de_las_perreras).
sintoma_de(secrecion_nasal, tos_de_las_perreras).

% La fiebre y la disnea pueden aparecer si hay bronconeumonia;
% no se registran como signos del cuadro no complicado.

% --- Erliquiosis canina ---
sintoma_de(fiebre, erliquiosis_canina).
sintoma_de(letargo, erliquiosis_canina).
sintoma_de(anorexia, erliquiosis_canina).
sintoma_de(perdida_peso, erliquiosis_canina).
sintoma_de(linfadenopatia, erliquiosis_canina).
sintoma_de(esplenomegalia, erliquiosis_canina).
sintoma_de(epistaxis, erliquiosis_canina).
sintoma_de(petequias, erliquiosis_canina).
sintoma_de(uveitis, erliquiosis_canina).
sintoma_de(edema_miembros, erliquiosis_canina).

prueba_asociada(trombocitopenia, erliquiosis_canina).
prueba_asociada(anemia, erliquiosis_canina).
prueba_asociada(hiperglobulinemia, erliquiosis_canina).
prueba_asociada(morulas_ehrlichia, erliquiosis_canina).

% --- Rabia ---
% No se asocian signos inespecificos aislados (fiebre, letargo)
% para evitar hipotesis de rabia por evidencia trivial.
sintoma_de(cambio_comportamiento, rabia).
sintoma_de(agresividad, rabia).
sintoma_de(sialorrea, rabia).
sintoma_de(dificultad_deglucion, rabia).
sintoma_de(ataxia, rabia).
sintoma_de(paralisis, rabia).
sintoma_de(convulsiones, rabia).

% --- Insuficiencia renal cronica ---
sintoma_de(poliuria, insuficiencia_renal_cronica).
sintoma_de(polidipsia, insuficiencia_renal_cronica).
sintoma_de(perdida_peso, insuficiencia_renal_cronica).
sintoma_de(vomito, insuficiencia_renal_cronica).
sintoma_de(halitosis_uremica, insuficiencia_renal_cronica).
sintoma_de(letargo, insuficiencia_renal_cronica).
sintoma_de(ulceras_orales, insuficiencia_renal_cronica).
sintoma_de(pelaje_opaco, insuficiencia_renal_cronica).
sintoma_de(deshidratacion, insuficiencia_renal_cronica).
sintoma_de(anorexia, insuficiencia_renal_cronica).

prueba_asociada(azotemia, insuficiencia_renal_cronica).
prueba_asociada(isostenuria, insuficiencia_renal_cronica).
prueba_asociada(anemia, insuficiencia_renal_cronica).

% --- Diabetes mellitus ---
sintoma_de(polidipsia, diabetes_mellitus).
sintoma_de(poliuria, diabetes_mellitus).
sintoma_de(polifagia, diabetes_mellitus).
sintoma_de(perdida_peso, diabetes_mellitus).
sintoma_de(cataratas, diabetes_mellitus).
sintoma_de(letargo, diabetes_mellitus).
sintoma_de(infecciones_urinarias_recurrentes, diabetes_mellitus).
sintoma_de(vomito, diabetes_mellitus).
sintoma_de(debilidad_miembros_posteriores, diabetes_mellitus).
sintoma_de(pelaje_opaco, diabetes_mellitus).

prueba_asociada(hiperglucemia, diabetes_mellitus).
prueba_asociada(glucosuria, diabetes_mellitus).

% --- Hepatitis canina infecciosa ---
sintoma_de(fiebre, hepatitis_canina_infecciosa).
sintoma_de(anorexia, hepatitis_canina_infecciosa).
sintoma_de(letargo, hepatitis_canina_infecciosa).
sintoma_de(vomito, hepatitis_canina_infecciosa).
sintoma_de(diarrea, hepatitis_canina_infecciosa).
sintoma_de(diarrea_hemorragica, hepatitis_canina_infecciosa).
sintoma_de(dolor_abdominal, hepatitis_canina_infecciosa).
sintoma_de(ictericia, hepatitis_canina_infecciosa).
sintoma_de(tonsilitis, hepatitis_canina_infecciosa).
sintoma_de(edema_corneal, hepatitis_canina_infecciosa).
sintoma_de(epistaxis, hepatitis_canina_infecciosa).

prueba_asociada(leucopenia, hepatitis_canina_infecciosa).


% ============================================================
% AMPLIACION CLINICA DOCUMENTADA (revision 2026-11)
% Los nuevos signos se clasifican como orientativos: no confirman
% enfermedad y deben interpretarse junto con el resto de la historia.
% ============================================================

% Tramo A: signos nuevos distintivos
sintoma_de(movimientos_compulsivos, moquillo_canino).
sintoma_de(oliguria_anuria, leptospirosis).
sintoma_de(dolor_lumbar, leptospirosis).
sintoma_de(edema_cabeza_cuello_tronco, hepatitis_canina_infecciosa).
sintoma_de(alopecia, leishmaniosis_canina).
sintoma_de(lesiones_nodulares_ulcerativas, leishmaniosis_canina).
sintoma_de(blefaritis, leishmaniosis_canina).
sintoma_de(cojera, leishmaniosis_canina).
sintoma_de(equimosis, erliquiosis_canina).
sintoma_de(ingestion_objetos_extranos, rabia).
sintoma_de(mandibula_caida, rabia).
sintoma_de(tos_graznido, tos_de_las_perreras).

% Tramo B: signos compartidos
sintoma_de(hematemesis, leptospirosis).
sintoma_de(hematemesis, hepatitis_canina_infecciosa).
sintoma_de(mucosas_palidas, leishmaniosis_canina).
sintoma_de(mucosas_palidas, insuficiencia_renal_cronica).
sintoma_de(hepatomegalia, leishmaniosis_canina).
sintoma_de(hepatomegalia, diabetes_mellitus).

% Tramo C: asociaciones nuevas de signos ya existentes
sintoma_de(petequias, hepatitis_canina_infecciosa).
sintoma_de(secrecion_ocular, hepatitis_canina_infecciosa).
sintoma_de(polidipsia, hepatitis_canina_infecciosa).
sintoma_de(epistaxis, leptospirosis).
sintoma_de(heces_oscuras, leptospirosis).
sintoma_de(diarrea, leptospirosis).
sintoma_de(perdida_peso, leptospirosis).
sintoma_de(hipotermia, leptospirosis).
sintoma_de(linfadenopatia, leptospirosis).
sintoma_de(secrecion_ocular, leptospirosis).
sintoma_de(heces_oscuras, erliquiosis_canina).
sintoma_de(vomito, leishmaniosis_canina).
sintoma_de(diarrea, leishmaniosis_canina).

% Categorias de los nuevos signos

% --- Gastritis cronica ---
sintoma_de(vomito_cronico, gastritis_cronica).
sintoma_de(dolor_abdominal, gastritis_cronica).
sintoma_de(perdida_peso, gastritis_cronica).
sintoma_de(anorexia_intermitente, gastritis_cronica).
sintoma_de(eructos, gastritis_cronica).
sintoma_de(ruidos_estomacales, gastritis_cronica).
sintoma_de(pica_pasto, gastritis_cronica).
sintoma_de(deshidratacion, gastritis_cronica).
sintoma_de(heces_oscuras, gastritis_cronica).

% ============================================================
% Metadatos para la interfaz: etiquetas y sistemas corporales.
% Esta taxonomia organiza el selector; no representa una escala
% de gravedad ni una afirmacion diagnostica.
% ============================================================
etiqueta_sintoma(fiebre, 'Fiebre').
etiqueta_sintoma(letargo, 'Letargo').
etiqueta_sintoma(anorexia, 'Pérdida del apetito').
etiqueta_sintoma(perdida_peso, 'Pérdida de peso').
etiqueta_sintoma(vomito, 'Vómito').
etiqueta_sintoma(diarrea, 'Diarrea').
etiqueta_sintoma(deshidratacion, 'Deshidratación').
etiqueta_sintoma(pelaje_opaco, 'Pelaje opaco').
etiqueta_sintoma(eructos, 'Eructos').
etiqueta_sintoma(ruidos_estomacales, 'Ruidos estomacales').
etiqueta_sintoma(pica_pasto, 'Ingesta de pasto').
etiqueta_sintoma(anorexia_intermitente, 'Pérdida intermitente del apetito').
etiqueta_sintoma(diarrea_hemorragica, 'Diarrea con sangre').
etiqueta_sintoma(tos, 'Tos').
etiqueta_sintoma(tos_seca_paroxistica, 'Tos seca paroxística').
etiqueta_sintoma(arcadas_post_tos, 'Arcadas después de toser').
etiqueta_sintoma(secrecion_nasal, 'Secreción nasal').
etiqueta_sintoma(secrecion_ocular, 'Secreción ocular').
etiqueta_sintoma(disnea, 'Dificultad para respirar').
etiqueta_sintoma(hiperqueratosis_nasodigital, 'Engrosamiento de nariz o almohadillas').
etiqueta_sintoma(mioclonias, 'Espasmos musculares').
etiqueta_sintoma(convulsiones, 'Convulsiones').
etiqueta_sintoma(ataxia, 'Falta de coordinación').
etiqueta_sintoma(dolor_abdominal, 'Dolor abdominal').
etiqueta_sintoma(hipotermia, 'Temperatura corporal baja').
etiqueta_sintoma(ictericia, 'Coloración amarilla de mucosas u ojos').
etiqueta_sintoma(poliuria, 'Aumento de la cantidad de orina').
etiqueta_sintoma(polidipsia, 'Aumento de la sed').
etiqueta_sintoma(dolor_muscular, 'Dolor muscular').
etiqueta_sintoma(uveitis, 'Inflamación dentro del ojo').
etiqueta_sintoma(linfadenopatia, 'Ganglios linfáticos aumentados').
etiqueta_sintoma(dermatitis_exfoliativa, 'Descamación de la piel').
etiqueta_sintoma(onicogrifosis, 'Uñas anormalmente largas o curvadas').
etiqueta_sintoma(epistaxis, 'Sangrado nasal').
etiqueta_sintoma(esplenomegalia, 'Aumento del tamaño del bazo').
etiqueta_sintoma(petequias, 'Puntos rojos de sangrado en piel o mucosas').
etiqueta_sintoma(edema_miembros, 'Hinchazón de las extremidades').
etiqueta_sintoma(cambio_comportamiento, 'Cambio inusual de comportamiento').
etiqueta_sintoma(agresividad, 'Agresividad inusual').
etiqueta_sintoma(sialorrea, 'Salivación excesiva').
etiqueta_sintoma(paralisis, 'Parálisis').
etiqueta_sintoma(dificultad_deglucion, 'Dificultad para tragar').
etiqueta_sintoma(halitosis_uremica, 'Mal aliento de tipo urémico').
etiqueta_sintoma(ulceras_orales, 'Úlceras en la boca').
etiqueta_sintoma(polifagia, 'Aumento del apetito').
etiqueta_sintoma(cataratas, 'Cataratas').
etiqueta_sintoma(infecciones_urinarias_recurrentes, 'Infecciones urinarias recurrentes').
etiqueta_sintoma(debilidad_miembros_posteriores, 'Debilidad de las patas traseras').
etiqueta_sintoma(edema_corneal, 'Opacidad de la córnea (ojo azul)').
etiqueta_sintoma(tonsilitis, 'Amígdalas inflamadas').
etiqueta_sintoma(vomito_cronico, 'Vómitos crónicos').
etiqueta_sintoma(heces_oscuras, 'Heces muy oscuras o negras').
etiqueta_sintoma(movimientos_compulsivos, 'Movimientos repetitivos o compulsivos').
etiqueta_sintoma(oliguria_anuria, 'Producción muy escasa o nula de orina').
etiqueta_sintoma(dolor_lumbar, 'Dolor en la zona lumbar o espalda').
etiqueta_sintoma(edema_cabeza_cuello_tronco, 'Hinchazón de cabeza, cuello o tronco').
etiqueta_sintoma(alopecia, 'Pérdida de pelo').
etiqueta_sintoma(lesiones_nodulares_ulcerativas, 'Lesiones cutáneas nodulares o ulceradas').
etiqueta_sintoma(blefaritis, 'Inflamación de los párpados').
etiqueta_sintoma(cojera, 'Cojera').
etiqueta_sintoma(equimosis, 'Moretones o hematomas').
etiqueta_sintoma(ingestion_objetos_extranos, 'Ingestión de objetos no comestibles').
etiqueta_sintoma(mandibula_caida, 'Mandíbula inferior caída').
etiqueta_sintoma(tos_graznido, 'Tos áspera similar a un graznido').
etiqueta_sintoma(hematemesis, 'Vómito con sangre').
etiqueta_sintoma(mucosas_palidas, 'Mucosas pálidas').
etiqueta_sintoma(hepatomegalia, 'Aumento del tamaño del hígado').
etiqueta_sintoma(leucopenia, 'Recuento bajo de glóbulos blancos').
etiqueta_sintoma(trombocitopenia, 'Recuento bajo de plaquetas').
etiqueta_sintoma(anemia, 'Anemia').
etiqueta_sintoma(azotemia, 'Aumento de compuestos nitrogenados en sangre').
etiqueta_sintoma(isostenuria, 'Densidad urinaria isostenúrica').
etiqueta_sintoma(hiperglucemia, 'Glucosa elevada en sangre').
etiqueta_sintoma(glucosuria, 'Glucosa en orina').
etiqueta_sintoma(hiperglobulinemia, 'Globulinas elevadas').
etiqueta_sintoma(pcr_cdv_positivo, 'PCR positiva para virus del moquillo').
etiqueta_sintoma(antigeno_cpv_fecal_positivo, 'Antígeno fecal positivo para parvovirus').
etiqueta_sintoma(serologia_leishmania_positiva, 'Serología positiva para Leishmania').
etiqueta_sintoma(morulas_ehrlichia, 'Mórulas compatibles con Ehrlichia').

sistema_sintoma(anemia, general).
sistema_sintoma(anorexia, general).
sistema_sintoma(deshidratacion, general).
sistema_sintoma(fiebre, general).
sistema_sintoma(hipotermia, general).
sistema_sintoma(letargo, general).
sistema_sintoma(linfadenopatia, linfatico).
sistema_sintoma(mucosas_palidas, general).
sistema_sintoma(perdida_peso, general).
sistema_sintoma(anorexia_intermitente, digestivo).
sistema_sintoma(diarrea, digestivo).
sistema_sintoma(diarrea_hemorragica, digestivo).
sistema_sintoma(dolor_abdominal, digestivo).
sistema_sintoma(eructos, digestivo).
sistema_sintoma(heces_oscuras, digestivo).
sistema_sintoma(hematemesis, digestivo).
sistema_sintoma(pica_pasto, digestivo).
sistema_sintoma(polifagia, digestivo).
sistema_sintoma(ruidos_estomacales, digestivo).
sistema_sintoma(vomito, digestivo).
sistema_sintoma(vomito_cronico, digestivo).
sistema_sintoma(arcadas_post_tos, respiratorio).
sistema_sintoma(disnea, respiratorio).
sistema_sintoma(secrecion_nasal, respiratorio).
sistema_sintoma(tos, respiratorio).
sistema_sintoma(tos_graznido, respiratorio).
sistema_sintoma(tos_seca_paroxistica, respiratorio).
sistema_sintoma(agresividad, neurologico).
sistema_sintoma(ataxia, neurologico).
sistema_sintoma(cambio_comportamiento, neurologico).
sistema_sintoma(debilidad_miembros_posteriores, neurologico).
sistema_sintoma(convulsiones, neurologico).
sistema_sintoma(mandibula_caida, neurologico).
sistema_sintoma(mioclonias, neurologico).
sistema_sintoma(movimientos_compulsivos, neurologico).
sistema_sintoma(paralisis, neurologico).
sistema_sintoma(halitosis_uremica, urinario).
sistema_sintoma(infecciones_urinarias_recurrentes, urinario).
sistema_sintoma(oliguria_anuria, urinario).
sistema_sintoma(polidipsia, urinario).
sistema_sintoma(poliuria, urinario).
sistema_sintoma(alopecia, piel).
sistema_sintoma(dermatitis_exfoliativa, piel).
sistema_sintoma(edema_miembros, piel).
sistema_sintoma(equimosis, piel).
sistema_sintoma(hiperqueratosis_nasodigital, piel).
sistema_sintoma(lesiones_nodulares_ulcerativas, piel).
sistema_sintoma(onicogrifosis, piel).
sistema_sintoma(pelaje_opaco, piel).
sistema_sintoma(blefaritis, ocular).
sistema_sintoma(cataratas, ocular).
sistema_sintoma(edema_corneal, ocular).
sistema_sintoma(secrecion_ocular, ocular).
sistema_sintoma(uveitis, ocular).
sistema_sintoma(anemia, hematologico).
sistema_sintoma(epistaxis, hematologico).
sistema_sintoma(equimosis, hematologico).
sistema_sintoma(mucosas_palidas, hematologico).
sistema_sintoma(petequias, hematologico).
sistema_sintoma(trombocitopenia, hematologico).
sistema_sintoma(dificultad_deglucion, oral).
sistema_sintoma(sialorrea, oral).
sistema_sintoma(tonsilitis, oral).
sistema_sintoma(ulceras_orales, oral).
sistema_sintoma(cojera, musculoesqueletico).
sistema_sintoma(dolor_lumbar, musculoesqueletico).
sistema_sintoma(dolor_muscular, musculoesqueletico).
sistema_sintoma(edema_cabeza_cuello_tronco, hepatobiliar).
sistema_sintoma(esplenomegalia, hepatobiliar).
sistema_sintoma(hepatomegalia, hepatobiliar).
sistema_sintoma(ictericia, hepatobiliar).
sistema_sintoma(ingestion_objetos_extranos, comportamiento).
sistema_sintoma(antigeno_cpv_fecal_positivo, laboratorio).
sistema_sintoma(azotemia, laboratorio).
sistema_sintoma(glucosuria, laboratorio).
sistema_sintoma(hiperglobulinemia, laboratorio).
sistema_sintoma(hiperglucemia, laboratorio).
sistema_sintoma(isostenuria, laboratorio).
sistema_sintoma(leucopenia, laboratorio).
sistema_sintoma(morulas_ehrlichia, laboratorio).
sistema_sintoma(pcr_cdv_positivo, laboratorio).
sistema_sintoma(serologia_leishmania_positiva, laboratorio).

% Fuente base por enfermedad para las asociaciones historicas.
fuente_base_enfermedad(moquillo_canino, merck_cdv).
fuente_base_enfermedad(parvovirus_canino, merck_cpv).
fuente_base_enfermedad(leptospirosis, merck_lepto).
fuente_base_enfermedad(leishmaniosis_canina, merck_leish).
fuente_base_enfermedad(tos_de_las_perreras, merck_cirdc).
fuente_base_enfermedad(erliquiosis_canina, merck_ehrlichia).
fuente_base_enfermedad(rabia, merck_rabia).
fuente_base_enfermedad(insuficiencia_renal_cronica, merck_ckd).
fuente_base_enfermedad(diabetes_mellitus, merck_dm).
fuente_base_enfermedad(hepatitis_canina_infecciosa, merck_ich).
fuente_base_enfermedad(gastritis_cronica, merck_gastritis).

% Cada asociacion clinica obtiene al menos una fuente de referencia.
fuente_signo(Sintoma, Enfermedad, Fuente) :-
    sintoma_de(Sintoma, Enfermedad),
    fuente_base_enfermedad(Enfermedad, Fuente).

% Fuentes mas especificas para las asociaciones incorporadas en esta revision.
fuente_signo(movimientos_compulsivos, moquillo_canino, merck_cdv).
fuente_signo(oliguria_anuria, leptospirosis, merck_lepto).
fuente_signo(dolor_lumbar, leptospirosis, merck_lepto).
fuente_signo(edema_cabeza_cuello_tronco, hepatitis_canina_infecciosa, merck_ich).
fuente_signo(alopecia, leishmaniosis_canina, merck_leish).
fuente_signo(lesiones_nodulares_ulcerativas, leishmaniosis_canina, merck_leish).
fuente_signo(blefaritis, leishmaniosis_canina, merck_leish).
fuente_signo(cojera, leishmaniosis_canina, merck_leish).
fuente_signo(equimosis, erliquiosis_canina, merck_ehrlichia).
fuente_signo(ingestion_objetos_extranos, rabia, merck_rabia).
fuente_signo(mandibula_caida, rabia, merck_rabia).
fuente_signo(tos_graznido, tos_de_las_perreras, merck_resp_general).
fuente_signo(hematemesis, leptospirosis, merck_lepto).
fuente_signo(hematemesis, hepatitis_canina_infecciosa, merck_ich).
fuente_signo(mucosas_palidas, leishmaniosis_canina, merck_leish).
fuente_signo(mucosas_palidas, insuficiencia_renal_cronica, merck_ckd).
fuente_signo(hepatomegalia, leishmaniosis_canina, merck_leish).
fuente_signo(hepatomegalia, diabetes_mellitus, merck_dm).
