<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="drugs" dataSource="jdbc/N3CCohort">
	select jsonb_pretty(jsonb_agg(bar))
	from (select to_char(pub_date,'yyyy-WW') as week,count(*) from covid_biorxiv.biorxiv_current where pub_date > '2020-01-01' group by 1 order by 1) as bar
	;
</sql:query>
<c:forEach items="${drugs.rows}" var="row" varStatus="rowCounter">
	${row.jsonb_pretty}
</c:forEach>
			