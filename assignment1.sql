SELECT * FROM sql1.lab1;

use sql1;
desc intx;
create table monthenddates select year(date) yr, month(date) mon, min(date) start, max(date) end from intx group by year(date), month(date);
desc monthenddates;
create table monthlyreturns select mr.yr, mr.mon, pr.date start, cu.date end, pr.open p_op, pr.adjclose p_ac, pr.volume p_vo, cu.open c_op,
cu.adjclose c_ac, cu.volume c_vo, cu.adjclose/pr.open -1 RTN from intx pr JOIN monthenddates mr on mr.start = pr.date JOIN intx cu ON cu.date = mr.end;
desc monthlyreturns;
select * from monthlyreturns;
select yr,mon, std(RTN), AVG(RTN)  from monthlyreturns  where start >= '2007/01/01 00:00:00' and start <='2014/12/31 00:00:00 '  group by yr ,mon;
select yr,mon,start, std(RTN), AVG(RTN)  from monthlyreturns  where start >= '2007/01/01 00:00:00' and start <='2014/12/31 00:00:00 '  group by yr ,mon,start;