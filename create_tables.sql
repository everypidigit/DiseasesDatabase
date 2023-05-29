-- Active: 1668768574551@@127.0.0.1@3306@assignment2
CREATE SCHEMA assignment2;

USE assignment2;

SHOW TABLES;

SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

CREATE TABLE DiseaseType (
    id INTEGER PRIMARY KEY NOT NULL,
    description VARCHAR(140)
);
CREATE TABLE Country (
    cname VARCHAR(50) PRIMARY KEY NOT NULL, 
    population BIGINT
);
CREATE TABLE Disease (
    disease_code VARCHAR(50) PRIMARY KEY, 
    pathogen VARCHAR(20), 
    description VARCHAR(140), 
    id INTEGER,
    UNIQUE (disease_code),
    FOREIGN KEY (id) REFERENCES DiseaseType(id)
);
CREATE TABLE Discover (
    cname VARCHAR(50) NOT NULL, 
    disease_code VARCHAR(50) NOT NULL, 
    first_enc_date DATE, 
    PRIMARY KEY (cname, disease_code), 
    FOREIGN KEY (disease_code) REFERENCES Disease(disease_code), 
    FOREIGN KEY (cname) REFERENCES Country(cname)
);
CREATE TABLE Users (
    email VARCHAR (60) PRIMARY KEY NOT NULL, 
    name VARCHAR(30), 
    surname VARCHAR(40), 
    salary INTEGER, 
    phone VARCHAR(20), 
    cname VARCHAR(50), 
    FOREIGN KEY (cname) REFERENCES Country(cname)
);
CREATE TABLE PublicServant (
    email VARCHAR(60) PRIMARY KEY NOT NULL, 
    department VARCHAR(50) NOT NULL, 
    FOREIGN KEY (email) REFERENCES Users(email)
);
CREATE TABLE Doctor (
    email VARCHAR (60) PRIMARY KEY NOT NULL, 
    degree VARCHAR(20), 
    FOREIGN KEY (email) REFERENCES Users(email)
);
CREATE TABLE Specialize (
    id INTEGER NOT NULL,  
    email VARCHAR(60) NOT NULL, 
    PRIMARY KEY (id, email), 
    FOREIGN KEY (id) REFERENCES DiseaseType(id), 
    FOREIGN KEY (email) REFERENCES Doctor(email)
);
CREATE TABLE Record (
    email VARCHAR (60) NOT NULL, 
    cname VARCHAR(50) NOT NULL, 
    disease_code VARCHAR(50) NOT NULL, 
    total_deathss INTEGER, 
    total_patients INTEGER, 
    PRIMARY KEY (email, cname, disease_code), 
    FOREIGN KEY (cname) REFERENCES Country(cname), 
    FOREIGN KEY (disease_code) REFERENCES Disease(disease_code), 
    FOREIGN KEY (email) REFERENCES PublicServant(email)
);

SHOW TABLES;

INSERT INTO DiseaseType(id, description) VALUES ('1', 'Self-inflicted');
INSERT INTO DiseaseType(id, description) VALUES ('2', 'Bacteria-inflicted');
INSERT INTO DiseaseType(id, description) VALUES ('3', 'infectious diseases');
INSERT INTO DiseaseType(id, description) VALUES ('4', 'weather-induced diseases');
INSERT INTO DiseaseType(id, description) VALUES ('5', 'insects-indused diseases');
INSERT INTO DiseaseType(id, description) VALUES ('6', 'mammalian diseases');
INSERT INTO DiseaseType(id, description) VALUES ('7', 'human diseases');
INSERT INTO DiseaseType(id, description) VALUES ('8', 'nervous system diseases');
INSERT INTO DiseaseType(id, description) VALUES ('9', 'mental health diseases');
INSERT INTO DiseaseType(id, description) VALUES ('10', 'physical health diseases');

INSERT INTO Country(cname, population) VALUES ('Kazakhstan', '1800000');
INSERT INTO Country(cname, population) VALUES ('Ukraine', '34000000');
INSERT INTO Country(cname, population) VALUES ('Russia', '154000000');
INSERT INTO Country(cname, population) VALUES ('USA', '321000000');
INSERT INTO Country(cname, population) VALUES ('Canada', '94000000');
INSERT INTO Country(cname, population) VALUES ('Uganda', '34000000');
INSERT INTO Country(cname, population) VALUES ('Greece', '66000000');
INSERT INTO Country(cname, population) VALUES ('Germany', '85000000');
INSERT INTO Country(cname, population) VALUES ('Vatikan', '250000');
INSERT INTO Country(cname, population) VALUES ('Luxembourg', '350000');

INSERT INTO Disease (disease_code, pathogen, description, id) VALUES('winterfiner1', 'virus','the most common type of diseases', '1' );
INSERT INTO Disease (disease_code, pathogen, description, id) VALUES('covid-19', 'virus','a man-made disease; biological weapon', '1');
INSERT INTO Disease (disease_code, pathogen, description, id) VALUES('borealis3', 'bacteria', 'very usual disease in Eastern Asia', '2');
INSERT INTO Disease (disease_code, pathogen, description, id) VALUES('david-223', 'bacteria', 'a disease that kills 5 million people each year', '2');
INSERT INTO Disease (disease_code, pathogen, description, id) VALUES('daniyar-2001', 'bacteria', 'mostly occurs in very sunny places which causes bacteria to choose a person', '2');
INSERT INTO Disease (disease_code, pathogen, description, id) VALUES('atlantis6', 'worms', 'occurs in people who eat a not well-prepared meat', '3');
INSERT INTO Disease (disease_code, pathogen, description, id) VALUES('basolda7', 'virus', 'a disease that caused a pandemic in 2020', '3');
INSERT INTO Disease (disease_code, pathogen, description, id) VALUES('derivata8', 'fungi', 'occurs in rainy places', '8');
INSERT INTO Disease (disease_code, pathogen, description, id) VALUES('integrale9', 'fungi', 'mostly affects muscles', '10');
INSERT INTO Disease (disease_code, pathogen, description, id) VALUES('bacterioza10', 'bacteria', 'is usually strong in winter', 6);

INSERT INTO Discover (cname, disease_code, first_enc_date) VALUES ('Canada', 'daniyar-2001', '1678-12-10');
INSERT INTO Discover (cname, disease_code, first_enc_date) VALUES ('USA', 'bacterioza10', '1994-10-05');
INSERT INTO Discover (cname, disease_code, first_enc_date) VALUES ('Kazakhstan', 'covid-19', '1456-06-06');
INSERT INTO Discover (cname, disease_code, first_enc_date) VALUES ('Uganda', 'integrale9', '1875-12-24');
INSERT INTO Discover (cname, disease_code, first_enc_date) VALUES ('Russia', 'derivata8', '1775-04-04');
INSERT INTO Discover (cname, disease_code, first_enc_date) VALUES ('Ukraine', 'basolda7', '1932-05-12');
INSERT INTO Discover (cname, disease_code, first_enc_date) VALUES ('Greece', 'atlantis6', '1773-11-24');
INSERT INTO Discover (cname, disease_code, first_enc_date) VALUES ('Germany', 'david-223', '1993-07-17');
INSERT INTO Discover (cname, disease_code, first_enc_date) VALUES ('USA', 'borealis3', '1895-10-10');
INSERT INTO Discover (cname, disease_code, first_enc_date) VALUES ('Germany', 'winterfiner1', '1886-02-15');

INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('harden@gmail.com','James', 'Harden','2000000','87787155364','USA');
INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('haslem@gmail.com','Udonis', 'Haslem','120000','87745837591','USA');
INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('brown@gmail.com','Jalen', 'Brown','150000','77753155364','Uganda');
INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('vitayev@gmail.com','Alen', 'Vitayev','3000','1984797175','Ukraine');
INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('jameson@gmail.com','James', 'James','350000','1415771234','Canada');
INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('kites@gmail.com','Daniel', 'Kites','12000000','87085824336','Kazakhstan');
INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('sellsword@gmail.com', 'Didar', 'Maximov','35000000','1983469918','Russia');
INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('maxwell@gmail.com', 'Plum', 'Maxwell', '24000', '123456743123','Germany');
INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('jenkins@gmail.com', 'Kyle', 'Jenkins','390000', '1009900911','Vatikan');
INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('zhaksylykov71@mail.ru','Arlan', 'Zhaksylykov', '12351', '87171239871', 'Greece');
INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('darabayeva@gmail.com','Sara', 'Darabayeva', '276000', '87171239124', 'Kazakhstan');
INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('adarynov@gmail.com','Aliber', 'Darynov', '272000', '871712312424', 'Kazakhstan');
INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('luxaburga@gmail.com','Luxa', 'Burga', '3116000', '171223239124', 'Luxembourg');
INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('zazzapazza@gmail.com','Zarina', 'Burgaliyeva', '3116000', '1712212339124', 'USA');


INSERT INTO PublicServant (email, department) VALUES ('harden@gmail.com','Dept1');
INSERT INTO PublicServant (email, department) VALUES ('haslem@gmail.com','Dept1');
INSERT INTO PublicServant (email, department) VALUES ('brown@gmail.com', 'Dept1');
INSERT INTO PublicServant (email, department) VALUES ('vitayev@gmail.com','Dept2');
INSERT INTO PublicServant (email, department) VALUES ('jameson@gmail.com','Dept5');
INSERT INTO PublicServant (email, department) VALUES ('kites@gmail.com','Dept3');
INSERT INTO PublicServant (email, department) VALUES ('sellsword@gmail.com','Dept4');
INSERT INTO PublicServant (email, department) VALUES ('maxwell@gmail.com','Dept3');
INSERT INTO PublicServant (email, department) VALUES ('jenkins@gmail.com','Dept2');
INSERT INTO PublicServant (email, department) VALUES ('zhaksylykov71@mail.ru','Dept1');
INSERT INTO PublicServant (email, department) VALUES ('zazzapazza@gmail.com','Dept1');



INSERT INTO Doctor (email, degree) VALUES ('harden@gmail.com', 'PhD');
INSERT INTO Doctor (email, degree) VALUES ('zazzapazza@gmail.com', 'PhD');
INSERT INTO Doctor (email, degree) VALUES ('haslem@gmail.com', 'MD');
INSERT INTO Doctor (email, degree) VALUES ('jenkins@gmail.com', 'PhD');
INSERT INTO Doctor (email, degree) VALUES ('darabayeva@gmail.com', 'MD');
INSERT INTO Doctor (email, degree) VALUES ('brown@gmail.com', 'PhD');
INSERT INTO Doctor (email, degree) VALUES ('maxwell@gmail.com', 'PhD');
INSERT INTO Doctor (email, degree) VALUES ('jameson@gmail.com', 'MD');
INSERT INTO Doctor (email, degree) VALUES ('vitayev@gmail.com', 'MD');
INSERT INTO Doctor (email, degree) VALUES ('kites@gmail.com', 'MD');
INSERT INTO Doctor (email, degree) VALUES ('sellsword@gmail.com', 'PhD');

INSERT INTO Specialize (id, email) VALUES ('1', 'kites@gmail.com');
INSERT INTO Specialize (id, email) VALUES ('1 2', 'zazzapazza@gmail.com');
INSERT INTO Specialize (id, email) VALUES ('2', 'harden@gmail.com');
INSERT INTO Specialize (id, email) VALUES ('3', 'sellsword@gmail.com');
INSERT INTO Specialize (id, email) VALUES ('4', 'haslem@gmail.com');
INSERT INTO Specialize (id, email) VALUES ('5', 'jenkins@gmail.com');
INSERT INTO Specialize (id, email) VALUES ('6', 'maxwell@gmail.com');
INSERT INTO Specialize (id, email) VALUES ('7', 'jameson@gmail.com');
INSERT INTO Specialize (id, email) VALUES ('8', 'vitayev@gmail.com');
INSERT INTO Specialize (id, email) VALUES ('9', 'brown@gmail.com');
INSERT INTO Specialize (id, email) VALUES ('10', 'darabayeva@gmail.com');

INSERT INTO Record (email, cname, disease_code, total_deaths, total_patients) VALUES ('kites@gmail.com','Kazakhstan','winterfiner1','150000','670000');
INSERT INTO Record (email, cname, disease_code, total_deaths, total_patients) VALUES ('harden@gmail.com','USA','covid-19','383','778');
INSERT INTO Record (email, cname, disease_code, total_deaths, total_patients) VALUES ('sellsword@gmail.com','Russia','borealis3','17000','18300');
INSERT INTO Record (email, cname, disease_code, total_deaths, total_patients) VALUES ('haslem@gmail.com','USA','covid-19','781934','2863663');
INSERT INTO Record (email, cname, disease_code, total_deaths, total_patients) VALUES ('jenkins@gmail.com','Vatikan','bacterioza10','15','9812356');
INSERT INTO Record (email, cname, disease_code, total_deaths, total_patients) VALUES ('brown@gmail.com','Uganda','covid-19','8722817','123666123');
INSERT INTO Record (email, cname, disease_code, total_deaths, total_patients) VALUES ('brown@gmail.com','Kazakhstan','covid-19','8722817','123666123');
INSERT INTO Record (email, cname, disease_code, total_deaths, total_patients) VALUES ('brown@gmail.com','USA','covid-19','8722817','123666123');
INSERT INTO Record (email, cname, disease_code, total_deaths, total_patients) VALUES ('brown@gmail.com','Germany','covid-19','8722817','123666123');
INSERT INTO Record (email, cname, disease_code, total_deaths, total_patients) VALUES ('vitayev@gmail.com','Ukraine','derivata8','87663','167917');
INSERT INTO Record (email, cname, disease_code, total_deaths, total_patients) VALUES ('harden@gmail.com','USA','derivata8','123663','16791557');
INSERT INTO Record (email, cname, disease_code, total_deaths, total_patients) VALUES ('maxwell@gmail.com','Germany','daniyar-2001','167','735617');
INSERT INTO Record (email, cname, disease_code, total_deaths, total_patients) VALUES ('kites@gmail.com','Kazakhstan','integrale9','250213','830314');
INSERT INTO Record (email, cname, disease_code, total_deaths, total_patients) VALUES ('zhaksylykov71@mail.ru','Uganda','basolda7','131556','8717178');


-- BEKS and GULS
INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('avorynov@gmail.com','Alibek', 'Vorynov', '12372000', '871715312424', 'Canada');
INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('gulya_varina@gmail.com','Gulsim', 'Varina', '316000', '87123239124', 'Kazakhstan');
INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES ('nurya_varina@gmail.com','Nurgul', 'Varina', '123500', '87123234144', 'Kazakhstan');


