<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="elements" dataSource="jdbc/N3CCohort">
	select name,count(*) from covid_pubchem.proteins_drugs_by_week group by 1 order by 2 desc;
</sql:query>

[
	<c:forEach items="${elements.rows}" var="row" varStatus="rowCounter">
	    {"element":"${row.name}","count":${row.count}}<c:if test="${!rowCounter.last}">,</c:if>
	</c:forEach>
  ]
