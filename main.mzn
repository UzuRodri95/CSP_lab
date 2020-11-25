%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   PRACTICA 3: CSP                                                              %%
%%                                                                                %%
%%   Autores: Alvaro Rodriguez                                                    %%
%%            Vladyslav Mazurkevych                                               %%
%%                                                                                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     Vamos a utilizar la siguiente formula para la extraccion de las medias     %%
%%     horas:                                                                     %%
%%                              (h - 10)*2 + min/30                               %%
%%                                                                                %%
%%    y de esta forma podremos trabajar con inicio en 10:00 y tener un intervalo  %%
%%    que se mueva en [0..24]                                                     %%
%%    Ej:   [inicio, fin, duracion] -> [17:30, 19:00, 30]                         %%
%%          17:30 -> [17,30] -> (17 - 10)*2 + 30/30 = 14 + 1 = 15 medias horas    %%
%%          19:00 -> [19,00] -> (19 - 10)*2 + 0/30 = 18 + 0 = 18 medias horas     %%
%%          30    -> 30/30 = 1 medias horas                                       %%
%%                                                                                %%
%%          [15,18,1] -> [inicio, fin, duracion] -> Podemos coger valores de      %%
%%          0..24 por lo que en el constraint debera haber algo que compruebe     %%
%%          que inicio + duracion <= 18, donde inicio podra tomar todos los       %%
%%          valores entre 0..24                                                   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use this editor as a MiniZinc scratch book
include "alldifferent.mzn";
include "data.dzn";
%======================================================
% DATOS DE ENTRADA ADAN ===============================
%======================================================
% Datos generales                                   
array [1..2] of var 10..20: inicio_adan;              
int: tiempo_desplazamiento;
array [1..2] of var int: vuelo_sale;

% Tintoreria
array [1..2] of var int: inicio_tintoreria;
array [1..2] of var int: inicio_descanso_tintoreria;
array [1..2] of var int: final_descanso_tintoreria;
array [1..2] of var int: final_tintoreria;
int: duracion_tintoreria;

% Peluqueria
array [1..2] of var int: inicio_peluqueria;
array [1..2] of var int: inicio_descanso_peluqueria;
array [1..2] of var int: final_descanso_peluqueria;
array [1..2] of var int: final_peluqueria;
int: duracion_peluqueria;

% Recoger paquete
array [1..2] of var int: inicio_paquete;
array [1..2] of var int: inicio_descanso_paquete;
array [1..2] of var int: final_descanso_paquete;
array [1..2] of var int: final_paquete;
int: duracion_paquete;

% Regalo
array [1..2] of var int: inicio_regalo;
array [1..2] of var int: final_regalo;
int: duracion_regalo;

%======================================================
% DATOS DE ENTRADA EVA ================================
%======================================================
% Datos generales
array [1..2] of var int: inicio_eva;

% Visita
array [1..2] of var int: inicio_visita;
array [1..2] of var int: inicio_descanso_visita;
array [1..2] of var int: final_descanso_visita;
array [1..2] of var int: final_visita;
int: duracion_visita;

% Farmacia
array [1..2] of var int: inicio_farmacia_1;
array [1..2] of var int: final_farmacia_1;
array [1..2] of var int: inicio_farmacia_2;
array [1..2] of var int: final_farmacia_2;
int: duracion_farmacia_1;
int: duracion_farmacia_2;

%######################################################
% RESTRICCIONES DE ADAN ###############################
%######################################################
% Tintoreria
array [1..3] of var int: tintoreria_tramo_1 = [inicio_tintoreria[1]*60 + inicio_tintoreria[2],inicio_descanso_tintoreria[1]*60 + inicio_descanso_tintoreria[2], duracion_tintoreria];
array [1..3] of var int: tintoreria_tramo_2 = [final_descanso_tintoreria[1]*60 + final_descanso_tintoreria[2],final_tintoreria[1]*60 + final_tintoreria[2], duracion_tintoreria];
constraint (tintoreria_tramo_1[1] + tintoreria_tramo_1[3] );

% Peluqueria
array [1..3] of var int: peluqueria_tramo_1 = [inicio_peluqueria[1]*60 + inicio_peluqueria[2],inicio_descanso_peluqueria[1]*60 + inicio_descanso_peluqueria[2], duracion_peluqueria];
array [1..3] of var int: peluqueria_tramo_2 = [final_descanso_peluqueria[1]*60 + final_descanso_peluqueria[2],final_peluqueria[1]*60 + final_peluqueria[2], duracion_peluqueria];
% constraint (inicio_descanso_tintoreria[0]*60 + inicio_descanso_tintoreria[1])-(inicio_tintoreria[0]*60 + inicio_tintoreria) = duracion_tintoreria; 
% constraint (inicio_descanso_tintoreria[0]*60 + inicio_descanso_tintoreria[1])-(inicio_tintoreria[0]*60 + inicio_tintoreria) = 30;


%######################################################
% RESTRICCIONES DE EVA ###############################
%######################################################

solve satisfy;


output[" ","Inicio","\t", "Fin","\t","Duracion", "\n"];
output[" ",show(peluqueria_tramo_1[1]),"\t", show(peluqueria_tramo_1[2]),"\t",show(peluqueria_tramo_1[3]), "\n"];
output[" ",show(peluqueria_tramo_1)];