<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="elements" dataSource="jdbc/N3CCohort">
	select
		sum(coalesce(biorxiv,0)) as biorxiv,
		sum(coalesce(medrxiv,0)) as medrxiv,
		sum(coalesce(litcovid,0)) as litcovid,
		sum(coalesce(pmc,0)) as pmc
	from covid_pubchem.proteins_source_by_month where protein = ?;
	<sql:param>${param.protein}</sql:param>
</sql:query>

<c:forEach items="${elements.rows}" var="row" varStatus="rowCounter">
		<table class="table">
			<tr>
				<th>Source</th>
				<th># ${param.drug} Mentions</th>
			</tr>
			<tr>
				<td>bioRxiv</td>
				<td>${row.biorxiv}</td>
			</tr>
			<tr>
				<td>MedRxiv</td>
				<td>${row.medrxiv}</td>
			</tr>
			<tr>
				<td>LitCovid</td>
				<td>${row.litcovid}</td>
			</tr>
			<tr>
				<td>PMC</td>
				<td>${row.pmc}</td>
			</tr>
		</table>
</c:forEach>
