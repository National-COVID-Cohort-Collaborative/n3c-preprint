<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="drugs" dataSource="jdbc/N3CCohort">
	select jsonb_pretty(jsonb_agg(done))
	from (
			(select symbol,week,coalesce(count,0) as count from (select 'medRxiv' as  symbol,* from covid_biorxiv.weeks_int) as foo
			natural left outer join
			(select site as symbol,to_char(pub_date,'WW')::int as week,count(*) from covid_biorxiv.biorxiv_current where pub_date >= '2020-01-01' and pub_date < '2021-01-01' group by 1,2) as bar)
		union
			(select symbol,week,coalesce(count,0) as count from (select 'bioRxiv' as  symbol,* from covid_biorxiv.weeks_int) as foo
			natural left outer join
			(select site as symbol,to_char(pub_date,'WW')::int as week,count(*) from covid_biorxiv.biorxiv_current where pub_date >= '2020-01-01' and pub_date < '2021-01-01' group by 1,2) as bar)
		order by 1,2
	) as done;
</sql:query>
<c:forEach items="${drugs.rows}" var="row" varStatus="rowCounter">
	${row.jsonb_pretty}
</c:forEach>
			