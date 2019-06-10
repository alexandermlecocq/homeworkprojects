function buildGauge(wfreq){
  // Trig to calc meter point
  var level = wfreq * 20;
  var degrees = 180 - level,
        radius = .5;
  var radians = degrees * Math.PI / 180;
  var x = radius * Math.cos(radians);
  var y = radius * Math.sin(radians);
  
  // Path: may have to change to create a better triangle
  var mainPath = 'M -.0 -0.025 L .0 0.025 L ',
        pathX = String(x),
        space = ' ',
        pathY = String(y),
        pathEnd = ' Z';
  var path = mainPath.concat(pathX,space,pathY,pathEnd);
  
  var data = [{ type: 'scatter',
      x: [0], y:[0],
      marker: {size: 28, color:'850000'},
      showlegend: false,
      name: 'scrubs',
      text: wfreq,
      hoverinfo: 'text+name'},
    { values: [50/9, 50/9, 50/9, 50/9, 50/9, 50/9, 50/9, 50/9, 50/9, 50],
    rotation: 90,
    text: ['8-9', '7-8', '6-7', '5-6', '4-5', '3-4', '2-3', '1-2', '0-1', ''],
    textinfo: 'text',
    textposition:'inside',
    marker: {colors:["#248914", "#3a9328","#4f9d3d","#65a751","#7bb165","#91ba79","#a7c48d","#bccea2","#d2d8b6",
                            'rgba(255, 255, 255, 0)']},
    labels: ['8-9', '7-8', '6-7', '5-6', '4-5', '3-4', '2-3', '1-2', '0-1', ''],
    hoverinfo: 'label',
    hole: .5,
    type: 'pie',
    showlegend: false
  }];
  
  var layout = {
    shapes:[{
        type: 'path',
        path: path,
        fillcolor: '850000',
        line: {
          color: '850000'
        }
      }],
    title: '<b>Belly Button Washing Frequency</b> <br> Scrubs per Week',
    // height: 600,
    // width: 600,
    xaxis: {zeroline:false, showticklabels:false,
                showgrid: false, range: [-1, 1]},
    yaxis: {zeroline:false, showticklabels:false,
                showgrid: false, range: [-1, 1]}
  };
  
  Plotly.newPlot('gauge', data, layout);
}


function buildMetadata(sample) {

  // @TODO: Complete the following function that builds the metadata panel

  // Use `d3.json` to fetch the metadata for a sample
  d3.json("/metadata/" + sample).then((sampleMeta) => {

    // Use d3 to select the panel with id of `#sample-metadata`
    var metadata_panel = d3.select('#sample-metadata');

    // Use `.html("") to clear any existing metadata
    metadata_panel.html("");

    // Use `Object.entries` to add each key and value pair to the panel
    // Hint: Inside the loop, you will need to use d3 to append new
    // tags for each key-value in the metadata.
    Object.entries(sampleMeta).forEach(([key, value]) => {
      metadata_panel.append('p').text(`${key}: ${value}`)
    })

    // BONUS: Build the Gauge Chart
    buildGauge(sampleMeta.WFREQ);
  })
}

function buildCharts(sample) {

  // @TODO: Use `d3.json` to fetch the sample data for the plots
  d3.json("/samples/" + sample).then((response) =>{
    // @TODO: Build a Bubble Chart using the sample data

    var data = [{
      x: response.otu_ids,
      y: response.sample_values,
      marker: {size: response.sample_values, color: response.otu_ids},
      mode: 'markers',
      text: response.otu_labels
    }];

    Plotly.newPlot('bubble', data);
    


    // @TODO: Build a Pie Chart
    // HINT: You will need to use slice() to grab the top 10 sample_values,
    // otu_ids, and labels (10 each).

    console.log(response)
    var sorting_array = []
    for (var i=0; i < response.sample_values.length; i++){
      sorting_array.push({
        sample_values: response.sample_values[i],
        otu_ids: response.otu_ids[i],
        otu_labels: response.otu_labels[i],
      })
    }

    var topTen = sorting_array.sort((a, b) => {
      return b.sample_values - a.sample_values;
    }).slice(0, 10);

    var topTenSampleValues = []
    var topTenOtuIds = []
    var topTenOtuLabels = []
    topTen.forEach(entry => {
      topTenSampleValues.push(entry.sample_values)
      topTenOtuIds.push(entry.otu_ids)
      topTenOtuLabels.push(entry.otu_labels)
    })
    console.log(topTen)
    var data = [{
      values: topTenSampleValues,
      labels: topTenOtuIds,
      hoverinfo: topTenOtuLabels,
      type: 'pie'
    }];
    Plotly.newPlot('pie', data);
  })
}

function init() {
  // Grab a reference to the dropdown select element
  var selector = d3.select("#selDataset");

  // Use the list of sample names to populate the select options
  d3.json("/names").then((sampleNames) => {
    sampleNames.forEach((sample) => {
      selector
        .append("option")
        .text(sample)
        .property("value", sample);
    });

    // Use the first sample from the list to build the initial plots
    const firstSample = sampleNames[0];
    buildCharts(firstSample);
    buildMetadata(firstSample);
  });
}

function optionChanged(newSample) {
  // Fetch new data each time a new sample is selected
  buildCharts(newSample);
  buildMetadata(newSample);
}

// Initialize the dashboard
init();
