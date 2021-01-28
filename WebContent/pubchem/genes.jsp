<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<script type="text/javascript">
	function gene_render(mode) {
		var footer = document.getElementById("gene-panel-footer");
		footer.innerHTML = "<a href=\"feeds/gene.jsp?gene="+mode+"\">Export this list as JSON</a>";
		d3.html("tables/gene.jsp?gene="+mode, function(fragment) {
			var divContainer = document.getElementById("gene_target_table");
			divContainer.innerHTML = "";
			divContainer.append(fragment);
		});
		d3.select("#gene_mode").property("value", mode);
		$('.nav-tabs a[href="#genes"]').tab('show');
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
	<sql:query var="genes" dataSource="jdbc/N3CCohort">
		select phrase as gene,count(*) from covid_biorxiv.pubchem_sentence_gene group by 1 order by 2 desc;
	</sql:query>
	<label for="table">Choose a gene:</label> <select name="mode" id="gene_mode" onchange="gene_render(mode.value)">
	<c:forEach items="${genes.rows}" var="row" varStatus="rowCounter">
		<option value="${row.gene}"	<c:if test="${rowCounter.first}">selected<c:set var="target" value="${row.gene}"/></c:if>>${row.gene}</option>
	</c:forEach>
	</select>
</form>

<div class="row">
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading">Gene Mentions</div>
			<div class="panel-body">
				<div id="gene_target_table">
					<jsp:include page="../tables/gene.jsp" flush="true">
						<jsp:param value="${target}" name="drug" />
					</jsp:include>
				</div>

				<div id="gene_table" style="overflow: scroll;">&nbsp;</div>
				<div id="op_table" style="overflow: scroll;">&nbsp;</div>
			</div>
			<div class="panel-footer" id="gene-panel-footer"><a href="feeds/gene.jsp?gene=${target}">Export this list as JSON</a></div>
		</div>
	</div>
</div>

