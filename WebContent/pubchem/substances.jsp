<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<script type="text/javascript">
	function substance_render(mode) {
		var footer = document.getElementById("substance-panel-footer");
		footer.innerHTML = "<a href=\"feeds/substance.jsp?substance="+mode+"\">Export this list as JSON</a>";
		d3.html("tables/substance.jsp?substance="+mode, function(fragment) {
			var divContainer = document.getElementById("substance_target_table");
			divContainer.innerHTML = "";
			divContainer.append(fragment);
		});
		d3.select("#substance_mode").property("value", mode);
		$('.nav-tabs a[href="#substances"]').tab('show');
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
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading">Substance Mentions</div>
			<div class="panel-body">
				<div id="substance_target_table">
					<jsp:include page="../tables/substance.jsp" flush="true">
						<jsp:param value="${target}" name="drug" />
					</jsp:include>
				</div>

				<div id="substance_table" style="overflow: scroll;">&nbsp;</div>
				<div id="op_table" style="overflow: scroll;">&nbsp;</div>
			</div>
			<div class="panel-footer" id="substance-panel-footer"><a href="feeds/substance.jsp?substance=${target}">Export this list as JSON</a></div>
		</div>
	</div>
</div>

