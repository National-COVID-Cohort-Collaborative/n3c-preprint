<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<div id="substance-line-wrapper">
</div>
<jsp:include page="../graph_support/multiline.jsp">
	<jsp:param name="data_page"	value="feeds/substance_by_source_count_weekly.jsp?substance=${param.substance}" />
	<jsp:param name="dom_element" value="#substance-line-wrapper" />
</jsp:include>
