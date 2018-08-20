# fluent-plugin-time-sampling

## Installation
```
gem install fluent-plugin-time-sampling
```

## Usage
Example:
```
<filter test.**>
  @type time_sampling
  unit ${tag}, hostname, sample_key1
  interval 10
  keep_keys hostname, sample_key2
</filter>
```

Assume following input in 10 seconds:
```
sample.tag { "hostname": "host1", "sample_key1": "foo", "sample_key2": "aaa" }
sample.tag { "hostname": "host1", "sample_key1": "foo", "sample_key2": "bbb" }
sample.tag { "hostname": "host2", "sample_key1": "bar", "sample_key2": "ccc" }
```

then output is below:
```
sample.tag { "hostname": "host1", "sample_key2": "aaa" }
sample.tag { "hostname": "host2", "sample_key2": "ccc" }
```

## Configuration

### unit
Specify keys for grouping.

### interval
Time of filtering interval. default is 60 second.

### keep_keys
Specify output keys. default is all keys.
