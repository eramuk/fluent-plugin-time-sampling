require "fluent/plugin/filter"
require "date"

module Fluent::Plugin
  class TimeSamplingFilter < Filter
    Fluent::Plugin.register_filter('time_sampling', self)

    config_param :unit, :array, value_type: :string
    config_param :keep_keys, :array, value_type: :string, default: []
    config_param :interval, :time, default: 60

    def configure(conf)
      super
      @cache = {}
      @cache_period = @interval * 2
      @interval = -1 if @interval.zero?
      @old_cache_clear_interval = 300
      @old_cache_clear_time = Time.now
    end

    def start
      super
    end

    def shutdown
      super
    end

    def filter(tag, time, record)
      cache_key = @unit.map do |unit|
        if unit != "${tag}" && !record.has_key?(unit)
          raise "#{unit}: unit not found"
        end
        unit != "${tag}" ? record[unit] : tag
      end.join(":")

      @keep_keys.each do |key|
        unless record.has_key?(key)
          raise "#{key}: keep_keys not found"
        end
      end

      unless cache(cache_key)
        cache(cache_key, "")
        new_record = @keep_keys.empty? ?
          record.dup : record.select { |k, v| @keep_keys.include?(k) }
      end

      if Time.now > @old_cache_clear_time + @old_cache_clear_interval
        clear_old_cache
        @old_cache_clear_time = Time.now
      end

      new_record ||= nil
    end

    def cache(key, data = nil)
      if data.nil?
        @cache[key] ||= { :time => Time.at(0) }
        expired = Time.now > @cache[key][:time]
        expired ? nil : @cache[key][:data]
      else
        @cache[key] = {
          :data => data,
          :time => Time.now + @interval
        }
      end
    end

    def clear_old_cache
      @cache.each_key do |key|
        expired = Time.now > @cache[key][:time] + @cache_period
        @cache.delete(key) if expired
      end
    end

  end
end
