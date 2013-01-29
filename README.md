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

Copyright (C) 2012 Ed Schmalzle

Permission is hereby granted, free of charge, to any person obtaining a 
copy of this software and associated documentation files (the "Software"), to 
deal in the Software without restriction, including without limitation the 
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
copies of the Software, and to permit persons to whom the Software is furnished 
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in 
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS 
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
