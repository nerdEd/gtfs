module GTFS
  class WideTime
    def initialize(seconds)
      @seconds = seconds || 0
    end

    def self.parse(t)
      if t.is_a?(WideTime)
        t
      elsif t.is_a?(Fixnum)
        self.new(t)
      elsif t.nil?
        nil
      elsif t.empty?
        nil
      else
        self.from_string(t)
      end
    end

    def self.from_string(t)
      raise ArgumentError.new('Cannot parse empty string') if t.empty?
      t = t.split(':')
      hours = t[0].to_i
      minutes = t[1].to_i
      seconds = t[2].to_i
      self.new((hours*3600)+(minutes*60)+seconds)
    end

    def to_s
      hours = @seconds / 3600
      minutes = (@seconds % 3600) / 60
      seconds = (@seconds % 3600) % 60
      "%02d:%02d:%02d"%[hours, minutes, seconds]
    end

    def to_seconds
      return @seconds
    end

    def +(other)
      WideTime.new(self.to_seconds + other.to_seconds)
    end

    def -(other)
      WideTime.new(self.to_seconds - other.to_seconds)
    end
  end
end
