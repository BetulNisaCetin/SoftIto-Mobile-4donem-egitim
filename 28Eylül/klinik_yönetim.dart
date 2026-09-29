
enum HizmetKategorisi {
  ciltYenileme,
  medikalEstetik,
  lazerEpilasyon,
  Lipo,
}

enum SeansDurum {
  bekliyor,
  odadaIslemde,
  tamamlandi,
  iptalEdildi,
}

enum OdemeYontemi {
  nakit,
  krediKarti,
  havaleEft,
  klinikPaketKredisi,
}

class Danisan {
  final String id;
  final String adSoyad;
  final String telefon;
  final List<String> alerjiler;
  final bool vipMi;
  final String? ozelCiltNotu;

  const Danisan({
    required this.id,
    required this.adSoyad,
    required this.telefon,
    this.alerjiler = const [],
    this.vipMi = false,
    this.ozelCiltNotu,
  });

  bool get hassasCiltMi => alerjiler.isNotEmpty;

  String get bilgiOzeti {
    final String alerjiBilgisi = alerjiler.isEmpty
        ? "Kayıtlı alerjiler yok"
        : "Alerjiler: ${alerjiler.join(", ")}";

    final String notBilgisi =
        ozelCiltNotu ?? "Özel cilt notu yok";

    final String vipRozeti =
        vipMi ? "VIP müşteri" : "Standart";

    return "$vipRozeti $adSoyad ($telefon) "
        "$alerjiBilgisi | Not bilgisi: $notBilgisi";
  }
}

class SeansKaydi {
  final String seansKodu;
  final Danisan danisan;
  final HizmetKategorisi kategori;
  final String islemAdi;
  final double birimFiyat;
  final int seansSayisi;
  final double indirimOrani;
  final String? sorumluUzman;

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
    this.durum = SeansDurum.bekliyor,
    this.odemeTipi,
    this.iptalNedeni,
  });

  double get brutTutar => birimFiyat * seansSayisi;

  double get indirimTutari {
    double toplamOran = indirimOrani;

    if (danisan.vipMi) {
      toplamOran += 10.0;
    }

    return brutTutar * (toplamOran / 100);
  }

  double get netTutar => brutTutar - indirimTutari;
}

class KlinikYoneticisi {
  final String subeAdi;

  final List<SeansKaydi> seanslar = [];

  final Map<String, Danisan> danisanRehberi = {};

  KlinikYoneticisi({required this.subeAdi});

  void danisanKaydet(Danisan danisan) {
    danisanRehberi[danisan.id] = danisan;

    print(
      "Rehbere eklendi: ${danisan.adSoyad} "
      "${danisan.vipMi ? "VIP" : "Standart"}",
    );
  }

  void randevuOlustur(SeansKaydi seans) {
    seanslar.add(seans);

    print(
      "Randevu kaydedildi ${seans.seansKodu}: "
      "${seans.danisan.adSoyad} "
      "${seans.kategori} --> ${seans.islemAdi}",
    );
  }

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

        return;
      }
    }

    print("Hata: $seansKodu bulunamadı.");
  }

  void seansiIptalEt(
    String seansKodu,
    String? iptalNedeni,
  ) {
    for (var seans in seanslar) {
      if (seans.seansKodu == seansKodu) {
        seans.durum = SeansDurum.iptalEdildi;

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

  double get toplamTahsilEdilenCiro {
    return seanslar
        .where((s) => s.durum == SeansDurum.tamamlandi)
        .fold(0.0, (toplam, s) => toplam + s.netTutar);
  }

  double get beklenenPotansiyelCiro {
    return seanslar
        .where(
          (s) =>
              s.durum == SeansDurum.bekliyor ||
              s.durum == SeansDurum.odadaIslemde,
        )
        .fold(0.0, (toplam, s) => toplam + s.netTutar);
  }

  Map<HizmetKategorisi, int> kategoriBazliSeansDagilimi() {
    final Map<HizmetKategorisi, int> dagilim = {};

    for (var kat in HizmetKategorisi.values) {
      dagilim[kat] = 0;
    }

    for (var s in seanslar) {
      dagilim[s.kategori] = (dagilim[s.kategori] ?? 0) + 1;
    }

    return dagilim;
  }

  Set<String> gorevliUzmanKadrosu() {
    return seanslar
        .map((s) => s.sorumluUzman)
        .whereType<String>()
        .toSet();
  }

  List<SeansKaydi> uzmansizSeanslariGetir() {
    return seanslar
        .where((s) => s.sorumluUzman == null)
        .toList();
  }
}