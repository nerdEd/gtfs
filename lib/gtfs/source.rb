require 'tmpdir'
require 'fileutils'
require 'zip'

module GTFS
  class Source

    ENTITIES = [
      GTFS::Agency,
      GTFS::Stop,
      GTFS::Route,
      GTFS::Trip,
      GTFS::StopTime,
      GTFS::Calendar,
      GTFS::CalendarDate,
      GTFS::Shape,
      GTFS::FareAttribute,
      GTFS::FareRule,
      GTFS::Frequency,
      GTFS::Transfer,
      GTFS::FeedInfo
    ]
    REQUIRED_SOURCE_FILES = ENTITIES.select(&:required_file?).map(&:filename)
    OPTIONAL_SOURCE_FILES = ENTITIES.reject(&:required_file?).map(&:filename)
    SOURCE_FILES = Hash[ENTITIES.map { |e| [e.filename, e] }]
    DEFAULT_OPTIONS = {strict: true}

    attr_accessor :source, :archive, :options

    def initialize(source, opts={})
      raise 'Source cannot be nil' if source.nil?
      # Cache
      @cache = {}
      # Parents/children
      @parents = Hash.new { |h,k| h[k] = Set.new }
      @children = Hash.new { |h,k| h[k] = Set.new }
      # Trip counter
      @trip_counter = Hash.new { |h,k| h[k] = 0 }
      # Merged calendars
      @service_periods = {}
      # Shape lines
      @shape_lines = {}
      # Temporary directory
      @tmp_dir = Dir.mktmpdir
      ObjectSpace.define_finalizer(self, self.class.finalize(@tmp_dir))
      # Load options
      @options = DEFAULT_OPTIONS.merge(opts)
      # Unzip to temporary directory
      @source = source
      load_archive(@source)
    end

    ##### Relationships #####

    def pclink(parent, child)
      @parents[child] << parent
      @children[parent] << child
    end

    def parents(entity)
      @parents[entity]
    end

    def children(entity)
      @children[entity]
    end

    ##### Cache #####

    def cache(filename, &block)
      # Read entities, cache by ID.
      cls = SOURCE_FILES[filename]
      if @cache[cls]
        @cache[cls].values.each(&block)
      else
        @cache[cls] = {}
        cls.each(File.join(@tmp_dir, filename), options) do |model|
          @cache[cls][model.id || model] = model
          block.call model
        end
      end
    end

    ##### Access methods #####

    # Define feed.<entities>, feed.each_<entity>, feed.<entity>
    ENTITIES.each do |cls|
      define_method cls.name.to_sym do
        ret = []
        self.cache(cls.filename) { |model| ret << model }
        ret
      end

      define_method cls.singular_name.to_sym do |key|
        @cache[cls][key]
      end

      define_method "each_#{cls.singular_name}".to_sym do |&block|
        cls.each(File.join(@tmp_dir, cls.filename), options, &block)
      end

    end

    def shape_line(shape_id)
      self.load_shapes if @shape_lines.empty?
      @shape_lines[shape_id]
    end

    def service_period(service_id)
      self.load_service_periods if @service_periods.empty?
      @service_periods[service_id]
    end

    ##### Load graph, shapes, calendars, etc. #####

    def load_graph
      # Clear
      @cache.clear
      @parents.clear
      @children.clear
      @trip_counter.clear
      # Cache core entities
      default_agency = nil
      self.agencies.each { |e| default_agency = e }
      self.routes.each { |e| self.pclink(self.agency(e.agency_id) || default_agency, e) }
      self.trips.each { |e| self.pclink(self.route(e.route_id), e)}
      # Link trips to stops
      self.stops.each {}
      self.each_stop_time do |e|
        trip = self.trip(e.trip_id)
        stop = self.stop(e.stop_id)
        self.pclink(trip, stop)
        @trip_counter[trip] += 1
      end
    end

    def load_shapes
      # Merge shapes
      @shape_lines.clear
      shapes_merge = Hash.new { |h,k| h[k] = [] }
      self.each_shape { |e| shapes_merge[e.shape_id] << e }
      shapes_merge.each do |k,v|
        @shape_lines[k] = v
          .sort_by { |i| i.shape_pt_sequence.to_i }
          .map { |i| [i.shape_pt_lon.to_f, i.shape_pt_lat.to_f] }
      end
    end

    def load_service_periods
      @service_periods.clear
      # Load calendar
      self.each_calendar do |e|
        service_period = ServicePeriod.from_calendar(e)
        @service_periods[service_period.id] = service_period
      end
      # Load calendar_date exceptions
      self.each_calendar_date do |e|
        service_period = @service_periods[e.service_id] || ServicePeriod.new(service_id: e.service_id)
        if e.exception_type.to_i == 1
          service_period.add_date(e.date)
        else
          service_period.except_date(e.date)
        end
        @service_periods[service_period.id] = service_period
      end
      # Expand service range
      @service_periods.values.each(&:expand_service_range)
    end

  ##### Incremental processing #####

    def trip_chunks(batchsize=1_000_000)
      # Return chunks of trips containing approx. batchsize stop_times.
      # Reverse sort trips
      trips = @trip_counter.sort_by { |k,v| -v }
      chunk = []
      current = 0
      trips.each do |k,v|
        if (current + v) > batchsize
          yield chunk
          chunk = []
          current = 0
        end
        chunk << k
        current += v
      end
      yield chunk
    end

    def trip_stop_times(trips=nil)
      # Return all the stop time pairs for a set of trips.
      # Trip IDs
      trips ||= self.trips
      trip_ids = Set.new trips.map(&:id)
      # Subgraph mapping trip IDs to stop_times
      trip_ids_stop_times = Hash.new {|h,k| h[k] = []}
      self.each_stop_time do |stop_time|
        next unless trip_ids.include?(stop_time.trip_id)
        trip_ids_stop_times[stop_time.trip_id] << stop_time
      end
      # Process each trip
      trips.each do |trip|
        stop_times = trip_ids_stop_times[trip.trip_id]
        stop_times = stop_times.sort_by { |st| st.stop_sequence.to_i }
        yield trip, stop_times
      end
    end

    def stop_time_pairs(trips=nil)
      self.trip_stop_times(trips) do |trip,stop_times|
        route = self.route(trip.route_id)
        stop_times[0..-2].zip(stop_times[1..-1]).each do |origin,destination|
          yield route, trip, origin, destination
        end
      end
    end

    private

    def self.finalize(directory)
      proc {FileUtils.rm_rf(directory)}
    end

    def self.build(data_root, opts={})
      if File.exists?(data_root)
        src = LocalSource.new(data_root, opts)
      else
        src = URLSource.new(data_root, opts)
      end
    end

    def extract_to_cache(source_path)
      Zip::File.open(source_path) do |zip|
        zip.entries.each do |entry|
          zip.extract(entry.name, File.join(@tmp_dir, '/', entry.name))
        end
      end
    end

    def load_archive(source)
      raise 'Cannot directly instantiate base GTFS::Source'
    end

    def entries
      Dir.entries(@tmp_dir)
    end

    def parse_file(filename)
      raise_if_missing_source filename
      open File.join(@tmp_dir, '/', filename), 'r:bom|utf-8' do |f|
        files[filename] ||= yield f
      end
    end
  end
end
