<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<div id="gene-line-wrapper">
</div>
<jsp:include page="../graph_support/multiline.jsp">
	<jsp:param name="data_page"	value="feeds/pubchem_gene_by_source_count_weekly.jsp?gene=${param.gene}" />
	<jsp:param name="dom_element" value="#gene-line-wrapper" />
</jsp:include>
