/*405 
MODELO RELACIONAL DEL ESQUEMA DEL HOSPITAL 
 
CONTENIDO DEL FICHERO CON COMENTARIOS 
A  continuación  se  describe  el  contenido  del  fichero 
script_bdhospital.sql. 
La ejecución de este fichero se deberá hacer con un usuario de base de datos con 
permisos de administración: por ejemplo SYS o SYSTEM. 
Creación del usuario propietario de los objetos 
*/

/*  Creación  de  un  usuario  para  el  curso  con  nombre  de  usuario 
PEPERF con contraseña PEPITO y asignación de permisos */ 

/* Los datos de usuario y contraseña pueden ser variados por el 
alumno si lo desea */ 

CREATE USER PEPERF IDENTIFIED BY PEPITO; 
GRANT CONNECT, RESOURCE TO PEPERF; 
GRANT CREATE VIEW TO PEPERF;  

/*© Alfaomega - RC Libros Oracle 12c PL/SQL. Curso práctico de formación 
 
406 */

--Conexión a la base de datos con el nuevo usuario 


/* Se cambia la conexión, para acceder con el nuevo usuario */ 
CONNECT PEPERF/PEPITO; 
--Creación de las tablas del esquema hospital 
/* Creación de la base de datos de una estructura hospitalaria 
*/ 
CREATE TABLE EMPLEADO 
 (NIF       VARCHAR2(9) NOT NULL 
 ,FALTA       VARCHAR2(240) 
 ,NOMBRE       VARCHAR2(20) 
 ,COMISION      NUMBER(6,2) 
 ,SALARIO       NUMBER(6,2) 
 ,OFICIO       VARCHAR2(20) 
 ,APELLIDOS     VARCHAR2(40) 
 ,NIF_DEPENDIENTE VARCHAR2(9) 
 ,CONSTRAINT EMP_PK PRIMARY KEY (NIF) 
 ,CONSTRAINT EMP_EMP_FK FOREIGN KEY (NIF_DEPENDIENTE)  
                        REFERENCES EMPLEADO (NIF)) 
/ 
 
CREATE TABLE HOSPITAL 
 (CODIGO    NUMBER(2,0) NOT NULL 
 ,TELEFONO  NUMBER(9) 
 ,NOMBRE    VARCHAR2(12) 
 ,NUMCAMAS  NUMBER(4,0) 
 ,DIRECCION VARCHAR2(50) 
,CONSTRAINT HOSP_PK PRIMARY KEY (CODIGO)) 
/ 
 
CREATE TABLE ENFERMO 
 (NUMSEGSOCIAL  NUMBER(9,0) NOT NULL 
 ,DIRECCION   VARCHAR2(50) 
 ,NOMBRE     VARCHAR2(20) 
 ,APELLIDOS   VARCHAR2(40) 
 ,FNACIMIENTO   DATE 
 ,SEXO     CHAR(1) NOT NULL 
 ,CONSTRAINT ENF_PK PRIMARY KEY (NUMSEGSOCIAL) 
 ,CONSTRAINT AVCON_1247567854_SEXO_000 CHECK (SEXO IN ('M', 
'F'))) 
/ 

/*   
© Alfaomega - RC Libros ANEXO III: FICHERO SCRIPT_BDHOSPITAL   
 
407 
*/

CREATE TABLE PLANTILLA 
 (NIF    VARCHAR2(9) NOT NULL 
 ,SALARIO    NUMBER(7,2) 
 ,NOMBRE    VARCHAR2(20) 
 ,TURNO    CHAR(1) NOT NULL 
 ,APELLIDOS VARCHAR2(40) 
 ,FUNCION    VARCHAR2(20) 
 ,CONSTRAINT PLAN_PK PRIMARY KEY (NIF) 
 ,CONSTRAINT AVCON_1247567854_TURNO_000 CHECK (TURNO IN 
('M','T','N'))) 
/ 
 
CREATE TABLE SALA 
 (HOSP_CODIGO   NUMBER(2,0) NOT NULL 
 ,CODIGO     NUMBER(2,0) NOT NULL 
 ,NUMCAMAS  NUMBER(2,0) 
 ,NOMBRE     VARCHAR2(30) 
 ,CONSTRAINT SALA_PK PRIMARY KEY (CODIGO,HOSP_CODIGO) 
 ,CONSTRAINT SALA_HOSP_FK FOREIGN KEY (HOSP_CODIGO)  
                          REFERENCES HOSPITAL (CODIGO)) 
/ 
 
CREATE TABLE PLANTILLA_SALA 
 (SALA_HOSP_CODIGO   NUMBER(2,0) NOT NULL 
 ,SALA_CODIGO     NUMBER(2,0) NOT NULL 
 ,PLAN_NIF    VARCHAR2(9) NOT NULL 
 ,CONSTRAINT PLAN_SALA_PK PRIMARY KEY 
(PLAN_NIF,SALA_CODIGO,SALA_HOSP_CODIGO) 
 ,CONSTRAINT PLAN_SALA_SALA_FK FOREIGN KEY 
(SALA_CODIGO,SALA_HOSP_CODIGO) REFERENCES SALA 
(CODIGO,HOSP_CODIGO) 
 ,CONSTRAINT PLAN_SALA_PLAN_FK FOREIGN KEY (PLAN_NIF)  
REFERENCES PLANTILLA (NIF)) 
/ 
 
create table estados_civiles 
(codigo    char(1), 
descripcion varchar2(50) constraint nn_estados_civiles not 
null, 
constraint pk_estados_civiles primary key(codigo)); 
 
create table persona 
(nif      varchar2(9), 
codestadocivil  number(1), 
nombre    varchar2(100) constraint nn_nombre_persona not 
null, 
constraint pk_personal primary key(nif)); 

/*
© Alfaomega - RC Libros Oracle 12c PL/SQL. Curso práctico de formación 
 
408 */

/*
Alteración de tablas del esquema hospital y creación de 
índices secundarios 
*/

/* Alteración de tablas y creación de índices */ 
alter table estados_civiles 
add constraint ck_codigo_estados_civiles check (codigo in 
('S','C','V','O')); 
 
alter table persona 
modify (codestadocivil  char(1)); 
 
alter table persona 
add constraint fk_persona_estados_civiles foreign key 
(codestadocivil) references estados_civiles(codigo); 
 
alter table persona 
disable constraint fk_persona_estados_civiles; 
 
CREATE INDEX ix1_enfermo ON enfermo(nombre); 
 
CREATE INDEX ix2_enfermo ON enfermo(apellidos); 
 
CREATE UNIQUE INDEX ix1_departamento ON departamento(nombre); 

/*
Creación  de  una  secuencia  para  manejo  del  código  de 
inscripción en un hospital 
*/
/* Creación de una secuencia */ 
CREATE SEQUENCE seq_inscripcion 
START WITH 1 
INCREMENT BY 1 
MINVALUE 1 
MAXVALUE 99999999 
NOCYCLE 
NOCACHE; 

/*
Inserción de datos en las tablas del esquema 
*/

/*  Inserción  de  datos  sobre  las  tablas  de  la  estructura 
hospitalaria */ 
-- Inserciones en la tabla HOSPITAL 
 
INSERT INTO hospital 
values (1,'916644264','Provincial',502,'O Donell 50'); 
 
/*
© Alfaomega - RC Libros ANEXO III: FICHERO SCRIPT_BDHOSPITAL   
 
409 
*/

INSERT INTO hospital 
values (2,'915953111','General',987,'Atocha s/n'); 
 
INSERT INTO hospital 
values (3,'919235411','La Paz',412,'Castellana 100'); 
 
INSERT INTO hospital 
values (4,'915971500','San Carlos',845,'Ciudad Universitaria'); 
 
INSERT INTO hospital 
values (5,'915971500','Gr. Marañon',300,'Francisco Silvela'); 
 
INSERT INTO hospital 
values (6,'915971500','Doce Octubre',200,'Avda. Cordoba'); 
 
INSERT INTO hospital 
values (7,'915971500','La Zarzuela',100,'Moncloa'); 
 
-- Inserciones en la tabla ENFERMO 
 
INSERT INTO enfermo 
VALUES(280862482,'Goya20','Jose','M.M.',to_date('16051956','ddm
myyyy'),'M'); 
 
INSERT INTO enfermo 
VALUES(280862481,'Granada 
35','Javier','R.R.',to_date('16081970','ddmmyyyy'),'M'); 
 
INSERT INTO enfermo 
VALUES(280862480,'Sevilla 
32','Ruben','S.S.',to_date('10091971','ddmmyyyy'),'M'); 
 
INSERT INTO enfermo 
VALUES(280862483,'Toledo 
1','Rocio','K.K.',to_date('10091968','ddmmyyyy'),'F'); 
 
INSERT INTO enfermo 
VALUES(280862484,'Malaga 
2','Laura','J.J.',to_date('10091971','ddmmyyyy'),'F'); 
 
INSERT INTO enfermo 
VALUES(280862485,'Barcelona 
2','Beatriz','A.A.',to_date('10091988','ddmmyyyy'),'M'); 
 
-- Inserciones en la tabla HOSPITAL_ENFERMO 
 
INSERT INTO hospital_enfermo 
VALUES(1,seq_inscripcion.nextval,280862482,to_date('01012002','
ddmmyyyy')); 

/*
© Alfaomega - RC Libros Oracle 12c PL/SQL. Curso práctico de formación 
 
410 
*/

INSERT INTO hospital_enfermo 
VALUES(1,seq_inscripcion.nextval,280862482,to_date('02012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(1,seq_inscripcion.nextval,280862482,to_date('03012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(1,seq_inscripcion.nextval,280862482,to_date('04012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(1,seq_inscripcion.nextval,280862482,to_date('05012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(1,seq_inscripcion.nextval,280862481,to_date('01012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(1,seq_inscripcion.nextval,280862481,to_date('02012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(1,seq_inscripcion.nextval,280862481,to_date('03012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(1,seq_inscripcion.nextval,280862480,to_date('01102002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(1,seq_inscripcion.nextval,280862480,to_date('02102002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(1,seq_inscripcion.nextval,280862480,to_date('03102002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(1,seq_inscripcion.nextval,280862483,to_date('03102002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(1,seq_inscripcion.nextval,280862484,to_date('04102002','
ddmmyyyy')); 
 
/*
© Alfaomega - RC Libros ANEXO III: FICHERO SCRIPT_BDHOSPITAL   
 
411 */
 
INSERT INTO hospital_enfermo 
VALUES(1,seq_inscripcion.nextval,280862485,to_date('03112002','
ddmmyyyy')); 
INSERT INTO hospital_enfermo 
VALUES(2,seq_inscripcion.nextval,280862482,to_date('02012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(2,seq_inscripcion.nextval,280862482,to_date('03012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(2,seq_inscripcion.nextval,280862482,to_date('04012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(2,seq_inscripcion.nextval,280862482,to_date('05012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(2,seq_inscripcion.nextval,280862481,to_date('02012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(2,seq_inscripcion.nextval,280862481,to_date('03012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(2,seq_inscripcion.nextval,280862480,to_date('02102002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(2,seq_inscripcion.nextval,280862480,to_date('03102002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(2,seq_inscripcion.nextval,280862484,to_date('04102002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(2,seq_inscripcion.nextval,280862485,to_date('03112002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(3,seq_inscripcion.nextval,280862482,to_date('03012002','
ddmmyyyy')); 
   
/*© Alfaomega - RC Libros Oracle 12c PL/SQL. Curso práctico de formación 
 
412*/
 
INSERT INTO hospital_enfermo 
VALUES(3,seq_inscripcion.nextval,280862482,to_date('04012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(3,seq_inscripcion.nextval,280862482,to_date('05012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(3,seq_inscripcion.nextval,280862480,to_date('03102002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(3,seq_inscripcion.nextval,280862485,to_date('03112002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(4,seq_inscripcion.nextval,280862482,to_date('04012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(4,seq_inscripcion.nextval,280862482,to_date('05012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(4,seq_inscripcion.nextval,280862485,to_date('03112002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(5,seq_inscripcion.nextval,280862482,to_date('05012002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(5,seq_inscripcion.nextval,280862485,to_date('03112002','
ddmmyyyy')); 
 
INSERT INTO hospital_enfermo 
VALUES(6,seq_inscripcion.nextval,280862485,to_date('03112002','
ddmmyyyy')); 
 
-- Inserciones en la tabla SALA 
 
INSERT INTO sala 
VALUES (1,1,24,'Maternidad'); 
INSERT INTO sala 
VALUES (1,2,21,'Cuidados intensivos'); 
 
INSERT INTO sala 
VALUES (1,3,67,'Psiquiatrico'); 

/*© Alfaomega - RC Libros ANEXO III: FICHERO SCRIPT_BDHOSPITAL   
 
413 */
 
INSERT INTO sala 
VALUES (1,4,53,'Cardiologia'); 
 
INSERT INTO sala 
VALUES (1,5,10,'Recuperacion'); 
 
INSERT INTO sala 
VALUES (2,1,88,'Maternidad'); 
 
INSERT INTO sala 
VALUES (2,2,88,'Cuidados intensivos'); 
 
INSERT INTO sala 
VALUES (2,3,88,'Psiquiatrico'); 
 
INSERT INTO sala 
VALUES (2,4,88,'Cardiologia'); 
 
INSERT INTO sala 
VALUES (2,5,88,'Recuperacion'); 
 
INSERT INTO sala 
VALUES (3,5,99,'Maternidad'); 
 
INSERT INTO sala 
VALUES (3,4,99,'Cuidados intensivos'); 
 
INSERT INTO sala 
VALUES (3,3,99,'Psiquiatrico'); 
 
INSERT INTO sala 
VALUES (3,2,99,'Cardiologia'); 
 
INSERT INTO sala 
VALUES (3,1,99,'Recuperacion'); 
 
INSERT INTO sala 
VALUES (4,1,10,'Maternidad'); 
INSERT INTO sala 
VALUES (4,2,11,'Cuidados intensivos'); 
 
INSERT INTO sala 
VALUES (4,3,12,'Psiquiatrico'); 
 
INSERT INTO sala 
VALUES (4,4,13,'Cardiologia'); 
 
INSERT INTO sala 
VALUES (5,1,10,'Maternidad'); 

/*© Alfaomega - RC Libros Oracle 12c PL/SQL. Curso práctico de formación 
 
414 */

INSERT INTO sala 
VALUES (5,2,11,'Cuidados intensivos'); 
 
INSERT INTO sala 
VALUES (5,3,12,'Psiquiatrico'); 
 
INSERT INTO sala 
VALUES (6,1,10,'Maternidad'); 
 
INSERT INTO sala 
VALUES (6,2,11,'Cuidados intensivos'); 
 
INSERT INTO sala 
VALUES (7,1,99,'Maternidad'); 
 
-- Inserciones en la tabla DOCTOR 
 
INSERT INTO doctor 
VALUES ('12345678A','Gutierrez J.','Raimundo','Cardiologia'); 
 
INSERT INTO doctor 
VALUES ('12345678F','Gutierrez J.','Perico','Cardiologia'); 
 
INSERT INTO doctor 
VALUES ('12345678J','Gutierrez T.','Iñaqui','Cardiologia'); 
 
INSERT INTO doctor 
VaLUES ('12345678B','Soledad B.','Ines','Ginecologia'); 
INSERT INTO doctor 
VaLUES ('12345678K','Casas B.','Bartolome','Ginecologia'); 
 
INSERT INTO doctor 
VALUES ('12345678C','Moreno D.','Rosa','Pediatria'); 
 
INSERT INTO doctor 
VALUES ('12345678L','Moreno D.','Maria','Pediatria'); 
 
INSERT INTO doctor 
VALUES ('12345678M','Moreno D.','Isidoro','Pediatria'); 
 
INSERT INTO doctor 
VALUES ('12345678N','Moreno D.','Antonio','Pediatria'); 
 
INSERT INTO doctor 
VALUES ('12345678D','Del Toro D.','Ramiro','Psiquiatria'); 
 
INSERT INTO doctor 
VALUES ('22345678A','Fermin J.','Edmunto','Cardiologia'); 
 
/*© Alfaomega - RC Libros ANEXO III: FICHERO SCRIPT_BDHOSPITAL   
 
415 */

INSERT INTO doctor 
VALUES ('22345678J','Lopez T.','Iñaqui','Cardiologia'); 
 
INSERT INTO doctor 
VaLUES ('22345678B','Acaso B.','Ines','Ginecologia'); 
 
INSERT INTO doctor 
VaLUES ('22345678K','Torres B.','Bartolome','Ginecologia'); 
 
INSERT INTO doctor 
VALUES ('22345678C','Moreno D.','Rosa','Pediatria'); 
 
INSERT INTO doctor 
VALUES ('32345678A','Fernandez J.','Loli','Cardiologia'); 
 
INSERT INTO doctor 
VALUES ('32345678P','Fermin J.','Jorge','Cardiologia'); 
 
INSERT INTO doctor 
VALUES ('32345678J','Lopez T.','Samuel','Cardiologia'); 
 
INSERT INTO doctor 
VaLUES ('32345678B','Acaso B.','Maria','Ginecologia'); 
 
INSERT INTO doctor 
VaLUES ('32345678K','Torres B.','Tirano','Ginecologia'); 
 
INSERT INTO doctor 
VALUES ('42345678A','Fernandez J.','Ramon','Cardiologia'); 
 
INSERT INTO doctor 
VALUES ('42345678M','Fermin J.','Fede','Cardiologia'); 
 
INSERT INTO doctor 
VALUES ('42345678J','Lopez T.','Loles','Cardiologia'); 
 
INSERT INTO doctor 
VaLUES ('42345678B','Acaso B.','Maica','Ginecologia'); 
 
INSERT INTO doctor 
VaLUES ('42345678K','Torres B.','Toñin','Ginecologia'); 
 
INSERT INTO doctor 
VALUES ('52345678A','Fernandez J.','Ramon','Cardiologia'); 
 
INSERT INTO doctor 
VALUES ('52345678T','Fermin J.','Fede','Cardiologia'); 
 
 
/*© Alfaomega - RC Libros Oracle 12c PL/SQL. Curso práctico de formación 
 
416 */

INSERT INTO doctor 
VALUES ('52345678J','Lopez T.','Loles','Cardiologia'); 
 
INSERT INTO doctor 
VaLUES ('52345678B','Acaso B.','Maica','Ginecologia'); 
INSERT INTO doctor 
VALUES ('62345678A','Fernandez J.','Rocio','Cardiologia'); 
 
INSERT INTO doctor 
VALUES ('62345678J','Lopez T.','Carlos','Cardiologia'); 
 
INSERT INTO doctor 
VaLUES ('62345678K','Torres B.','Juan','Ginecologia'); 
 
INSERT INTO doctor 
VALUES ('72345678J','Lopez T.','JuanMa','Cardiologia'); 
 
-- Inserciones en la tabla DOCTOR_HOSPITAL 
 
INSERT INTO doctor_hospital 
VALUES (1,'12345678A'); 
 
INSERT INTO doctor_hospital 
VALUES (1,'12345678F'); 
 
INSERT INTO doctor_hospital 
VALUES (1,'12345678J'); 
 
INSERT INTO doctor_hospital 
VaLUES (1,'12345678B'); 
 
INSERT INTO doctor_hospital 
VaLUES (1,'12345678K'); 
 
INSERT INTO doctor_hospital 
VALUES (1,'12345678C'); 
 
INSERT INTO doctor_hospital 
VALUES (1,'12345678L'); 
 
INSERT INTO doctor_hospital 
VALUES (1,'12345678M'); 
 
INSERT INTO doctor_hospital 
VALUES (1,'12345678N'); 
 
INSERT INTO doctor_hospital 
VALUES (1,'12345678D'); 
 
/*© Alfaomega - RC Libros ANEXO III: FICHERO SCRIPT_BDHOSPITAL   
 
417 */

INSERT INTO doctor_hospital 
VALUES (2,'12345678A'); 
 
INSERT INTO doctor_hospital 
VALUES (2,'22345678A'); 
 
INSERT INTO doctor_hospital 
VALUES (2,'22345678J'); 
 
INSERT INTO doctor_hospital 
VaLUES (2,'22345678B'); 
 
INSERT INTO doctor_hospital 
VaLUES (2,'22345678K'); 
 
INSERT INTO doctor_hospital 
VALUES (2,'22345678C'); 
 
INSERT INTO doctor_hospital 
VALUES (3,'32345678A'); 
 
INSERT INTO doctor_hospital 
VALUES (3,'32345678P'); 
 
INSERT INTO doctor_hospital 
VALUES (3,'32345678J'); 
 
INSERT INTO doctor_hospital 
VaLUES (3,'32345678B'); 
 
INSERT INTO doctor_hospital 
VaLUES (3,'32345678K'); 
 
INSERT INTO doctor_hospital 
VALUES (3,'22345678C'); 
 
INSERT INTO doctor_hospital 
VALUES (4,'42345678A'); 
 
INSERT INTO doctor_hospital 
VALUES (4,'42345678M'); 
INSERT INTO doctor_hospital 
VALUES (4,'42345678J'); 
 
INSERT INTO doctor_hospital 
VaLUES (4,'42345678B'); 
 
INSERT INTO doctor_hospital 
VaLUES (4,'42345678K'); 

/*© Alfaomega - RC Libros Oracle 12c PL/SQL. Curso práctico de formación 
 
418*/
 
INSERT INTO doctor_hospital 
VALUES (5,'52345678A'); 
 
INSERT INTO doctor_hospital 
VALUES (5,'52345678T'); 
 
INSERT INTO doctor_hospital 
VALUES (5,'52345678J'); 
 
INSERT INTO doctor_hospital 
VaLUES (5,'52345678B'); 
 
INSERT INTO doctor_hospital 
VALUES (6,'62345678A'); 
 
INSERT INTO doctor_hospital 
VALUES (6,'62345678J'); 
 
INSERT INTO doctor_hospital 
VaLUES (6,'62345678K'); 
 
INSERT INTO doctor_hospital 
VALUES (7,'62345678A'); 
 
INSERT INTO doctor_hospital 
VALUES (7,'72345678J'); 
 
-- Inserciones en la tabla DEPARTAMENTO 
 
INSERT INTO departamento 
VALUES(1,'CONTABILIDAD'); 
 
INSERT INTO departamento 
VALUES(2,'INVESTIGACION'); 
 
INSERT INTO departamento 
VALUES(3,'FACTURACION'); 
 
INSERT INTO departamento 
VALUES(4,'ADMINISTRACION'); 
 
INSERT INTO departamento 
VALUES(5,'FARMACIA'); 
 
INSERT INTO departamento 
VALUES(6,'LIMPIEZA'); 
 
-- Inserciones en la tabla EMPLEADO 
 
/*© Alfaomega - RC Libros ANEXO III: FICHERO SCRIPT_BDHOSPITAL   
 
419*/
 
INSERT INTO empleado 
VALUES('10000000A',TO_DATE('10012002','DDMMYYYY'),'Jorge',1000.
22,3000.11,'DIRECTOR','Perez Sala',NULL); 
 
INSERT INTO empleado 
VALUES('20000000B',TO_DATE('11012002','DDMMYYYY'),'Javier',500.
22,2000.22,'GERENTE','Sala Rodriguez','10000000A'); 
 
INSERT INTO empleado 
VALUES('30000000C',TO_DATE('11012002','DDMMYYYY'),'Soledad',500
.33,2000.33,'ADMISTRADOR','Lopez J.','10000000A'); 
 
INSERT INTO empleado 
VALUES('40000000D',TO_DATE('12012002','DDMMYYYY'),'Sonia',NULL,
1800.44,'JEFE FARMACIA','Moldes R.','20000000B'); 
 
INSERT INTO empleado 
VALUES('50000000E',TO_DATE('12012002','DDMMYYYY'),'Antonio',300
.44,1800.44,'JEFE LABORATORIO','Lopez A.','20000000B'); 
 
INSERT INTO empleado 
VALUES('60000000F',TO_DATE('12012002','DDMMYYYY'),'Carlos',500.
55,1800.55,'CONTABLE','Roa D.','30000000C'); 
 
INSERT INTO empleado 
VALUES('70000000G',TO_DATE('13012002','DDMMYYYY'),'Lola',NULL,1
000,'ADMINISTRATIVO','Sanchez D.','60000000F'); 
 
INSERT INTO empleado 
VALUES('80000000L',TO_DATE('13012002','DDMMYYYY'),'Angel',NULL,
1000,'ADMINISTRATIVO','Perez','60000000F'); 
 
INSERT INTO empleado 
VALUES('90000000M',TO_DATE('12012002','DDMMYYYY'),'Ramon',NULL,
1500,'JEFE LIMPIEZA','Maria Casas','20000000B'); 
 
INSERT INTO empleado 
VALUES('11000000P',TO_DATE('14012002','DDMMYYYY'),'Luis',NULL,7
00,'HIGIENE','Sanchez D.','90000000M'); 
 
INSERT INTO empleado 
VALUES('12000000Q',TO_DATE('14012002','DDMMYYYY'),'Rosa',NULL,7
00,'HIGIENE','Torres A.','90000000M'); 
 
INSERT INTO empleado 
VALUES('10000000N',TO_DATE('14012002','DDMMYYYY'),'Sara',200,10
00,'INVESTIGADOR','Gomez A.','50000000E'); 
 
-- Inserciones en la tabla EMPLEADO_HOSPITAL 

/*© Alfaomega - RC Libros Oracle 12c PL/SQL. Curso práctico de formación 
 
420 */

INSERT INTO empleado_hospital 
VALUES(1,'10000000A'); 
 
INSERT INTO empleado_hospital 
VALUES(1,'20000000B'); 
 
INSERT INTO empleado_hospital 
VALUES(1,'30000000C'); 
 
INSERT INTO empleado_hospital 
VALUES(1,'40000000D'); 
 
INSERT INTO empleado_hospital 
VALUES(1,'50000000E'); 
 
INSERT INTO empleado_hospital 
VALUES(1,'60000000F'); 
 
INSERT INTO empleado_hospital 
VALUES(1,'70000000G'); 
 
INSERT INTO empleado_hospital 
VALUES(1,'80000000L'); 
 
INSERT INTO empleado_hospital 
VALUES(1,'90000000M'); 
 
INSERT INTO empleado_hospital 
VALUES(1,'11000000P'); 
 
INSERT INTO empleado_hospital 
VALUES(1,'12000000Q'); 
 
INSERT INTO empleado_hospital 
VALUES(1,'10000000N'); 
 
INSERT INTO empleado_hospital 
VALUES(2,'10000000A'); 
 
INSERT INTO empleado_hospital 
VALUES(2,'20000000B'); 
 
INSERT INTO empleado_hospital 
VALUES(2,'30000000C'); 
 
INSERT INTO empleado_hospital 
VALUES(2,'40000000D'); 
 
 
/*© Alfaomega - RC Libros ANEXO III: FICHERO SCRIPT_BDHOSPITAL   
 
421*/
 
INSERT INTO empleado_hospital 
VALUES(2,'50000000E'); 
 
INSERT INTO empleado_hospital 
VALUES(2,'70000000G'); 
 
INSERT INTO empleado_hospital 
VALUES(2,'80000000L'); 
 
INSERT INTO empleado_hospital 
VALUES(2,'90000000M'); 
 
INSERT INTO empleado_hospital 
VALUES(2,'11000000P'); 
 
INSERT INTO empleado_hospital 
VALUES(2,'12000000Q'); 
 
INSERT INTO empleado_hospital 
VALUES(2,'10000000N'); 
 
INSERT INTO empleado_hospital 
VALUES(3,'10000000A'); 
 
INSERT INTO empleado_hospital 
VALUES(3,'20000000B'); 
 
INSERT INTO empleado_hospital 
VALUES(3,'30000000C'); 
 
INSERT INTO empleado_hospital 
VALUES(3,'40000000D'); 
 
INSERT INTO empleado_hospital 
VALUES(3,'80000000L'); 
 
INSERT INTO empleado_hospital 
VALUES(3,'90000000M'); 
 
INSERT INTO empleado_hospital 
VALUES(3,'11000000P'); 
 
INSERT INTO empleado_hospital 
VALUES(3,'12000000Q'); 
 
INSERT INTO empleado_hospital 
VALUES(3,'10000000N'); 
 
 
/*© Alfaomega - RC Libros Oracle 12c PL/SQL. Curso práctico de formación 
 
422 */

INSERT INTO empleado_hospital 
VALUES(4,'10000000A'); 
 
INSERT INTO empleado_hospital 
VALUES(4,'20000000B'); 
 
INSERT INTO empleado_hospital 
VALUES(4,'30000000C'); 
 
INSERT INTO empleado_hospital 
VALUES(4,'40000000D'); 
 
INSERT INTO empleado_hospital 
VALUES(4,'80000000L'); 
 
INSERT INTO empleado_hospital 
VALUES(4,'90000000M'); 
 
INSERT INTO empleado_hospital 
VALUES(4,'12000000Q'); 
 
INSERT INTO empleado_hospital 
VALUES(4,'10000000N'); 
 
INSERT INTO empleado_hospital 
VALUES(5,'10000000A'); 
 
INSERT INTO empleado_hospital 
VALUES(5,'20000000B'); 
 
INSERT INTO empleado_hospital 
VALUES(5,'30000000C'); 
 
INSERT INTO empleado_hospital 
VALUES(5,'40000000D'); 
 
INSERT INTO empleado_hospital 
VALUES(5,'80000000L'); 
 
INSERT INTO empleado_hospital 
VALUES(5,'12000000Q'); 
 
INSERT INTO empleado_hospital 
VALUES(5,'10000000N'); 
 
INSERT INTO empleado_hospital 
VALUES(6,'10000000A'); 
 
 
/*© Alfaomega - RC Libros ANEXO III: FICHERO SCRIPT_BDHOSPITAL   
 
423 */
 
INSERT INTO empleado_hospital 
VALUES(6,'20000000B'); 
 
INSERT INTO empleado_hospital 
VALUES(6,'30000000C'); 
 
INSERT INTO empleado_hospital 
VALUES(6,'40000000D'); 
 
INSERT INTO empleado_hospital 
VALUES(6,'12000000Q'); 
 
INSERT INTO empleado_hospital 
VALUES(6,'10000000N'); 
 
-- Inserciones en la tabla PLANTILLA 
 
INSERT INTO plantilla 
VALUES('11111111A',15000.22,'Alejandro','M','A.A.','ENFERMERO')
; 
 
INSERT INTO plantilla 
VALUES('11111111B',15000.22,'Bartolome','T','B.B.','ENFERMERO')
; 
 
INSERT INTO plantilla 
VALUES('11111111C',15000.22,'Carlos','N','C.C.','ENFERMERO'); 
 
INSERT INTO plantilla 
VALUES('22222222A',15000.22,'Adriana','M','A.A.','ENFERMERA'); 
 
INSERT INTO plantilla 
VALUES('22222222B',15000.22,'Bibiana','T','B.B.','ENFERMERA'); 
 
INSERT INTO plantilla 
VALUES('22222222C',15000.22,'Casilda','N','C.C.','ENFERMERA'); 
 
INSERT INTO plantilla 
VALUES('33333333A',15000.22,'Alberto','M','A.A.','ENFERMERO'); 
INSERT INTO plantilla 
VALUES('33333333B',15000.22,'Bonifacio','T','B.B.','ENFERMERO')
; 
 
INSERT INTO plantilla 
VALUES('33333333C',15000.22,'Casimiro','N','C.C.','ENFERMERO'); 
 
INSERT INTO plantilla 
VALUES('44444444A',15000.22,'Amelia','M','A.A.','ENFERMERA'); 
 
/*© Alfaomega - RC Libros Oracle 12c PL/SQL. Curso práctico de formación 
 
424 */

INSERT INTO plantilla 
VALUES('44444444B',15000.22,'Bony','T','B.B.','ENFERMERA'); 
 
INSERT INTO plantilla 
VALUES('44444444C',15000.22,'Casandra','N','C.C.','ENFERMERA'); 
 
INSERT INTO plantilla 
VALUES('55555555A',15000.22,'Armando','M','A.A.','ENFERMERO'); 
 
INSERT INTO plantilla 
VALUES('55555555B',15000.22,'Benicio','T','B.B.','ENFERMERO'); 
 
INSERT INTO plantilla 
VALUES('55555555C',15000.22,'Ciceron','N','C.C.','ENFERMERO'); 
 
-- Inserciones en la tabla PLANTILLA_SALA 
 
INSERT INTO plantilla_sala 
VALUES(1,1,'11111111A'); 
 
INSERT INTO plantilla_sala 
VALUES(1,1,'11111111B'); 
 
INSERT INTO plantilla_sala 
VALUES(1,1,'11111111C'); 
 
INSERT INTO plantilla_sala 
VALUES(1,2,'22222222A'); 
 
INSERT INTO plantilla_sala 
VALUES(1,2,'22222222B'); 
 
INSERT INTO plantilla_sala 
VALUES(1,2,'22222222C'); 
 
INSERT INTO plantilla_sala 
VALUES(1,3,'33333333A'); 
 
INSERT INTO plantilla_sala 
VALUES(1,3,'33333333B'); 
 
INSERT INTO plantilla_sala 
VALUES(1,3,'33333333C'); 
 
INSERT INTO plantilla_sala 
VALUES(1,4,'44444444A'); 
 
INSERT INTO plantilla_sala 
VALUES(1,4,'44444444B'); 

/*© Alfaomega - RC Libros ANEXO III: FICHERO SCRIPT_BDHOSPITAL   
 
425 */

INSERT INTO plantilla_sala 
VALUES(1,4,'44444444C'); 
 
INSERT INTO plantilla_sala 
VALUES(1,5,'55555555A'); 
 
INSERT INTO plantilla_sala 
VALUES(1,5,'55555555B'); 
 
INSERT INTO plantilla_sala 
VALUES(1,5,'55555555C'); 
 
INSERT INTO plantilla_sala 
VALUES(2,1,'11111111A'); 
 
INSERT INTO plantilla_sala 
VALUES(2,1,'11111111B'); 
 
INSERT INTO plantilla_sala 
VALUES(2,2,'22222222A'); 
INSERT INTO plantilla_sala 
VALUES(2,2,'22222222B'); 
 
INSERT INTO plantilla_sala 
VALUES(2,3,'33333333A'); 
 
INSERT INTO plantilla_sala 
VALUES(2,3,'33333333B'); 
 
INSERT INTO plantilla_sala 
VALUES(2,4,'44444444A'); 
 
INSERT INTO plantilla_sala 
VALUES(2,4,'44444444B'); 
 
INSERT INTO plantilla_sala 
VALUES(2,5,'55555555A'); 
 
INSERT INTO plantilla_sala 
VALUES(2,5,'55555555B'); 
 
INSERT INTO plantilla_sala 
VALUES(3,1,'11111111A'); 
 
INSERT INTO plantilla_sala 
VALUES(3,2,'22222222A'); 
 
INSERT INTO plantilla_sala 
VALUES(3,3,'33333333A'); 

/*© Alfaomega - RC Libros Oracle 12c PL/SQL. Curso práctico de formación 
 
426 */

INSERT INTO plantilla_sala 
VALUES(3,4,'44444444A'); 
 
INSERT INTO plantilla_sala 
VALUES(3,5,'55555555A'); 
 
INSERT INTO plantilla_sala 
VALUES(4,1,'11111111A'); 
 
INSERT INTO plantilla_sala 
VALUES(4,2,'22222222A'); 
 
INSERT INTO plantilla_sala 
VALUES(4,3,'33333333A'); 
INSERT INTO plantilla_sala 
VALUES(4,4,'44444444A'); 
 
INSERT INTO plantilla_sala 
VALUES(6,1,'11111111A'); 
 
INSERT INTO plantilla_sala 
VALUES(6,2,'22222222A'); 
 
INSERT INTO plantilla_sala 
VALUES(7,1,'11111111A'); 
 
-- Inserciones en la tabla DEPARTAMENTO_EMPLEADO 
 
INSERT INTO departamento_empleado 
VALUES(4,'10000000A'); 
 
INSERT INTO departamento_empleado 
VALUES(4,'20000000B'); 
 
INSERT INTO departamento_empleado 
VALUES(4,'30000000C'); 
 
INSERT INTO departamento_empleado 
VALUES(5,'40000000D'); 
 
INSERT INTO departamento_empleado 
VALUES(2,'50000000E'); 
 
INSERT INTO departamento_empleado 
VALUES(1,'60000000F'); 
 
INSERT INTO departamento_empleado 
VALUES(1,'70000000G'); 
 
/*© Alfaomega - RC Libros  
427 */

INSERT INTO departamento_empleado 
VALUES(1,'80000000L'); 
 
INSERT INTO departamento_empleado 
VALUES(6,'90000000M'); 
 
INSERT INTO departamento_empleado 
VALUES(6,'11000000P'); 
 
INSERT INTO departamento_empleado 
VALUES(6,'12000000Q'); 
 
INSERT INTO departamento_empleado 
VALUES(2,'10000000N'); 
commit; 
 
-- Inserciones en la tabla EMPLEADO 
 
INSERT INTO empleado 
VALUES('12345678B',TO_DATE('11011970','DDMMYYYY'),'Juan',NULL,3
000,'DIRECTOR','Lopez Z.',NULL); 
 
INSERT INTO empleado 
VALUES('87654321A',TO_DATE('12011975','DDMMYYYY'),'Fermin',1000
,2000,'GERENTE','Garcia L.','12345678B'); 
 
INSERT INTO empleado 
VALUES('64328285C',TO_DATE('13011979','DDMMYYYY'),'Rosa',NULL,1
500,'ADMINISTRADOR','Miranda R.','87654321A'); 
 
INSERT INTO empleado 
VALUES('83253235F',TO_DATE('14011980','DDMMYYYY'),'Miguel',300,
1000,'CONTABLE','Soria T.','64328285C'); 
 
-- Inserciones en la tabla DEPARTAMENTO_EMPLEAO 
 
INSERT INTO departamento_empleado 
VALUES(4,'12345678B'); 
 
INSERT INTO departamento_empleado 
VALUES(4,'87654321A'); 
 
INSERT INTO departamento_empleado 
VALUES(4,'64328285C'); 
 
INSERT INTO departamento_empleado 
VALUES(4,'83253235F'); 
Commit;
