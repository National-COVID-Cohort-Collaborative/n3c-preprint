<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<style type="text/css">
.axis path,.axis line {
	fill: none;
	stroke: black;
	shape-rendering: crispEdges;
}

.axis text {
	font-family: sans-serif;
	font-size: 11px;
}
</style>

<script type="text/javascript">

d3.json("${param.data_page}", function(error, dataset) {
			//Width and height
			var w = 400;
			var h = 400;
			var padding = 70;

			//Create scale functions
			var xScale = d3.scale.linear()
								 .domain([0, d3.max(dataset, function(d) { return Math.max(d[0], d[1]); })])
								 .range([padding, w - padding]);

			var yScale = d3.scale.linear()
								 .domain([0, d3.max(dataset, function(d) { return Math.max(d[0], d[1]); })])
								 .range([h - padding, padding]);

			var rScale = d3.scale.linear()
								 .domain([0, d3.max(dataset, function(d) { return d[1]; })])
								 .range([2, 3]);

			//Define X axis
			var xAxis = d3.svg.axis()
							  .scale(xScale)
							  .orient("bottom")
							  .ticks(5);

			//Define Y axis
			var yAxis = d3.svg.axis()
							  .scale(yScale)
							  .orient("left")
							  .ticks(5);
			
			//Create SVG element
			var svg = d3.select("${param.dom_element}")
						.append("svg")
						.attr("width", w+padding)
						.attr("height", h);
			
			// plot x=y
			
			svg.append("line").attr('x1',0+padding).attr('y1',h-padding).attr('x2',w-padding).attr('y2',0+padding).attr("stroke-width", 1).attr("stroke", '#376076').attr("fill", "black");

			//Create circles
			svg.selectAll("circle")
			   .data(dataset)
			   .enter()
			   .append("circle")
			   .attr("cx", function(d) {
			   		return xScale(d[0]);
			   })
			   .attr("cy", function(d) {
			   		return yScale(d[1]);
			   })
			   .attr("r", function(d) {
			   		return rScale(d[1]);
			   });

			//Create labels
			svg.selectAll("text")
			   .data(dataset)
			   .enter()
			   .append("text")
			   .text(function(d) {
			   		return d[2];
			   })
			   .attr("x", function(d) {
			   		return xScale(d[0])*1.05;
			   })
			   .attr("y", function(d) {
			   		return yScale(d[1]);
			   })
			   .attr("font-family", "sans-serif")
			   .attr("font-size", "11px")
			   .attr("fill", "#376076");
			
			//Create X axis
			svg.append("g")
				.attr("class", "axis")
				.attr("transform", "translate(0," + (h - padding) + ")")
				.call(xAxis);
			
			svg.append("text")
		        .attr("transform", "translate(" + (w / 2) + " ," + (h - padding/2) + ")")
		        .style("text-anchor", "middle")
		        .text("${param.xLabel}");
			 
			//Create Y axis
			svg.append("g")
				.attr("class", "axis")
				.attr("transform", "translate(" + padding + ",0)")
				.call(yAxis);

			svg.append("text")
	        .attr("transform", "rotate(-90)")
	        .attr("y", 0)
	        .attr("x",0 - (h / 2))
	        .attr("dy", "1em")
	        .style("text-anchor", "middle")
	        .text("${param.yLabel}");

			<c:if test="${not empty param.click_action}">
			var rect = svg.append("rect").attr({
				"class" : "overlay",
				"width" : w,
				"height" : h
			}).attr('fill-opacity', 0.0)
			.on({
				"click" : function() {
					window.open("${param.click_action}"
							+ xScale.invert(d3.mouse(this)[0])
							+ "${param.click_continuation}"
							+ yScale.invert(d3.mouse(this)[1]),
							"_self");
				}
			});
		</c:if>
});
			</script>
			<c:if test="${not empty param.click_action}">
				<ol class="bulletedList">
					<li>Click on a point in the graph to constrain the scale to those values.
					<li>Clicking outside of one axis resets the constraint on that axis.
					<li>Clicking outside both axes resets the display to defaults (all data shown).
				</ol>
			</c:if>