DROP TABLE IF EXISTS instruktorzy CASCADE;
DROP TABLE IF EXISTS instruktorzy_stopnie CASCADE;
DROP TABLE IF EXISTS stopnie CASCADE;
DROP TABLE IF EXISTS ubezpieczenia CASCADE;
DROP TABLE IF EXISTS dostepnosc_sezon CASCADE;
DROP TABLE IF EXISTS klienci CASCADE;
DROP TABLE IF EXISTS dzieci_odznaki CASCADE;
DROP TABLE IF EXISTS odznaki CASCADE;
DROP TABLE IF EXISTS dzieci_grupy CASCADE;
DROP TABLE IF EXISTS grupy CASCADE;
DROP TABLE IF EXISTS harmonogram CASCADE;
DROP TABLE IF EXISTS stawki_stopnie;
DROP TABLE IF EXISTS sporty;

CREATE TABLE instruktorzy (
	id_instruktora SERIAL PRIMARY KEY,
	imie VARCHAR(30) NOT NULL,
	nazwisko VARCHAR(30) NOT NULL,
	numer_telefonu NUMERIC(9) NOT NULL
);
CREATE TABLE stopnie (
	id_stopnia SERIAL PRIMARY KEY,
	nazwa VARCHAR(100) NOT NULL
);

CREATE TABLE stawki_stopnie (
	id_stopnia INT REFERENCES stopnie NOT NULL,
	stawka_godzinowa INT NOT NULL,
	data_od DATE NOT NULL,
	PRIMARY KEY (id_stopnia, data_od),
	CHECK (stawka_godzinowa >= 0),
	CHECK (data_od <= CURRENT_DATE)
);

CREATE TABLE instruktorzy_stopnie (
	id_instruktora INT REFERENCES instruktorzy NOT NULL,
	id_stopnia INT REFERENCES stopnie NOT NULL,
	data_od DATE NOT NULL,
	PRIMARY KEY (id_instruktora, id_stopnia)
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
	CHECK(data_od <= data_do),
	PRIMARY KEY (id_instruktora, data_od)
);

CREATE TABLE klienci (
    id_klienta SERIAL PRIMARY KEY,
    imie VARCHAR(30) NOT NULL,
    nazwisko VARCHAR(30) NOT NULL,
    kontakt NUMERIC(9) NOT NULL,
    data_urodz DATE
);

CREATE TABLE sporty (
	id_sportu SERIAL PRIMARY KEY,
	opis VARCHAR(9)
);

CREATE TABLE odznaki (
    id_odznaki SERIAL PRIMARY KEY,
    opis VARCHAR(20),
    id_sportu INT REFERENCES sporty NOT NULL
);

CREATE TABLE dzieci_odznaki (
    id_klienta INT REFERENCES klienci NOT NULL,
    id_odznaki INT REFERENCES odznaki NOT NULL,
    data_uzysk DATE NOT NULL,
	PRIMARY KEY (id_klienta, id_odznaki, data_uzysk)
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
    id_grupy INT REFERENCES grupy NOT NULL,
	PRIMARY KEY (id_klienta, id_grupy)
);
	
CREATE TABLE harmonogram (
	id_instruktora INT REFERENCES instruktorzy NOT NULL,
	"data" DATE NOT NULL,
	godz_od NUMERIC(2) NOT NULL,
	godz_do NUMERIC(2) NOT NULL,
	id_klienta INT REFERENCES klienci,
	id_grupy INT REFERENCES grupy,
	czy_nieobecnosc BOOL NOT NULL,
	CHECK(godz_od >= 9 AND godz_od <= 20),
	CHECK(godz_do >= 9 AND godz_do <= 20),
	CHECK(godz_do > godz_od),
	CHECK(czy_nieobecnosc = false OR (id_klienta IS NULL AND id_grupy IS NULL)),
	CHECK(czy_nieobecnosc = true OR ((id_klienta IS NULL AND id_grupy IS NOT NULL) OR (id_klienta IS NOT NULL AND id_grupy IS NULL))),
	PRIMARY KEY (id_instruktora, "data", godz_od)
);
CREATE TABLE lista_oczekujacych (
	id_klienta INT NOT NULL REFERENCES klienci,
	data_rozpoczecia DATE NOT NULL,
	id_odznaki INT NOT NULL REFERENCES odznaki
)
INSERT INTO instruktorzy (imie, nazwisko, numer_telefonu) VALUES
	('Szymon', 'Trofimiec', 135792468),
	('Urszula', 'Pilśniak', 111222555),
	('Anna', 'Krzaczkowska', 112112112),
	('Leonardo', 'Fibonacci', 112358130),
	('Pitagoras', 'Pitagoras', 345051214),
	('Albert', 'Einstein', 314159265),
	('Leonhard', 'Euler', 271828182);

INSERT INTO dostepnosc_sezon (id_instruktora, data_od, data_do) VALUES
    (1, '2024-01-01', '2024-01-18'),
    (1, '2024-01-23', '2024-02-10'),
    (2, '2023-12-26', '2024-01-05'),
    (2, '2024-01-16', '2024-02-07'),
    (3, '2024-01-20', '2024-02-15'),
    (4, '2023-12-25', '2024-01-01'),
    (4, '2024-01-15', '2024-01-25'),
    (6, '2023-12-26', '2024-01-13'),
    (6, '2024-01-15', '2024-01-19'),
    (7, '2023-12-26', '2024-01-05'),
    (7, '2024-01-17', '2024-01-27');

INSERT INTO stopnie (nazwa) VALUES
	('Pomocnik Instruktora PZN'),
	('Instruktor SITN'),
	('Instruktor PZN'),
	('Instruktor ISIA'),
	('Asystent Instruktora SITS'),
	('Instruktor SITS'),
	('Instruktor Zawodowy SITS');

INSERT INTO stawki_stopnie (id_stopnia, stawka_godzinowa, data_od) VALUES
	(1, 65, '2014-01-01'),
	(2, 70, '2014-01-01'),
	(3, 75, '2014-01-01'),
	(4, 80, '2014-01-01'),
	(5, 65, '2014-01-01'),
	(6, 70, '2014-01-01'),
	(7, 75, '2014-01-01');


INSERT INTO instruktorzy_stopnie (id_instruktora, id_stopnia, data_od) VALUES
	(1, 3, '2019-01-01'),
	(1, 4, '2022-04-12'),
	(2, 2, '2014-03-21'),
	(2, 3, '2018-06-30'),
	(2, 4, '2023-01-12'),
	(3, 4, '2014-09-22'),
	(4, 1, '2024-01-03'),
	(5, 5, '2018-02-04'),
	(6, 6, '2017-05-12'),
	(7, 7, '2011-03-16');

INSERT INTO ubezpieczenia (numer_polisy, id_instruktora, data_od, data_do) VALUES
	('ABC23409700989809790790', 1, '2022-12-23', '2023-12-24'),
	('AGH56420989024535466656', 1, '2021-01-01', '2022-12-01'),
	('DFS45465657768787867756', 1, '2023-01-13', '2024-03-23'),
	('BFS35465768576534546573', 2, '2023-02-01', '2024-03-24'),
	('GHI24123455768776543477', 2, '2022-01-13', '2023-03-12'),
	('AFS12354679876543245678', 3, '2024-01-01', '2025-01-01'),
	('LKM09876543567865456545', 4, '2024-03-12', '2025-12-01'),
	('OBS78976543456786545665', 4, '2024-01-11', '2025-12-13'),
	('IHK24356786543234567865', 5, '2024-02-15', '2025-11-11'),
	('ODK56768654356786545676', 6, '2021-01-13', '2022-04-16'),
	('IRK56786543456765432456', 6, '2024-02-22', '2025-01-11'),
	('LKM12345467876543214765', 7, '2023-12-25', '2025-04-01');

INSERT INTO klienci (imie, nazwisko, kontakt, data_urodz) VALUES
	('Piotr', 'Micek', 126647594, NULL),
    ('Katarzyna', 'Grygiel',126646672 ,'2006-04-12'),
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

INSERT INTO sporty (opis) VALUES
	('narty'),
	('snowboard');
   
INSERT INTO odznaki (opis, id_sportu) VALUES
    ('biała', 1),
    ('biała', 2),
    ('zielona', 1),
    ('zielona', 2),
    ('niebieska', 1),
    ('niebieska', 2),
    ('czerwona', 1),
    ('czerwona', 2),
    ('czarna', 1),
    ('czarna', 2),
    ('brązowa', 1),
    ('brązowa', 2),
    ('srebrna', 1),
    ('srebrna', 2),
    ('złota', 1),
    ('złota', 2);

INSERT INTO dzieci_odznaki(id_klienta, id_odznaki, data_uzysk) VALUES
    (2, 1, '2024-01-17'),
    (2, 3, '2024-01-24'),
    (2, 5, '2024-02-01'),
    (12, 1, '2024-01-17'),
    (12, 3, '2024-01-24'),
    (12, 2, '2024-01-03'),
    (15, 1, '2024-01-17'),
    (15, 6, '2024-01-24'),
    (18, 1, '2024-01-17'),
    (20, 2, '2024-01-03'),
    (20, 4, '2024-01-10'),
    (23, 6, '2023-12-27'),
    (23, 2, '2024-01-03'),
    (25, 5, '2024-02-01'),
    (25, 4, '2024-01-10'),
    (28, 4, '2024-01-10'),
    (28, 1, '2024-01-17'),
    (30, 2, '2024-01-03'),
    (31, 2, '2024-01-03'),
    (29, 3, '2024-01-24'),
    (29, 1, '2024-01-17'),
    (31, 1, '2023-03-21'),
    (31, 3, '2024-01-24'),
    (32, 1, '2023-03-21'),
    (32, 3, '2024-01-24'),
    (33, 1, '2023-03-21'),
    (33, 3, '2024-01-24'),
    (32, 6, '2024-01-24'),
    (33, 6, '2024-01-24'),
    (34, 6, '2024-01-24'),
    (35, 6, '2024-01-24'),
    (35, 5, '2024-02-01'),
    (32, 2, '2024-01-31'),
    (33, 2, '2024-01-31'),
    (34, 2, '2024-01-31'),
    (35, 2, '2024-01-31'),
    (36, 5, '2024-02-01'),
    (37, 5, '2024-02-01'),
    (38, 2, '2024-01-03'),
    (39, 2, '2024-01-03'),
    (25, 3, '2023-03-21'),
    (35, 3, '2023-03-21'),
    (36, 3, '2023-03-21'),
    (37, 3, '2023-03-21'),
    (38, 3, '2023-03-21'),
    (39, 3, '2023-03-21'),
    (25, 2, '2023-03-21'),
    (28, 2, '2023-03-21'),
    (15, 4, '2023-03-21'),
    (32, 4, '2023-03-21'),
    (33, 4, '2023-03-21'),
    (34, 4, '2023-03-21'),
    (35, 4, '2023-03-14'),
    (40, 2, '2024-01-03');

INSERT INTO grupy (id_instruktora, id_odznaki, data_rozpoczecia, maks_dzieci, min_dzieci) VALUES
    (1, 1, '2024-01-11', 10, 3),
    (2, 3, '2024-01-18', 10, 3),
    (3, 5, '2024-01-25', 10, 3),
    (7, 6, '2024-01-18', 10, 3),
    (6, 2, '2023-12-28', 10, 3),
    (6, 4, '2024-01-04', 10, 3);
    
INSERT INTO dzieci_grupy (id_klienta, id_grupy) VALUES
	(2, 1),
	(12, 1),
	(15, 1),
	(18, 1),
	(28, 1),
	(29, 1),
	(40, 1),
	(30, 1),
	(20, 1),
	(2, 2),
	(12, 2),
	(15, 2),
	(29, 2),
	(31, 2),
	(32, 2),
	(33, 2),
	(2, 3),
	(25, 3),
	(35, 3),
	(36, 3),
	(37, 3),
	(38, 3),
	(39, 3),
	(12, 5),
	(20, 5),
	(23, 5),
	(30, 5),
	(31, 5),
	(38, 5),
	(39, 5),
	(40, 5),
	(20, 6),
	(25, 6),
	(28, 6),
	(38, 6),
	(39, 6),
	(15, 4),
	(32, 4),
	(33, 4),
	(34, 4),
	(35, 4);
	
INSERT INTO harmonogram (id_instruktora, "data", godz_od, godz_do, id_klienta, id_grupy, czy_nieobecnosc) VALUES
-- GRUPY
	(1, '2024-01-11', 9, 12, NULL, 1, false),
	(1, '2024-01-12', 9, 12, NULL, 1, false),
	(1, '2024-01-13', 9, 12, NULL, 1, false),
	(1, '2024-01-14', 9, 12, NULL, 1, false),
	(1, '2024-01-15', 9, 12, NULL, 1, false),
	(1, '2024-01-16', 9, 12, NULL, 1, false),
	(1, '2024-01-17', 9, 12, NULL, 1, false),
	(2, '2024-01-18', 9, 12, NULL, 2, false),
	(2, '2024-01-19', 9, 12, NULL, 2, false),
	(2, '2024-01-20', 9, 12, NULL, 2, false),
	(2, '2024-01-21', 9, 12, NULL, 2, false),
	(2, '2024-01-22', 9, 12, NULL, 2, false),
	(2, '2024-01-23', 9, 12, NULL, 2, false),
	(2, '2024-01-24', 9, 12, NULL, 2, false),
	(3, '2024-01-25', 9, 12, NULL, 3, false),
	(3, '2024-01-26', 9, 12, NULL, 3, false),
	(3, '2024-01-27', 9, 12, NULL, 3, false),
	(3, '2024-01-28', 9, 12, NULL, 3, false),
	(3, '2024-01-29', 9, 12, NULL, 3, false),
	(3, '2024-01-30', 9, 12, NULL, 3, false),
	(3, '2024-01-31', 9, 12, NULL, 3, false),
	(7, '2024-01-18', 9, 12, NULL, 4, false),
	(7, '2024-01-19', 9, 12, NULL, 4, false),
	(7, '2024-01-20', 9, 12, NULL, 4, false),
	(7, '2024-01-21', 9, 12, NULL, 4, false),
	(7, '2024-01-22', 9, 12, NULL, 4, false),
	(7, '2024-01-23', 9, 12, NULL, 4, false),
	(7, '2024-01-24', 9, 12, NULL, 4, false),
	(6, '2023-12-28', 9, 12, NULL, 5, false),
	(6, '2023-12-29', 9, 12, NULL, 5, false),
	(6, '2023-12-30', 9, 12, NULL, 5, false),
	(6, '2023-12-31', 9, 12, NULL, 5, false),
	(6, '2024-01-01', 9, 12, NULL, 5, false),
	(6, '2024-01-02', 9, 12, NULL, 5, false),
	(6, '2024-01-03', 9, 12, NULL, 5, false),
	(6, '2024-01-04', 9, 12, NULL, 6, false),
	(6, '2024-01-05', 9, 12, NULL, 6, false),
	(6, '2024-01-06', 9, 12, NULL, 6, false),
	(6, '2024-01-07', 9, 12, NULL, 6, false),
	(6, '2024-01-08', 9, 12, NULL, 6, false),
	(6, '2024-01-09', 9, 12, NULL, 6, false),
	(6, '2024-01-10', 9, 12, NULL, 6, false),
-- 25.12
	(4, '2023-12-25', 9, 11, 7, NULL, false),
	(4, '2023-12-25', 11, 12, 8, NULL, false),
	(4, '2023-12-25', 12, 14, 9, NULL, false),
	(4, '2023-12-25', 14, 15, 10, NULL, false),
	(4, '2023-12-25', 15, 16, NULL, NULL, true),
	(4, '2023-12-25', 16, 18, 11, NULL, false),
	(4, '2023-12-25', 19, 20, 12, NULL, false),
-- 26.12
	(2, '2023-12-26', 9, 10, 1, NULL, false),
	(2, '2023-12-26', 10, 11, 2, NULL, false),
	(2, '2023-12-26', 11, 12, 3, NULL, false),
	(2, '2023-12-26', 12, 13, 4, NULL, false),
	(2, '2023-12-26', 13, 14, NULL, NULL, true),
	(2, '2023-12-26', 15, 16, 5, NULL, false),
	(2, '2023-12-26', 17, 19, 6, NULL, false),
	(2, '2023-12-26', 19, 20, NULL, NULL, true),
	(4, '2023-12-26', 9, 11, 7, NULL, false),
	(4, '2023-12-26', 11, 12, 8, NULL, false),
	(4, '2023-12-26', 12, 14, 9, NULL, false),
	(4, '2023-12-26', 14, 15, 10, NULL, false),
	(4, '2023-12-26', 15, 16, NULL, NULL, true),
	(4, '2023-12-26', 16, 18, 11, NULL, false),
	(4, '2023-12-26', 19, 20, 12, NULL, false),
	(6, '2023-12-26', 9, 11, 17, NULL, false),
	(6, '2023-12-26', 11, 12, 18, NULL, false),
	(6, '2023-12-26', 12, 14, 19, NULL, false),
	(6, '2023-12-26', 14, 15, 20, NULL, false),
	(6, '2023-12-26', 15, 16, NULL, NULL, true),
	(6, '2023-12-26', 16, 18, 21, NULL, false),
	(6, '2023-12-26', 19, 20, 22, NULL, false),
	(7, '2023-12-26', 9, 10, 31, NULL, false),
	(7, '2023-12-26', 10, 11, 32, NULL, false),
	(7, '2023-12-26', 11, 12, 33, NULL, false),
	(7, '2023-12-26', 12, 14, 34, NULL, false),
	(7, '2023-12-26', 14, 15, NULL, NULL, true),
	(7, '2023-12-26', 15, 16, 35, NULL, false),
	(7, '2023-12-26', 17, 18, 36, NULL, false),
	(7, '2023-12-26', 19, 20, NULL, NULL, true),
-- 27.12
	(2, '2023-12-27', 9, 10, 2, NULL, false),
	(2, '2023-12-27', 10, 11, 3, NULL, false),
	(2, '2023-12-27', 11, 12, 1, NULL, false),
	(2, '2023-12-27', 12, 13, 4, NULL, false),
	(2, '2023-12-27', 13, 14, NULL, NULL, true),
	(2, '2023-12-27', 15, 16, 5, NULL, false),
	(2, '2023-12-27', 17, 18, 6, NULL, false),
	(2, '2023-12-27', 19, 20, NULL, NULL, true),
	(4, '2023-12-27', 9, 11, 8, NULL, false),
	(4, '2023-12-27', 11, 12, 7, NULL, false),
	(4, '2023-12-27', 12, 14, 10, NULL, false),
	(4, '2023-12-27', 14, 15, 9, NULL, false),
	(4, '2023-12-27', 15, 16, NULL, NULL, true),
	(4, '2023-12-27', 16, 18, 11, NULL, false),
	(4, '2023-12-27', 19, 20, 12, NULL, false),
	(6, '2023-12-27', 9, 11, 17, NULL, false),
	(6, '2023-12-27', 11, 12, 18, NULL, false),
	(6, '2023-12-27', 12, 14, 20, NULL, false),
	(6, '2023-12-27', 14, 15, 19, NULL, false),
	(6, '2023-12-27', 15, 16, NULL, NULL, true),
	(6, '2023-12-27', 16, 18, 21, NULL, false),
	(6, '2023-12-27', 19, 20, 22, NULL, false),
	(7, '2023-12-27', 9, 10, 31, NULL, false),
	(7, '2023-12-27', 10, 11, 32, NULL, false),
	(7, '2023-12-27', 12, 14, 34, NULL, false),
	(7, '2023-12-27', 14, 15, NULL, NULL, true),
	(7, '2023-12-27', 15, 16, 35, NULL, false),
	(7, '2023-12-27', 17, 18, 36, NULL, false),
	(7, '2023-12-27', 19, 20, NULL, NULL, true),
-- 28.12
	(2, '2023-12-28', 9, 10, 1, NULL, false),
	(2, '2023-12-28', 10, 11, 2, NULL, false),
	(2, '2023-12-28', 11, 12, 3, NULL, false),
	(2, '2023-12-28', 12, 13, 4, NULL, false),
	(2, '2023-12-28', 13, 14, NULL, NULL, true),
	(2, '2023-12-28', 15, 16, 5, NULL, false),
	(2, '2023-12-28', 17, 19, 6, NULL, false),
	(2, '2023-12-28', 19, 20, NULL, NULL, true),
	(4, '2023-12-28', 9, 11, 7, NULL, false),
	(4, '2023-12-28', 11, 12, 8, NULL, false),
	(4, '2023-12-28', 12, 14, 9, NULL, false),
	(4, '2023-12-28', 14, 15, 10, NULL, false),
	(4, '2023-12-28', 15, 16, NULL, NULL, true),
	(4, '2023-12-28', 16, 18, 11, NULL, false),
	(4, '2023-12-28', 19, 20, 12, NULL, false),
	(6, '2023-12-28', 12, 14, 19, NULL, false),
	(6, '2023-12-28', 14, 15, 20, NULL, false),
	(6, '2023-12-28', 15, 16, NULL, NULL, true),
	(6, '2023-12-28', 16, 18, 21, NULL, false),
	(6, '2023-12-28', 19, 20, 22, NULL, false),
	(7, '2023-12-28', 10, 11, 32, NULL, false),
	(7, '2023-12-28', 11, 12, 33, NULL, false),
	(7, '2023-12-28', 12, 14, 34, NULL, false),
	(7, '2023-12-28', 14, 15, NULL, NULL, true),
	(7, '2023-12-28', 15, 16, 35, NULL, false),
	(7, '2023-12-28', 17, 18, 36, NULL, false),
	(7, '2023-12-28', 19, 20, NULL, NULL, true),	
-- 29.12
	(2, '2023-12-29', 9, 10, 2, NULL, false),
	(2, '2023-12-29', 10, 11, 3, NULL, false),
	(2, '2023-12-29', 11, 12, 1, NULL, false),
	(2, '2023-12-29', 12, 13, 4, NULL, false),
	(2, '2023-12-29', 13, 14, NULL, NULL, true),
	(2, '2023-12-29', 15, 16, 5, NULL, false),
	(2, '2023-12-29', 17, 18, 6, NULL, false),
	(2, '2023-12-29', 19, 20, NULL, NULL, true),
	(4, '2023-12-29', 9, 11, 8, NULL, false),
	(4, '2023-12-29', 11, 12, 7, NULL, false),
	(4, '2023-12-29', 12, 14, 10, NULL, false),
	(4, '2023-12-29', 14, 15, 9, NULL, false),
	(4, '2023-12-29', 15, 16, NULL, NULL, true),
	(4, '2023-12-29', 16, 18, 11, NULL, false),
	(4, '2023-12-29', 19, 20, 12, NULL, false),
	(6, '2023-12-29', 12, 14, 20, NULL, false),
	(6, '2023-12-29', 14, 15, 19, NULL, false),
	(6, '2023-12-29', 15, 16, NULL, NULL, true),
	(6, '2023-12-29', 16, 18, 21, NULL, false),
	(6, '2023-12-29', 19, 20, 22, NULL, false),
	(7, '2023-12-29', 10, 11, 32, NULL, false),
	(7, '2023-12-29', 12, 14, 34, NULL, false),
	(7, '2023-12-29', 14, 15, NULL, NULL, true),
	(7, '2023-12-29', 15, 16, 35, NULL, false),
	(7, '2023-12-29', 17, 18, 36, NULL, false),
	(7, '2023-12-29', 19, 20, NULL, NULL, true),
-- 30.12
	(2, '2023-12-30', 9, 10, 1, NULL, false),
	(2, '2023-12-30', 10, 11, 2, NULL, false),
	(2, '2023-12-30', 11, 12, 3, NULL, false),
	(2, '2023-12-30', 12, 13, 4, NULL, false),
	(2, '2023-12-30', 13, 14, NULL, NULL, true),
	(2, '2023-12-30', 15, 16, 5, NULL, false),
	(2, '2023-12-30', 17, 19, 6, NULL, false),
	(2, '2023-12-30', 19, 20, NULL, NULL, true),
	(4, '2023-12-30', 9, 11, 7, NULL, false),
	(4, '2023-12-30', 11, 12, 8, NULL, false),
	(4, '2023-12-30', 12, 14, 9, NULL, false),
	(4, '2023-12-30', 14, 15, 10, NULL, false),
	(4, '2023-12-30', 15, 16, NULL, NULL, true),
	(4, '2023-12-30', 16, 18, 11, NULL, false),
	(4, '2023-12-30', 19, 20, 12, NULL, false),
	(6, '2023-12-30', 12, 14, 19, NULL, false),
	(6, '2023-12-30', 14, 15, 20, NULL, false),
	(6, '2023-12-30', 15, 16, NULL, NULL, true),
	(6, '2023-12-30', 16, 18, 21, NULL, false),
	(6, '2023-12-30', 19, 20, 22, NULL, false),
	(7, '2023-12-30', 10, 11, 32, NULL, false),
	(7, '2023-12-30', 11, 12, 33, NULL, false),
	(7, '2023-12-30', 12, 14, 34, NULL, false),
	(7, '2023-12-30', 14, 15, NULL, NULL, true),
	(7, '2023-12-30', 15, 16, 35, NULL, false),
	(7, '2023-12-30', 17, 18, 36, NULL, false),
	(7, '2023-12-30', 19, 20, NULL, NULL, true),
-- 31.12
	(2, '2023-12-31', 9, 10, 1, NULL, false),
	(2, '2023-12-31', 10, 11, 2, NULL, false),
	(2, '2023-12-31', 11, 12, 3, NULL, false),
	(2, '2023-12-31', 12, 13, 4, NULL, false),
	(2, '2023-12-31', 13, 14, NULL, NULL, true),
	(2, '2023-12-31', 15, 16, 5, NULL, false),
	(2, '2023-12-31', 17, 19, 6, NULL, false),
	(2, '2023-12-31', 19, 20, NULL, NULL, true),
	(4, '2023-12-31', 9, 11, 7, NULL, false),
	(4, '2023-12-31', 11, 12, 8, NULL, false),
	(4, '2023-12-31', 12, 14, 9, NULL, false),
	(4, '2023-12-31', 14, 15, 10, NULL, false),
	(4, '2023-12-31', 15, 16, NULL, NULL, true),
	(4, '2023-12-31', 16, 18, 11, NULL, false),
	(4, '2023-12-31', 19, 20, 12, NULL, false),
	(6, '2023-12-31', 12, 14, 19, NULL, false),
	(6, '2023-12-31', 14, 15, 20, NULL, false),
	(6, '2023-12-31', 15, 16, NULL, NULL, true),
	(6, '2023-12-31', 16, 18, 21, NULL, false),
	(6, '2023-12-31', 19, 20, 22, NULL, false),
	(7, '2023-12-31', 10, 11, 32, NULL, false),
	(7, '2023-12-31', 11, 12, 33, NULL, false),
	(7, '2023-12-31', 12, 14, 34, NULL, false),
	(7, '2023-12-31', 14, 15, NULL, NULL, true),
	(7, '2023-12-31', 15, 16, 35, NULL, false),
	(7, '2023-12-31', 17, 18, 36, NULL, false),
	(7, '2023-12-31', 19, 20, NULL, NULL, true),
-- 1.01
	(1, '2024-01-01', 9, 11, 13, NULL, false),
	(1, '2024-01-01', 11, 12, 17, NULL, false),
	(1, '2024-01-01', 12, 14, 14, NULL, false),
	(1, '2024-01-01', 14, 15, 19, NULL, false),
	(1, '2024-01-01', 15, 16, NULL, NULL, true),
	(1, '2024-01-01', 16, 18, 18, NULL, false),
	(1, '2024-01-01', 19, 20, 16, NULL, false),
	(2, '2024-01-01', 9, 10, 2, NULL, false),
	(2, '2024-01-01', 10, 11, 3, NULL, false),
	(2, '2024-01-01', 11, 12, 1, NULL, false),
	(2, '2024-01-01', 12, 13, 4, NULL, false),
	(2, '2024-01-01', 13, 14, NULL, NULL, true),
	(2, '2024-01-01', 15, 16, 5, NULL, false),
	(2, '2024-01-01', 17, 18, 6, NULL, false),
	(2, '2024-01-01', 19, 20, NULL, NULL, true),
	(4, '2024-01-01', 9, 11, 8, NULL, false),
	(4, '2024-01-01', 11, 12, 7, NULL, false),
	(4, '2024-01-01', 12, 14, 10, NULL, false),
	(4, '2024-01-01', 14, 15, 9, NULL, false),
	(4, '2024-01-01', 15, 16, NULL, NULL, true),
	(4, '2024-01-01', 16, 18, 11, NULL, false),
	(4, '2024-01-01', 19, 20, 12, NULL, false),
	(6, '2024-01-01', 12, 14, 20, NULL, false),
	(6, '2024-01-01', 14, 15, 19, NULL, false),
	(6, '2024-01-01', 15, 16, NULL, NULL, true),
	(6, '2024-01-01', 16, 18, 21, NULL, false),
	(6, '2024-01-01', 19, 20, 22, NULL, false),
	(7, '2024-01-01', 10, 11, 32, NULL, false),
	(7, '2024-01-01', 12, 14, 34, NULL, false),
	(7, '2024-01-01', 14, 15, NULL, NULL, true),
	(7, '2024-01-01', 15, 16, 35, NULL, false),
	(7, '2024-01-01', 17, 18, 36, NULL, false),
	(7, '2024-01-01', 19, 20, NULL, NULL, true),
-- 2.01
	(1, '2024-01-02', 9, 11, 13, NULL, false),
	(1, '2024-01-02', 11, 12, 17, NULL, false),
	(1, '2024-01-02', 12, 14, 14, NULL, false),
	(1, '2024-01-02', 14, 15, 19, NULL, false),
	(1, '2024-01-02', 15, 16, NULL, NULL, true),
	(1, '2024-01-02', 16, 18, 18, NULL, false),
	(1, '2024-01-02', 19, 20, 16, NULL, false),
	(2, '2024-01-02', 9, 10, 2, NULL, false),
	(2, '2024-01-02', 10, 11, 3, NULL, false),
	(2, '2024-01-02', 11, 12, 1, NULL, false),
	(2, '2024-01-02', 12, 13, 4, NULL, false),
	(2, '2024-01-02', 13, 14, NULL, NULL, true),
	(2, '2024-01-02', 15, 16, 5, NULL, false),
	(2, '2024-01-02', 17, 18, 6, NULL, false),
	(2, '2024-01-02', 19, 20, NULL, NULL, true),
	(6, '2024-01-02', 12, 14, 20, NULL, false),
	(6, '2024-01-02', 14, 15, 19, NULL, false),
	(6, '2024-01-02', 15, 16, NULL, NULL, true),
	(6, '2024-01-02', 16, 18, 21, NULL, false),
	(6, '2024-01-02', 19, 20, 22, NULL, false),
	(7, '2024-01-02', 9, 11, 32, NULL, false),
	(7, '2024-01-02', 12, 14, 34, NULL, false),
	(7, '2024-01-02', 14, 15, NULL, NULL, true),
	(7, '2024-01-02', 15, 16, 35, NULL, false),
	(7, '2024-01-02', 17, 18, 36, NULL, false),
	(7, '2024-01-02', 19, 20, NULL, NULL, true),
-- 3.01
	(1, '2024-01-03', 9, 11, 13, NULL, false),
	(1, '2024-01-03', 11, 12, 17, NULL, false),
	(1, '2024-01-03', 12, 14, 14, NULL, false),
	(1, '2024-01-03', 14, 15, 19, NULL, false),
	(1, '2024-01-03', 15, 16, NULL, NULL, true),
	(1, '2024-01-03', 16, 18, 18, NULL, false),
	(1, '2024-01-03', 19, 20, 16, NULL, false),
	(2, '2024-01-03', 9, 10, 2, NULL, false),
	(2, '2024-01-03', 10, 11, 3, NULL, false),
	(2, '2024-01-03', 11, 12, 1, NULL, false),
	(2, '2024-01-03', 12, 13, 4, NULL, false),
	(2, '2024-01-03', 13, 14, NULL, NULL, true),
	(2, '2024-01-03', 15, 16, 5, NULL, false),
	(2, '2024-01-03', 17, 18, 6, NULL, false),
	(2, '2024-01-03', 19, 20, NULL, NULL, true),
	(6, '2024-01-03', 12, 14, 20, NULL, false),
	(6, '2024-01-03', 14, 15, 19, NULL, false),
	(6, '2024-01-03', 15, 16, NULL, NULL, true),
	(6, '2024-01-03', 16, 18, 21, NULL, false),
	(6, '2024-01-03', 19, 20, 22, NULL, false),
	(7, '2024-01-03', 10, 11, 32, NULL, false),
	(7, '2024-01-03', 12, 14, 34, NULL, false),
	(7, '2024-01-03', 14, 15, NULL, NULL, true),
	(7, '2024-01-03', 15, 16, 35, NULL, false),
	(7, '2024-01-03', 17, 18, 36, NULL, false),
	(7, '2024-01-03', 19, 20, NULL, NULL, true),
-- 4.01
	(1, '2024-01-04', 9, 11, 13, NULL, false),
	(1, '2024-01-04', 11, 12, 17, NULL, false),
	(1, '2024-01-04', 12, 14, 14, NULL, false),
	(1, '2024-01-04', 14, 15, 19, NULL, false),
	(1, '2024-01-04', 15, 16, NULL, NULL, true),
	(1, '2024-01-04', 16, 18, 18, NULL, false),
	(1, '2024-01-04', 19, 20, 16, NULL, false),
	(2, '2024-01-04', 9, 10, 2, NULL, false),
	(2, '2024-01-04', 10, 11, 3, NULL, false),
	(2, '2024-01-04', 11, 12, 1, NULL, false),
	(2, '2024-01-04', 12, 13, 4, NULL, false),
	(2, '2024-01-04', 13, 14, NULL, NULL, true),
	(2, '2024-01-04', 15, 16, 5, NULL, false),
	(2, '2024-01-04', 17, 18, 6, NULL, false),
	(2, '2024-01-04', 19, 20, NULL, NULL, true),
	(6, '2024-01-04', 12, 14, 20, NULL, false),
	(6, '2024-01-04', 14, 15, 19, NULL, false),
	(6, '2024-01-04', 15, 16, NULL, NULL, true),
	(6, '2024-01-04', 17, 18, 21, NULL, false),
	(6, '2024-01-04', 19, 20, 22, NULL, false),
	(7, '2024-01-04', 9, 11, 32, NULL, false),
	(7, '2024-01-04', 12, 14, 34, NULL, false),
	(7, '2024-01-04', 14, 15, NULL, NULL, true),
	(7, '2024-01-04', 15, 16, 35, NULL, false),
	(7, '2024-01-04', 17, 18, 36, NULL, false),
	(7, '2024-01-04', 19, 20, NULL, NULL, true),
-- 5.01
	(1, '2024-01-05', 9, 11, 13, NULL, false),
	(1, '2024-01-05', 11, 12, 17, NULL, false),
	(1, '2024-01-05', 12, 14, 14, NULL, false),
	(1, '2024-01-05', 14, 15, 19, NULL, false),
	(1, '2024-01-05', 15, 16, NULL, NULL, true),
	(1, '2024-01-05', 16, 18, 18, NULL, false),
	(1, '2024-01-05', 19, 20, 16, NULL, false),
	(2, '2024-01-05', 9, 10, 2, NULL, false),
	(2, '2024-01-05', 10, 11, 3, NULL, false),
	(2, '2024-01-05', 11, 12, 1, NULL, false),
	(2, '2024-01-05', 12, 13, 4, NULL, false),
	(2, '2024-01-05', 13, 14, NULL, NULL, true),
	(2, '2024-01-05', 15, 16, 5, NULL, false),
	(2, '2024-01-05', 17, 18, 6, NULL, false),
	(2, '2024-01-05', 19, 20, NULL, NULL, true),
	(6, '2024-01-05', 12, 14, 20, NULL, false),
	(6, '2024-01-05', 14, 15, 19, NULL, false),
	(6, '2024-01-05', 15, 16, NULL, NULL, true),
	(6, '2024-01-05', 16, 18, 21, NULL, false),
	(6, '2024-01-05', 19, 20, 22, NULL, false),
	(7, '2024-01-05', 9, 10, 32, NULL, false),
	(7, '2024-01-05', 12, 13, 34, NULL, false),
	(7, '2024-01-05', 13, 15, NULL, NULL, true),
	(7, '2024-01-05', 15, 16, 35, NULL, false),
	(7, '2024-01-05', 17, 18, 36, NULL, false),
	(7, '2024-01-05', 19, 20, NULL, NULL, true),
-- 6.01
	(1, '2024-01-06', 9, 11, 13, NULL, false),
	(1, '2024-01-06', 11, 12, 17, NULL, false),
	(1, '2024-01-06', 12, 14, 14, NULL, false),
	(1, '2024-01-06', 14, 15, 19, NULL, false),
	(1, '2024-01-06', 15, 16, NULL, NULL, true),
	(1, '2024-01-06', 16, 18, 18, NULL, false),
	(1, '2024-01-06', 19, 20, 16, NULL, false),
	(6, '2024-01-06', 12, 14, 20, NULL, false),
	(6, '2024-01-06', 14, 15, 19, NULL, false),
	(6, '2024-01-06', 15, 16, NULL, NULL, true),
	(6, '2024-01-06', 16, 18, 21, NULL, false),
	(6, '2024-01-06', 19, 20, 22, NULL, false),
-- 7.01
	(1, '2024-01-07', 9, 11, 13, NULL, false),
	(1, '2024-01-07', 11, 12, 17, NULL, false),
	(1, '2024-01-07', 12, 14, 14, NULL, false),
	(1, '2024-01-07', 14, 15, NULL, NULL, true),
	(1, '2024-01-07', 15, 16, 19, NULL, false),
	(1, '2024-01-07', 16, 17, 18, NULL, false),
	(1, '2024-01-07', 18, 20, 16, NULL, false),
	(6, '2024-01-07', 12, 13, 20, NULL, false),
	(6, '2024-01-07', 13, 15, 19, NULL, false),
	(6, '2024-01-07', 15, 16, NULL, NULL, true),
	(6, '2024-01-07', 16, 18, 21, NULL, false),
	(6, '2024-01-07', 19, 20, 22, NULL, false),
-- 8.01
	(1, '2024-01-08', 9, 11, 23, NULL, false),
	(1, '2024-01-08', 11, 12, 27, NULL, false),
	(1, '2024-01-08', 12, 14, 24, NULL, false),
	(1, '2024-01-08', 14, 15, 29, NULL, false),
	(1, '2024-01-08', 15, 16, NULL, NULL, true),
	(1, '2024-01-08', 16, 18, 28, NULL, false),
	(1, '2024-01-08', 19, 20, 26, NULL, false),
	(6, '2024-01-08', 12, 14, 30, NULL, false),
	(6, '2024-01-08', 14, 15, 1, NULL, false),
	(6, '2024-01-08', 15, 16, NULL, NULL, true),
	(6, '2024-01-08', 16, 18, 31, NULL, false),
	(6, '2024-01-08', 19, 20, 32, NULL, false),
-- 9.01
	(1, '2024-01-09', 9, 10, 23, NULL, false),
	(1, '2024-01-09', 10, 12, 27, NULL, false),
	(1, '2024-01-09', 12, 13, 24, NULL, false),
	(1, '2024-01-09', 14, 15, 29, NULL, false),
	(1, '2024-01-09', 15, 16, 14, NULL, false),
	(1, '2024-01-09', 16, 18, 28, NULL, false),
	(1, '2024-01-09', 19, 20, 26, NULL, false),
	(6, '2024-01-09', 12, 14, 30, NULL, false),
	(6, '2024-01-09', 14, 15, 1, NULL, false),
	(6, '2024-01-09', 15, 16, NULL, NULL, true),
	(6, '2024-01-09', 16, 17, 31, NULL, false),
	(6, '2024-01-09', 19, 20, 32, NULL, false),
-- 10.01
	(1, '2024-01-10', 9, 11, 23, NULL, false),
	(1, '2024-01-10', 11, 12, 27, NULL, false),
	(1, '2024-01-10', 12, 14, 24, NULL, false),
	(1, '2024-01-10', 14, 15, 29, NULL, false),
	(1, '2024-01-10', 15, 16, NULL, NULL, true),
	(1, '2024-01-10', 16, 18, 28, NULL, false),
	(1, '2024-01-10', 19, 20, 26, NULL, false),
	(6, '2024-01-10', 12, 14, 30, NULL, false),
	(6, '2024-01-10', 14, 15, 1, NULL, false),
	(6, '2024-01-10', 15, 16, NULL, NULL, true),
	(6, '2024-01-10', 16, 18, 31, NULL, false),
	(6, '2024-01-10', 19, 20, 32, NULL, false),
-- 11.01
	(1, '2024-01-11', 12, 14, 24, NULL, false),
	(1, '2024-01-11', 14, 15, 29, NULL, false),
	(1, '2024-01-11', 15, 16, NULL, NULL, true),
	(1, '2024-01-11', 16, 18, 28, NULL, false),
	(1, '2024-01-11', 19, 20, 26, NULL, false),
	(6, '2024-01-11', 9, 10, 30, NULL, false),
	(6, '2024-01-11', 10, 11, 3, NULL, false),
	(6, '2024-01-11', 11, 12, 4, NULL, false),
	(6, '2024-01-11', 12, 14, 5, NULL, false),
	(6, '2024-01-11', 14, 15, 1, NULL, false),
	(6, '2024-01-11', 15, 16, NULL, NULL, true),
	(6, '2024-01-11', 16, 18, 31, NULL, false),
	(6, '2024-01-11', 19, 20, 32, NULL, false),
-- 12.01
	(1, '2024-01-12', 12, 13, 24, NULL, false),
	(1, '2024-01-12', 14, 15, 29, NULL, false),
	(1, '2024-01-12', 15, 16, NULL, NULL, true),
	(1, '2024-01-12', 16, 18, 28, NULL, false),
	(1, '2024-01-12', 18, 20, 26, NULL, false),
	(6, '2024-01-12', 9, 10, 30, NULL, false),
	(6, '2024-01-12', 10, 11, 3, NULL, false),
	(6, '2024-01-12', 11, 13, 4, NULL, false),
	(6, '2024-01-12', 13, 14, 5, NULL, false),
	(6, '2024-01-12', 14, 15, 1, NULL, false),
	(6, '2024-01-12', 15, 16, NULL, NULL, true),
	(6, '2024-01-12', 16, 17, 31, NULL, false),
	(6, '2024-01-12', 18, 20, 32, NULL, false),
-- 13.01
	(1, '2024-01-13', 12, 14, 24, NULL, false),
	(1, '2024-01-13', 14, 15, 29, NULL, false),
	(1, '2024-01-13', 15, 16, NULL, NULL, true),
	(1, '2024-01-13', 16, 18, 28, NULL, false),
	(1, '2024-01-13', 19, 20, 26, NULL, false),
	(6, '2024-01-13', 9, 10, 30, NULL, false),
	(6, '2024-01-13', 10, 11, 3, NULL, false),
	(6, '2024-01-13', 11, 12, 4, NULL, false),
	(6, '2024-01-13', 12, 14, 5, NULL, false),
	(6, '2024-01-13', 14, 15, 1, NULL, false),
	(6, '2024-01-13', 15, 16, NULL, NULL, true),
	(6, '2024-01-13', 16, 18, 31, NULL, false),
	(6, '2024-01-13', 19, 20, 32, NULL, false),
-- 14.01
	(1, '2024-01-14', 12, 13, 24, NULL, false),
	(1, '2024-01-14', 14, 15, 29, NULL, false),
	(1, '2024-01-14', 15, 16, 13, NULL, false),
	(1, '2024-01-14', 16, 18, 28, NULL, false),
	(1, '2024-01-14', 18, 20, 26, NULL, false),
--15.01	
	(1, '2024-01-15', 12, 13, NULL, NULL, true),
	(1, '2024-01-15', 13, 15, 1, NULL, false),
	(1, '2024-01-15', 16, 19, 13, NULL, false),
	(4, '2024-01-15', 9, 11, 23, NULL, false),
	(4, '2024-01-15', 12, 14, 4, NULL, false),
	(4, '2024-01-15', 15, 17, NULL, NULL, true),
	(4, '2024-01-15', 17, 18, 14, NULL, false),
	(6, '2024-01-15', 9, 11, 21, NULL, false),
	(6, '2024-01-15', 11, 13, 3, NULL, false),
	(6, '2024-01-15', 15, 16, 16, NULL, false),
	(6, '2024-01-15', 16, 18, 22, NULL, false),
	(6, '2024-01-15', 18, 19, 35, NULL, false),
	(6, '2024-01-15', 19, 20, NULL, NULL, true),
--16.01
	(1, '2024-01-16', 13, 15, 30, NULL, false),
	(1, '2024-01-16', 16, 19, 3, NULL, false),
	(2, '2024-01-16', 10, 12, 26, NULL, false),
	(2, '2024-01-16', 13, 15, 17, NULL, false),
	(2, '2024-01-16', 16, 18, NULL, NULL, true),
	(4, '2024-01-16', 9, 11, 32, NULL, false),
	(4, '2024-01-16', 12, 14, 13, NULL, false),
	(4, '2024-01-16', 15, 18, 24, NULL, false),
	(6, '2024-01-16', 9, 11, 5, NULL, false),
	(6, '2024-01-16', 11, 13, 16, NULL, false),
	(6, '2024-01-16', 14, 16, 7, NULL, false),
	(6, '2024-01-16', 16, 18, 18, NULL, false),
	(6, '2024-01-16', 18, 20, NULL, NULL, true),
--17.01
	(1, '2024-01-17', 13, 15, 11, NULL, false),
	(1, '2024-01-17', 15, 16, 4, NULL, false),
	(1, '2024-01-17', 16, 19, 15, NULL, false),
	(2, '2024-01-17', 10, 12, 6, NULL, false),
	(2, '2024-01-17', 13, 15, 14, NULL, false),
	(2, '2024-01-17', 15, 17, 28, NULL, false),
	(2, '2024-01-17', 17, 18, 2, NULL, false),
	(2, '2024-01-17', 18, 20, NULL, NULL, true),
	(4, '2024-01-17', 9, 11, 34, NULL, false),
	(4, '2024-01-17', 11, 12, NULL, NULL, true),	
	(4, '2024-01-17', 12, 14, 25, NULL, false),
	(4, '2024-01-17', 15, 18, 31, NULL, false),
	(6, '2024-01-17', 9, 10, 22, NULL, false),
	(6, '2024-01-17', 10, 12, 13, NULL, false),
	(6, '2024-01-17', 12, 14, NULL, NULL, true),
	(6, '2024-01-17', 16, 18, 19, NULL, false),
	(6, '2024-01-17', 18, 20, 26, NULL, false),
	(7, '2024-01-17', 9, 10, 21, NULL, false),
	(7, '2024-01-17', 13, 15, 40, NULL, false),
	(7, '2024-01-17', 17, 19, 27, NULL, false),
--18.01
	(1, '2024-01-18', 9, 12, 1, NULL, false),
	(1, '2024-01-18', 13, 15, 2, NULL, false),
	(1, '2024-01-18', 16, 19, 3, NULL, false),
	(1, '2024-01-18', 19, 20, NULL, NULL, true),
	(2, '2024-01-18', 12, 13, 4, NULL, false),
	(2, '2024-01-18', 13, 14, 5, NULL, false),
	(2, '2024-01-18', 14, 15, NULL, NULL, true),
	(2, '2024-01-18', 16, 18, 6, NULL, false),
	(4, '2024-01-18', 9, 11, 7, NULL, false),
	(4, '2024-01-18', 12, 14, 8, NULL, false),
	(4, '2024-01-18', 15, 18, 9, NULL, false),
	(6, '2024-01-18', 11, 13, 11, NULL, false),
	(6, '2024-01-18', 14, 16, 12, NULL, false),
	(6, '2024-01-18', 16, 18, 13, NULL, false),
	(6, '2024-01-18', 18, 20, 14, NULL, false),
	(7, '2024-01-18', 13, 15, 16, NULL, false),
	(7, '2024-01-18', 16, 19, 17, NULL, false),
	(7, '2024-01-18', 19, 20, 17, NULL, false),
--19.01
	(1, '2024-01-19', 9, 12, 1, NULL, false),
	(1, '2024-01-19', 13, 15, 2, NULL,false),
	(1, '2024-01-19', 16, 19, 3, NULL, false),
	(2, '2024-01-19', 16, 18, 8, NULL, false),
	(2, '2024-01-19', 13, 15, 10, NULL, false),
	(4, '2024-01-19', 9, 11, 11, NULL, false),
	(4, '2024-01-19', 11, 12, NULL, NULL, true),
	(4, '2024-01-19', 12, 14, 12, NULL, false),
	(4, '2024-01-19', 15, 18, 13, NULL, false),
	(4, '2024-01-19', 18, 19, 14, NULL, false),
	(4, '2024-01-19', 19, 20, 15, NULL, false),
	(6, '2024-01-19', 9, 11, 16, NULL, false),
	(6, '2024-01-19', 11, 13, 17, NULL, false),
	(6, '2024-01-19', 14, 16, 18, NULL, false),
	(6, '2024-01-19', 16, 18, 19, NULL, false),
	(6, '2024-01-19', 18, 20, 20, NULL, false),
--20.01
	(2, '2024-01-20', 13, 15, 22, NULL, false),
	(2, '2024-01-20', 16, 18, 3, NULL, false),
	(2, '2024-01-20', 18, 19, 25, NULL, false),
	(2, '2024-01-20', 19, 20, NULL, NULL, true),
	(3, '2024-01-20', 9, 12, 26, NULL, false),
	(3, '2024-01-20', 12, 13, NULL, NULL, true),
	(3, '2024-01-20', 13, 15, 17, NULL, false),
	(3, '2024-01-20', 16, 18, 28, NULL, false),
	(3, '2024-01-20', 18, 20, 10, NULL, false),
	(4, '2024-01-20', 12, 14, 32, NULL, false),
	(4, '2024-01-20', 15, 18, 34, NULL, false),
	(4, '2024-01-20', 19, 20, 35, NULL, false),
	(7, '2024-01-20', 13, 15, 27, NULL, false),
	(7, '2024-01-20', 15, 16, NULL, NULL, true),
	(7, '2024-01-20', 16, 18, 9, NULL, false),
--21.01
	(2, '2024-01-21', 13, 15, 22, NULL, false),
	(2, '2024-01-21', 16, 18, 3, NULL, false),
	(2, '2024-01-21', 18, 19, 14, NULL, false),
	(2, '2024-01-21', 19, 20, 35, NULL, false),
	(3, '2024-01-21', 9, 12, 6, NULL, false),
	(3, '2024-01-21', 13, 15, 7, NULL, false),
	(3, '2024-01-21', 16, 18, 8, NULL, false),
	(3, '2024-01-21', 18, 19, 39, NULL, false),
	(3, '2024-01-21', 19, 20, 11, NULL, false),
	(4, '2024-01-21', 9, 11, NULL, NULL, true),
	(4, '2024-01-21', 12, 14, 12, NULL, false),
	(4, '2024-01-21', 15, 17, 23, NULL, false),
	(4, '2024-01-21', 17, 18, 15, NULL, false),
	(7, '2024-01-21', 13, 15, 17, NULL, false),
	(7, '2024-01-21', 16, 18, 38, NULL, false);
	
	
