<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<script type="text/javascript">
	function drug_render(mode) {
		var footer = document.getElementById("drug-panel-footer");
		footer.innerHTML = "<a href=\"feeds/drug.jsp?drug="+mode+"\">Export this list as JSON</a>";
		d3.html("tables/drug.jsp?drug="+mode, function(fragment) {
			var divContainer = document.getElementById("drug_target_table");
			divContainer.innerHTML = "";
			divContainer.append(fragment);
		});
		d3.select("#drug_mode").property("value", mode);
		$('.nav-tabs a[href="#drugs"]').tab('show');
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
	<sql:query var="drugs" dataSource="jdbc/N3CCohort">
		select original as drug,count(*) from covid_biorxiv.cohort_match group by 1 order by 2 desc;
	</sql:query>
	<label for="table">Choose a  Drug:</label> <select name="mode" id="drug_mode" onchange="drug_render(mode.value)">
	<c:forEach items="${drugs.rows}" var="row" varStatus="rowCounter">
		<option value="${row.drug}"	<c:if test="${rowCounter.first}">selected<c:set var="target" value="${row.drug}"/></c:if>>${row.drug}</option>
	</c:forEach>
	</select>
</form>

<div class="row">
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading">Drug Mentions</div>
			<div class="panel-body">
				<div id="drug_target_table">
					<jsp:include page="../tables/drug.jsp" flush="true">
						<jsp:param value="${target}" name="drug" />
					</jsp:include>
				</div>

				<div id="drug_table" style="overflow: scroll;">&nbsp;</div>
				<div id="op_table" style="overflow: scroll;">&nbsp;</div>
			</div>
			<div class="panel-footer" id="drug-panel-footer"><a href="feeds/drug.jsp?drug=${target}">Export this list as JSON</a></div>
		</div>
	</div>
</div>

