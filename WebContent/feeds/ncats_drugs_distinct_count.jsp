<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="elements" dataSource="jdbc/N3CCohort">
	select medication as drug,count(distinct doi||' '||pmcid||' '||pmid) from covid.sentence group by 1 order by 2 desc;
</sql:query>

[
	<c:forEach items="${elements.rows}" var="row" varStatus="rowCounter">
	    {"element":"${row.drug}","count":${row.count}}<c:if test="${!rowCounter.last}">,</c:if>
	</c:forEach>
  ]
