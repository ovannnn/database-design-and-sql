: INTRO TO SQL - SQL EXAMPLES 
; SQL-TEXT-1.TXT
: These file contains sql commands used in the textbook.
: Theachers and students can use this file to "copy and paste"
: the SQL commands from this file to the "SQL>" command prompt (Oracle SQL Plus).
: This way, the class looses less time in typing (and error corrections!).
: Please be aware that date formats may differ among DBMS programs.
: Most commands here are for ORACLE 8i or MS ACCESS where indicated.
: The ";" has been removed to allow the teacher to explain the command before executing it 

======== CHANGING YOUR PASSWORD
: This Data Control Lanaguage command is given at begin of class to show students
: how to change their respective password

ALTER USER "userid" IDENTIFIED BY "abc";


======== CREATING TABLE STRUCTURES
: ORACLE will not accept UNIQUE and PRIMARY KEY in the same command sequence.
: If using ORACLE, remove the UNIQUE keyword from the two statements below.
: ORACLE does not support ON UPDATE CASCADE

CREATE TABLE VENDOR ( 
 V_CODE     INTEGER     NOT NULL UNIQUE, 
 V_NAME     VARCHAR(35) NOT NULL, 
 V_CONTACT  VARCHAR(15) NOT NULL, 
 V_AREACODE CHAR(3)     NOT NULL, 
 V_PHONE    CHAR(8)     NOT NULL, 
 V_STATE    CHAR(2)     NOT NULL, 
 V_ORDER    CHAR(1)     NOT NULL, 
 PRIMARY KEY (V_CODE))


CREATE TABLE PRODUCT ( 
 P_CODE     VARCHAR(10) NOT NULL UNIQUE, 
 P_DESCRIPT VARCHAR(35) NOT NULL, 
 P_INDATE   DATE        NOT NULL, 
 P_QOH      SMALLINT    NOT NULL,  
 P_MIN      SMALLINT    NOT NULL, 
 P_PRICE    NUMBER(8,2) NOT NULL, 
 P_DISCOUNT NUMBER(5,2) NOT NULL, 
 V_CODE     INTEGER, 
 PRIMARY KEY (P_CODE),
 FOREIGN KEY (V_CODE) REFERENCES VENDOR)

-- ORACLE Version

CREATE TABLE PRODUCT (
 P_CODE     VARCHAR2(10)
   CONSTRAINT PRODUCT_P_CODE_PK PRIMARY KEY,
 P_DESCRIPT VARCHAR2(35) NOT NULL,
 P_INDATE   DATE         NOT NULL,
 P_QOH      NUMBER       NOT NULL,
 P_MIN      NUMBER       NOT NULL,
 P_PRICE    NUMBER(8,2)  NOT NULL,
 P_DISCOUNT NUMBER(5,2)  NOT NULL,
 V_CODE     NUMBER,
   CONSTRAINT PRODUCT_V_CODE_FK
   FOREIGN KEY (V_CODE) REFERENCES VENDOR)

-- Checking table structure in Oracle

DESCRIBE VENDOR

DESCRIBE PRODUCT

======== CONSTRAINTS, CHECKS and DEFAULTS

CREATE TABLE CUSTOMER (
CUS_CODE       	NUMBER PRIMARY KEY,
CUS_LNAME       VARCHAR(15) NOT NULL,
CUS_FNAME       VARCHAR(15) NOT NULL,
CUS_INITIAL     CHAR(1),
CUS_AREACODE 	CHAR(3) DEFAULT '615' NOT NULL CHECK(CUS_AREACODE IN ('615','713','931')),
CUS_PHONE       CHAR(8) NOT NULL,
CUS_BALANCE     NUMBER(9,2) DEFAULT 0.00,
CONSTRAINT CUS_UI1 UNIQUE(CUS_LNAME,CUS_FNAME));


CREATE TABLE INVOICE (
INV_NUMBER     	NUMBER PRIMARY KEY,
CUS_CODE        NUMBER NOT NULL REFERENCES CUSTOMER(CUS_CODE),
INV_DATE        DATE DEFAULT SYSDATE NOT NULL,
CONSTRAINT INV_CK1 CHECK (INV_DATE > TO_DATE('01-JAN-2010','DD-MON-YYYY')));


CREATE TABLE LINE (
INV_NUMBER      NUMBER NOT NULL,
LINE_NUMBER     NUMBER(2,0) NOT NULL,
P_CODE	        VARCHAR(10) NOT NULL,
LINE_UNITS      NUMBER(9,2) DEFAULT 0.00 NOT NULL,
LINE_PRICE      NUMBER(9,2) DEFAULT 0.00 NOT NULL,
PRIMARY KEY (INV_NUMBER,LINE_NUMBER),
FOREIGN KEY (INV_NUMBER) REFERENCES INVOICE ON DELETE CASCADE,
FOREIGN KEY (P_CODE) REFERENCES PRODUCT(P_CODE),
CONSTRAINT LINE_UI1 UNIQUE(INV_NUMBER, P_CODE));

======== INDEXES
- Q: Create index on P_INDATE
CREATE INDEX P_INDATEX ON PRODUCT(P_INDATE);

- Q: Create composite index on V_CODE and P_CODE
CREATE INDEX VENPRODX ON PRODUCT(V_CODE,P_CODE);

- Q: Create index on P_PRICE descendent order
CREATE INDEX PROD_PRICEX ON PRODUCT(P_PRICE DESC);

- Q: Delete the PROD_PRICEX index
DROP INDEX PROD_PRICEX;

======== DATA ENTRY

INSERT INTO VENDOR
VALUES (21225,'Bryson, Inc.','Smithson','615','223-3234','TN','Y')

SELECT * FROM VENDOR;

INSERT INTO VENDOR
VALUES (21226,'Superloo, Inc.','Flushing','904','215-8995','FL','N')

SELECT * FROM VENDOR

: ORACLE users should use 'DD-MON-YY', i.e. '03-NOV-09'

INSERT INTO PRODUCT
VALUES ('11QER/31','Power painter, 15 psi., 3-nozzle','03-NOV-09',8,5,109.99,0.00,21225)

INSERT INTO PRODUCT
VALUES ('13-Q2/P2','7.25-in. pwr. saw blade','13-DEC-09',32,15,14.99, 0.05,21225)

SELECT * FROM VENDOR

-- Insert with null attribute

INSERT INTO PRODUCT
VALUES ('BRT-345','Titanium drill bit', '10/18/09', 75, 10, 4.50, 0.06, NULL)

-- Insert with optional attributes

INSERT INTO PRODUCT(P_CODE, P_DESCRIPT)
VALUES ('BRT-345','Titanium drill bit')

======== COMMIT 
: Notice that table name is not required in Oracle

COMMIT

======== LISTING TABLE CONTECTS - SELECT QUERIES
: NOTE TO ORACLE USERS:  
: You can use the following lines to set some columns display format options

SET PAGESIZE 60
SET LINESIZE 132
 
COLUMN P_PRICE FORMAT $99,999.99
COLUMN V_NAME FORMAT A12 TRUNCATE

-- SELECT

SELECT * FROM PRODUCT

SELECT P_CODE, P_DESCRIPT, P_INDATE, P_QOH, P_MIN, P_PRICE, P_DISCOUNT, V_CODE
FROM   PRODUCT

======== UPDATE TABLE ROWS 

UPDATE PRODUCT
SET    P_INDATE = '01/18/2010'
WHERE  P_CODE = '13-Q2/P2'

SELECT * FROM PRODUCT;

: Oracle date format '18-JAN-2010'

UPDATE PRODUCT
SET    P_INDATE = '01/18/2010', 
       P_PRICE = 17.99, 
       P_MIN = 10
WHERE  P_CODE = '13-Q2/P2'

SELECT * FROM PRODUCT;

======== ROLLBACK

ROLLBACK;

SELECT * FROM PRODUCT;

======== DELETE TABLE ROWS 

DELETE FROM PRODUCT
WHERE  P_CODE = 'BRT-345'

DELETE FROM PRODUCT
WHERE  P_MIN = 5

-- NOTE: use rollback to restore table rows

ROLLBACK;

======== INSERTING ROWS WITH SELECT SUBQUERY

: Run script to create P and V tables (CREATE_P_V.SQL)
: Use: @drive:\path\create_p_v.sql

DELETE FROM PRODUCT;

DELETE FROM VENDOR;

INSERT INTO VENDOR SELECT * FROM V;

INSERT INTO PRODUCT SELECT * FROM P;

SELECT * FROM VENDOR;

SELECT * FROM PRODUCT;

======== CREATE ALL DATABASE TABLES
-- Use: @drive:\path\sqlintrodbinit.sql

======== SELECT WITH WHERE CLAUSE 

SELECT P_DESCRIPT, P_INDATE, P_PRICE, V_CODE
FROM   PRODUCT
WHERE  V_CODE = 21344

-- Other comparison operators >, >=, <, <=, <>

SELECT P_DESCRIPT, P_INDATE, P_PRICE, V_CODE
FROM   PRODUCT
WHERE  V_CODE < > 21344

: Access user <>  w/o spaces

SELECT P_DESCRIPT, P_QOH, P_MIN, P_PRICE
FROM   PRODUCT
WHERE  P_PRICE <= 10

-- Using comparison operators in character attributes

SELECT P_CODE, P_DESCRIPT, P_QOH, P_MIN, P_PRICE
FROM   PRODUCT
WHERE  P_CODE < '1558-QW1'

-- Using comparison operators on dates

SELECT P_DESCRIPT, P_QOH, P_MIN, P_PRICE, P_INDATE
FROM   PRODUCT
WHERE  P_INDATE >= '20-JAN-2010'

-- Using computed columns and aliases 

SELECT P_DESCRIPT, P_QOH, P_PRICE, P_QOH*P_PRICE
FROM   PRODUCT

SELECT P_DESCRIPT, P_QOH, P_PRICE, P_QOH*P_PRICE AS TOTVALUE
FROM   PRODUCT

SELECT P_CODE, P_INDATE, SYSDATE - 90 AS CUTDATE
FROM   PRODUCT
WHERE  P_INDATE <= SYSDATE - 90

SELECT P_CODE, P_INDATE, P_INDATE + 90 AS EXPDATE
FROM   PRODUCT

-- Logical operators AND, OR, NOT

SELECT P_DESCRIPT, P_INDATE, P_PRICE, V_CODE
FROM   PRODUCT
WHERE  V_CODE = 21344
   OR  V_CODE = 24288

SELECT P_DESCRIPT, P_INDATE, P_PRICE, V_CODE
FROM   PRODUCT
WHERE  P_PRICE < 50
AND    P_INDATE > '01/15/2010'

SELECT P_DESCRIPT, P_INDATE, P_PRICE, V_CODE
FROM   PRODUCT
WHERE (P_PRICE < 50 AND P_INDATE > '15-JAN-2010')
OR     V_CODE = 24288

SELECT *
FROM   PRODUCT
WHERE  NOT (V_CODE = 21344)

-- Special operators : BETWEEN, IS NULL, LIKE, IN, EXITS

SELECT *
FROM   PRODUCT
WHERE  P_PRICE BETWEEN 50.00 AND 100.00

-- If DBMS does not support BETWEEN
SELECT *
FROM   PRODUCT
WHERE  P_PRICE > 50.00 AND P_PRICE < 100.00


SELECT P_CODE, P_DESCRIPT, V_CODE
FROM   PRODUCT
WHERE  V_CODE IS NULL

SELECT P_CODE, P_DESCRIPT, P_INDATE
FROM   PRODUCT
WHERE  P_INDATE IS NULL

-- Note: MS Access is case insensitive, ORACLE is case sensitive
-- Note: MS Access uses * and %, ORACLE uses % and _

SELECT V_NAME, V_CONTACT, V_AREACODE, V_PHONE
FROM   VENDOR
WHERE  V_CONTACT LIKE 'Smith%'

: or use this version if case sensitive 

SELECT V_NAME, V_CONTACT, V_AREACODE, V_PHONE
FROM   VENDOR
WHERE  UPPER(V_CONTACT) LIKE 'SMITH%'

SELECT V_NAME, V_CONTACT, V_AREACODE, V_PHONE
FROM   VENDOR
WHERE  V_CONTACT NOT LIKE 'Smith%'

SELECT *
FROM   VENDOR
WHERE  V_CONTACT LIKE 'Johns_n'

SELECT *
FROM   PRODUCT
WHERE  V_CODE IN (21344, 24288)

--If DBMS does not support IN
SELECT *
FROM   PRODUCT
WHERE  V_CODE = 21344
OR     V_CODE = 24288

- Q: List the v_code of vendors that provide products
SELECT V_CODE FROM PRODUCT      		-- includes duplicates and Nulls

SELECT DISTINCT V_CODE FROM PRODUCT      	-- includes Nulls

- Q: List the V_CODE and V_NAME of vendors that provide products
SELECT V_CODE, V_NAME
FROM   VENDOR 
WHERE  V_CODE IN (SELECT DISTINCT V_CODE FROM PRODUCT)

- Three value logic (NULL) problem - Null values in FK cause problems
- Q: List the V_CODE and V_NAME of vendors that do not provide products

   - will list no rows!

- Correct answer
SELECT V_CODE, V_NAME
FROM   VENDOR 
WHERE  V_CODE NOT IN (SELECT DISTINCT V_CODE FROM PRODUCT WHERE V_CODE IS NOT NULL)

-- EXISTS
- Returns true if the inner query returns at least 1 row, otherwise it returns false
- Q: List all vendors but only if there are products to order (P_QOH <= P_MIN)

SELECT *
FROM   VENDOR
WHERE  EXISTS (SELECT * FROM PRODUCT WHERE P_QOH <= P_MIN)

- Q: List all vendors but only if there are products with the qty on hand less than double the min qty
SELECT * FROM VENDOR
WHERE  EXISTS (SELECT * FROM PRODUCT WHERE P_QOH < P_MIN*2)

- Q: List the products that are supplied by a vendor
SELECT *
FROM   PRODUCT
WHERE  V_CODE IS NOT NULL

======== ADVANCED DATA MGMT

-- ALTER DATA TYPE
- Will not run unless column is empty - only increasing size will work
- Q: Change the V_CODE data type to CHAR
ALTER  TABLE PRODUCT
MODIFY (V_CODE CHAR(5))

- Q: Increase the width of P_PRICE column to nine digits
ALTER  TABLE PRODUCT
MODIFY (P_PRICE DECIMAL(9,2))

-- ADD A COLUMN TO TABLE

ALTER TABLE PRODUCT
ADD   (P_SALECODE CHAR(1))

-- DROPING A COLUMN FROM TABLE
- Only will work if column has no data or is not related in a foreign key relationship.

ALTER TABLE VENDOR
DROP  COLUMN V_ORDER

-- UPDATE COMMANDS

UPDATE PRODUCT
SET    P_SALECODE = '2'
WHERE  P_CODE = '1546-QQ2'

UPDATE PRODUCT
SET    P_SALECODE = '1'
WHERE  P_CODE IN ('2232/QWE', '2232/QTY')

UPDATE PRODUCT
SET    P_SALECODE = '2'
WHERE  P_INDATE < '12/25/2009'

UPDATE PRODUCT
SET    P_SALECODE = '1'
WHERE  P_INDATE >= '01/16/2010'
AND    P_INDATE <  '02/10/2010'

COMMIT;

UPDATE PRODUCT
SET    P_QOH = P_QOH + 20
WHERE  P_CODE = '2232/QWE'

UPDATE PRODUCT
SET    P_PRICE = P_PRICE*1.10
WHERE  P_PRICE < 50.00

ROLLBACK;

---- COPYING PARTS OF TABLES
- Q: Create a PART table with only using the code, description and price columns of PRODUCT
CREATE TABLE PART (
PART_CODE       CHAR(8) NOT NULL UNIQUE,
PART_DESCRIPT   CHAR(35),
PART_PRICE      DECIMAL(8,2),
V_CODE		INTEGER,
PRIMARY KEY (PART_CODE))

INSERT INTO PART (PART_CODE, PART_DESCRIPT, PART_PRICE, V_CODE)
SELECT P_CODE, P_DESCRIPT, P_PRICE, V_CODE FROM PRODUCT

- OR USE THIS
- ORACLE VERSION

CREATE TABLE PART AS 
SELECT P_CODE AS PART_CODE, 
       P_DESCRIPT AS PART_DESCRIPT, 
       P_PRICE AS PART_PRICE,
       V_CODE
FROM   PRODUCT

- OR MS ACCESS VERSION

SELECT 	P_CODE AS PART_CODE,
	P_DESCRIPT AS PART_DESCRIPT,
	P_PRICE AS PART_PRICE,
	V_CODE 
INTO   PART 
FROM   PRODUCT

-- ADDING PK AND FK WITH THE ALTER TABLE COMMAND

ALTER TABLE PART 
  ADD PRIMARY KEY(PART_CODE)

ALTER TABLE PART
  ADD PRIMARY KEY(P_CODE)

ALTER TABLE PART
  ADD FOREIGN KEY(V_CODE) REFERENCES VENDOR

- OR

ALTER TABLE PART 
  ADD PRIMARY KEY(P_CODE)
  ADD FOREIGN KEY (V_CODE) REFERENCES VENDOR

---- DROPING A TABLE 

DROP TABLE PART

======== END PART I