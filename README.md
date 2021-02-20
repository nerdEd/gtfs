[![Build Status](https://travis-ci.org/nerdEd/gtfs.svg?branch=master)](https://travis-ci.org/nerdEd/gtfs)

### GTFS Ruby

A Ruby wrapper for the [General Transit Feed Specification](https://developers.google.com/transit/gtfs/)

### Getting started

Initialize a new GTFS source:

    # Defaults to strict checking of required columns
    source = GTFS::Source.build(<URI or Path to GTFS zip file>)
    
    # Relax the column checks, useful for sources that don't conform to standard
    source = GTFS::Source.build(<URI or Path to GTFS zip file>, {strict: false})
    
Accessing GTFS data from the source:

    source.agencies
    source.stops
    source.routes
    source.trips
    source.stop_times
    source.calendars
    source.calendar_dates     
    source.fare_attributes    
    source.fare_rules         
    source.shapes
    source.frequencies        
    source.transfers          
    
Alternatively:

    source.each_agency {|agency| puts agency}
    ...
    source.each_transfer {|transfer| puts transfer}


### License

This project is licensed under the terms of the MIT license.

See this license at [`LICENSE`](LICENSE).
