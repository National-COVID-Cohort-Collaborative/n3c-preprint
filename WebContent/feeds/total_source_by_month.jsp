<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="drugs" dataSource="jdbc/N3CCohort">
	select jsonb_pretty(jsonb_agg(done order by month))
	from (
			select * from covid.total_source_by_month
	) as done;
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