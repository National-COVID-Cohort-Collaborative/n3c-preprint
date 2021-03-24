<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="elements" dataSource="jdbc/N3CCohort">
	select source,count(*) from (select distinct source,doi,pmcid,pmid from covid_pubchem.sentence_gene where name=?) as foo group by 1 order by 1;
	<sql:param>${param.gene}</sql:param>
</sql:query>

<c:forEach items="${elements.rows}" var="row" varStatus="rowCounter">
	<c:if test="${rowCounter.first}">
		<table class="table">
			<tr>
				<th>Preprint Server</th>
				<th># ${param.drug} Mentions</th>
			</tr>
			</c:if>
			<tr>
				<td>${row.source}</td>
				<td>${row.count}</td>
			</tr>
			<c:if test="${rowCounter.last}">
		</table>
	</c:if>
</c:forEach>
