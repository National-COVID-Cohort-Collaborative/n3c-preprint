<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<style>
.block_header{
	text-align:center; 
	color:#fff; 
	background: #454F82;
	font-family: Arial, Helvetica, sans-serif;
	font-size:18px; 
	padding: 3px; 
	margin-top:20px;
}

.kpi tr {
	width: auto;
}

.block_header{
	background:none;
}

.kpi_ind{
	text-align:center;
}

.kpi_section .dropdown-item{
	white-space: unset;
}

#viz_title{
	display:none;
}

#${param.block}_btn_hide{
	position: absolute;
    left: 0px;
    top: 0px;
    transform: rotate(-90deg) translate(-20px, -77px);
    border-radius: 0;
}


#${param.block}_btn_show {
    /* position: absolute; */
    left: 0px;
    top: 0px;
    transform: rotate(-90deg) translate(-24px, 54px);
    border-radius: 0;
}

.drop_filter{
	right: 0;
	left: auto;
	width: max-content;
}

.dash_filter_header{
	margin-right: 30px;
    margin-left: 30px;
}

.show_clear{
	display: inline-block;
}

.no_clear{
	display:none;
}

.show_filt:after{
	border-top: 0.3em solid;
    border-right: 0.3em solid transparent;
    border-bottom: 0;
    border-left: 0.3em solid transparent;
}

.hide_filt:after{
	border-top: 0;
    border-right: 0.3em solid transparent;
    border-bottom: 0.3em solid;
    border-left: 0.3em solid transparent;
}

.viz_options_dropdown{
	text-align: left; 
	font-size: 1.2rem;
}
.filter_button_container{
	text-align:right;
}

@media (max-width: 768px) {
  .viz_options_dropdown, 
  .filter_button_container{
    text-align: center;
  }
}

.select2-container--default .select2-results__option--disabled{
	display:none;
}

.dash_viz{
	text-align:center;
}

</style>
<div class="row">
	<div class="col-sm-3">
		<div class="panel panel-primary">
			<div class="panel-heading">Summary</div>
			<div class="panel-body">
				<div id="home_summary">
				<sql:query var="elements" dataSource="jdbc/N3CCohort">
					select
						description,
						to_char(count,'FM999,999') as count,
						to_char(last_update, 'yyyy-mm-dd FMHH:MI PM') as last_update
					from covid.stats
					where category='publications' or category='preprints'
					order by source
				</sql:query>
				
				<c:forEach items="${elements.rows}" var="row" varStatus="rowCounter">
					<c:if test="${rowCounter.first}">
						<table  class="table">
						<tr><th>Source</th><th># COVID-19 Publications</th></tr>
					</c:if>
					<tr><td>${row.description}</td><td>${row.count}</td></tr>
					<c:if test="${rowCounter.last}">
						</table>
						<p>Last Updated: ${row.last_update}</p>
					</c:if>
				</c:forEach>
				</div>
			</div>
		</div>
	</div>
	<div class="col-sm-9">
		<div class="panel panel-primary">
			<div class="panel-heading">Publication Counts by Month</div>
			<jsp:include page="filters/source.jsp">
				<jsp:param value="home_table" name="block"/>
			</jsp:include>
			<div id="home_timeline">
			<script type="text/javascript">
				var categorical8 = ["#09405A", "#AD1181", "#8406D1", "#ffa600", "#ff7155", "#4833B2", "#007BFF", "#a6a6a6"];

				async function home_load() {
					const response = await fetch('feeds/total_source_by_month2.jsp');
					const data = await response.json();
					for (let i = 0; i < data.length; i++) {
						data[i].date = new Date(data[i].date+"-02")
					}
					home_table_timeline_refresh(data);
				}
				home_load();
				
				function home_table_timeline_refresh(data) {
					//console.log(data); 

					var properties = {
							block: "home_table",
							domName: "home_timeline",
							legend_labels: ['biorxiv', "medrxiv", "litcovid", "pmc"],
							aspectRatio: 2,
							xaxis_label: "Month",
							yaxis_label: "Publication Count"
						}

				   	d3.select("#home_timeline").select("svg").remove();
					TimeLineNColumnChart(data, properties);						
				}
			</script>
			</div>
			<div id="home_wrapper">
				<div id="table-div"></div>
			<jsp:include page="tables/timeline_table.jsp">
				<jsp:param name="feed" value="feeds/total_source_by_month.jsp" />
				<jsp:param name="block" value="home_table" />
				<jsp:param name="target_div" value="table-div" />
			</jsp:include>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-sm-6">
		<div class="panel panel-primary">
			<div class="panel-heading">NCATS Drugs of Interest by # Mentioning Publications</div>
			<div class="panel-body" style="height:613px; overflow-y:auto; ">
				<p>Click on a drug or its bar to display mentions. Scroll to see the full histogram.</p>
				<div id="ncats_drugs_distinct"></div>
			</div>
		</div>
	</div>
	<div class="col-sm-4">
		<div class="panel panel-primary">
			<div class="panel-heading">N3C Drugs by # Mentioning Preprints</div>
			<div class="panel-body">
				<p>Click on a drug or its bar to display mentions.</p>
				<div id="drugs_distinct"></div>
			</div>
		</div>
	</div>
	<div class="col-sm-6">
		<div class="panel panel-primary">
			<div class="panel-heading">PubChem Compounds by # Mentioning Preprints</div>
			<div class="panel-body" style="height:613px; overflow-y:auto; ">
				<p>Click on a compound or its bar to display mentions. Scroll to see the full histogram.</p>
				<div id="compounds_distinct"></div>
			</div>
		</div>
	</div>
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading">PubChem Genes by # Mentioning Preprints</div>
			<div class="panel-body"  style="height:613px; overflow-y:auto; ">
				<p>Click on a gene or its bar to display mentions. Scroll to see the full histogram.</p>
				<div id="genes_distinct"></div>
			</div>
		</div>
	</div>
	<div class="col-sm-9">
		<div class="panel panel-primary">
			<div class="panel-heading">PubChem Proteins by # Mentioning Preprints</div>
			<div class="panel-body">
				<p>Click on a protein or its bar to display mentions.</p>
				<div id="proteins_distinct"></div>
			</div>
		</div>
	</div>
	<div class="col-sm-3">
		<div class="panel panel-primary">
			<div class="panel-heading">PubChem Substances by # Mentioning Preprints</div>
			<div class="panel-body">
				<p>Click on a substance or its bar to display mentions.</p>
				<div id="substances_distinct"></div>
			</div>
		</div>
	</div>
</div>

<jsp:include page="graph_support/verticalBarChart.jsp">
	<jsp:param name="data_page" value="feeds/ncats_drugs_distinct_count.jsp" />
	<jsp:param name="dom_element" value="#ncats_drugs_distinct" />
	<jsp:param name="entity" value="ncats_drug" />
</jsp:include>

<jsp:include page="graph_support/verticalBarChart.jsp">
	<jsp:param name="data_page" value="feeds/n3c_drugs_distinct_count.jsp" />
	<jsp:param name="dom_element" value="#drugs_distinct" />
	<jsp:param name="entity" value="drug" />
</jsp:include>

<jsp:include page="graph_support/verticalBarChart.jsp">
	<jsp:param name="data_page" value="feeds/pubchem_compounds_distinct_count.jsp" />
	<jsp:param name="dom_element" value="#compounds_distinct" />
	<jsp:param name="entity" value="compound" />
</jsp:include>

<jsp:include page="graph_support/verticalBarChart.jsp">
	<jsp:param name="data_page" value="feeds/pubchem_genes_distinct_count.jsp" />
	<jsp:param name="dom_element" value="#genes_distinct" />
	<jsp:param name="entity" value="gene" />
</jsp:include>

<jsp:include page="graph_support/verticalBarChart.jsp">
	<jsp:param name="data_page" value="feeds/pubchem_proteins_distinct_count.jsp" />
	<jsp:param name="dom_element" value="#proteins_distinct" />
	<jsp:param name="entity" value="protein" />
</jsp:include>

<jsp:include page="graph_support/verticalBarChart.jsp">
	<jsp:param name="data_page" value="feeds/pubchem_substances_distinct_count.jsp" />
	<jsp:param name="dom_element" value="#substances_distinct" />
	<jsp:param name="entity" value="substance" />
</jsp:include>
