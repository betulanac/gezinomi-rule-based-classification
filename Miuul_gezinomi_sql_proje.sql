--miuul.gezinomi isminde bir tablo oluşturunuz. miuul_gezinomi.csv dosyasının içeriğini miuul.gezinomi 
--tablosuna giriniz. İlk 10 satırını gözlemleyiniz.

create schema miuul;

create table miuul.gezinomi(
SaleId int,
SaleDate timestamp,
heckInDate timestamp,
Price float,
ConceptName text,
SaleCityName text,
CInDay text ,
SaleCheckInDayDiff int,
Seasons text
);

select * from miuul.gezinomi limit 10;

--Kaç tekil şehir vardır? Frekansları nedir?

select count(distinct (salecityname)) from miuul.gezinomi;

select salecityname, count(*)from miuul.gezinomi group by salecityname order by count desc;

--Kaç tekil konsept vardır?

select count(distinct (conceptname)) from miuul.gezinomi;

--Hangi konseptten kaçar tane satış gerçekleşmiş?

select conceptname, count(*) from miuul.gezinomi group by conceptname;

--Şehirlere göre satışlardan toplam ne kadar kazanılmış?

select salecityname, sum(price) from miuul.gezinomi group by salecityname;

--Konsept türlerine göre ne kadar kazanılmış?

select conceptname, sum(price) from miuul.gezinomi group by conceptname;

--Şehirlere göre PRICE ortalamaları nedir?

select salecityname, avg(price) from miuul.gezinomi group by salecityname;

--Konsept göre PRICE ortalamaları nedir?

select conceptname, avg(price) from miuul.gezinomi group by conceptname;

--Şehir-Konsept kırılımında PRICE ortalamaları nedir?

select salecityname, conceptname, avg(price) from miuul.gezinomi group by salecityname, conceptname;

-- SaleCheckInDayDiff değişkenini kategorik bir değişkene çeviriniz. miuul.sales adında yeni bir tablo oluşturunuz. 
--SaleCheckInDayDiff değişkeni müşterinin CheckIn tarihinden ne kadar önce satin alımını tamamladığını gösterir.
--•Aralıkları ikna edici şekilde oluşturunuz.
--Örneğin: ‘0_7’, ‘7_30', ‘30_90', ‘90_max’ aralıklarını kullanabilirsiniz.
--• Bu aralıklar için "Last Minuters", "Potential Planners","Planners", "Early Bookers“ isimlerini kullanabilirsiniz

create table miuul.sales as 
select 
g.*,
case 
	when salecheckindaydiff < 7 then 'last minuters'
	when salecheckindaydiff >= 7 
	and salecheckindaydiff <30 then 'potential planners'
	when salecheckindaydiff >= 7 
	and salecheckindaydiff <30 then 'planners'
	else 'early bookers'
end as eb_score
from miuul.gezinomi as g;

select * from miuul.sales;

--Şehir-Konsept-EB_Score 
--o Şehir-Konsept-Sezon 
--o Şehir-Konsept-CInDay 
--kırılımlarında ortalama ödenen ücret ve yapılan işlem sayısı cinsinden inceleyiniz

select conceptname, salecityname, eb_score, avg(price), count(*) from miuul.sales group by conceptname, salecityname, eb_score;

select conceptname, salecityname, seasons, avg(price), count(*) from miuul.sales group by conceptname, salecityname, seasons;

select conceptname, salecityname, cinday, avg(price), count(*) from miuul.sales group by conceptname, salecityname, cinday;

--City-Concept-Season kırılımının çıktısını PRICE'a göre sıralayınız.
--Elde ettiğiniz çıktıyı  miuul.sales_ccs olarak kaydediniz.

create table miuul.sales_css as 
select conceptname, salecityname, seasons, avg(price) as mean_price, count(*) from miuul.sales group by conceptname, salecityname, seasons order by mean_price;

--Yeni seviye tabanlı satışları (persona) tanımlayınız. level_base_sales adında yeni tablo olarak kaydediniz.

create table miuul.level_base_sales as
select ad.*,
 upper(
 	concat(
 		ad.salecityname, '_',
 		ad.conceptname, '_',
 		ad.seasons
 	) 
 	) as sales_level_based
 	from 
 	miuul.sales_css ad;
 
 select * from miuul.level_base_sales;

--Personaları segmentlere ayırınız.
-- Segmentleri betimleyiniz (Segmentlere göre group by yapıp price mean, max, sum’larını alınız)

create table miuul.segment as 
select lbs.*,
case 
	when mean_price <=39.30 then 'd'
	when mean_price >39.30 
	and mean_price <= 43.30 then 'c'
	when mean_price >43.30 
	and mean_price <= 50.30 then 'b'
	else 'a'
end as segment 
from miuul.level_base_sales lbs;

select * from miuul.segment ;

select s.segment, avg(s.mean_price), max(s.mean_price), sum(s.mean_price) from miuul.segment s group by segment;

--Yeni satış taleplerini sınıflandırıp, ne kadar gelir getirebileceklerini tahmin ediniz.
--Antalya’da herşey dahil ve yüksek sezonda tatil yapmak isteyen bir kişinin ortalama ne kadar gelir kazandırması beklenir?

select * from miuul.segment s where sales_level_based = 'ANTALYA_HERŞEY DAHIL_HIGH';

--Girne’de yarım pansiyon bir otele düşük sezonda giden bir tatilci hangi segmentte yer alacaktır?

select * from miuul.segment s where sales_level_based = 'GIRNE_YARIM PANSIYON_LOW';













