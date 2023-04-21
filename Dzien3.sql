


select imie, nazwisko, kraj, data_ur
from zawodnicy
union
select imie_t, nazwisko_t, format(data_ur_t,'dd-MM-yyyy'), data_ur_t
from trenerzy


select imie, nazwisko
from zawodnicy
union
select imie, nazwisko
from zawodnicy 
where kraj ='pol'

select imie, nazwisko
from zawodnicy
union all
select imie, nazwisko
from zawodnicy 
where kraj ='pol'

select imie, nazwisko
from zawodnicy
except
select imie, nazwisko
from zawodnicy 
where kraj ='pol'

select imie, nazwisko
from zawodnicy
intersect
select imie, nazwisko
from zawodnicy 
where kraj ='pol'


-- podaj zawodnikow, ktorych wzrost jest drugi co do wielkosci 

select * from zawodnicy
where wzrost = 
	(select max(wzrost) from
		(select imie, nazwisko, wzrost from zawodnicy
		except 
		select imie, nazwisko, wzrost 
		from zawodnicy
		where wzrost = (select max(wzrost) from zawodnicy )) t)



-- podaj wsp�ln� list� zawodnik�w i trener�w (imie, nazwisko i kraj)
-- kraj trenera ma by� taki sam jak kraj najwy�szego zawodnika tego trenera 


select z.imie,z.nazwisko, z.kraj,z.wzrost, t.imie_t, t.nazwisko_t
from zawodnicy z join trenerzy t on z.id_trenera = t.id_trenera


select  z.kraj, t.imie_t, t.nazwisko_t, max(z.wzrost)
from zawodnicy z join trenerzy t on z.id_trenera = t.id_trenera
group by  t.imie_t, t.nazwisko_t, kraj


select  z.kraj, t.imie_t, t.nazwisko_t
from zawodnicy z join trenerzy t on z.id_trenera = t.id_trenera
group by  t.imie_t, t.nazwisko_t, kraj
union 
select kraj, imie, nazwisko from zawodnicy

-- w tym zadaniu mozemy pomina� wzrost bo trenerzy trenuj� wszystkich zawodnik�w z tego samego kraju 




-- wypisz zawodnikow, kt�rzy startowali w puchar burmistrza Zakopanego
-- ale bez tych, kt�rzy maj� wi�cej ni� 2 starty 
 

 select imie, nazwisko
 from zawodnicy z join uczestnictwa u on z.id_zawodnika = u.id_zawodnika
			      join zawody zw on zw.id_zawodow = u.id_zawodow
 where zw.nazwa =  'puchar burmistrza Zakopanego'
 except
 select imie, nazwisko from
	 (select z.imie, z.nazwisko, count(z.id_zawodnika) ile
	 from zawodnicy z join uczestnictwa u  on z.id_zawodnika = u.id_zawodnika
	 group by imie, nazwisko
	 having count(z.id_zawodnika)>2) t 


	 -- str 39 

	 -- znajdz wszystkie kraje, w kt�rych nie ma zwodnik�w o imieniu martin 

	 select distinct kraj from zawodnicy
	 except 
	 select kraj from zawodnicy where imie = 'Martin'

	 -- podaj ile zawodnik�w urodzi�o si� w danym dniu tygodnia np:
	 -- pondzia�ek : 4
	 -- wtorek : 2.. 
	 -- itd.. upewnij si�, �e wszystkie dni tygodnia s� wy�wietlone nawet gdy nikt si� nie urodzi� 
	 -- posortuj wynik tak aby poniedzia�ek by� pierwszy 

select t1.dt, ISNULL(t2.ls,'0') luz from
	 (select 'Poniedzia�ek' dt  , 1 nr
	 union 
	 select 'Wtorek' , 2
	 union  
	 select '�roda'	 , 3
	 union 
	 select 'Czwartek' ,4
	 union 
	 select 'Pi�tek', 5
	 union 
	 select 'Sobota', 6 
	 union 
	 select 'Niedziela' ,7) t1

left join

	 (select format(data_ur,'dddd','pl') dt, count(id_zawodnika) ls
	 from zawodnicy
	 group by  format(data_ur,'dddd','pl')) t2
on t1.dt = t2.dt
order by nr
	 -- * 
     -- podaj ile os�b urodzi�o si� w danym dniu tygodnia w 3 kolumnach :
	 -- |dzie� tyg|ile zawodnik�w|ile trenerow
	 -- pondzia�ek : 4, 2
	 -- wtorek : 2 , 3
	 -- itd.. upewnij si�, �e wszystkie dni tygodnia s� wy�wietlone nawet gdy nikt si� nie urodzi� 
	 -- posortuj wynik tak aby poniedzia�ek by� pierwszy

select k1.dt,Isnull(k1.luz,0) luz, Isnull(k2.lt,0) lut from

	(select t1.dt, ISNULL(t2.ls,'0') luz, nr from
		 (select 'Poniedzia�ek' dt  , 1 nr
		 union 
		 select 'Wtorek' , 2
		 union  
		 select '�roda'	 , 3
		 union 
		 select 'Czwartek' ,4
		 union 
		 select 'Pi�tek', 5
		 union 
		 select 'Sobota', 6 
		 union 
		 select 'Niedziela' ,7) t1

	left join

		 (select format(data_ur,'dddd','pl') dt, count(id_zawodnika) ls
		 from zawodnicy
		 group by  format(data_ur,'dddd','pl')) t2
	on t1.dt = t2.dt) k1

full join
	(select format(data_ur_t,'dddd','pl') dt, count(id_trenera) lt
	from trenerzy
	group by  format(data_ur_t,'dddd','pl')) k2
on k1.dt = k2.dt
order by k1.nr

 

 -- funkcje okienkowe 

 select *
 from zawodnicy
 order by wzrost desc



 select imie, nazwisko, wzrost , rank() over (order by wzrost desc)
 from zawodnicy



 select * from 
	 (select imie, nazwisko, wzrost , dense_rank() over (order by wzrost desc) r
	 from zawodnicy) t 
 where r =4


  select imie, nazwisko, wzrost , ntile(4) over (order by wzrost desc)
 from zawodnicy


 select imie, nazwisko, wzrost , lag(imie,2) over (order by wzrost desc)
 from zawodnicy

 select imie, nazwisko, wzrost , lead(imie,2) over (order by wzrost desc)
 from zawodnicy


 select imie, nazwisko, wzrost , max(wzrost) over (order by wzrost desc)
 from zawodnicy


  select imie, nazwisko, wzrost , max(wzrost) over (order by wzrost desc rows between 1 preceding and 2 following)
 from zawodnicy

   select imie, nazwisko, wzrost , avg(convert(decimal,wzrost)) over (order by wzrost desc rows between 1 preceding and 2 following)
 from zawodnicy

    select imie, nazwisko, wzrost , avg(convert(decimal,wzrost)) over (order by wzrost desc rows between unbounded preceding and 2 following)
 from zawodnicy

     select imie, nazwisko, wzrost , avg(convert(decimal,wzrost)) over (order by wzrost desc rows between unbounded preceding and unbounded following)
 from zawodnicy


 select imie, nazwisko, wzrost , avg(convert(decimal,wzrost)) over (order by wzrost desc rows between unbounded preceding and 0 following)
 from zawodnicy

  select imie, nazwisko, wzrost , avg(convert(decimal,wzrost)) over (order by wzrost desc rows between unbounded preceding and current row)
 from zawodnicy

   select imie, nazwisko, wzrost , avg(convert(decimal,wzrost)) over (order by wzrost desc )
 from zawodnicy


 -- dla kazdego zawodnika wypisz o ile rozni sie jego wzrost 
-- od wzorstu zawodnika od niego nizszego (wzgledem uporzadkowania po wzroscie)



--rank, dense_rank, ntile, lag, lead, i wszystkie agreguj�ce 


select imie ,nazwisko, wzrost, wzrost - lag(wzrost,1) over(order by wzrost) r
from zawodnicy 


-- partycjonowaine 

select imie, nazwisko, wzrost, kraj, avg(wzrost) over (partition by kraj order by wzrost rows between unbounded preceding  and unbounded following)
from zawodnicy

-- dla kazdego zawodnika, policz o ile cm rozni sie jego wzrost od sredniego wzrostu z jego kraju 


select imie, nazwisko, wzrost, kraj, 
	abs(wzrost -avg(convert(decimal,wzrost)) over (partition by kraj order by wzrost rows between unbounded preceding and unbounded following))
from zawodnicy


-- 1) dla kazdego zawodnika wypisz nazwisko zawodnika najcie�szego z jego kraju 

select * , (select imie + ' ' + nazwisko from zawodnicy where waga = t.mw and kraj = t.kraj)
from
	(select imie, nazwisko, waga, kraj, max(waga) over (partition by kraj order by waga rows between unbounded preceding and unbounded following) mw
	from zawodnicy) t 

-- mozna jeszcze prosciej uzyawj�c LAST_VALUE lub FIRST_VALUE

select imie, nazwisko, waga, LAST_VALUE(nazwisko) over (partition by kraj order by waga rows between unbounded preceding and unbounded following)
from zawodnicy


--2) dla kazdego zawodnika podaj jaka jest r�znica w danich pomiedzy data jego urodzin
   -- a data najstraszego zawodnika z jego kraju 

select imie, nazwisko, data_ur, abs(datediff(d, data_ur, dn)) roznica
from
  (select imie, nazwisko, data_ur, kraj, min(data_ur) over (partition by kraj order by data_ur rows between unbounded preceding and unbounded following) dn
  from zawodnicy) t 


  -- pivot 

  -- dla kazdego zawodnika wypisz polowe roku , w ktorej sie urodzil - ( I polowa , II polowa) 


  select imie, nazwisko, kraj, iif(month(data_ur) < 7,'I polowa','II polowa') p , wzrost
  from zawodnicy


  select imie, nazwisko, kraj, iif(month(data_ur) < 7,'I polowa','II polowa') p , wzrost
  from zawodnicy


  -- krok 1: wypisz tylko 3 kolumn: I kategoria, II kategoria , wartosci do agregacji 

  select  kraj, iif(month(data_ur) < 7,'I polowa','II polowa') p , wzrost
  from zawodnicy

  -- krok 2: zrobienie z tego podzapytania, dodanie pivota kt�ry okre�la co i jak agragujemy oraz trzeba wskaza� kt�re kolumny chcemy wswielac 

select * from
  (select  kraj, iif(month(data_ur) < 7,'I polowa','II polowa') p , wzrost
  from zawodnicy) t
pivot 
(
	avg(wzrost)
	for p in ([I polowa],[II polowa])
) pvt

-- piwot staramy sie w taki spos�b tworzy� aby 
-- kategoria I mo�e by� liczna ale kategoria II powinna by� mniej liczna


-- zr�b zestawienie, kr�re wy�wieli ile razy dana ekpia zawodnik�w startowa�a w danym mie�cie

-- nag��wki wierszy to b�d� kraje
-- nag��wki kolumn to b�d� miasta
-- na przeci�ciu liczba start�w

 select *
 from
	 (select z.kraj, m.nazwa_miasta, count(*) starty
	 from zawodnicy z join uczestnictwa u on z.id_zawodnika = u.id_zawodnika
					  join zawody zw on zw.id_zawodow = u.id_zawodow
					  join skocznie s on s.id_skoczni = zw.id_skoczni
					  join miasta m on m.id_miasta = s.id_miasta
	group by  z.kraj, m.nazwa_miasta) q
pivot
(
	sum(starty)
	for nazwa_miasta in (["Lahti"],["Oberstdorf"],["Zakopane"])
) pvt

select * from miasta

-- sql -> t-sql 


declare @napis varchar(50)
set @napis = 'ger'




declare @szukanyWzrost varchar(50)
set @szukanyWzrost = 178


select imie, nazwisko, kraj
from zawodnicy
where wzrost = @szukanyWzrost


declare @tekst varchar(max)
set @tekst = ''


select @tekst = @tekst + imie + ', '
from zawodnicy

select @tekst


-- tworzenie walsnych funkcji 

 --select len(imie), policzBMI(waga,wzrost), dodaj(4,5) 

 go
 create function dodawanie(@liczbaA int, @liczbaB int) returns int 
 as
 begin
	declare @wynik int
	set @wynik = @liczbaA + @liczbaB
	return @wynik
 end

 go

 select dbo.dodawanie(4,5)

 select imie, nazwisko, dbo.dodawanie(waga,wzrost) from zawodnicy

 -- spr�buj stwozryc funkcje BMI, kt�ra na na wej�ciu bedzie oczekiwa� : waga i wzrost 


 go
 create function bmi(@waga int , @wzrost int) returns decimal(5,2)
 as
 begin

	declare @wynik decimal(5,2)
	set @wynik = @waga/power(@wzrost/100.0,2)
	return @wynik
 end
 go


 select imie, nazwisko , dbo.bmi(waga,wzrost) bmi 
 from zawodnicy

 drop function bmi 


 -- stw�rz funkcje, kt�ra na podstawie zadanego na wejsciu id_zawodnika
 -- wypisze nazwisko jego trenera 
 go
 create function jegoTrener(@id int) returns varchar(255)
 as
 begin

	declare @nazwisko varchar(255)
	
	select @nazwisko = nazwisko_t
	from zawodnicy z join trenerzy t on z.id_trenera = t.id_trenera
	where id_zawodnika= @id

	return @nazwisko
 end
 go

 select imie, nazwisko, dbo.jegoTrener(id_zawodnika) from zawodnicy

 -- napiszmy funkcje: "jegoZawodnicy", kt�ra na wejsciu oczekuje id_trenera
-- i zwraca jako napis liste nazwisk zawodnikow, oddzielon� przecinkami 

go
alter function jegoZawodnicy(@id int) returns varchar(max)
as
begin

	declare @nazwiska varchar(max)
	set @nazwiska = ''

	select @nazwiska = @nazwiska + ', ' + nazwisko
	from zawodnicy z join trenerzy t on z.id_trenera = t.id_trenera
	where t.id_trenera = @id
	return substring(@nazwiska,3,len(@nazwiska))

end
go

select imie_t, nazwisko_t, dbo.jegoZawodnicy(id_trenera)
from trenerzy


declare @i int 
set @i = 1

while @i<10
begin

	--select @i
	insert into zawodnicy (imie, nazwisko) values ('jan','kowalski (' + CONVERT(varchar,@i) + ')') 
	set @i = @i + 1
end

select * from zawodnicy



-- dynamiczne generowanie SQL


declare @miasta as nvarchar(max)

SELECT @miasta = STUFF((
    SELECT DISTINCT ', [' + m.nazwa_miasta + ']'
    FROM miasta AS m
    FOR XML PATH('')), 1, 1, '');

declare @dynamicSQL as nvarchar(max)

set @dynamicSQL = N'select *
 from
	 (select z.kraj, m.nazwa_miasta, count(*) starty
	 from zawodnicy z join uczestnictwa u on z.id_zawodnika = u.id_zawodnika
					  join zawody zw on zw.id_zawodow = u.id_zawodow
					  join skocznie s on s.id_skoczni = zw.id_skoczni
					  join miasta m on m.id_miasta = s.id_miasta
	group by  z.kraj, m.nazwa_miasta) q
pivot
(
	sum(starty)
	for nazwa_miasta in ('+@miasta+')
) pvt';

exec sp_executesql @dynamicSQL;


drop table osoby

create table osoby 
(
	id int primary key identity (1,1),
	imie varchar(255)
)


insert into osoby values ('jan')


select * from osoby


