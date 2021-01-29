d3.json("${param.data_page}", function(data) {
	var maxWidth = 280; // width of the bar with the max value

	// parse the date / time
	var parseTime = d3.timeParse("%Y-%W");

	// format the data
	data.forEach(function(d) {
		d.week = parseDate(d.week);
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
		//Set the dimensions of the canvas / graph
		var margin = { top: 30, right: 20, bottom: 70, left: 50 },
			width = Math.floor(entry.contentRect.width),
			height = 300 - margin.top - margin.bottom;

		// Set the ranges
		var x = d3.scaleTime().range([0, width]);
		var y = d3.scaleLinear().range([height, 0]);

		// Define the line
		var countline = d3.line()
			.x(function(d) { return x(d.week); })
			.y(function(d) { return y(d.count); });

		// Adds the svg canvas
		var svg = d3.select("${param.dom_element}")
			.append("svg")
			.attr("width", width + margin.left + margin.right)
			.attr("height", height + margin.top + margin.bottom)
			.append("g")
			.attr("transform",
				"translate(" + margin.left + "," + margin.top + ")");

		// Scale the range of the data
		x.domain(d3.extent(data, function(d) { return d.week; }));
		y.domain([0, d3.max(data, function(d) { return d.count; })]);

		// Nest the entries by symbol
		var dataNest = d3.nest()
			.key(function(d) { return d.symbol; })
			.entries(data);

		// set the colour scale
		var color = d3.scaleOrdinal(d3.schemeCategory10);

		legendSpace = width / dataNest.length; // spacing for the legend

		// Loop through each symbol / key
		dataNest.forEach(function(d, i) {

			svg.append("path")
				.attr("class", "line")
				.style("stroke", function() { // Add the colours dynamically
					return d.color = color(d.key);
				})
				.attr("d", countline(d.values));

			// Add the Legend
			svg.append("text")
				.attr("x", (legendSpace / 2) + i * legendSpace)  // space legend
				.attr("y", height + (margin.bottom / 2) + 5)
				.attr("class", "legend")    // style the legend
				.style("fill", function() { // Add the colours dynamically
					return d.color = color(d.key);
				})
				.text(d.key);

		});

		// Add the X Axis
		svg.append("g")
			.attr("class", "axis")
			.attr("transform", "translate(0," + height + ")")
			.call(d3.axisBottom(x));

		// Add the Y Axis
		svg.append("g")
			.attr("class", "axis")
			.call(d3.axisLeft(y));
	}
});

