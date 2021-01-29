<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="drugs" dataSource="jdbc/N3CCohort">
	select jsonb_pretty(jsonb_agg(bar))
	from (select site as symbol,to_char(pub_date,'yyyy-WW') as week,count(*) from covid_biorxiv.biorxiv_current where pub_date > '2020-01-01' group by 1,2
		  union
		  select phrase||' ('||site||')' as symbol,to_char(pub_date,'yyyy-WW') as week,count(*) from covid_biorxiv.biorxiv_current natural join covid_biorxiv.pubchem_sentence_compound where phrase=? and pub_date > '2020-01-01' group by 1,2 order by 1,2) as bar
	;
	<sql:param>${param.compound}</sql:param>
</sql:query>
<c:forEach items="${drugs.rows}" var="row" varStatus="rowCounter">
	${row.jsonb_pretty}
</c:forEach>
			