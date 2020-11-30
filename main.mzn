%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   PRACTICA 3: CSP                                                              %%
%%                                                                                %%
%%   Autores: Alvaro Rodriguez                                                    %%
%%            Vladyslav Mazurkevych                                               %%
%%                                                                                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%     Vamos a utilizar la siguiente formula para la extraccion de las medias     %%
%%%%%%%%%%%%%%%     horas:                                                                     %%
%%%%%%%%%%%%%%%                              (h - 10)*2 + min (donde min puede ser 0 o 1)      %%
%%%%%%%%%%%%%%%    1 designa una media hora = 30 min                                           %%
%%%%%%%%%%%%%%%    y de esta forma podremos trabajar con inicio en 10:00 y tener un intervalo  %%
%%%%%%%%%%%%%%%    que se mueva en [0..24]                                                     %%
%%%%%%%%%%%%%%%    Ej:   [inicio, fin, duracion] -> [17:30, 19:00, 30]                         %%
%%%%%%%%%%%%%%%          17:30 -> [17,1] -> (17 - 10)*2 + 1 = 14 + 1 = 15 medias horas         %%
%%%%%%%%%%%%%%%          19:00 -> [19,0] -> (19 - 10)*2 + 0 = 18 + 0 = 18 medias horas         %%
%%%%%%%%%%%%%%%          1    -> 1 = 1 medias horas                                            %%
%%%%%%%%%%%%%%%                                                                                %%
%%%%%%%%%%%%%%%          [15,18,1] -> [inicio, fin, duracion] -> Podemos coger valores de      %%
%%%%%%%%%%%%%%%          0..24 por lo que en el constraint debera haber algo que compruebe     %%
%%%%%%%%%%%%%%%          que inicio + duracion <= 18, donde inicio podra tomar todos los       %%
%%%%%%%%%%%%%%%          valores entre 0..24                                                   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INFORMACION ENUNCIADO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ADAN Son las 10:00 -> Coger vuelo a las 20:00 Tiene que estar 30 minutos antes.            %%%
%% 1.Tintoreria [9:00-13:30] [17:00-20:30] 30 min - Restriccion a la hora de inicio y final   %%%
%% 2.Peluqueria [12:00-14:30][16:30-18:30] 60 min - Restriccion a la hora de llegada          %%%
%% 3.Paquete    [14:00-17:00][18:00-21:30] 30 min - Restriccion a la hora de llegada          %%%
%% 4.Regalo     [9:00-21:00]		120 min - Restriccion a la hora de llegada                      %%%
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
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                             @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ DATOS DE ENTRADA DE FICHERO @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                             @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%========================
%==== ADAN ==============
%========================
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

%========================
%==== EVA ===============
%========================
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

%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                             @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   DECLARACION DE VARIABLES  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                             @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
array[1..7] of var int: inicioA;
array[1..7] of var int: finalA;
array[1..5] of var int: inicioE;
array[1..5] of var int: finalE;
array[1..7] of var int: duracionA;
array[1..5] of var int: duracionE;
var int: desplazamiento;
var int: empiezaA;
var int: empiezaE;
var int: horaVuelo;
var int: antelacionAeropuerto;
var 0..24: x;
var 0..24: y;
var 0..24: z;
var 0..24: w;
var 0..24: v;
var 0..24: k;
var int: xA;
var int: yA;
var int: zA;
var int: wA;
var int: vE;
var int: kE;
array[1..4] of var int: horasInicioTareasA;
array[1..4] of var int: horasFinalTareasA;
array[1..3] of var int: horasInicioTareasE;
array[1..3] of var int: horasFinalTareasE;
var 0..24: holgura;
var int: horaUltimaTareaAdan;
var 0..24: horaTempranaLlegarCasaE;

%============================================================================================================
%================================= ASIGNACION DE VARIABLES DE ENTRADA A =====================================
%=================================        VARIABLES DECLARADAS          =====================================
%============================================================================================================
inicioA = [ 
            (inicio_tintoreria[1] - 10) * 2 + inicio_tintoreria[2],
            (final_descanso_tintoreria[1] - 10) * 2 + final_descanso_tintoreria[2],
            (inicio_peluqueria[1] - 10) * 2 + inicio_peluqueria[2],
            (final_descanso_peluqueria[1] - 10) * 2 + final_descanso_peluqueria[2],
            (inicio_paquete[1] - 10) * 2 + inicio_paquete[2],
            (final_descanso_paquete[1] - 10) * 2 + final_descanso_paquete[2],
            (inicio_regalo[1] - 10) * 2 + inicio_regalo[2]
          ];

finalA = [
            (inicio_descanso_tintoreria[1] - 10)*2 + (inicio_descanso_tintoreria[2]),
            (final_tintoreria[1] - 10)*2 + (final_tintoreria[2]),
            (inicio_descanso_peluqueria[1] - 10)*2 + (inicio_descanso_peluqueria[2]),
            (final_peluqueria[1] - 10)*2 + (final_peluqueria[2]),
            (inicio_descanso_paquete[1] - 10)*2 + (inicio_descanso_paquete[2]),
            (final_paquete[1] - 10)*2 + (final_paquete[2]),
            (final_regalo[1] - 10)*2 + (final_regalo[2])
         ];

inicioE = [
            (inicio_visita[1] - 10) * 2 + inicio_visita[2],
            (final_descanso_visita[1] - 10) * 2 + final_descanso_visita[2],
            (inicio_farmacia_1[1] - 10) * 2 + inicio_farmacia_1[2],
            (inicio_farmacia_2[1] - 10) * 2 + inicio_farmacia_2[2],
            (inicio_regalo[1] - 10) * 2 + inicio_regalo[2]
          ];

finalE = [
          ( inicio_descanso_visita[1] - 10)*2 + (final_descanso_visita[2]),
          ( final_visita[1] - 10)*2 + ( final_visita[2]),
          ( final_farmacia_1[1] - 10)*2 + ( final_farmacia_1[2]),
          ( final_farmacia_2[1] - 10)*2 + ( final_farmacia_2[2]),
          ( final_regalo[1] - 10)*2 + ( final_regalo[2])
         ];
         
duracionA = [ 
              duracion_tintoreria,
              duracion_tintoreria,
              duracion_peluqueria,
              duracion_peluqueria,
              duracion_paquete,
              duracion_paquete,
              duracion_regalo,
            ];
          
duracionE = [ 
              duracion_visita,
              duracion_visita,
              duracion_farmacia_1,
              duracion_farmacia_2,
              duracion_regalo,
            ];
            
desplazamiento = tiempo_desplazamiento;

empiezaA = (inicio_adan[1] - 10)*2 + (inicio_adan[2]);
empiezaE = (inicio_eva[1] - 10)*2 + (inicio_eva[2]);

horaVuelo = (vuelo_sale[1] - 10)*2 + (vuelo_sale[2]);
antelacionAeropuerto = 1;

%============================================================================================================
%=============================================               ================================================
%============================================= RESTRICCIONES ================================================
%=============================================               ================================================
%============================================================================================================
%########################
%#### ADAN ##############
%########################
%Tintoreria
constraint x >= empiezaA /\ x+desplazamiento >= inicioA[1] /\ x + desplazamiento + duracionA[1] <= finalA[1]
                                                             \/
           x >= empiezaA /\ x + desplazamiento >= inicioA[2] /\ x + desplazamiento + duracionA[2] <= finalA[2] /\ 
           x + desplazamiento + duracionA[2] < horaVuelo - antelacionAeropuerto;

%Peluqueria
constraint y >= empiezaA /\ y + desplazamiento >= inicioA[3] /\ y + desplazamiento <= finalA[3]
                                                             \/
           y >= empiezaA /\ y + desplazamiento >= inicioA[4] /\ y + desplazamiento <= finalA[4] /\ 
           y + desplazamiento + duracionA[4] < horaVuelo - antelacionAeropuerto;

%Paquete
constraint z >= empiezaA /\ z + desplazamiento >= inicioA[5] /\ z + desplazamiento <= finalA[5]
                                                             \/
           z >= empiezaA /\ z + desplazamiento >= inicioA[6] /\ z + desplazamiento <= finalA[6] /\ 
           z + desplazamiento + duracionA[6] < horaVuelo - antelacionAeropuerto;

%Regalo
constraint w >= empiezaA /\ w + desplazamiento >= inicioA[7] /\ w + desplazamiento <= finalA[7] /\ 
           w + desplazamiento + duracionA[7] < horaVuelo - antelacionAeropuerto;
           
%########################
%#### EVA  ##############
%########################
%Visita
constraint v >= empiezaE /\ v + desplazamiento >= inicioE[1] /\ v + desplazamiento + duracionE[1] <= finalE[1]
                                                             \/
           v >= empiezaE /\ v + desplazamiento >= inicioE[2] /\ v + desplazamiento + duracionE[2] <= finalE[2];

%Farmacia
constraint if k + desplazamiento <= finalE[3] then kE = (k + desplazamiento + duracionE[3]) else kE = (k + desplazamiento + duracionE[4]) endif;

%Regalo
constraint w >= empiezaE /\ w + desplazamiento >= inicioE[5] /\ w + desplazamiento <= finalE[5];  

%########################
%##### SOLAPES ##########
%########################

xA = (x + duracionA[1]);
yA = (y + duracionA[3]);
zA = (z + duracionA[5]);
wA = (w + duracionA[7]);

horasInicioTareasA = [x,y,z,w];
horasFinalTareasA = [xA,yA,zA,wA];

vE = (v + duracionE[1]);
%kE
horasInicioTareasE = [v,k,w];
horasFinalTareasE = [vE,kE,wA];



constraint forall(i,j in 1..4 where i!=j)(horasInicioTareasA[i]>=horasFinalTareasA[j] + desplazamiento \/ horasFinalTareasA[i]<=horasInicioTareasA[j] - desplazamiento);
constraint forall(i,j in 1..3 where i!=j)(horasInicioTareasE[i]>=horasFinalTareasE[j] + desplazamiento \/ horasFinalTareasE[i]<=horasInicioTareasE[j] - desplazamiento); 


%Ejercicio 1 - Obtener los tiempos de inicio y final para cada una de las tareas de Adán y de Eva, las horas de salida
%y llegada a casa de Eva, la hora de salida de casa de Adán y la hora de llegada al aeropuerto. Obtener algunos resultados factibles.
solve satisfy;

%Ejercicio 2 - ¿Cuál es la máxima holgura que puede tener Adán respecto a su llegada al aeropuerto y salida del vuelo? Obtened la asignación de tiempos de las tareas.
horaUltimaTareaAdan = max(horasFinalTareasA);
holgura = 20 - horaUltimaTareaAdan;
constraint holgura >= 1;
%solve maximize holgura;

%Ejercicio 3 - ¿Cuál es la hora más temprana que puede volver Eva a casa?. Obtened la asignación de tiempos de las tareas.
%solve minimize k;
horaTempranaLlegarCasaE= max(horasFinalTareasE);
%solve minimize horaTempranaLlegarCasaE;

%Ejercicio 4 - ¿Cuál es la hora más tardía en la que Adán puede salir de casa?. Obtened la asignación de tiempos de las tareas.
%solve maximize x;

%Ejercicio 5 - ¿Es posible que Eva acabe la vista a la amiga 4 horas antes, al menos, que Adán entre en la peluquería? ¿Y almenos, 5 horas antes?
%constraint  v + desplazamiento + duracionE[1] + 8 < y;
%constraint  v + desplazamiento + duracionE[1] + 10 < y;

output["HORARIO ADAN","\n"];
output["\tTarea" ++ show(i) ++ ":" ++ (show(horasInicioTareasA[i]/2 + 10) ++ "-" ++ show(horasFinalTareasA[i]/2 + 10) ++ "\n") | i in 1..4];
output["\n"];
output["HORARIO EVA","\n"];
output["\tTarea" ++ show(i) ++ ":" ++ (show(horasInicioTareasE[i]/2 + 10) ++ "-" ++ show(horasFinalTareasE[i]/2 + 10) ++ "\n") | i in 1..3];
output["\n Holgura: " ++ show(holgura) ++ " medias horas que son " ++ show(holgura/2) ++ " horas\n"];
output["\n Horas finales Adan: ", show(horasFinalTareasA)," Ultima hora: ", show(horaUltimaTareaAdan), "\n"];
output["Horas finales Eva: ", show(horasFinalTareasE)," Ultima hora: ", show(horaTempranaLlegarCasaE), "\n"];
