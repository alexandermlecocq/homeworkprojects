// from data.js
var tableData = data;

// Select table body
var table_body = d3.select('#table_body');

// Select the submit button
var filter_button = d3.select("#filter-btn");

// Complete the click handler for the form
filter_button.on("click", function() {

  // Prevent the page from refreshing
  d3.event.preventDefault();

  // Select the input element and get the raw HTML node
  var inputElement = d3.select('#datetime');

  // Get the value property of the input element
  var inputValue = inputElement.property("value");

  // Clear table body of any existing rows
  table_body.selectAll("tr").remove();

  // Use the form input to filter the data by blood type
  tableData.filter(sighting => sighting['datetime'] == inputValue).forEach(sighting => {
      var row = table_body.append('tr');
      Object.values(sighting).forEach(data_entry => {
        var cell = row.append('td');
        cell.text(data_entry)
      })
  })
});


tableData.forEach(sighting => {
    var row = table_body.append('tr');
    Object.values(sighting).forEach(data_entry => {
      var cell = row.append('td');
      cell.text(data_entry)
    })
})