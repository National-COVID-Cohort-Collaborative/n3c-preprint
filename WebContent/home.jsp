<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<div class="row">
	<div class="col-sm-4">
		<div class="panel panel-primary">
			<div class="panel-heading">Summary</div>
			<div class="panel-body">
				<div id="home_summary">
				<sql:query var="elements" dataSource="jdbc/N3CCohort">
					select description,to_char(last_update, 'YYYY-MM-DD HH:MIam') as last_update ,to_char(count, '999,999') as count from covid.stats where category='preprints' order by count desc;
				</sql:query>
				
				<c:forEach items="${elements.rows}" var="row" varStatus="rowCounter">
					<c:if test="${rowCounter.first}">
						<table  class="table">
						<tr><th>Preprint Server</th><th># COVID-19 Preprints</th></tr>
					</c:if>
					<tr><td>${row.description}</td><td>${row.count}</td></tr>
					<c:if test="${rowCounter.last}">
						</table>
						<p>Last Updated: ${row.last_update}</p>
					</c:if>
				</c:forEach>
				</div>
			</div>
		</div>
	</div>
	<div class="col-sm-4">
		<div class="panel panel-primary">
			<div class="panel-heading">Drugs by # Mentioning Preprints</div>
			<div class="panel-body">
				<div id="drugs_distinct"></div>
			</div>
		</div>
	</div>
	<div class="col-sm-4">
		<div class="panel panel-primary">
			<div class="panel-heading">Drugs by Total Mentions</div>
			<div class="panel-body">
				<div id="drugs_total"></div>
			</div>
		</div>
	</div>
</div>

<jsp:include page="graph_support/verticalBarChart.jsp">
	<jsp:param name="data_page" value="feeds/drugs_distinct_count.jsp" />
	<jsp:param name="dom_element" value="#drugs_distinct" />
</jsp:include>

<jsp:include page="graph_support/verticalBarChart.jsp">
	<jsp:param name="data_page" value="feeds/drugs_total_count.jsp" />
	<jsp:param name="dom_element" value="#drugs_total" />
</jsp:include>
