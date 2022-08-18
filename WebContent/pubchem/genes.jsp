<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<script type="text/javascript">
	function gene_render(mode) {
		var summary = document.getElementById("gene-summary-heading");
		summary.innerHTML = mode + " Summary";
		var graph = document.getElementById("pubchem_gene-graph-heading");
		graph.innerHTML = mode + " Preprint Counts by Month";
		var mention = document.getElementById("gene-mention-heading");
		mention.innerHTML = mode + " Mentions";
		var footer = document.getElementById("gene-panel-footer");
		footer.innerHTML = "<a href=\"feeds/pubchem_gene.jsp?gene=" + mode
				+ "\">Export this list as JSON</a>";
		d3.html("pubchem/gene_count_by_source.jsp?gene=" + mode,
				function(fragment) {
					var divContainer = document.getElementById("gene-summary-panel");
					divContainer.innerHTML = "";
					divContainer.append(fragment);
				});

		pubchem_gene_table_load(mode);
		pubchem_gene_table_reload(mode);
		
		d3.html("tables/pubchem_gene.jsp?gene=" + mode,
				function(fragment) {
					var divContainer = document.getElementById("gene_target_table");
					divContainer.innerHTML = "";
					divContainer.append(fragment);
				});
		d3.select("#gene_mode").property("value", mode);
		$('.nav-tabs a[href="#genes"]').tab('show');
	}
	function removeAllChildNodes(parent) {
	    while (parent.firstChild) {
	        parent.removeChild(parent.firstChild);
	    }
	}

	async function pubchem_gene_table_reload(gene) {
		const response = await fetch('feeds/pubchem_gene_by_source_count_monthly.jsp?gene=' + gene);
		var newDataArray = await response.json();
		console.log("new data", newDataArray)
		var datatable = $("#pubchem-gene-div-table").DataTable();
		datatable.clear();
		datatable.rows.add(newDataArray.rows);
		datatable.draw();
	}
</script>

<form action="index.jsp">
	<sql:query var="genes" dataSource="jdbc/N3CCohort">
		select name as gene,count(*) from covid_pubchem.genes_drugs_by_week group by 1 order by 2 desc;
	</sql:query>
	<label for="table">Choose a Compound:</label>
	<select name="mode" id="gene_mode" onchange="gene_render(mode.value)">
		<c:forEach items="${genes.rows}" var="row" varStatus="rowCounter">
			<option value="${row.gene}" <c:if test="${rowCounter.first}">selected<c:set var="target" value="${row.gene}"/></c:if>>${row.gene}</option>
		</c:forEach>
	</select>
</form>

<div class="row">
	<div class="col-sm-3">
		<div class="panel panel-primary">
			<div class="panel-heading" id="gene-summary-heading">Summary</div>
			<div class="panel-body">
				<div id="gene-summary-panel">
					<jsp:include page="gene_count_by_source.jsp">
						<jsp:param value="hydroxychloroquine" name="gene"/>
					</jsp:include>
				</div>
			</div>
		</div>
	</div>
	<div class="col-sm-9">
		<div class="panel panel-primary">
			<div class="panel-heading" id="pubchem_gene-graph-heading">Publication Counts by Month</div>
			<jsp:include page="../filters/source.jsp">
				<jsp:param value="pubchem_gene_table" name="block"/>
			</jsp:include>
			<div id="pubchem_gene_timeline">
			<script type="text/javascript">
				var categorical8 = ["#09405A", "#AD1181", "#8406D1", "#ffa600", "#ff7155", "#4833B2", "#007BFF", "#a6a6a6"];

				async function pubchem_gene_table_load(gene) {
					const response = await fetch('feeds/pubchem_gene_by_source_count_monthly2.jsp?gene='+gene);
					const data = await response.json();
					for (let i = 0; i < data.length; i++) {
						data[i].date = new Date(data[i].date+"-02")
					}
					pubchem_gene_table_timeline_refresh(data);
				}
				pubchem_gene_table_load("${target}");
				
				function pubchem_gene_table_timeline_refresh(data) {
					//console.log(data); 

					var properties = {
							block: "pubchem_gene_table",
							domName: "pubchem_gene_timeline",
							legend_labels: ['biorxiv', "medrxiv", "litcovid", "pmc"],
							aspectRatio: 2,
							xaxis_label: "Month",
							yaxis_label: "Publication Count",
							constraintPropagator: pubchem_gene_table_constraint
						}

				   	d3.select("#pubchem_gene_timeline").select("svg").remove();
					TimeLineNColumnChart(data, properties);						
				}
			</script>
				<div id="pubchem_gene_timeline_save_viz"> 
					<button id='svgButton' class="btn btn-light btn-sm" onclick="saveVisualization('pubchem_gene_timeline', 'pubchem_gene_timeline.svg');">Save as SVG</button>
					<button id='pngButton' class="btn btn-light btn-sm" onclick="saveVisualization('pubchem_gene_timeline', 'pubchem_gene_timeline.pmg');">Save as PNG</button>
					<button id='jpegButton' class="btn btn-light btn-sm" onclick="saveVisualization('pubchem_gene_timeline', 'pubchem_gene_timeline.jpg');">Save as JPEG</button>
				</div>
			</div>
			<div id="pubchem_gene_wrapper">
				<div id="pubchem_gene-div"></div>
				<jsp:include page="../tables/timeline_table.jsp">
					<jsp:param name="feed" value="feeds/pubchem_gene_by_source_count_monthly.jsp?gene=${target}" />
					<jsp:param name="block" value="pubchem_gene_table" />
					<jsp:param name="target_div" value="pubchem_gene-div" />
					<jsp:param name="text_table" value="gene_table_inner" />
				</jsp:include>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading" id="gene-mention-heading">Compound
				Mentions</div>
			<div class="panel-body">
				<div id="gene_target_table">
					<jsp:include page="../tables/pubchem_gene.jsp" flush="true">
						<jsp:param value="${target}" name="gene" />
					</jsp:include>
				</div>

				<div id="gene_table" style="overflow: scroll;">&nbsp;</div>
				<div id="op_table" style="overflow: scroll;">&nbsp;</div>
			</div>
			<div class="panel-footer" id="gene-panel-footer">
				<a href="feeds/pubchem_gene.jsp?gene=${target}">Export this list as JSON</a>
			</div>
		</div>
	</div>
</div>


