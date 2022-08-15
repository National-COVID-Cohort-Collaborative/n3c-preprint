<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<script type="text/javascript">
	function drug_render(mode) {
		var summary = document.getElementById("drug-summary-heading");
		summary.innerHTML = mode + " Summary";
		var graph = document.getElementById("n3c-drug-graph-heading");
		graph.innerHTML = mode + " Preprint Counts by Month";
		var mention = document.getElementById("drug-mention-heading");
		mention.innerHTML = mode + " Mentions";
		var footer = document.getElementById("drug-panel-footer");
		footer.innerHTML = "<a href=\"feeds/n3c_drug.jsp?drug="+mode+"\">Export this list as JSON</a>";
		d3.html("n3c/drug_count_by_source.jsp?drug="+mode, function(fragment) {
			var divContainer = document.getElementById("drug-summary-panel");
			divContainer.innerHTML = "";
			divContainer.append(fragment);
		});

		n3c_table_load(mode);
		n3c_table_reload(mode);
		
		d3.html("tables/n3c_drug.jsp?drug="+mode, function(fragment) {
			var divContainer = document.getElementById("drug_target_table");
			divContainer.innerHTML = "";
			divContainer.append(fragment);
		});
		d3.select("#drug_mode").property("value", mode);
		$('.nav-tabs a[href="#drugs"]').tab('show');
	}

	async function n3c_table_reload(drug) {
		const response = await fetch('feeds/n3c_drug_by_source_count_monthly.jsp?drug=' + drug);
		var newDataArray = await response.json();
		console.log("new data", newDataArray)
		var datatable = $("#n3c-div-table").DataTable();
		datatable.clear();
		datatable.rows.add(newDataArray.rows);
		datatable.draw();
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
			<div class="panel-heading" id="n3c-drug-graph-heading">Publication Counts by Month</div>
			<jsp:include page="../filters/source.jsp">
				<jsp:param value="n3c_table" name="block"/>
			</jsp:include>
			<div id="n3c_timeline">
			<script type="text/javascript">
				var categorical8 = ["#09405A", "#AD1181", "#8406D1", "#ffa600", "#ff7155", "#4833B2", "#007BFF", "#a6a6a6"];

				async function n3c_table_load(drug) {console.log("n3c call", drug)
					const response = await fetch('feeds/n3c_drug_by_source_count_monthly2.jsp?drug='+drug);
					const data = await response.json();
					for (let i = 0; i < data.length; i++) {
						data[i].date = new Date(data[i].date+"-02")
					}
					n3c_table_timeline_refresh(data);
				}
				n3c_table_load("${target}");
				
				function n3c_table_timeline_refresh(data) {
					//console.log(data); 

					var properties = {
							block: "n3c_table",
							domName: "n3c_timeline",
							legend_labels: ['biorxiv', "medrxiv", "litcovid", "pmc"],
							aspectRatio: 2,
							xaxis_label: "Month",
							yaxis_label: "Publication Count",
							constraintPropagator: n3c_table_constraint
						}

				   	d3.select("#n3c_timeline").select("svg").remove();
					TimeLineNColumnChart(data, properties);						
				}
			</script>
			</div>
			<div id="n3c_wrapper">
				<div id="n3c-div"></div>
				<jsp:include page="../tables/timeline_table.jsp">
					<jsp:param name="feed" value="feeds/n3c_drug_by_source_count_monthly.jsp?drug=${target}" />
					<jsp:param name="block" value="n3c_table" />
					<jsp:param name="target_div" value="n3c-div" />
					<jsp:param name="text_table" value="drug_table_inner" />
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
