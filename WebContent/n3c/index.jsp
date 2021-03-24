<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<script type="text/javascript">
	function drug_render(mode) {
		var summary = document.getElementById("drug-summary-heading");
		summary.innerHTML = mode + " Summary";
		var graph = document.getElementById("drug-graph-heading");
		graph.innerHTML = mode + " Preprint Counts by Week";
		var mention = document.getElementById("drug-mention-heading");
		mention.innerHTML = mode + " Mentions";
		var footer = document.getElementById("drug-panel-footer");
		footer.innerHTML = "<a href=\"feeds/n3c_drug.jsp?drug="+mode+"\">Export this list as JSON</a>";
		d3.html("n3c/drug_count_by_source.jsp?drug="+mode, function(fragment) {
			var divContainer = document.getElementById("drug-summary-panel");
			divContainer.innerHTML = "";
			divContainer.append(fragment);
		});
		d3.html("n3c/drug_plot_by_source.jsp?drug=" + mode,
				function(fragment) {
					var divContainer = document.getElementById("drug-panel-body");
					divContainer.innerHTML = "";
					divContainer.append(fragment);
				});
		d3.html("tables/n3c_drug.jsp?drug="+mode, function(fragment) {
			var divContainer = document.getElementById("drug_target_table");
			divContainer.innerHTML = "";
			divContainer.append(fragment);
		});
		d3.select("#drug_mode").property("value", mode);
		$('.nav-tabs a[href="#drugs"]').tab('show');
	}

</script>

<form action="index.jsp">
	<sql:query var="drugs" dataSource="jdbc/N3CCohort">
		select medication as drug, count(*) from covid_n3c.drugs_by_week group by 1 order by 2 desc;
	</sql:query>
	<label for="table">Choose a  Drug:</label> <select name="mode" id="drug_mode" onchange="drug_render(mode.value)">
	<c:forEach items="${drugs.rows}" var="row" varStatus="rowCounter">
		<option value="${row.drug}"	<c:if test="${rowCounter.first}">selected<c:set var="target" value="${row.drug}"/></c:if>>${row.drug}</option>
	</c:forEach>
	</select>
</form>

<div class="row">
	<div class="col-sm-3">
		<div class="panel panel-primary">
			<div class="panel-heading" id="drug-summary-heading">Summary</div>
			<div class="panel-body">
				<div id="drug-summary-panel">
					<jsp:include page="drug_count_by_source.jsp?drug=Remdesivir"/>
				</div>
			</div>
		</div>
	</div>
	<div class="col-sm-9">
		<div class="panel panel-primary">
			<div class="panel-heading" id="drug-graph-heading">Preprint Counts by Week</div>
			<div class="panel-body" id="drug-panel-body">
				<div id="drug-line-wrapper"></div>
				<jsp:include page="../graph_support/multiline.jsp">
					<jsp:param name="data_page"	value="feeds/n3c_drug_by_source_count_weekly.jsp?drug=${target}" />
					<jsp:param name="dom_element" value="#drug-line-wrapper" />
				</jsp:include>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading" id="drug-mention-heading">Drug Mentions</div>
			<div class="panel-body">
				<div id="drug_target_table">
					<jsp:include page="../tables/n3c_drug.jsp" flush="true">
						<jsp:param value="${target}" name="drug" />
					</jsp:include>
				</div>

				<div id="drug_table" style="overflow: scroll;">&nbsp;</div>
				<div id="op_table" style="overflow: scroll;">&nbsp;</div>
			</div>
			<div class="panel-footer" id="drug-panel-footer"><a href="feeds/n3c_drug.jsp?drug=${target}">Export this list as JSON</a></div>
		</div>
	</div>
</div>
