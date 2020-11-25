% Use this editor as a MiniZinc scratch book
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

%array [1..2] of var int: ;
%array [1..2] of var int: ;
%array [1..2] of var int: ;



% RESTRICCIONES DE ADAN ===============================
% Tintoreria
% constraint (inicio_descanso_tintoreria[0]*60 + inicio_descanso_tintoreria[1])-(inicio_tintoreria[0]*60 + inicio_tintoreria) = duracion_tintoreria; 
% constraint (inicio_descanso_tintoreria[0]*60 + inicio_descanso_tintoreria[1])-(inicio_tintoreria[0]*60 + inicio_tintoreria) = 30;
% =====================================================

solve satisfy;


output[" ",show(inicio_tintoreria[1])," - ",show(inicio_tintoreria[2])];