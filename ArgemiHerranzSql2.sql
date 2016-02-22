Pr�ctica 0, part 2: SQL est�ndard

1. Crea un script per a la creaci� d�aquesta base de dades. Cal tenir present:
a. Dels tipus de dades assignats a les columnes de cada taula, �s molt important especificar la seva longitud m�xima adaptada als possibles valors que contindran les columnes de cada fila de cada taula.
b. Cal especificar les restriccions (primary key, foreign key, unique,....) que s�indiquen, en el moment de la creaci� de les taules.


CREATE TABLE departament
( codi varchar2(3) NOT NULL,
  nom varchar2(20) NOT NULL,
  CONSTRAINT pk_departament PRIMARY KEY (codi)
);


CREATE TABLE professor
( codi int NOT NULL,
  cognom1 varchar2(25) NOT NULL,
  cognom2 varchar2(25) NOT NULL,
  nom varchar2(20) NOT NULL,
  actiu varchar2(1) NOT NULL,
  categoria varchar2(40) NOT NULL,
  dedicacio varchar2(3) NOT NULL,
  departament varchar2(3) NOT NULL,
  director int,
  CONSTRAINT pk_professor PRIMARY KEY (codi),
  CONSTRAINT fk_professor_departament FOREIGN KEY (departament) REFERENCES departament(codi)
);

ALTER TABLE professor
  ADD CONSTRAINT fk_professor_director FOREIGN KEY (director) REFERENCES professor(codi);


CREATE TABLE assignatura
( sigles varchar2(6) NOT NULL,
  nom varchar2(40) NOT NULL,
  credits int,
  curs varchar2(3),
  hores_teoria int,
  hores_practica int,
  num_alumnes int,
  CONSTRAINT pk_assignatura PRIMARY KEY (sigles),
  CONSTRAINT ak_assignatura UNIQUE(nom)
);


CREATE TABLE classe
( codi varchar2(5) NOT NULL,
  nom varchar2(40) NOT NULL,
  capacitat int,
  situacio varchar2(40),
  CONSTRAINT pk_classe PRIMARY KEY (codi)
);


CREATE TABLE docencia
( id number(6) NOT NULL,
  professor int NOT NULL,
  classe varchar2(5),
  assignatura varchar2(6),
  Curs_academic varchar2(5),
  CONSTRAINT pk_docencia PRIMARY KEY (id),
  CONSTRAINT fk_docencia_professor FOREIGN KEY (professor) REFERENCES professor(codi),
  CONSTRAINT fk_docencia_classe FOREIGN KEY (classe) REFERENCES classe(codi),
  CONSTRAINT fk_docencia_assignatura FOREIGN KEY (assignatura) REFERENCES assignatura(sigles),
  CONSTRAINT ak_docencia UNIQUE(professor,classe,assignatura)
);



2. Crea un script per eliminar totes les taules de la base de dades
Per eliminar una taula DROP TABLE nom_taula

DROP TABLE professor;
DROP TABLE departament;
DROP TABLE assignatura;
DROP TABLE docencia;
DROP TABLE classe;


3. Torna a executar l�script de creaci� de taules

4. Crea un script reutilitzable per inserir com a m�nim 3 files a cada taula de la base de dades amb dades donades per l�usuari.

/*
DEPARTAMENT
*/

TRUNCATE TABLE Departament; 

INSERT INTO Departament (codi, nom) VALUES ('001','Inform�tica');
INSERT INTO Departament (codi, nom) VALUES ('002','Telem�tica');
INSERT INTO Departament (codi, nom) VALUES ('003','Electr�nica');

SELECT * FROM Departament;

/*
PROFESSOR
*/

TRUNCATE TABLE professor; 

INSERT INTO professor 
(codi, cognom1, cognom2, nom, actiu, categoria, dedicacio, departament, director) 
VALUES (1,'Jimenez', 'Clos', 'Josep', 'S', 'Titular', 'TC', '001', 3);

INSERT INTO professor 
(codi, cognom1, cognom2, nom, actiu, categoria, dedicacio, departament, director) 
VALUES (2,'Marti', 'Margall', 'Maria', 'S', 'Titular', 'TC', '001', 3);

INSERT INTO professor 
(codi, cognom1, cognom2, nom, actiu, categoria, dedicacio, departament, director) 
VALUES (3,'Mons', 'Adell', 'Marta', 'S', 'Director', 'TC', '002', NULL);


SELECT * FROM professor;


/*
DOC�NCIA
*/

TRUNCATE TABLE docencia;

INSERT INTO docencia 
(id, professor, classe, assignatura, Curs_academic) 
VALUES (1, 2, 2, 'MP', '08_09');

INSERT INTO docencia 
(id, professor, classe, assignatura, Curs_academic) 
VALUES (2, 2, 2, 'BD', '08_09');

INSERT INTO docencia 
(id, professor, classe, assignatura, Curs_academic) 
VALUES (3, 1, 1, 'SO', '08_09');

SELECT * FROM docencia

/*
ASSIGNATURA
*/

TRUNCATE TABLE assignatura;

INSERT INTO assignatura 
(sigles, nom, credits, curs, hores_teoria, hores_practica, num_alumnes) 
VALUES ('MP', 'Metodologia', 6, '1B', 3, 1, 30);

INSERT INTO assignatura 
(sigles, nom, credits, curs, hores_teoria, hores_practica, num_alumnes) 
VALUES ('BD', 'Bases de dades', 6, '2A', 4, 0, 28);

INSERT INTO assignatura 
(sigles, nom, credits, curs, hores_teoria, hores_practica, num_alumnes) 
VALUES ('SO', 'Sistemes Operatius', 9, '3A', 5, 1, 46);

SELECT * FROM assignatura

/*
CLASSE
*/

TRUNCATE TABLE classe;

INSERT INTO classe 
(codi, nom, capacitat, situacio) 
VALUES ('1', '3.1', 60, 'Planta3');

INSERT INTO classe 
(codi, nom, capacitat, situacio) 
VALUES ('2', '2.3', 30, 'Planta2');

INSERT INTO classe 
(codi, nom, capacitat, situacio) 
VALUES ('3', '2.6', 30, 'Planta2');

SELECT * FROM classe


5. Canvia la definici� de la restricci� de clau prim�ria de la taula departaments per
assignar-li el nom pk.
Especifica els passos per aconseguir el nom assignat a la restricci� i despr�s usa la
sent�ncia ALTER TABLE per canviar el nom a la restricci�

ALTER TABLE departaments
DROP CONSTRAINT pk_departament
ADD CONSTRAINT pk PRIMARY KEY (codi);

6. Afegir la regla de negoci de que els professors nom�s poden tenir assignada una
dedicaci� de temps complert (TC), o parcial de 6 hores (6h) o de 3 hores(3h).
Comprovar que has modelat b� intentant modificar la dedicaci� del professor de
codi=1 al valor 20m.
Especifica la sent�ncia per afegir aquesta regla de negoci una vegada ja est� creada
la base de dades.

ALTER TABLE professor
add constraint chk_professor_dedicacio_values check (dedicacio IN ('TC', '6h', '3h'));

UPDATE professor SET dedicacio = '20m' WHERE codi = '1';
SELECT * FROM professor;


7. Comprovar quines s�n les restriccions definides a la taula Classe. Una d�elles no �s necess�ria ja que �s redundant. Detecta-la i elimina-la. Executa alguna operaci� de tipus DML per a demostrar que encara que aquesta restricci� s�ha eliminat, es segueix satisfent.

ALTER TABLE classe
MODIFY (codi NULL);

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name = "classe";

8. Desactivar la restricci� NOT NULL de la columna nom de la taula departaments.
Comprovar amb alguna operaci� UPDATE que ja est� desactivada. Tornar a activar-la i
esbrinar quin efecte produeix el canvi. Torna la situaci� de manera que la restricci� quedi activada.

INSERT INTO departament (codi) VALUES ('999');

ALTER TABLE departament MODIFY nom NULL ;

INSERT INTO departament (codi) VALUES ('999');

ALTER TABLE departament MODIFY nom NOT NULL ;

UPDATE departament SET nom = 'PROVA' WHERE codi='999';

ALTER TABLE departament MODIFY nom NOT NULL ;

SELECT * FROM departament;


9. Afegir la regla de negoci de que una assignatura t� una hora setmanal de classe (de teoria i/o pr�ctiques) per cada 1,5 cr�dits. Comprovar abans d�afegir-la que aquesta regla de negoci es satisf� amb les dades actuals.

SELECT credits, (hores_teoria + hores_practica)*1.5, CASE WHEN credits = (hores_teoria + hores_practica)*1.5 THEN 'OK' ELSE 'NO' END as VALID FROM assignatura;

ALTER TABLE assignatura
add constraint chk_hores_credits check (credits = (hores_teoria + hores_practica)*1.5);


10. Afegir una regla de negoci que verifiqui que els cr�dits d�una assignatura com a
m�xim s�n 9.

ALTER TABLE assignatura
add constraint chk_assignatura_min_max check (credits between 0 and 9);

SELECT * FROM assignatura ;
UPDATE assignatura SET credits = 10 WHERE sigles = 'SO';
SELECT * FROM assignatura ;

11. Afegir una regla de negoci que comprovi que a la taula doc�ncia, la capacitat de la classe assignada a una assignatura ha de ser m�s gran o igual al n�mero d�alumnes
d�aquesta assignatura.

SELECT classe.capacitat, assignatura.num_alumnes 
FROM docencia
JOIN classe ON docencia.classe = classe.codi
JOIN assignatura ON docencia.assignatura = assignatura.sigles;

ALTER TABLE docencia
add constraint chk_capacitat_num_alumnes check (????);

12. Comprova quina acci� referencial est� associada a la restricci� d�integritat
referencial definida a l�atribut departament de la taula professor.

SELECT *
FROM USER_CONSTRAINTS
WHERE constraint_type = 'R'
AND table_name = 'PROFESSOR';


13. Fes que la restricci� de clau forana de l�atribut departament de la taula professor tingui l�acci� referencial d�esborrat de posada a nuls.
Fes alguna comprovaci�: fes algun esborrat i comprova que s�han posat els valors
pertinents a nul. Desf�s l�operaci� d�esborrat de la comprovaci�.

ALTER TABLE professor
    MODIFY departament NULL;

ALTER TABLE professor
    DROP CONSTRAINT fk_professor_departament;

ALTER TABLE professor
    ADD CONSTRAINT fk_professor_departament FOREIGN KEY (departament) REFERENCES departament(codi) ON DELETE SET NULL;
    
DELETE departament WHERE codi = '002';
SELECT * FROM departament;
SELECT * FROM professor;

INSERT INTO Departament (codi, nom) VALUES ('002','Telem�tica');
UPDATE professor SET departament  = '002' WHERE departament  IS NULL;


SELECT * FROM departament;
SELECT * FROM professor;


14. Fes que la restricci� de clau forana de l�atribut departament de la taula professor tingui l�acci� referencial d�esborrat en cascada.
Fes alguna comprovaci�: fes algun esborrat i comprova que s�han eliminat les files
pertinents. En cas de no obtenir el resultat esperat. Dona una justificaci�. Soluciono.
Desf�s les operacions d�esborrat de la comprovaci�.

ALTER TABLE professor
    DROP CONSTRAINT fk_professor_departament;

ALTER TABLE professor
    ADD CONSTRAINT fk_professor_departament FOREIGN KEY (departament) REFERENCES departament(codi) ON DELETE CASCADE;
    
DELETE departament WHERE codi = '002';
    
SELECT * FROM departament;
SELECT * FROM professor;

INSERT INTO Departament (codi, nom) VALUES ('002','Telem�tica');
INSERT INTO professor 
(codi, cognom1, cognom2, nom, actiu, categoria, dedicacio, departament, director) 
VALUES (3,'Mons', 'Adell', 'Marta', 'S', 'Director', 'TC', '002', NULL);
    
SELECT * FROM departament;
SELECT * FROM professor;
    

15. Deixa la restricci� de clau forana tal i com estava abans de fer els canvis al punt 12.

ALTER TABLE professor
    MODIFY departament NOT NULL;

ALTER TABLE professor
    DROP CONSTRAINT fk_professor_departament;

ALTER TABLE professor
    ADD CONSTRAINT fk_professor_departament FOREIGN KEY (departament) REFERENCES departament(codi);

16. Insereix a la taula departament 3 files on nom�s hi aparegui el codi, �s a dir:
Pots fer-ho?. Desactiva les restriccions pertinents per poder introduir aquestes 3 files
a la taula departament. Insereix les files a la taula.
Activa les restriccions que has desactivant indicant que les dades que ja estan a la
taula no es validin. Comprova que aquesta informaci� la guardes al diccionari de
dades. 

ALTER TABLE departament
  MODIFY nom NULL;

INSERT INTO Departament (codi, nom) VALUES ('004',NULL);
INSERT INTO Departament (codi, nom) VALUES ('005',NULL);
INSERT INTO Departament (codi, nom) VALUES ('006',NULL);

ALTER TABLE departament
  MODIFY nom NOT NULL;

17. A la taula professor insereix les seg�ents files, en aquest ordre: 
Et surt algun error?. Quin?. Com ho faries per tal de que la comprovaci� de les restriccions es
realitzes en el moment del commit? 

INSERT INTO professor 
(codi, cognom1, cognom2, nom, actiu, categoria, dedicacio, departament, director) 
VALUES (4,'Marti', 'Gomez', 'Pere', 'S', 'Titular', 'TC', '001', 6);

INSERT INTO professor 
(codi, cognom1, cognom2, nom, actiu, categoria, dedicacio, departament, director) 
VALUES (5,'Cotet', 'Jull', 'Albert', 'S', 'Titular', 'TC', '001', 6);

INSERT INTO professor 
(codi, cognom1, cognom2, nom, actiu, categoria, dedicacio, departament, director) 
VALUES (6,'Adell', 'Carpi', 'Xavier', 'S', 'Director', 'TC', '002', NULL);