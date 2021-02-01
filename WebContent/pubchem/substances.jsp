<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<script type="text/javascript">
	function substance_render(mode) {
		var summary = document.getElementById("substance-summary-heading");
		summary.innerHTML = mode + " Summary";
		var graph = document.getElementById("substance-graph-heading");
		graph.innerHTML = mode + " Preprint Counts by Week";
		var mention = document.getElementById("substance-mention-heading");
		mention.innerHTML = mode + " Mentions";
		var footer = document.getElementById("substance-panel-footer");
		footer.innerHTML = "<a href=\"feeds/substance.jsp?substance="+mode+"\">Export this list as JSON</a>";
		d3.html("pubchem/substance_count_by_source.jsp?substance="+mode, function(fragment) {
			var divContainer = document.getElementById("substance-summary-panel");
			divContainer.innerHTML = "";
			divContainer.append(fragment);
		});
		d3.html("pubchem/substance_plot_by_source.jsp?substance=" + mode,
				function(fragment) {
					var divContainer = document.getElementById("substance-panel-body");
					divContainer.innerHTML = "";
					divContainer.append(fragment);
				});
		d3.html("tables/substance.jsp?substance="+mode, function(fragment) {
			var divContainer = document.getElementById("substance_target_table");
			divContainer.innerHTML = "";
			divContainer.append(fragment);
		});
		d3.select("#substance_mode").property("value", mode);
		$('.nav-tabs a[href="#substances"]').tab('show');
	}

</script>

<form action="index.jsp">
	<sql:query var="substances" dataSource="jdbc/N3CCohort">
		select phrase as substance,count(*) from covid_biorxiv.pubchem_sentence_substance group by 1 order by 2 desc;
	</sql:query>
	<label for="table">Choose a substance:</label> <select name="mode" id="substance_mode" onchange="substance_render(mode.value)">
	<c:forEach items="${substances.rows}" var="row" varStatus="rowCounter">
		<option value="${row.substance}"	<c:if test="${rowCounter.first}">selected<c:set var="target" value="${row.substance}"/></c:if>>${row.substance}</option>
	</c:forEach>
	</select>
</form>

<div class="row">
	<div class="col-sm-3">
		<div class="panel panel-primary">
			<div class="panel-heading" id="substance-summary-heading">Summary</div>
			<div class="panel-body">
				<div id="substance-summary-panel">
					<jsp:include page="substance_count_by_source.jsp?substance=hydroxychloroquine"/>
				</div>
			</div>
		</div>
	</div>
	<div class="col-sm-9">
		<div class="panel panel-primary">
			<div class="panel-heading" id="substance-graph-heading">Preprint Counts by Week</div>
			<div class="panel-body"  id="substance-panel-body">
				<div id="substance-line-wrapper"></div>
				<jsp:include page="../graph_support/multiline.jsp">
					<jsp:param name="data_page"	value="feeds/substance_by_source_count_weekly.jsp?substance=${target}" />
					<jsp:param name="dom_element" value="#substance-line-wrapper" />
				</jsp:include>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading" id="substance-mention-heading">Substance Mentions</div>
			<div class="panel-body">
				<div id="substance_target_table">
					<jsp:include page="../tables/substance.jsp" flush="true">
						<jsp:param value="${target}" name="substance" />
					</jsp:include>
				</div>

				<div id="substance_table" style="overflow: scroll;">&nbsp;</div>
				<div id="op_table" style="overflow: scroll;">&nbsp;</div>
			</div>
			<div class="panel-footer" id="substance-panel-footer"><a href="feeds/substance.jsp?substance=${target}">Export this list as JSON</a></div>
		</div>
	</div>
</div>

<jsp:include page="../graph_support/multiline.jsp">
	<jsp:param name="data_page" value="feeds/total_by_source_count_weekly.jsp" />
	<jsp:param name="dom_element" value="#substance-line-wrapper" />
</jsp:include>

