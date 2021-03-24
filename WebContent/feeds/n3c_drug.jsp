<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="drugs" dataSource="jdbc/N3CCohort">
	select jsonb_pretty(jsonb_agg(bar))
	from (select source, title, url, substring(section from 1 for 20) as section, sentence
		  from covid_n3c.sentence
		  where original = ?
		  order by 1,4) as bar
	;
	<sql:param>${param.drug}</sql:param>
</sql:query>
{
    "headers": [
        {"value":"title", "label":"Title"},
        {"value":"section", "label":"Section"},
        {"value":"sentence", "label":"Sentence"},
        {"value":"source", "label":"Source"}
    ],
    "rows" : 
<c:forEach items="${drugs.rows}" var="row" varStatus="rowCounter">
	${row.jsonb_pretty}
</c:forEach>
}

			