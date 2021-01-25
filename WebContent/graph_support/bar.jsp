<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<script>

d3.json("${param.data_page}", function(data) {
	var maxWidth = 280; // width of the bar with the max value

	// parse the date / time
	var parseTime = d3.timeParse("%Y-%W");

	data.forEach(function(d) {
		d.date = parseTime(d.week);
		d.count = +d.count;
	});

	var myObserver = new ResizeObserver(entries => {
		entries.forEach(entry => {
			var newWidth = Math.floor(entry.contentRect.width);
			// console.log('body width '+newWidth);
			if (newWidth > 0) {
				d3.select("${param.dom_element}").select("svg").remove();
				maxWidth = newWidth;
				draw();
			}
		});
	});
	myObserver.observe(d3.select("${param.dom_element}").node());

	draw();

	function draw() {
		var margin = { top: 20, right: 20, bottom: 70, left: 40 },
			width = maxWidth - margin.left - margin.right,
			height = 400 - margin.top - margin.bottom;


		var x = d3.scaleBand().rangeRound([0, width], .05).padding(0.1);

		var y = d3.scaleLinear().range([height, 0]);


		var yAxis = d3.axisLeft()
			.scale(y)
			.ticks(10);

		var svg = d3.select("${param.dom_element}").append("svg")
			.attr("width", width + margin.left + margin.right)
			.attr("height", height + margin.top + margin.bottom)
			.append("g")
			.attr("transform",
				"translate(" + margin.left + "," + margin.top + ")");

		x.domain(data.map(function(d) { return d.week; }));
		y.domain([0, d3.max(data, function(d) { return d.count; })]);

		// Add the X Axis
		svg.append("g")
			.attr("class", "x axis")
			.attr("transform", "translate(0," + height + ")")
			.call(d3.axisBottom(x))
			.selectAll("text")
			.style("text-anchor", "end")
			.attr("dx", "-.8em")
			.attr("dy", ".15em")
			.attr("transform", "rotate(-65)");

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
			.style("fill", '#376076')
			.attr("x", function(d) { return x(d.week); })
			.attr("width", x.bandwidth())
			.attr("y", function(d) { return y(d.count); })
			.attr("height", function(d) { return height - y(d.count); });
	}
});
</script>

