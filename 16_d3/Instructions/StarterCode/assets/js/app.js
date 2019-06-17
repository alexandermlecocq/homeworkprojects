var xAxisType = 'poverty';
var yAxisType = 'healthcare'

var svgWidth = 960;
var svgHeight = 500;

var margin = {
  top: 20,
  right: 40,
  bottom: 60,
  left: 100
};

var width = svgWidth - margin.left - margin.right;
var height = svgHeight - margin.top - margin.bottom;

// Create an SVG wrapper, append an SVG group that will hold our chart, and shift the latter by left and top margins.
var svg = d3.select("#scatter")
  .append("svg")
  .attr("width", svgWidth)
  .attr("height", svgHeight);

var chartGroup = svg.append("g")
  .attr("transform", `translate(${margin.left}, ${margin.top})`);

// Import Data
d3.csv("assets/data/data.csv")
  .then(function(stateData) {

    // Step 1: Parse Data/Cast as numbers
    // ==============================
    stateData.forEach(function(data) {
      data.age = +data.age;
      data.smokes = +data.smokes;
      data.poverty = +data.poverty;
      data.healthcare = +data.healthcare;
    });
    console.log(stateData);

    // Step 2: Create scale functions
    // ==============================
    var xLinearScale = d3.scaleLinear()
      .domain([d3.min(stateData, d => d[xAxisType]) * 0.9, d3.max(stateData, d => d[xAxisType]) * 1.1])
      .range([0, width]);

    var yLinearScale = d3.scaleLinear()
      .domain([d3.min(stateData, d => d[yAxisType]) * 0.9, d3.max(stateData, d => d[yAxisType]) * 1.1])
      .range([height, 0]);

    // Step 3: Create axis functions
    // ==============================
    var bottomAxis = d3.axisBottom(xLinearScale);
    var leftAxis = d3.axisLeft(yLinearScale);

    // Step 4: Append Axes to the chart
    // ==============================
    chartGroup.append("g")
      .attr("transform", `translate(0, ${height})`)
      .call(bottomAxis);

    chartGroup.append("g")
      .call(leftAxis);

    // Step 5: Create Circles
    // ==============================
    var circlesGroup = chartGroup.selectAll("circle")
    .data(stateData)
    .enter()
    .append("circle")
    .attr("cx", d => xLinearScale(d[xAxisType]))
    .attr("cy", d => yLinearScale(d[yAxisType]))
    .attr("r", "15")
    .attr("fill", "blue")
    .attr("opacity", ".9");

    var labelsGroup = chartGroup.append('g')
    .selectAll('text')
    .data(stateData)
    .enter()
    .append('text')
    .text((d) => (d.abbr))
    .attr("x", d => xLinearScale(d[xAxisType]))
    .attr("y", d => yLinearScale(d[yAxisType] - .35))
    .attr("text-anchor", "middle")
    .attr('color', 'white')
    .attr('text-align', 'center');

    // Create axes labels
    chartGroup.append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 0 - margin.left + 40)
      .attr("x", 0 - (height / 2))
      .attr("dy", "1em")
      .attr("class", "axisText")
      .text(yAxisType);

    chartGroup.append("text")
      .attr("transform", `translate(${width / 2}, ${height + margin.top + 30})`)
      .attr("class", "axisText")
      .text(xAxisType);
  });
