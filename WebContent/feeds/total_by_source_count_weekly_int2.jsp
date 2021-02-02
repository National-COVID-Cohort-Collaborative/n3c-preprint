<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="counts" dataSource="jdbc/N3CCohort">
	select jsonb_pretty(jsonb_agg(done))
	from (
			(select week as week,coalesce(count,0) as count from (select week from covid_biorxiv.weeks_int) as foo
			natural left outer join
			(select to_char(pub_date,'WW')::int as week,count(*) from covid_biorxiv.biorxiv_current where site = ? and pub_date >= '2020-01-01' and pub_date < '2021-01-01' group by 1) as bar)
		order by 1
	) as done;
	<sql:param>${param.site}</sql:param>
</sql:query>
<c:forEach items="${counts.rows}" var="row" varStatus="rowCounter">
	${row.jsonb_pretty}
</c:forEach>
			