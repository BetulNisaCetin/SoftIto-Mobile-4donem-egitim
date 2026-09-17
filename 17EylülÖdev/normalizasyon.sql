PRAGMA foreign_keys = ON;
-- 1. Bolumler Tablosu
CREATE TABLE IF NOT EXISTS Bolumler (
    bolum_id INTEGER PRIMARY KEY AUTOINCREMENT,
    bolum_adi TEXT NOT NULL UNIQUE
);
-- 2. Ogrenciler Tablosu
CREATE TABLE IF NOT EXISTS Ogrenciler (
    ogrenci_id INTEGER PRIMARY KEY AUTOINCREMENT,
    ogrenci_no TEXT NOT NULL UNIQUE,
    ad TEXT NOT NULL,
    soyad TEXT NOT NULL,
    email TEXT UNIQUE,
    bolum_id INTEGER NOT NULL,
    FOREIGN KEY (bolum_id) REFERENCES Bolumler(bolum_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
-- 3. Dersler Tablosu
CREATE TABLE IF NOT EXISTS Dersler (
    ders_id INTEGER PRIMARY KEY AUTOINCREMENT,
    ders_kodu TEXT NOT NULL UNIQUE,
    ders_adi TEXT NOT NULL,
    kredi INTEGER NOT NULL CHECK (kredi > 0),
    bolum_id INTEGER NOT NULL,
    FOREIGN KEY (bolum_id) REFERENCES Bolumler(bolum_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
-- 4. Ogrenci_Dersler (Ara/İlişki Tablosu)
CREATE TABLE IF NOT EXISTS Ogrenci_Dersler (
    ogrenci_id INTEGER NOT NULL,
    ders_id INTEGER NOT NULL,
    donem TEXT NOT NULL,
    harf_notu TEXT,
    PRIMARY KEY (ogrenci_id, ders_id, donem),
    FOREIGN KEY (ogrenci_id) REFERENCES Ogrenciler(ogrenci_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ders_id) REFERENCES Dersler(ders_id) ON DELETE CASCADE ON UPDATE CASCADE
);