### 1. Birinci Normal Form (1NF)
- **Kural:** Her hücrede atomik (tekil) değer tutulmalıdır.
- **Uygulama:** Virgülle ayrılmış ders isimleri ve çoklu değer içeren sütunlar tekil satırlara bölündü.

### 2. İkinci Normal Form (2NF)
- **Kural:** Kısmi bağımlılıklar (Partial Dependency) kaldırılmalıdır.
- **Uygulama:** Anahtar olmayan veriler birincil anahtarın tamamına bağımlı hale getirildi. 
  - `Bolumler`, `Ogrenciler` ve `Dersler` ana tablolar olarak ayrıldı.

### 3. Üçüncü Normal Form (3NF)
- **Kural:** Geçişli bağımlılıklar (Transitive Dependency) kaldırılmalıdır.
- **Uygulama:** Anahtar dışı alanların birbiri arasındaki bağımlılıkları temizlendi.
  - Öğrenci ve Ders arasındaki **Çoka-Çok (N:M)** ilişkiyi çözmek amacıyla `Ogrenci_Dersler` ara (köprü) tablosu oluşturuldu.

Bir öğrencinin bir bölüme kayıtlı olduğu ve birden fazla ders alabileceği; bir dersin de birden fazla öğrenci tarafından alınabileceği senaryoda.
Bölüm - Öğrenci: Bire-Çok (1:N) — Bir bölümün birden fazla öğrencisi vardır, bir öğrenci tek bir bölüme aittir.

Öğrenci - Ders: Çoka-Çok (N:M) — Bir öğrenci birden fazla ders alabilir; bir dersi birden fazla öğrenci alabilir.

Bölüm - Ders: Bire-Çok (1:N) — Bir ders belirli bir bölüme aittir.
Normalizasyon Adımları (3NF Tasarımı):
--Bolumler Tablosu:

PK (Primary Key): bolum_id

Sadece bölüme ait bilgiler tutulur (bolum_adi).

--Ogrenciler Tablosu (1NF, 2NF, 3NF):

PK: ogrenci_id

FK (Foreign Key): bolum_id (Bolumler tablosuna bağımlı).

Öğrenciye özel bilgiler tutulur (ad, soyad, email, kayit_tarihi).

--Dersler Tablosu:

PK: ders_id

FK: bolum_id (Bolumler tablosuna bağımlı).

Derse ait bilgiler tutulur (ders_kodu, ders_adi, kredi).

--Ogrenci_Dersler Tablosu (İlişki Tablosu):

Öğrenci ve Ders arasındaki N:M (Çoka-Çok) ilişkiyi çözmek için oluşturulur.

Bileşik PK (Composite Primary Key): (ogrenci_id, ders_id)

FK 1: ogrenci_id -> Ogrenciler(ogrenci_id)

FK 2: ders_id -> Dersler(ders_id)
## 3. Veritabanı Şeması ve İlişkiler

- **`Bolumler`** `(bolum_id [PK], bolum_adi)`
- **`Ogrenciler`** `(ogrenci_id [PK], ogrenci_no, ad, soyad, email, bolum_id [FK])`
- **`Dersler`** `(ders_id [PK], ders_kodu, ders_adi, kredi, bolum_id [FK])`
- **`Ogrenci_Dersler`** `(ogrenci_id [FK], ders_id [FK], donem, harf_notu)`  
  *(Bileşik PK: `ogrenci_id` + `ders_id` + `donem`)*

İlişkiye özgü veriler tutulur (harf_notu, donem).
Eğer bir öğrenci veya ders veritabanından silinirse, o öğrenciye/derse ait tüm not ve kayıt geçmişi de otomatik olarak silinir (CASCADE).
Sıralama: Yabancı anahtar bağımlılıkları yüzünden önce Bolumler, ardından bu bölümlere bağlı Ogrenciler ve Dersler, en son ise bu ikisine bağlı Ogrenci_Dersler tablosuna kayıt eklenmiştir.