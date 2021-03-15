<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<div id="drug-line-wrapper">
</div>
<jsp:include page="../graph_support/multiline.jsp">
	<jsp:param name="data_page"	value="feeds/drug_by_source_count_weekly.jsp?drug=${param.drug}" />
	<jsp:param name="dom_element" value="#drug-line-wrapper" />
</jsp:include>
