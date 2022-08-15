<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="drugs" dataSource="jdbc/N3CCohort">
	select month,coalesce(medrxiv,0) as medrxiv,coalesce(biorxiv,0) as biorxiv,coalesce(litcovid,0) as litcovid,coalesce(pmc,0) as pmc from covid_pubchem.compounds_source_by_month where compound = ?
	<sql:param>${param.compound}</sql:param>
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
