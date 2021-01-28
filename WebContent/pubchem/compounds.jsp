<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<script type="text/javascript">
	function compound_render(mode) {
		var footer = document.getElementById("compound-panel-footer");
		footer.innerHTML = "<a href=\"feeds/compound.jsp?compound="+mode+"\">Export this list as JSON</a>";
		d3.html("tables/compound.jsp?compound="+mode, function(fragment) {
			var divContainer = document.getElementById("compound_target_table");
			divContainer.innerHTML = "";
			divContainer.append(fragment);
		});
		d3.select("#compound_mode").property("value", mode);
		$('.nav-tabs a[href="#compounds"]').tab('show');
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
	<sql:query var="compounds" dataSource="jdbc/N3CCohort">
		select phrase as compound,count(*) from covid_biorxiv.pubchem_sentence_compound group by 1 order by 2 desc;
	</sql:query>
	<label for="table">Choose a Compound:</label> <select name="mode" id="compound_mode" onchange="compound_render(mode.value)">
	<c:forEach items="${compounds.rows}" var="row" varStatus="rowCounter">
		<option value="${row.compound}"	<c:if test="${rowCounter.first}">selected<c:set var="target" value="${row.compound}"/></c:if>>${row.compound}</option>
	</c:forEach>
	</select>
</form>

<div class="row">
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading">Compound Mentions</div>
			<div class="panel-body">
				<div id="compound_target_table">
					<jsp:include page="../tables/compound.jsp" flush="true">
						<jsp:param value="${target}" name="drug" />
					</jsp:include>
				</div>

				<div id="compound_table" style="overflow: scroll;">&nbsp;</div>
				<div id="op_table" style="overflow: scroll;">&nbsp;</div>
			</div>
			<div class="panel-footer" id="compound-panel-footer"><a href="feeds/compound.jsp?compound=${target}">Export this list as JSON</a></div>
		</div>
	</div>
</div>

