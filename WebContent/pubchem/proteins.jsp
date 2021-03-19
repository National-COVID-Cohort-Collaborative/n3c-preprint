<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<script type="text/javascript">
	function protein_render(mode) {
		var summary = document.getElementById("protein-summary-heading");
		summary.innerHTML = mode + " Summary";
		var graph = document.getElementById("protein-graph-heading");
		graph.innerHTML = mode + " Preprint Counts by Week";
		var mention = document.getElementById("protein-mention-heading");
		mention.innerHTML = mode + " Mentions";
		var footer = document.getElementById("protein-panel-footer");
		footer.innerHTML = "<a href=\"feeds/pubchem_protein.jsp?protein="+mode+"\">Export this list as JSON</a>";
		d3.html("pubchem/protein_count_by_source.jsp?protein="+mode, function(fragment) {
			var divContainer = document.getElementById("protein-summary-panel");
			divContainer.innerHTML = "";
			divContainer.append(fragment);
		});
		d3.html("pubchem/protein_plot_by_source.jsp?protein=" + mode,
				function(fragment) {
					var divContainer = document.getElementById("protein-panel-body");
					divContainer.innerHTML = "";
					divContainer.append(fragment);
				});
		d3.html("tables/pubchem_protein.jsp?protein="+mode, function(fragment) {
			var divContainer = document.getElementById("protein_target_table");
			divContainer.innerHTML = "";
			divContainer.append(fragment);
		});
		d3.select("#protein_mode").property("value", mode);
		$('.nav-tabs a[href="#proteins"]').tab('show');
	}

</script>

<form action="index.jsp">
	<sql:query var="proteins" dataSource="jdbc/N3CCohort">
		select phrase as protein,count(*) from covid_biorxiv.pubchem_sentence_protein group by 1 order by 2 desc;
	</sql:query>
	<label for="table">Choose a protein:</label> <select name="mode" id="protein_mode" onchange="protein_render(mode.value)">
	<c:forEach items="${proteins.rows}" var="row" varStatus="rowCounter">
		<option value="${row.protein}"	<c:if test="${rowCounter.first}">selected<c:set var="target" value="${row.protein}"/></c:if>>${row.protein}</option>
	</c:forEach>
	</select>
</form>

<div class="row">
	<div class="col-sm-3">
		<div class="panel panel-primary">
			<div class="panel-heading" id="protein-summary-heading">Summary</div>
			<div class="panel-body">
				<div id="protein-summary-panel">
					<jsp:include page="protein_count_by_source.jsp?protein=nsp3"/>
				</div>
			</div>
		</div>
	</div>
	<div class="col-sm-9">
		<div class="panel panel-primary">
			<div class="panel-heading" id="protein-graph-heading">Preprint Counts by Week</div>
			<div class="panel-body"  id="protein-panel-body">
				<div id="protein-line-wrapper"></div>
				<jsp:include page="../graph_support/multiline.jsp">
					<jsp:param name="data_page"	value="feeds/pubchem_protein_by_source_count_weekly.jsp?protein=${target}" />
					<jsp:param name="dom_element" value="#protein-line-wrapper" />
				</jsp:include>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading" id="protein-mention-heading">Protein Mentions</div>
			<div class="panel-body">
				<div id="protein_target_table">
					<jsp:include page="../tables/pubchem_protein.jsp" flush="true">
						<jsp:param value="${target}" name="protein" />
					</jsp:include>
				</div>

				<div id="protein_table" style="overflow: scroll;">&nbsp;</div>
				<div id="op_table" style="overflow: scroll;">&nbsp;</div>
			</div>
			<div class="panel-footer" id="protein-panel-footer"><a href="feeds/pubchem_protein.jsp?protein=${target}">Export this list as JSON</a></div>
		</div>
	</div>
</div>

<jsp:include page="../graph_support/multiline.jsp">
	<jsp:param name="data_page" value="feeds/total_by_source_count_weekly.jsp" />
	<jsp:param name="dom_element" value="#protein-line-wrapper" />
</jsp:include>

