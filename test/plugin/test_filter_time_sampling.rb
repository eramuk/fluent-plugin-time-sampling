require "helper"

class TimeSamplingFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %q{
    unit ${tag}, sample_key1
    keep_keys sample_key2
  }

  def create_driver(conf = CONFIG, tag = "test")
    Fluent::Test::FilterTestDriver.new(Fluent::TimeSamplingFilter, tag).configure(conf)
  end

  def test_filter
    sample_records = [
      {"sample_key1" => "foo", "sample_key2" => "aaa"},
      {"sample_key1" => "foo", "sample_key2" => "bbb"},
      {"sample_key1" => "bar", "sample_key2" => "ccc"},
    ]
    d = create_driver
    d.run {
      sample_records.each do |records|
        d.filter(records, Time.now)
      end
    }
    filtered = d.filtered_as_array
    p filtered.map {|m| m[2] }
  end

end
