<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<script type="text/javascript">
	function protein_render(mode) {
		var footer = document.getElementById("protein-panel-footer");
		footer.innerHTML = "<a href=\"feeds/protein.jsp?protein="+mode+"\">Export this list as JSON</a>";
		d3.html("tables/protein.jsp?protein="+mode, function(fragment) {
			var divContainer = document.getElementById("protein_target_table");
			divContainer.innerHTML = "";
			divContainer.append(fragment);
		});
		d3.select("#protein_mode").property("value", mode);
		$('.nav-tabs a[href="#proteins"]').tab('show');
	}

	function intervention_display(mode) {
		var divContainer = document.getElementById("intervention_trials_header");
		divContainer.innerHTML = mode+" Trials";
		d3.html("tables/trials_by_intervention.jsp?mode="+mode, function(fragment) {
			var divContainer = document.getElementById("intervention_trials");
			divContainer.innerHTML = "<div id='intervention_detail_table'></div>";
			divContainer.append(fragment);
		});
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
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading">Protein Mentions</div>
			<div class="panel-body">
				<div id="protein_target_table">
					<jsp:include page="../tables/protein.jsp" flush="true">
						<jsp:param value="${target}" name="drug" />
					</jsp:include>
				</div>

				<div id="protein_table" style="overflow: scroll;">&nbsp;</div>
				<div id="op_table" style="overflow: scroll;">&nbsp;</div>
			</div>
			<div class="panel-footer" id="protein-panel-footer"><a href="feeds/protein.jsp?protein=${target}">Export this list as JSON</a></div>
		</div>
	</div>
</div>

