<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="drugs" dataSource="jdbc/N3CCohort">
	select jsonb_pretty(jsonb_agg(done order by month))
	from (
			select month,medrxiv,biorxiv,litcovid,pmc from covid_pubchem.substances_source_by_month where substance = ?
	) as done;
	<sql:param>${param.substance}</sql:param>
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
