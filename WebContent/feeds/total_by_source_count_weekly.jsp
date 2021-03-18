<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="drugs" dataSource="jdbc/N3CCohort">
	select jsonb_pretty(jsonb_agg(done))
	from (
			(select symbol,week,coalesce(count,0) as count from (select 'medRxiv' as  symbol,* from covid_biorxiv.weeks) as foo
			natural left outer join
			(select site as symbol,to_char(pub_date,'yyyy-WW') as week,count(*) from covid_biorxiv.biorxiv_current where pub_date >= '2020-01-01' group by 1,2) as bar)
		union
			(select symbol,week,coalesce(count,0) as count from (select 'bioRxiv' as  symbol,* from covid_biorxiv.weeks) as foo
			natural left outer join
			(select site as symbol,to_char(pub_date,'yyyy-WW') as week,count(*) from covid_biorxiv.biorxiv_current where pub_date >= '2020-01-01' group by 1,2) as bar)
		union
			(select symbol,week,coalesce(count,0) as count from (select 'litcovid' as  symbol,* from covid_biorxiv.weeks) as foo
			natural left outer join
			(select 'litcovid' as symbol,to_char((pub_date_year||'-'||pub_date_month||'-'||coalesce(pub_date_day,'01'))::date,'yyyy-WW') as week,count(*) from covid_litcovid.article where pub_date_month is not null group by 1,2 order by 1,2) as bar)
		union
			(select symbol,week,coalesce(count,0) as count from (select 'pmc' as  symbol,* from covid_biorxiv.weeks) as foo
			natural left outer join
			(select 'pmc' as symbol,to_char((pub_date_year||'-'||pub_date_month||'-'||coalesce(pub_date_day,'01'))::date,'yyyy-WW') as week,count(*) from covid_litcovid.article natural join covid_pmc.link natural join covid_pmc.xml where pub_date_month is not null group by 1,2 order by 1,2) as bar)
		order by 1,2
	) as done;
</sql:query>
<c:forEach items="${drugs.rows}" var="row" varStatus="rowCounter">
	${row.jsonb_pretty}
</c:forEach>
			