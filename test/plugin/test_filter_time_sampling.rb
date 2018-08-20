require "helper"

class TimeSamplingFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %q{
    unit _source_address, ${tag}
    keep_keys _source_address
  }

  def create_driver(conf = CONFIG, tag = "tag.test")
    Fluent::Test::FilterTestDriver.new(Fluent::TimeSamplingFilter, tag).configure(conf)
  end

  def test_filter
    msg = {"_source_address" => "127.0.0.1", "foo" => "bar", "hoge" => "fuga"}
    d = create_driver
    d.run {
      d.filter(msg, @time)
    }
    filtered = d.filtered_as_array
    p filtered.map {|m| m[2] }
  end

end
