### GTFS Ruby

A Ruby wrapper for the [General Transit Feed Specification](https://developers.google.com/transit/gtfs/)

### Getting started

Initialize a new GTFS source:

    source = GTFS::Source.build(<URI or Path to GTFS zip file>)

Accessing GTFS data from the source:

    source.agencies
    source.stops
    source.routes
    source.trips
    source.stop_times
    source.calendar           # Not implemented
    source.calendar_dates     # Not implemented
    source.fare_attributes    # Not implemented
    source.fare_rules         # Not implemented
    source.shapes
    source.frequencies        # Not implemented
    source.transfers          # Not implemented
