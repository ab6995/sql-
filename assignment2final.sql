use sql5;
SELECT * FROM sql5.ge;
SELECT * FROM sql5.gspc;
create index gedt on sql5.GE(DATE);
create table gereturns select c.date , c.adjclose/ p.adjclose-1 rtn from sql5.ge c join sql5.ge p on p.date = (select max(date) from sql5.ge where date (c.date));
create table gspcreturns select c.date , c.adjclose/ p.adjclose-1 rtn from sql5.gspc c join sql5.gspc p on p.date = (select max(date) from sql5.gspc where date (c.date));
create table ols select sql5.ge.date , sql5.gspc.rtn x, sql5.ge.rtn y from gspcreturns gspc join gereturns ge on ge.date = gspc.date;
desc ols;

select count(*) , min(date), max(date) from ols;
select avg(y) - (avg(x*y)-avg(x)*avg(y))/(avg(x*x)-avg(x)*avg(x))*avg(x) from ols;
select (avg(x*y)-avg(x)*avg(y))/(avg(x*x)-avg(x)*avg(x)) from ols;



#equation
select "GE = 0.008728773735265528 - 0.22969350148512777*GSPC" equation;

select month(date),(avg(x*y)-avg(x)*avg(y))/(avg(x*x)-avg(x)*avg(x)) slope from ols group by month(date);
select month(date),avg(y) - (avg(x*y)-avg(x)*avg(y))/(avg(x*x)-avg(x)*avg(x))*avg(x) intercept from ols group by month(date);



#r^2
select @ax := avg(x), @ay := avg(y) , @div := ( stddev_samp(x)*stddev_samp(y))  from ols;

select @r :=sum((x - @ax)*(y - @ay))/ ((count(x)-1)*@div) from ols ;
select power(@r ,2) ;



#skew 
SELECT sum(POWER((x - (SELECT AVG(x) FROM ols))/ (SELECT stddev(x) FROM ols) , 3)) / count(x) skewness FROM ols;
SELECT sum(POWER((y - (SELECT AVG(y) FROM ols))/ (SELECT stddev(y) FROM ols) , 3)) / count(y) skewness FROM ols;

#kurtosis
SELECT sum(POWER((x - (SELECT AVG(x) FROM ols))/ (SELECT stddev(x) FROM ols) , 4)) / count(x) kurtosis FROM ols;
SELECT sum(POWER((y - (SELECT AVG(y) FROM ols))/ (SELECT stddev(y) FROM ols) , 4)) / count(y) skewness FROM ols;

#p_value


