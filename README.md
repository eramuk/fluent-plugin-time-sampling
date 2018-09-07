# fluent-plugin-time-sampling

## Requirements

| fluent-plugin-time-sampling | fluentd    |
|-----------------------------|------------|
| >= 1.0.0                    | >= v0.14.0 |
| <  1.0.0                    | <  v0.14.0 |

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
test.tag { "hostname": "host1", "sample_key1": "foo", "sample_key2": "aaa" }
test.tag { "hostname": "host1", "sample_key1": "foo", "sample_key2": "bbb" }
test.tag { "hostname": "host2", "sample_key1": "bar", "sample_key2": "ccc" }
test.tag { "hostname": "host2", "sample_key1": "baz", "sample_key2": "ddd" }
```

then output is below:
```
test.tag { "hostname": "host1", "sample_key2": "aaa" }
test.tag { "hostname": "host2", "sample_key2": "ccc" }
test.tag { "hostname": "host2", "sample_key2": "ddd" }
```

## Configuration

### unit
Specify keys for grouping.

### interval
Time of filtering interval. default is 60 second.

### keep_keys
Specify output keys. default is all keys.
