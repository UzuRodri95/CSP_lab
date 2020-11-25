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
%%%%%%%%%%%%%%%%%%%%%%%%%%% INFORMACION ENUNCIADO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ADAN Son las 10:00 -> Coger vuelo a las 20:00 Tiene que estar 30 minutos antes.            %%%
%% 1.Tintoreria [9:00-13:30] [17:00-20:30] 30 min - Restriccion a la hora de inicio y final   %%%
%% 2.Peluqueria [12:00-14:30][16:30-18:30] 60 min - Restriccion a la hora de llegada          %%%
%% 3.Paquete    [14:00-17:00][18:00-21:30] 30 min - Restriccion a la hora de llegada          %%%
%% 4.Regalo     [9:00-21:00]		120 min - Restriccion a la hora de llegada                       %%% 
%%                                                                                            %%%
%% EVA Son las 12:00                                                                          %%%
%% 1.Farmacia [ir<17:00 -> 2 h 30 min] OR [ir>17:00 -> 2 h 0 min]                             %%%
%% 2.Visita   [12:00-14:30] OR [17:30-19:30] 60 min - Restriccion a la hora de inicio y final %%%
%%                                                                                            %%%
%% DESPLAZAMIENTOS +30 min                                                                    %%%
%% En restriccion 4 ADAN y EVA deben hacerlo juntos                                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

include "alldifferent.mzn";
include "data.dzn";
%======================================================
% DATOS DE ENTRADA ADAN ===============================
%======================================================
% Datos generales                                   
array [1..2] of var int: inicio_adan;              
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

var 0..24: x;

%######################################################
% RESTRICCIONES DE ADAN ############################### [inicio, final, duracion]
%######################################################
var float: adan_inicio = (inicio_adan[1]-10)*2 + inicio_adan[2]/30; % adan_inicio = 0
var float: desplazamiento = tiempo_desplazamiento/30;               % desplazamiento = 1 (30 min)

% Tintoreria
array [1..3] of var float: tintoreria_tramo_1 = [(inicio_tintoreria[1]-10)*2 + inicio_tintoreria[2]/30,
                                                 (inicio_descanso_tintoreria[1]-10)*2 + inicio_descanso_tintoreria[2]/30,
                                                  duracion_tintoreria/30];
array [1..3] of var float: tintoreria_tramo_2 = [(final_descanso_tintoreria[1]-10)*2 + final_descanso_tintoreria[2]/30,
                                                 (final_tintoreria[1]-10)*2 + final_tintoreria[2]/30,
                                                  duracion_tintoreria/30];
                                                  
constraint (x + desplazamiento >= adan_inicio /\ x + tintoreria_tramo_1[3] + desplazamiento <= tintoreria_tramo_1[2]) 
                                                           \/ 
           (x + desplazamiento >= tintoreria_tramo_2[1] /\ x + tintoreria_tramo_2[3] + desplazamiento <= tintoreria_tramo_2[2]);   

% Peluqueria                             

%######################################################
% RESTRICCIONES DE EVA ################################
%######################################################

solve satisfy;


output[" ","Inicio","\t", "Fin","\t","Duracion", "\n"];
output[" ",show(tintoreria_tramo_1[1]),"\t", show(tintoreria_tramo_1[2]),"\t",show(tintoreria_tramo_1[3]), "\n"];
output[" ",show(tintoreria_tramo_2[1]),"\t", show(tintoreria_tramo_2[2]),"\t",show(tintoreria_tramo_2[3]), "\n"];
output[" ",show(x),"\n"];