# Gezinomi Kural Tabanlı Sınıflandırma

Bu proje, bir seyahat acentesinin satış verilerini kullanarak potansiyel müşteri getirilerini hesaplamayı ve kural tabanlı segmentasyon yapmayı amaçlar.

## 📋 İş Problemi
Gezinomi, satış özelliklerini kullanarak:
1. Seviye tabanlı (Level Based) yeni satış tanımları oluşturmak.
2. Bu tanımlara göre segmentler oluşturmak.
3. Yeni gelecek müşterilerin ortalama kazancını tahmin etmek istemektedir.

## 🗂️ Veri Seti Hikayesi
`miuul_gezinomi.csv` veri seti, Gezinomi şirketinin yaptığı satışların fiyatlarını ve bu satışlara ait bilgileri (Şehir, Konsept, Sezon vb.) içerir.

## 🛠️ Kullanılan Teknolojiler
* **Veritabanı:** PostgreSQL
* **Araç:** DBeaver
* **Yöntem:** SQL (Aggregate Functions, Case-When, Subqueries)
