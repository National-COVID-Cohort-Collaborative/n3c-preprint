<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="drugs" dataSource="jdbc/N3CCohort">
	select jsonb_pretty(jsonb_agg(done))
	from (
			select  symbol,week,coalesce(count,0) as count from
			(select * from (select ?||' ('||symbol||')' as symbol,week from (select 'bioRxiv' as  symbol,* from covid_biorxiv.weeks) as foo) as foo2
			left outer join
			(select phrase||' ('||site||')' as symbol,to_char(pub_date,'yyyy-WW') as week,count(distinct doi)
			 from covid_biorxiv.biorxiv_current natural join covid_biorxiv.pubchem_sentence_protein
			 where phrase=? and pub_date > '2020-01-01' group by 1,2) as  bar
			 using(symbol,week)) as bar2
		union
			select  symbol,week,coalesce(count,0) as count from
			(select * from (select ?||' ('||symbol||')' as symbol,week from (select 'medRxiv' as  symbol,* from covid_biorxiv.weeks) as foo) as foo2
			left outer join
			(select phrase||' ('||site||')' as symbol,to_char(pub_date,'yyyy-WW') as week,count(distinct doi)
			 from covid_biorxiv.biorxiv_current natural join covid_biorxiv.pubchem_sentence_protein
			 where phrase=? and pub_date > '2020-01-01' group by 1,2) as  bar
			 using(symbol,week)) as bar2
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
			