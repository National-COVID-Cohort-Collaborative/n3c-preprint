<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="drugs" dataSource="jdbc/N3CCohort">
	select jsonb_pretty(jsonb_agg(done order by month))
	from (
			select month,medrxiv,biorxiv,litcovid,pmc from covid_n3c.source_by_month where medication = ?
	) as done;
	<sql:param>${param.drug}</sql:param>
</sql:query>
{
    "headers": [
        {"value":"month", "label":"Month"},
        {"value":"medrxiv", "label":"medRxiv"},
        {"value":"biorxiv", "label":"bioRxiv"},
        {"value":"litcovid", "label":"LitCovid"},
        {"value":"pmc", "label":"PMC"}
    ],
    "rows" : 
<c:forEach items="${drugs.rows}" var="row" varStatus="rowCounter">
	${row.jsonb_pretty}
</c:forEach>
}
