<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="drugs" dataSource="jdbc/N3CCohort">
	select jsonb_pretty(jsonb_agg(done))
	from (
		select symbol,week,coalesce(count, 0) as count from
			(select 'bioRxiv' as symbol,week from covid.weeks) as bar
			natural left outer join
			(select source as symbol,week,count(*) from covid_pubchem.proteins_drugs_by_week where name=? group by 1,2) as foo
		union
		select symbol,week,coalesce(count, 0) as count from
			(select 'medRxiv' as symbol,week from covid.weeks) as bar
			natural left outer join
			(select source as symbol,week,count(*) from covid_pubchem.proteins_drugs_by_week where name=? group by 1,2) as foo
		union
		select symbol,week,coalesce(count, 0) as count from
			(select 'litcovid' as symbol,week from covid.weeks) as bar
			natural left outer join
			(select source as symbol,week,count(*) from covid_pubchem.proteins_drugs_by_week where name=? group by 1,2) as foo
		union
		select symbol,week,coalesce(count, 0) as count from
			(select 'pmc' as symbol,week from covid.weeks) as bar
			natural left outer join
			(select source as symbol,week,count(*) from covid_pubchem.proteins_drugs_by_week where name=? group by 1,2) as foo
		order by 1,2
	) as done;
	<sql:param>${param.protein}</sql:param>
	<sql:param>${param.protein}</sql:param>
	<sql:param>${param.protein}</sql:param>
	<sql:param>${param.protein}</sql:param>
</sql:query>
<c:forEach items="${drugs.rows}" var="row" varStatus="rowCounter">
	${row.jsonb_pretty}
</c:forEach>
			