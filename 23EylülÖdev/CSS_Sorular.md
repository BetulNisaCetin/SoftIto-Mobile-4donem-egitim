1. Flexbox ile CSS Grid Arasındaki Mimari Fark
Flexbox yalnızca tek eksende row ya da columd düzenleme yapabilir. (1D)
CSS Grid ise satır ve sütunları aynı anda kontrol etmemizi sağlar , 2 boyutlu yapısı vardır(2D).
Flexboxta content first yaklaşımı vardır, içerikler kendi boyutlarına göre hizalanır. CSS Grid ise layput first yaklaşımı vardır önceden tanımlanmış bir ızgara şablonu vardır elemanlar buraya yerleşir.
Tüm sayfa düzenleri gib yapılarda CSS Grid seçilmelidir. Navigasyon barları , kart içerikleri gibi tek yönlü bileşenler için Flexbox seçilmelidir.

2. fr (Fractional Unit) Biriminin Yüzde (%) Birimine Göre Güvenli Olması
Yüzde (%) hesabı yaparken margin, padding veya gap değerleri eklendiğinde toplam genişlik %100 sınırını aşabilir ve taşmalara (overflow) yol açar. Bunu engellemek için karmaşık calc() hesaplamaları gerekir
fr birimi ise kullanılabilir boş alanı (available space) temsil eder. Grid container içindeki sabit genişlikler, padding ve gap değerleri hesaplamadan düşüldükten sonra kalan net alanı oranlar. Bu sayede taşma riski olmadan esnek ve güvenli bir dağılım sağlar

3. "Mobile-First" (min-width) Mimarisinin Tercih Edilme Nedenleri
Performans ve Kaynak Yönetimi: Mobil cihazlar daha düşük donanım ve bant genişliğine sahiptir. Mobile-First yaklaşımında temel/hafif kodlar önce yüklenir, masaüstü için gereken ağır stiller yalnızca ekran büyüdüğünde (min-width) medya sorguları üzerinden çekilir.
4. Animasyonlarda transform ve opacity Tercih Edilme Nedeni?
top, left, width veya margin gibi özellikler değiştirildiğinde tarayıcı Reflow (Layout) ve Repaint adımlarını tekrar tetikler. Bu durum CPU'yu yorar ve animasyonda takılmalara (jank) yol açar.
transform ve opacity özellikleri ise layout boyutlarını etkilemez. Tarayıcı bu işlemleri doğrudan grafik kartına (GPU / Composite aşaması) devreder. Bu sayede 60 FPS akıcılığında ve donanım hızlandırmalı animasyonlar elde edilir.
5. auto-fit ve minmax() Birleşimi:
grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
minmax(250px, 1fr) kuralı her bir sütunun en az 250px genişliğinde olmasını, alan varsa eşit oranda (1fr) büyümesini söyler. auto-fit ise sığabildiği kadar sütunu yan yana dizer; sığmayan elemanları otomatik olarak bir alt satıra kaydırır.

6. grid-template-areas Özelliğinin Kurumsal Avantajı:
Kodun görsel bir haritasını sunduğu için ekibe yeni katılan geliştiricilerin projeye adaptasyonunu hızlandırır.
HTML yapısını değiştirmeden, sadece CSS üzerinden responsive durumlarda tüm sayfa düzenini (örneğin mobilde sidebar'ı alta alma) tek bir blokta kolayca değiştirmeye olanak tanır.
7. CSS clamp() Fonksiyonunun Parametreleri:
clamp(2rem, 5vw, 4rem); clamp(min,tercih edilen,max), clamp(2rem, 5vw, 4rem); yazıldığında yazı tipi ekran genişliğine göre büyüyüp küçülür ancak asla 2rem'den küçük, 4rem'den büyük olamaz.

8. CSS Animasyonunun Sonsuza Kadar Çalışması:
Animasyonun kesintisiz döngüye girmesi için animation-iteration-count özelliğine infinite değeri verilir.
9. Flutter'da CSS Grid ve Flexbox Karşılıkları
Flexbox Karşılığı:
Row (Yatay eksen)
Column (Dikey eksen)
Esneklik ve oranlama için Flex, Expanded ve Spacer widget'ları ile birlikte kullanılır.
CSS Grid Karşılığı:
GridView (Özellikle GridView.builder veya GridView.count)
Karmaşık ve özel alan gridleri için CustomMultiChildLayout veya StaggeredGridView (paket) tercih edilir.
10. React Native'de CSS Grid Kullanımı ve Alternatifleri
React Native web'deki CSS Grid'i doğrudan desteklemez. React Native'in yerel düzen motoru (Yoga Engine) yalnızca Flexbox yapısını destekler (ve varsayılan flexDirection değeri web'in aksine column'dur). 
Çok sütunlu ızgara yapısı FlatList ile numColumns parametresi ile kolayca oluşturulabilir.
<FlatList
  data={data}
  numColumns={2}
  renderItem={({item}) => <Card item={item} />}
/>
