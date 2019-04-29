# Python SQL toolkit and Object Relational Mapper
import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func, inspect
import pandas as pd
import datetime as dt
from flask import Flask, jsonify

engine = create_engine("sqlite:///Resources/hawaii.sqlite")

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# Save references to each table
Measurement = Base.classes.measurement
Station = Base.classes.station

# Create our session (link) from Python to the DB
session = Session(engine)

# Determine cutoff date of a year from the last data point.
last_date = session.query(func.max(Measurement.date)).first()
cutoff_date = dt.datetime.strptime(last_date[0], '%Y-%m-%d') - dt.timedelta(365, 0, 0)


app = Flask(__name__)

@app.route("/")
def welcome():
    """List all available api routes."""
    return (
        f"Available Routes:<br/>"
        f"/api/v1.0/precipitation<br/>"
        f"/api/v1.0/stations<br/>"
        f"/api/v1.0/tobs<br/>"
        f"/api/v1.0/[start]<br/>"
        f"/api/v1.0/[start]/[end]"
    )

@app.route("/api/v1.0/precipitation")
def precipitation():
    """Return a list of percipitation data by date """
    # Query all percipitation data
    prcp_query = session.query(Measurement.date, Measurement.prcp)

    # Convert list of tuples into dictionary
    prcp_data = pd.read_sql(prcp_query.statement, session.bind).to_dict()


    return jsonify(prcp_data)

@app.route("/api/v1.0/stations")
def stations():
    """Return a list of stations """
    # Query all station data
    station_query = session.query(Station)

    # Convert query result into dictionary
    station_data = pd.read_sql(station_query.statement, session.bind).to_dict()

    return jsonify(station_data)

@app.route("/api/v1.0/tobs")
def tobs():
    """Return a list of dates and temperature observations from a year from the last data point. """
    # Query tobs data from after the cutoff date, organized by date 
    tobs_query = session.query(Measurement.date, Measurement.tobs).filter(Measurement.date >= cutoff_date)

    # Convert query result into dictionary
    tobs_data = pd.read_sql(tobs_query.statement, session.bind).to_dict()

    return jsonify(tobs_data)


@app.route("/api/v1.0/<start>")
def tobs_start(start):
    """Return a an overview of temperature since a givens start date. """
    # Query temp data from after the start date
    temp_query = session.query(Measurement.date, Measurement.tobs)\
        .filter(Measurement.date >= start)
    temp_data = pd.read_sql(temp_query.statement, session.bind)

    # Calculate min, max and avg for the temp data
    result = {'min': temp_data['tobs'].min(), 
            'max': temp_data['tobs'].max(), 
            'avg': temp_data['tobs'].mean()}
    return jsonify(result)

@app.route("/api/v1.0/<start>/<end>")
def tobs_start_end(start, end):
    """Return a an overview of temperature since between a given start and end date. """
    # Query temp data from after the start date
    temp_query = session.query(Measurement.date, Measurement.tobs)\
        .filter(Measurement.date >= start)\
        .filter(Measurement.date <= end)
    temp_data = pd.read_sql(temp_query.statement, session.bind)

    # Calculate min, max and avg for the temp data
    result = {'min': temp_data['tobs'].min(), 
            'max': temp_data['tobs'].max(), 
            'avg': temp_data['tobs'].mean()}
    return jsonify(result)