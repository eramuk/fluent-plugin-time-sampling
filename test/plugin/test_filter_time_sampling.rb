require "helper"

class TimeSamplingFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %q{
    unit ${tag}, sample_key1
    keep_keys sample_key2
  }

  def create_driver(conf = CONFIG, tag = "tag.test")
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::TimeSamplingFilter).configure(conf)
  end

  def test_filter
    sample_records = [
      {"sample_key1" => "foo", "sample_key2" => "aaa"},
      {"sample_key1" => "foo", "sample_key2" => "bbb"},
      {"sample_key1" => "bar", "sample_key2" => "ccc"},
    ]
    d = create_driver
    d.run(default_tag: "test") do
      sample_records.each do |record|
        d.feed(record)
      end
    end
    p d.filtered
  end
end
