<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<div id="compound-line-wrapper">
</div>
<jsp:include page="../graph_support/multiline.jsp">
	<jsp:param name="data_page"	value="feeds/compound_by_source_count_weekly.jsp?compound=${param.compound}" />
	<jsp:param name="dom_element" value="#compound-line-wrapper" />
</jsp:include>
