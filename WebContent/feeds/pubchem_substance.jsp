<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="substances" dataSource="jdbc/N3CCohort">
	select jsonb_pretty(jsonb_agg(bar))
	from (select
			foo.doi,
			coalesce(title.title,foo.title) as title,
			section,
			regexp_replace(sentence, '(^|[^a-zA-Z])('||replace(replace(replace(replace(? , '(', '\('), ')', '\)'), ']', '\]'), '[', '\[')||')', '\1<b>\2</b>', 'i') as sentence
		  from (select doi,title,name as section,full_text as sentence from covid_biorxiv.document natural join covid_biorxiv.section natural join covid_biorxiv.sentence natural join covid_biorxiv.pubchem_sentence_substance where phrase = ?) as foo
		  left outer join
		  covid_crossref.title
		  on  foo.doi=title.doi
		  order by 1,3) as bar
	;
	<sql:param>${param.substance}</sql:param>
	<sql:param>${param.substance}</sql:param>
</sql:query>
{
    "headers": [
        {"value":"title", "label":"Title"},
        {"value":"section", "label":"Section"},
        {"value":"sentence", "label":"Sentence"}
    ],
    "rows" : 
<c:forEach items="${substances.rows}" var="row" varStatus="rowCounter">
	${row.jsonb_pretty}
</c:forEach>
}

			