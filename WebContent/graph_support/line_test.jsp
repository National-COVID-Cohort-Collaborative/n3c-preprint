<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<!-- jQuery library -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<!-- Latest compiled JavaScript -->
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<link
	href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf8"
	src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.js"></script>
<script src="../resources/dataTables.rowsGroup.js"></script>

<script src="https://d3js.org/d3.v4.min.js"></script>

<style> /* set the CSS */

.axis { font: 14px sans-serif; }

.line {
  fill: none;
  stroke: #376076;
  stroke-width: 2px;
}

</style>
</head>
<body>
	<div class="container-fluid center-box">
		<div class="row">
			<div class="col-sm-12">
				<div class="panel panel-primary">
					<div class="panel-heading">Line Chart Testing</div>
					<div class="panel-body">
						<div id="line-wrapper"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
<jsp:include page="line.jsp">
	<jsp:param name="data_page" value="../feeds/total_count_weekly.jsp" />
	<jsp:param name="dom_element" value="#line-wrapper" />
</jsp:include>
	
</body>
</html>
