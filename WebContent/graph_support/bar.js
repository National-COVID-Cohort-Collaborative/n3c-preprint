
d3.csv("bar-data.csv", function(data) {
	var maxWidth = 280; // width of the bar with the max value

	data.forEach(function(d) {
		d.date = d3.isoParse(d.date);
		d.value = +d.value;
	});

	var myObserver = new ResizeObserver(entries => {
		entries.forEach(entry => {
			var newWidth = Math.floor(entry.contentRect.width);
			// console.log('body width '+newWidth);
			if (newWidth > 0) {
				d3.select("#bar-wrapper").select("svg").remove();
				maxWidth = newWidth;
				draw();
			}
		});
	});
	myObserver.observe(d3.select("#bar-wrapper").node());

	draw();

	function draw() {
	var margin = { top: 20, right: 20, bottom: 70, left: 40 },
		width = maxWidth - margin.left - margin.right,
		height = 400 - margin.top - margin.bottom;


	var x = d3.scaleBand().rangeRound([0, width], .05).padding(0.1);

	var y = d3.scaleLinear().range([height, 0]);

	var xAxis = d3.axisBottom()
		.scale(x)
		.tickFormat(d3.timeFormat("%b"));

	var yAxis = d3.axisLeft()
		.scale(y)
		.ticks(10);

	var svg = d3.select("#bar-wrapper").append("svg")
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
	//       .attr("dx", "-.8em")
	//       .attr("dy", "-.55em")
	//       .attr("transform", "rotate(-90)" )
		;
		
	svg.append("g")
		.attr("class", "y axis")
		.call(yAxis.ticks(null).tickSize(0))
		.append("text")
		//       .attr("transform", "rotate(-90)")
		.attr("y", 6)
		//       .attr("dy", ".71em")
		.style("text-anchor", "middle")
		.text("Value");

	svg.selectAll("bar")
		.data(data)
		.enter().append("rect")
		.style("fill", function(d) { return d.value < d.target ? '#EF5F67': '#3FC974'})
		.attr("x", function(d) { return x(d.date); })
		.attr("width", x.bandwidth())
		.attr("y", function(d) { return y(d.value); })
		.attr("height", function(d) { return height - y(d.value); });
	svg.selectAll("lines")
		.data(data)
		.enter().append("line")
		.style("fill", 'none')
		.attr("x1", function(d) { return x(d.date) + x.bandwidth() + 5; })
		.attr("x2", function(d) { return x(d.date)-5; })
		.attr("y1", function(d) { return y(d.target); })
		.attr("y2", function(d) { return y(d.target); })
		.style("stroke-dasharray", [2,2])
		.style("stroke", "#000000")
		.style("stroke-width", 2);
}
});

