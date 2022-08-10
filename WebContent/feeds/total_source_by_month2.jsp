<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="drugs" dataSource="jdbc/N3CCohort">
	select * from covid.total_source_by_month
</sql:query>
[
<c:forEach items="${drugs.rows}" var="row" varStatus="rowCounter">
	{
		"date": "${row.month}",
		"elements": {
			"biorxiv": ${row.biorxiv},
			"medrxiv": ${row.medrxiv},
			"litcovid": ${row.litcovid},
			"pmc": ${row.pmc}
		}
	}<c:if test="${!rowCounter.last}">,</c:if>
</c:forEach>
]			