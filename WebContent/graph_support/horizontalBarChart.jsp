<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<script>
//accessor functions
var barLabel = function(d) { return d.element; };
var barValue = function(d) { return parseFloat(d.count); };

d3.json("${param.data_page}", function(data) {
	var valueLabelWidth = 50; // space reserved for value labels (right)
	var barHeight = 20; // height of one bar
	var barLabelWidth = 10; // space reserved for bar labels
	var barLabelPadding = 5; // padding between bar and bar labels (left)
	var gridLabelHeight = 18; // space reserved for gridline labels
	var gridChartOffset = 3; // space between start of grid and first bar
	var maxBarWidth = 280; // width of the bar with the max value

	data.forEach(function(node) {
		barLabelWidth = Math.max(barLabelWidth,node.element.length * 8);
	    //console.log(node.element + "  " + node.element.length*7. );
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
var x = d3.scaleBand().rangeRound([0, width], .05).padding(0.1);

var y = d3.scaleLinear().range([height, 0]);

var xAxis = d3.axisBottom()
    .scale(x)
    .tickFormat(d3.timeFormat("%b"));

var yAxis = d3.axisLeft()
    .scale(y)
    .ticks(10);
var svg = d3.select("body").append("svg")
.attr("width", width + margin.left + margin.right)
.attr("height", height + margin.top + margin.bottom)
.append("g")
.attr("transform",
      "translate(" + margin.left + "," + margin.top + ")");
x.domain(data.map(function(d) { return d.date; }));
y.domain([0, d3.max(data, function(d) { return d.value; })]);

svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis.ticks(null).tickSize(0))
  .selectAll("text")
    .style("text-anchor", "middle")
//     .attr("dx", "-.8em")
//     .attr("dy", "-.55em")
//     .attr("transform", "rotate(-90)" );

svg.append("g")
    .attr("class", "y axis")
    .call(yAxis.ticks(null).tickSize(0))
  .append("text")
//     .attr("transform", "rotate(-90)")
    .attr("y", 6)
//     .attr("dy", ".71em")
    .style("text-anchor", "middle")
    .text("Value");

svg.selectAll("bar")
    .data(data)
  .enter().append("rect")
    .style("fill", function(d){ return d.value < d.target ? '#EF5F67': '#3FC974'})
    .attr("x", function(d) { return x(d.date); })
    .attr("width", x.bandwidth())
    .attr("y", function(d) { return y(d.value); })
    .attr("height", function(d) { return height - y(d.value); });
svg.selectAll("lines")
    .data(data)
  .enter().append("line")
    .style("fill", 'none')
		.attr("x1", function(d) { return x(d.date) + x.bandwidth()+5; })
    .attr("x2", function(d) { return x(d.date)-5; })
 .attr("y1", function(d) { return y(d.target); })
    .attr("y2", function(d) { return y(d.target); })
		.style("stroke-dasharray", [2,2])
		.style("stroke", "#000000")
.style("stroke-width", 2)

		// svg container element
		var chart = d3.select("${param.dom_element}").append("svg")
			.attr('width', maxBarWidth + barLabelWidth + barLabelPadding + valueLabelWidth)
			.attr('height', gridLabelHeight + gridChartOffset + data.length * barHeight);
		// grid line labels
		var gridContainer = chart.append('g')
			.attr('transform', 'translate(' + barLabelWidth + ',' + gridLabelHeight + ')');
		gridContainer.selectAll("text").data(x.ticks(10)).enter().append("text")
			.attr("x", x)
			.attr("dy", -3)
			.attr("text-anchor", "middle")
			.text(String);
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
			.on("click", function(d) { drug_render(d.element); })
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
			.on("click", function(d) { drug_render(d.element); })
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
