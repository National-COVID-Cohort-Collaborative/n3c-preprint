<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<script>

d3.json("${param.data_page}", function(data) {
	//accessor functions
	var barLabel = function(d) { return d.week; };
	var barValue = function(d) { return d.count; };

	var valueLabelWidth = 50; // space reserved for value labels (right)
	var barHeight = 20; // height of one bar
	var barLabelWidth = 10; // space reserved for bar labels
	var barLabelPadding = 5; // padding between bar and bar labels (left)
	var gridLabelHeight = 30; // space reserved for gridline labels
	var gridChartOffset = 3; // space between start of grid and first bar
	var maxBarWidth = 280; // width of the bar with the max value

	data.forEach(function(node) {
		barLabelWidth = Math.max(barLabelWidth,node.week.length * 8);
	    //console.log(node.week + "  " + node.week.length*7. );
	});
	
	var myObserver = new ResizeObserver(entries => {
		entries.forEach(entry => {
			var newWidth = Math.floor(entry.contentRect.width);
			if (newWidth > 0) {
				d3.select("${param.dom_element}").select("svg").remove();
				//console.log('${param.dom_element} width '+newWidth);
				maxBarWidth = newWidth - barLabelWidth - barLabelPadding - valueLabelWidth;
				draw();
			}
		});
	});
	myObserver.observe(d3.select("${param.dom_element}").node());

	draw();

	function draw() {

		// scales
		var yScale = d3.scaleBand().domain(d3.range(0, data.length)).range([0, data.length * barHeight]);
		var y = function(d, i) { return yScale(i); };
		var yText = function(d, i) { return y(d, i) + yScale.bandwidth() / 2; };
		var x = d3.scaleLinear().domain([0, d3.max(data, barValue)]).range([0, maxBarWidth]);

		// svg container element
		var chart = d3.select("${param.dom_element}").append("svg")
			.attr('width', maxBarWidth + barLabelWidth + barLabelPadding + valueLabelWidth)
			.attr('height', gridLabelHeight + gridChartOffset + data.length * barHeight);
		// grid line labels
		var gridContainer = chart.append('g')
			.attr('transform', 'translate(' + barLabelWidth + ',' + gridLabelHeight + ')');
		// vertical grid lines
		gridContainer.selectAll("line").data(x.ticks(10)).enter().append("line")
			.attr("x1", x)
			.attr("x2", x)
			.attr("y1", 0)
			.attr("y2", yScale.range()[1] + gridChartOffset)
			.style("stroke", "#ccc");
		// bar labels
		var labelsContainer = chart.append('g')
			.attr('transform', 'translate(' + (barLabelWidth - barLabelPadding) + ',' + (gridLabelHeight + gridChartOffset) + ')');
		labelsContainer.selectAll('text').data(data).enter().append('text')
			.on("click", function(d) { ${param.entity}_render(d.week); })
			.attr('y', yText)
			.attr('stroke', 'none')
			.attr('fill', 'black')
			.attr("dy", ".35em") // vertical-align: middle
			.attr('text-anchor', 'end')
			.text(barLabel);
		// bars
		var barsContainer = chart.append('g')
			.attr('transform', 'translate(' + barLabelWidth + ',' + (gridLabelHeight + gridChartOffset) + ')');
		barsContainer.selectAll("rect").data(data).enter().append("rect")
			.on("click", function(d) { ${param.entity}_render(d.week); })
			.attr('y', y)
			.attr('height', yScale.bandwidth())
			.attr('width', function(d) { return x(barValue(d)); })
			.attr('stroke', 'white')
			.attr('fill', '#376076');
		// bar value labels
		barsContainer.selectAll("text").data(data).enter().append("text")
			.attr("x", function(d) { return x(barValue(d)); })
			.attr("y", yText)
			.attr("dx", 3) // padding-left
			.attr("dy", ".35em") // vertical-align: middle
			.attr("text-anchor", "start") // text-align: right
			.attr("fill", "black")
			.attr("stroke", "none")
			.text(function(d) { return barValue(d); });
		// start line
		barsContainer.append("line")
			.attr("y1", -gridChartOffset)
			.attr("y2", yScale.range()[1] + gridChartOffset)
			.style("stroke", "#000");
	}
});
</script>
