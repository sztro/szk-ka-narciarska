DROP TABLE IF EXISTS instruktorzy CASCADE;
DROP TABLE IF EXISTS instruktorzy_stopnie CASCADE;
DROP TABLE IF EXISTS stopnie CASCADE;
DROP TABLE IF EXISTS ubezpieczenia CASCADE;
DROP TABLE IF EXISTS instruktorzy_dostepnosc CASCADE;
DROP TABLE IF EXISTS klienci CASCADE;
DROP TABLE IF EXISTS dzieci_odznaki CASCADE;
DROP TABLE IF EXISTS odznaki CASCADE;
DROP TABLE IF EXISTS dzieci_grupy CASCADE;
DROP TABLE IF EXISTS grupy CASCADE;
DROP TABLE IF EXISTS harmonogram CASCADE;

CREATE TABLE instruktorzy (
	id_instruktora SERIAL PRIMARY KEY,
	imie VARCHAR(30) NOT NULL,
	nazwisko VARCHAR(30) NOT NULL,
	numer_telefonu NUMERIC(9) NOT NULL
);
	
CREATE TABLE stopnie (
	id_stopnia SERIAL PRIMARY KEY,
	nazwa VARCHAR(100) NOT NULL,
	stawka_godzinowa INT NOT NULL
);

CREATE TABLE instruktorzy_stopnie (
	id_instruktora INT REFERENCES instruktorzy NOT NULL,
	id_stopnia INT REFERENCES stopnie NOT NULL,
	data_od DATE NOT NULL
);
	
CREATE TABLE ubezpieczenia (
	id_ubezpieczenia SERIAL PRIMARY KEY,
	numer_polisy VARCHAR(30) NOT NULL,
	id_instruktora INT REFERENCES instruktorzy NOT NULL,
	data_od DATE NOT NULL,
	data_do DATE NOT NULL,
	CHECK(data_od < data_do)
);

CREATE TABLE dostepnosc_sezon (
	id_instruktora INT REFERENCES instruktorzy NOT NULL,
	data_od DATE NOT NULL,
	data_do DATE NOT NULL,
	CHECK(data_od < data_do)
);

CREATE TABLE klienci (
    id_klienta SERIAL PRIMARY KEY,
    imie VARCHAR(30) NOT NULL,
    nazwisko VARCHAR(30) NOT NULL,
    kontakt NUMERIC(9) NOT NULL,
    data_urodz DATE
);

CREATE TABLE odznaki (
    id_odznaki SERIAL PRIMARY KEY,
    opis VARCHAR(20),
    sport VARCHAR(9)
);

CREATE TABLE dzieci_odznaki (
    id_klienta INT REFERENCES klienci NOT NULL,
    id_odznaki INT REFERENCES odznaki NOT NULL,
    data_uzysk DATE NOT NULL
);

CREATE TABLE grupy (
	id_grupy SERIAL NOT NULL PRIMARY KEY,
	id_instruktora INT REFERENCES instruktorzy NOT NULL,
	id_odznaki INT NOT NULL REFERENCES odznaki,
	data_rozpoczecia DATE NOT NULL,
	maks_dzieci INT NOT NULL,
	min_dzieci INT NOT NULL,
	CHECK(maks_dzieci >= min_dzieci)
);

CREATE TABLE dzieci_grupy (
    id_klienta INT REFERENCES klienci NOT NULL,
    id_grupy INT REFERENCES grupy NOT NULL
);
	
CREATE TABLE harmonogram (
	id_instruktora INT REFERENCES instruktorzy NOT NULL,
	"data" DATE NOT NULL,
	godz_od NUMERIC(2) NOT NULL,
	godz_do NUMERIC(2) NOT NULL,
	id_klienta INT REFERENCES klienci,
	id_grupy INT REFERENCES grupy,
	czy_nieobecność BOOL NOT NULL,
	CHECK(godz_od >= 9 AND godz_od <= 20),
	CHECK(godz_do >= 9 AND godz_do <= 20),
	CHECK(godz_do > godz_od),
	CHECK(czy_nieobecność = false OR (id_klienta IS NULL AND id_grupy IS NULL))
);

INSERT INTO instruktorzy (imie, nazwisko, numer_telefonu)
VALUES
	('Szymon', 'Trofimiec', 135792468),
	('Urszula', 'Pilśniak', 111222555),
	('Anna', 'Krzaczkowska', 112112112),
	('Leonardo', 'Fibonacci', 112358130),
	('Pitagoras', 'Pitagoras', 345051214),
	('Albert', 'Einstein', 314159265),
	('Leonhard', 'Euler', 271828182);

INSERT INTO Stopnie (nazwa, stawka_godzinowa)
VALUES
	('Pomocnik Instruktora PZN', 65),
	('Instruktor SITN', 70),
	('Instruktor PZN', 75),
	('Instruktor ISIA', 80),
	('Asystent Instruktora SITS', 65),
	('Instruktor SITS', 70),
	('Instruktor Zawodowy SITS', 75 );

INSERT INTO klienci (imie, nazwisko, kontakt, data_urodz) VALUES
	('Piotr', 'Micek', 126647594, NULL),
    ('Katerzyna', 'Grygiel',126646672 ,'2006-04-12'),
    ('Andrzej', 'Pezarski', 126647564, NULL),
    ('Iwona', 'Cieślik', 126647560, '1978-12-24'),
    ('Marek', 'Zaionc', 126646649,'1953-02-16'),
    ('Jakub', 'Kozik', 126647557,'1978-03-25'),
    ('Marcin', 'Kozik', 126647562, '1982-07-23'),
    ('Rafał', 'Pierzchała', 763476340, '1970-10-21'),
    ('Paweł', 'Idziak', 126646648, '1958-01-29'),
    ('Jan', 'Kowalski', 123456789, '1990-05-15'),
    ('Anna', 'Nowak', 987654321, '1985-10-20'),
    ('Piotr', 'Wiśniewski', 515636779, '2017-03-25'),
    ('Katarzyna', 'Dąbrowska', 181222933, '1995-08-12'),
    ('Mateusz', 'Lewandowski', 244383422, '1978-12-30'),
    ('Magdalena', 'Wójcik', 929898677, '2009-07-08'),
    ('Grzegorz', 'Kamiński', 656877318, '1976-02-18'),
    ('Natalia', 'Kowalczyk', 228373464, '1992-11-05'),
    ('Michał', 'Zieliński', 727868999, '2008-09-23'),
    ('Alicja', 'Szymańska', 828999111, '1987-04-17'),
    ('Tomasz', 'Woźniak', 333244555, '2015-01-10'),
    ('Karolina', 'Jankowska', 299117822, '1998-06-28'),
    ('Marek', 'Wojciechowski', 159447333, '1984-03-03'),
    ('Monika', 'Kaczmarek', 777166555, '2010-12-14'),
    ('Łukasz', 'Piotrowski', 117222333, '1979-08-07'),
    ('Patrycja', 'Grabowska', 838577668, '2007-05-22'),
    ('Damian', 'Nowakowski', 144525696, '1983-10-31'),
    ('Izabela', 'Pawlak', 666155444, '1994-07-19'),
    ('Kamil', 'Michalski', 224111833, '2006-01-26'),
    ('Aleksandra', 'Adamczyk', 331232171, '2018-09-09'),
    ('Maja', 'Wójcik', 123456789, '2011-02-14'),
    ('Oliwia', 'Kowalska', 987654321, '2013-08-20'),
    ('Bartosz', 'Nowakowski', 515636779, '2012-05-05'),
    ('Kacper', 'Dąbrowski', 181222933, '2010-10-22'),
    ('Zuzanna', 'Kamińska', 244383422, '2013-12-15'),
    ('Oskar', 'Zieliński', 929898677, '2009-04-28'),
    ('Julia', 'Piotrowska', 656877318, '2011-07-17'),
    ('Iga', 'Kowalczyk', 228373464, '2010-11-30'),
    ('Filip', 'Michalski', 727868999, '2014-03-24'),
    ('Nadia', 'Szymańska', 828999111, '2013-09-01'),
    ('Leon', 'Wojciechowski', 333244555, '2012-08-07');

INSERT INTO dzieci_odznaki(id_klienta, id_odznaki, data_uzysk) VALUES
    (2, 1, '2024-01-17'),
    (2, 3, '2024-01-24'),
    (2, 5, '2024-02-31'),
    (12, 1, '2024-01-17'),
    (12, 3, '2024-01-24'),
    (12, 8, '2024-01-03'),
    (15, 1, '2024-01-17'),
    (15, 6, '2024-01-24'),
    (18, 1, '2024-02-17'),
    (20, 2, '2024-01-03'),
    (20, 4, '2024-01-10'),
    (23, 6, '2023-12-27'),
    (23, 8, '2024-01-03'),
    (25, 5, '2024-01-03'),
    (25, 4, '2024-01-10'),
    (28, 4, '2024-01-10'),
    (28, 1, '2024-01-17'),
    (30, 8, '2024-01-03'),
    (31, 8, '2024-01-03'),
    (29, 3, '2024-01-24'),
    (29, 1, '2024-01-17'),
    (31, 3, '2024-01-24'),
    (32, 6, '2024-01-24'),
    (33, 6, '2024-01-24'),
    (34, 6, '2024-01-24'),
    (35, 6, '2024-01-24'),
    (35, 5, '2024-01-03'),
    (32, 8, '2024-01-31'),
    (33, 8, '2024-01-31'),
    (34, 8, '2024-01-31'),
    (35, 8, '2024-01-31'),
    (36, 5, '2024-01-03'),
    (37, 5, '2024-01-03'),
    (38, 2, '2024-01-03'),
    (39, 2, '2024-01-03'),
    (40, 2, '2024-01-03');

INSERT INTO grupy (id_instruktora, id_odznaki, data_rozpoczecia, maks_dzieci, min_dzieci) VALUES
    (1, 1, '2024-01-11', 10, 3),
    (2, 3, '2024-01-18', 10, 3),
    (3, 5, '2023-12-28', 10, 3),
    (7, 6, '2024-01-18', 10, 3),
    (6, 8, '2023-12-28', 10, 3),
    (6, 4, '2024-01-04', 10, 3);