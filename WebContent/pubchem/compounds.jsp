<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<script type="text/javascript">
	function compound_render(mode) {
		var summary = document.getElementById("compound-summary-heading");
		summary.innerHTML = mode + " Summary";
		var graph = document.getElementById("compound-graph-heading");
		graph.innerHTML = mode + " Preprint Counts by Week";
		var mention = document.getElementById("compound-mention-heading");
		mention.innerHTML = mode + " Mentions";
		var footer = document.getElementById("compound-panel-footer");
		footer.innerHTML = "<a href=\"feeds/compound.jsp?compound=" + mode
				+ "\">Export this list as JSON</a>";
		d3.html("pubchem/compound_count_by_source.jsp?compound=" + mode,
				function(fragment) {
					var divContainer = document.getElementById("compound-summary-panel");
					divContainer.innerHTML = "";
					divContainer.append(fragment);
				});
		d3.html("pubchem/compound_plot_by_source.jsp?compound=" + mode,
				function(fragment) {
					var divContainer = document.getElementById("compound-panel-body");
					divContainer.innerHTML = "";
					divContainer.append(fragment);
				});
		d3.html("tables/compound.jsp?compound=" + mode,
				function(fragment) {
					var divContainer = document.getElementById("compound_target_table");
					divContainer.innerHTML = "";
					divContainer.append(fragment);
				});
		d3.select("#compound_mode").property("value", mode);
		$('.nav-tabs a[href="#compounds"]').tab('show');
	}
	function removeAllChildNodes(parent) {
	    while (parent.firstChild) {
	        parent.removeChild(parent.firstChild);
	    }
	}
</script>

<form action="index.jsp">
	<sql:query var="compounds" dataSource="jdbc/N3CCohort">
		select phrase as compound,count(*) from covid_biorxiv.pubchem_sentence_compound group by 1 order by 2 desc;
	</sql:query>
	<label for="table">Choose a Compound:</label>
	<select name="mode" id="compound_mode" onchange="compound_render(mode.value)">
		<c:forEach items="${compounds.rows}" var="row" varStatus="rowCounter">
			<option value="${row.compound}" <c:if test="${rowCounter.first}">selected<c:set var="target" value="${row.compound}"/></c:if>>${row.compound}</option>
		</c:forEach>
	</select>
</form>

<div class="row">
	<div class="col-sm-3">
		<div class="panel panel-primary">
			<div class="panel-heading" id="compound-summary-heading">Summary</div>
			<div class="panel-body">
				<div id="compound-summary-panel">
					<jsp:include page="compound_count_by_source.jsp?compound=hydroxychloroquine" />
				</div>
			</div>
		</div>
	</div>
	<div class="col-sm-9">
		<div class="panel panel-primary">
			<div class="panel-heading" id="compound-graph-heading">Preprint
				Counts by Week</div>
			<div class="panel-body" id="compound-panel-body">
				<div id="compound-line-wrapper"></div>
				<jsp:include page="../graph_support/multiline.jsp">
					<jsp:param name="data_page"	value="feeds/compound_by_source_count_weekly.jsp?compound=${target}" />
					<jsp:param name="dom_element" value="#compound-line-wrapper" />
				</jsp:include>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading" id="compound-mention-heading">Compound
				Mentions</div>
			<div class="panel-body">
				<div id="compound_target_table">
					<jsp:include page="../tables/compound.jsp" flush="true">
						<jsp:param value="${target}" name="compound" />
					</jsp:include>
				</div>

				<div id="compound_table" style="overflow: scroll;">&nbsp;</div>
				<div id="op_table" style="overflow: scroll;">&nbsp;</div>
			</div>
			<div class="panel-footer" id="compound-panel-footer">
				<a href="feeds/compound.jsp?compound=${target}">Export this list as JSON</a>
			</div>
		</div>
	</div>
</div>


