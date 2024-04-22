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

INSERT INTO instruktorzy (imie, nazwisko, numer_telefonu) VALUES
	('Szymon', 'Trofimiec', 135792468),
	('Urszula', 'Pilśniak', 111222555),
	('Anna', 'Krzaczkowska', 112112112),
	('Leonardo', 'Fibonacci', 112358130),
	('Pitagoras', 'Pitagoras', 345051214),
	('Albert', 'Einstein', 314159265),
	('Leonhard', 'Euler', 271828182);

INSERT INTO stopnie (nazwa, stawka_godzinowa) VALUES
	('Pomocnik Instruktora PZN', 65),
	('Instruktor SITN', 70),
	('Instruktor PZN', 75),
	('Instruktor ISIA', 80),
	('Asystent Instruktora SITS', 65),
	('Instruktor SITS', 70),
	('Instruktor Zawodowy SITS', 75 );

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
	('ABC23409700989809790790', 1, '23-12-2022', '24-12-2023'),
	('AGH56420989024535466656', 1, '01-01-2021', '01-12-2022'),
	('DFS45465657768787867756', 1, '13-01-2023', '23-03-2024'),
	('BFS35465768576534546573', 2, '01-02-2023', '03-24-2024'),
	('GHI24123455768776543477', 2, '13-01-2022', '12-03-2023'),
	('AFS12354679876543245678', 3, '01-01-2024', '01-01-2025'),
	('LKM09876543567865456545', 4, '12-03-2024', '01-12-2025'),
	('OBS78976543456786545665', 4, '11-01-2024', '13-12-2025'),
	('IHK24356786543234567865', 5, '15-02-2024', '11-11-2025'),
	('ODK56768654356786545676', 6, '13-01-2021', '16-04-2022'),
	('IRK56786543456765432456', 6, '22-02-2024', '11-01-2025'),
	('LKM12345467876543214765', 7, '25-12-2023', '01-04-2025');

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
   
INSERT INTO odznaki (opis,sport) VALUES
    ('biała', 'narty'),
    ('biała', 'snowboard'),
    ('zielona', 'narty'),
    ('zielona', 'snowboard'),
    ('niebieska', 'narty'),
    ('niebieska', 'snowboard'),
    ('czerwona', 'narty'),
    ('czerwona', 'snowboard'),
    ('czarna', 'narty'),
    ('czarna', 'snowboard'),
    ('brązowa', 'narty'),
    ('brązowa', 'snowboard'),
    ('srebrna', 'narty'),
    ('srebrna', 'snowboard'),
    ('złota', 'narty'),
    ('złota', 'snowboard');

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
    (25, 5, '2023-03-21'),
    (35, 5, '2023-03-21'),
    (36, 5, '2023-03-21'),
    (37, 5, '2023-03-21'),
    (38, 5, '2023-03-21'),
    (39, 5, '2023-03-21'),
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
	
	