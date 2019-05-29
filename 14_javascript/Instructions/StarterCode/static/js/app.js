// from data.js
var tableData = data;

var table_body = d3.select('#table-body');

var filters = d3.select('#filters')

var filter_button = d3.select("#filter-btn");

// Display default filter (datetime)
changeFilter();

// Populate the initial table
tableData.forEach(sighting => {
    var row = table_body.append('tr');
    Object.values(sighting).forEach(data_entry => {
      var cell = row.append('td');
      cell.text(data_entry)
    })
})



// Events

// Filter table and display
filter_button.on("click", function() {
    d3.event.preventDefault();
    var inputElement = d3.select('#' + filter_type);
    var inputValue = inputElement.property("value");
    // Clear output table
    table_body.selectAll("tr").remove();
    // Take entire table if no filter applied, otherwise only collect matching rows
    if (inputValue == '') {
        var outputData = tableData;
    }
    else {
        var outputData = tableData.filter(sighting => sighting[filter_type] == inputValue);
    }
    // Add the filtered data to the table body
    outputData.forEach(sighting => {
        var row = table_body.append('tr');
        Object.values(sighting).forEach(data_entry => {
          var cell = row.append('td');
          cell.text(data_entry)
        })
    })
  });

// Change which filter is showing
function changeFilter() {
    // Figure out which filter has been chosen
    filter_type = d3.select('#select-filter').node().value;
    // Hide whatever existing filter exists
    filters.selectAll('li').style('display', 'none');
    // Display chosen filter
    d3.select('#' + filter_type + '-filter').style('display', 'block');
}