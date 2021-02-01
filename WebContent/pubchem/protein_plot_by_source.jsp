<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<div id="protein-line-wrapper">
</div>
<jsp:include page="../graph_support/multiline.jsp">
	<jsp:param name="data_page"	value="feeds/protein_by_source_count_weekly.jsp?protein=${param.protein}" />
	<jsp:param name="dom_element" value="#protein-line-wrapper" />
</jsp:include>
