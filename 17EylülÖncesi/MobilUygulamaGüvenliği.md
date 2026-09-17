A- Ekran görüntüsü ve ekran kaydı
Bir bankacılık uygulamasında kredi kartı bilgileri, kart numarası veya bakiye gibi hassas verilerin ekran görüntüsü ya da ekran kaydı ile alınmasını engellemek önemlidir. Böylece kullanıcıya ait finansal ve kişisel bilgilerin başka kişiler tarafından ele geçirilmesi veya paylaşılması riski azaltılır.
ANDROİD: WindowManager üzerinden kullanılan FLAG_SECURE ile ekran görüntüsü alınması ve ekran içeriğinin bazı ekran yakalama/kayıt yöntemleriyle paylaşılması engellenebilir.

iOS: UIScreen.isCaptured kullanılarak ekranın kaydedilip kaydedilmediği veya yansıtılıp yansıtılmadığı tespit edilebilir. Uygulama bu duruma göre hassas içeriği gizleyebilir.

B-Overlay Saldırıları

Overlay saldırısında kötü amaçlı bir uygulama, Android'in ekran üzerine pencere gösterme (overlay) yeteneğini kullanarak başka bir uygulamanın arayüzünün üzerine sahte bir arayüz yerleştirir.
Kullanıcı gerçek bankacılık uygulamasında giriş ekranını açtığında, saldırganın uygulaması bankacılık uygulamasının üzerine sahte bir giriş formu (kullanıcı adı ve şifre alanları) gösterir. Kullanıcı gerçek bankacılık ekranında olduğunu düşünerek bilgilerini girer. Bu bilgiler saldırganın uygulaması tarafından alınabilir.

C-Root / Jailbreak
Root edilmiş (Android) veya Jailbreak yapılmış (iOS) cihazlarda işletim sisteminin normalde uygulamalara ve kullanıcıya koyduğu bazı güvenlik kısıtlamaları kaldırılır. Bu nedenle saldırganların sistem dosyalarına, uygulama dosyalarına veya uygulamaların belleğinde bulunan verilere erişmesi daha kolay hale gelebilir.

Saldırı Senaryosu: Root/Jailbreak yetkisine sahip bir cihazda saldırgan veya cihaza bulaşan zararlı bir yazılım, su (superuser) ayrıcalıklarını kullanarak /data/data/com.ornek.uygulama/shared_prefs/ dizinine doğrudan erişebilir. Bu yetki sayesinde, normal şartlarda korunan session_token.xml dosyasındaki gizli oturum anahtarını okuyabilir ve bu bilgiyi ele geçirerek kullanıcının oturumunu başka bir cihaza klonlayabilir.

D-SQLite ve şifreleme
SQLite, varsayılan olarak verileri herhangi bir şifreleme mekanizması olmadan düz metin (plaintext) biçiminde saklar.SQLCipher, SQLite veritabanına 256-bit AES şifreleme katmanı ekleyen açık kaynaklı bir eklentidir. Şifrelenmiş dosya anahtar olmadan hiçbir şekilde okunamaz .Normal Sqlite ile saldırgan veriyi okuyup değiştirebilir.Root /Jailbreak koruması SQLCIPHER'da güçlüdür (Root olunsa bile dosya anlamsız karmaşık baytlardan oluşur).

E-Access Token ve Refresh Token
Access Token 15 dakika ömürlüdür ve yalnızca RAM bellekte tutulur. API'lere erişmek ve kullanıcının yetkili olduğu işlemleri gerçekleştirmek için kullanılır.

Refresh Token ise Access Token'ın süresi dolduğunda yeni bir Access Token almak için kullanılır. 30 gün ömürlüdür ve güvenli depolama alanında (Secure Storage) tutulur.
Kısaca: Access Token API erişimi için, Refresh Token ise yeni bir Access Token almak için kullanılır.
a-Access Token, istemci ile sunucu arasındaki her istekte (HTTP Header'da) ağ üzerinden taşınır. Bu durum onu dinleme (Sniffing), Man-in-the-Middle (MitM) veya XSS gibi saldırılara açık hale getirir.
Eğer bir saldırgan Access Token'ı ele geçirirse, token'ın süresi kısa olduğu için (örneğin 10 dakika sonra) saldırganın erişim yetkisi otomatik olarak biter. Bu yaklaşım, token çalınması durumunda oluşacak zarar penceresini en aza indirir.
b-Refresh Token, hesabın "ana anahtarı" gibidir. Süresi uzun olduğu için saldırganın eline geçerse, saldırgan kullanıcı fark etmeden günlerce veya aylarca yeni Access Token'lar üreterek hesabı kontrol edebilir.
Bu nedenle Refresh Token, ağ üzerinde her istekte taşınmaz; sadece token yenileme anında kullanılır. Cihaz üzerinde de en güvenli alanlarda saklanmalıdır:
Android'te = keystore, İOS'ta keychain.
c-Kullanıcı "Çıkış Yap" (Logout) butonuna bastığında, uygulamanın istemci tarafındaki token'ları silmesi yeterli değildir. Eğer sunucu tarafında veritabanından veya önbellekten (Redis vb.) bu Refresh Token iptal edilmezse (Revocation), cihazdan çalınmış eski bir Refresh Token ile saldırgan yeni Access Token'lar almaya devam edebilir.

Refresh Token'ın iptal edilmesi, o oturum için yeni erişim anahtarı üretme yetkisini tamamen sonlandırır ve güvenli bir çıkış işlemi sağlar.