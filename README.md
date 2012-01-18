### GTFS Ruby

A Ruby wrapper for the General Transit Feed Specification

### Getting started

Initialize a new GTFS source:

    source = GTFS::Source.build(<URI or Path to GTFS zip file>)

Accessing GTFS data from the source:

    source.agencies
    source.stops
    source.routes
    source.trips
    source.stop_times
    source.calendar
    source.calendar_dates
    source.fare_attributes
    source.fare_rules
    source.shapes
    source.frequencies
    source.transfers
