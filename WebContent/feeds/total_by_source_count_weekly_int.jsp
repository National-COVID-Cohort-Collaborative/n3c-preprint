<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="drugs" dataSource="jdbc/N3CCohort">
	select jsonb_pretty(jsonb_agg(done))
	from (
			select week as group,coalesce(medrxiv,0) as right,coalesce(biorxiv,0) as left from (select week from covid_biorxiv.weeks_int) as foo
			natural left outer join
			(select to_char(pub_date,'WW')::int as week,count(*) as medrxiv from covid_biorxiv.biorxiv_current where site='medRxiv' and pub_date >= '2020-01-01' and pub_date < '2021-01-01' group by 1) as bar
			natural left outer join
			(select to_char(pub_date,'WW')::int as week,count(*) as biorxiv from covid_biorxiv.biorxiv_current where site='bioRxiv' and pub_date >= '2020-01-01' and pub_date < '2021-01-01' group by 1) as barn
		order by 1,2
	) as done;
</sql:query>
<c:forEach items="${drugs.rows}" var="row" varStatus="rowCounter">
	${row.jsonb_pretty}
</c:forEach>
			