# Bilimsel Hesap Makinesi Uygulaması

Flutter ile geliştirilmiş, MVP (Model-View-Presenter) mimarisini benimseyen ve durum yönetimi için Riverpod kullanan modern bir bilimsel hesap makinesi uygulamasıdır.

## Özellikler

- **İşlem Önceliği**: Hesaplamalar için BODMAS/PEMDAS kurallarına uyar.
- **Bilimsel Fonksiyonlar**: Sin, cos, tan, ln, log, karekök, π, e ve faktöriyel gibi fonksiyonları içerir.
- **Parantez Desteği**: Karmaşık hesaplamalar için parantez kullanımını destekler.
- **Geçmiş Takibi**: Hesaplama geçmişini Hive veritabanı ile kaydeder.
- **Modern Arayüz**: Yeşil ve beyaz renk şemasına sahip temiz bir tasarıma sahiptir.
- **Animasyonlar**: Akıcı geçişler ve efektler sunar.
- **Duyarlı Tasarım**: Hem dikey hem de yatay modda sorunsuz çalışır.
- **Dokunsal Geri Bildirim**: Daha iyi bir kullanıcı deneyimi için dokunsal geri bildirim sağlar.

## Mimari

Bu uygulama MVP (Model-View-Presenter) mimarisini kullanır:
- **Model**: Veri ve iş mantığını yönetir.
- **View (Görünüm)**: Arayüz bileşenlerini (ekranlar, widget'lar) içerir.
- **Presenter (Sunucu)**: Model ve Görünüm arasındaki iletişimi sağlar.

## Teknik Detaylar

- **Durum Yönetimi**: Riverpod
- **Yerel Depolama**: Geçmiş takibi için Hive
- **Optimizasyonlar**: Daha iyi performans için sistem yazı tipleri ve `const` kullanımı.

## Başlarken

Projeyi yerel makinenizde çalıştırmak için:

