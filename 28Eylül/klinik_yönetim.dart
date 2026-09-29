/// Klinik içerisinde sunulan hizmet kategorilerini temsil eden numaralandırma (Enum).
enum HizmetKategorisi {
  ciltYenileme,
  medikalEstetik,
  lazerEpilasyon,
  Lipo,
}

/// Seansın anlık durumunu takip etmek için kullanılan numaralandırma (Enum).
enum SeansDurum {
  bekliyor,       // Randevu oluşturuldu, randevu saati bekleniyor
  odadaIslemde,   // Danışan odada, işlem devam ediyor
  tamamlandi,     // İşlem bitti, ödeme alındı
  iptalEdildi,    // Randevu iptal edildi
}

/// Klinik tarafından kabul edilen ödeme yöntemleri.
enum OdemeYontemi {
  nakit,
  krediKarti,
  havaleEft,
  klinikPaketKredisi,
}

/// Klinikten hizmet alan Danışan (Müşteri) bilgilerini tutan model sınıfı.
class Danisan {
  final String id;
  final String adSoyad;
  final String telefon;
  final List<String> alerjiler; // Müşterinin alerjisi olan maddelerin listesi
  final bool vipMi;             // VIP müşteri durum bayrağı
  final String? ozelCiltNotu;   // Opsiyonel özel cilt bilgisi veya notu

  // Const constructor sayesinde değişmez (immutable) nesneler oluşturulabilir.
  const Danisan({
    required this.id,
    required this.adSoyad,
    required this.telefon,
    this.alerjiler = const [],  // Varsayılan olarak boş liste
    this.vipMi = false,         // Varsayılan olarak standart müşteri
    this.ozelCiltNotu,          // Nullable (boş bırakılabilir)
  });

  /// Müşterinin alerji listesi doluysa 'hassas cilt' kabul eden getter.
  bool get hassasCiltMi => alerjiler.isNotEmpty;

  /// Danışana ait özet bilgileri metin formatında döndüren getter.
  String get bilgiOzeti {
    // Alerji kontrolü: Liste boşsa özel mesaj, doluysa virgülle birleştirilmiş alerjiler gösterilir.
    final String alerjiBilgisi = alerjiler.isEmpty
        ? "Kayıtlı alerjiler yok"
        : "Alerjiler: ${alerjiler.join(", ")}";

    // Null safety kontrolü: Not yoksa varsayılan metin atanır.
    final String notBilgisi =
        ozelCiltNotu ?? "Özel cilt notu yok";

    // VIP statüsüne göre etiket belirlenir.
    final String vipRozeti =
        vipMi ? "VIP müşteri" : "Standart";

    return "$vipRozeti $adSoyad ($telefon) "
        "$alerjiBilgisi | Not bilgisi: $notBilgisi";
  }
}

/// Tek bir seansa/randevuya ait işlem, fiyat ve durum detaylarını tutan sınıf.
class SeansKaydi {
  final String seansKodu;
  final Danisan danisan;
  final HizmetKategorisi kategori;
  final String islemAdi;
  final double birimFiyat;
  final int seansSayisi;
  final double indirimOrani;     // Yüzde cinsinden indirim oranı (Örn: 15.0 = %15)
  final String? sorumluUzman;    // İşlemi yapacak uzman (atanmamış olabilir)

  // Duruma göre zamanla güncellenebilecek (mutable) alanlar:
  SeansDurum durum;
  OdemeYontemi? odemeTipi;
  String? iptalNedeni;

  SeansKaydi({
    required this.seansKodu,
    required this.danisan,
    required this.kategori,
    required this.islemAdi,
    required this.birimFiyat,
    this.seansSayisi = 1,
    this.indirimOrani = 0.0,
    this.sorumluUzman,
    this.durum = SeansDurum.bekliyor, // Oluşturulduğunda varsayılan durum: bekliyor
    this.odemeTipi,
    this.iptalNedeni,
  });

  /// İndirim uygulanmadan önceki ham tutar hesaplaması.
  double get brutTutar => birimFiyat * seansSayisi;

  /// Toplam indirim tutarını hesaplayan getter.
  double get indirimTutari {
    double toplamOran = indirimOrani;

    // Eğer danışan VIP müşteriyse, mevcut indirime ekstra %10 ilave edilir.
    if (danisan.vipMi) {
      toplamOran += 10.0;
    }

    return brutTutar * (toplamOran / 100);
  }

  /// İndirimler düşüldükten sonra ödenmesi gereken son net tutar.
  double get netTutar => brutTutar - indirimTutari;
}

/// Şubenin tüm operasyonlarını, danışan rehberini ve finansal verilerini yöneten ana sınıf.
class KlinikYoneticisi {
  final String subeAdi;

  // Klinik bünyesinde oluşturulan tüm seansların listesi.
  final List<SeansKaydi> seanslar = [];

  // Müşterilere hızlı erişim sağlamak için ID bazlı çalışan danışan rehberi (Map/Dictionary).
  final Map<String, Danisan> danisanRehberi = {};

  KlinikYoneticisi({required this.subeAdi});

  /// Yeni bir danışanı sisteme ve rehbere kaydeder.
  void danisanKaydet(Danisan danisan) {
    danisanRehberi[danisan.id] = danisan;

    print(
      "Rehbere eklendi: ${danisan.adSoyad} "
      "${danisan.vipMi ? "VIP" : "Standart"}",
    );
  }

  /// Yeni bir randevu/seans kaydı oluşturur ve listeye ekler.
  void randevuOlustur(SeansKaydi seans) {
    seanslar.add(seans);

    print(
      "Randevu kaydedildi ${seans.seansKodu}: "
      "${seans.danisan.adSoyad} "
      "${seans.kategori} --> ${seans.islemAdi}",
    );
  }

  /// Seansı tamamlandı olarak işaretler ve ödeme yöntemini kaydederek tahsilat bilgisini basar.
  void seansTamamla({
    required String seansKodu,
    required OdemeYontemi odeme,
  }) {
    for (var seans in seanslar) {
      if (seans.seansKodu == seansKodu) {
        seans.durum = SeansDurum.tamamlandi;
        seans.odemeTipi = odeme;

        print(
          "Seans tamamlandı: $seansKodu "
          "${seans.netTutar.toStringAsFixed(2)} ₺ "
          "tahsil edildi. ${odeme.name}",
        );

        return; // İşlem yapılan seans bulunduktan sonra döngüden çıkılır.
      }
    }

    // Kod eşleşmezse çalışacak hata mesajı.
    print("Hata: $seansKodu bulunamadı.");
  }

  /// Belirtilen seansı iptal durumuna getirir ve varsa iptal gerekçesini işler.
  void seansiIptalEt(
    String seansKodu,
    String? iptalNedeni,
  ) {
    for (var seans in seanslar) {
      if (seans.seansKodu == seansKodu) {
        seans.durum = SeansDurum.iptalEdildi;

        // İptal nedeni verilmediyse varsayılan bir gerekçe atanır.
        seans.iptalNedeni =
            iptalNedeni ?? "Gerekçe belirtilmedi";

        print(
          "Seans iptal edildi: $seansKodu "
          "${seans.iptalNedeni}",
        );

        return;
      }
    }

    print("Hata: $seansKodu bulunamadı.");
  }

  /// Yalnızca TAMAMLANMIŞ seanslardan elde edilen toplam gerçekleşen ciroyu hesaplar.
  double get toplamTahsilEdilenCiro {
    return seanslar
        .where((s) => s.durum == SeansDurum.tamamlandi) // Sadece tamamlananları filtrele
        .fold(0.0, (toplam, s) => toplam + s.netTutar); // Net tutarları topla
  }

  /// Bekleyen veya şu an işlemde olan seanslardan gelmesi beklenen olası ciroyu hesaplar.
  double get beklenenPotansiyelCiro {
    return seanslar
        .where(
          (s) =>
              s.durum == SeansDurum.bekliyor ||
              s.durum == SeansDurum.odadaIslemde,
        )
        .fold(0.0, (toplam, s) => toplam + s.netTutar);
  }

  /// Her hizmet kategorisinde kaç adet seans oluşturulduğunu sayan raporlama metodu.
  Map<HizmetKategorisi, int> kategoriBazliSeansDagilimi() {
    final Map<HizmetKategorisi, int> dagilim = {};

    // İlk olarak tüm kategorilerin sayacını 0 olarak başlatır.
    for (var kat in HizmetKategorisi.values) {
      dagilim[kat] = 0;
    }

    // Seansları gezerek ilgili kategorinin sayacını 1 artırır.
    for (var s in seanslar) {
      dagilim[s.kategori] = (dagilim[s.kategori] ?? 0) + 1;
    }

    return dagilim;
  }

  /// Aktif olarak seanslara atanmış uzman isimlerinin benzersiz (Set) listesini döndürür.
  Set<String> gorevliUzmanKadrosu() {
    return seanslar
        .map((s) => s.sorumluUzman)    // Sadece uzman isimlerini alır
        .whereType<String>()          // null olmayan (gerçek isim içeren) değerleri süzer
        .toSet();                     // Tekrarlayan isimleri teke indirip Set'e dönüştürür
  }

  /// Henüz bir uzman atanmamış seansların listesini getirir.
  List<SeansKaydi> uzmansizSeanslariGetir() {
    return seanslar
        .where((s) => s.sorumluUzman == null)
        .toList();
  }
}