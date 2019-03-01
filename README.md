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
  unit ${tag}, hostname
  interval 10
</filter>
```

Assume following input in 10 seconds:
```
test.tag1 { "hostname": "host1", "sample_key1": "100", "sample_key2": "aaa" }
test.tag1 { "hostname": "host1", "sample_key1": "200", "sample_key2": "bbb" }
test.tag1 { "hostname": "host1", "sample_key1": "300", "sample_key2": "ccc" }
test.tag1 { "hostname": "host2", "sample_key1": "100", "sample_key2": "ddd" }
test.tag1 { "hostname": "host2", "sample_key1": "200", "sample_key2": "eee" }
test.tag2 { "hostname": "host2", "sample_key1": "300", "sample_key2": "fff" }
```

then output is below:
```
test.tag { "hostname": "host1", "sample_key1": "100", "sample_key2": "aaa" }
test.tag { "hostname": "host2", "sample_key1": "100", "sample_key2": "ddd" }
```

## Configuration

### unit
Specify keys for grouping.

### interval
Time of filtering interval. default is 60 second.

### keep_keys
Specify output keys. default is all keys.
