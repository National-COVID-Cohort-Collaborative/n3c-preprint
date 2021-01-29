<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="elements" dataSource="jdbc/N3CCohort">
	select site,count(*) from covid_biorxiv.pubchem_sentence_substance natural join covid_biorxiv.biorxiv_current where phrase = ? group by 1 order by 1;
	<sql:param>${param.substance}</sql:param>
</sql:query>

<c:forEach items="${elements.rows}" var="row" varStatus="rowCounter">
	<c:if test="${rowCounter.first}">
		<table class="table">
			<tr>
				<th>Preprint Server</th>
				<th># ${param.substance} Mentions</th>
			</tr>
			</c:if>
			<tr>
				<td>${row.site}</td>
				<td>${row.count}</td>
			</tr>
			<c:if test="${rowCounter.last}">
		</table>
	</c:if>
</c:forEach>
