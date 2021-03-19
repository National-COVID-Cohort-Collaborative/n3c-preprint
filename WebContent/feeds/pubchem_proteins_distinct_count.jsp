<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="elements" dataSource="jdbc/N3CCohort">
	select phrase,count(distinct doi) from covid_biorxiv.pubchem_sentence_protein group by 1 order by 2 desc;
</sql:query>

[
	<c:forEach items="${elements.rows}" var="row" varStatus="rowCounter">
	    {"element":"${row.phrase}","count":${row.count}}<c:if test="${!rowCounter.last}">,</c:if>
	</c:forEach>
  ]
