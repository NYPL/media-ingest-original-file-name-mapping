# Media Ingest Original File Name Mapping

During media ingest, we may encounter an asset with a filename of 'foo'
and although MMS has no capture with the `original_file_name` of 'foo', it may have _intellectually_
the same content in a capture, just with a different `original_file_name`.

See [DR-360](https://jira.nypl.org/browse/DR-360) for more info.

## Our Approach

We decided to create a directory of simple files in S3 in order to facilitate association of incoming and existing assets. We went with this approach because:
* It prevents loading a large lookup object in memory during bag parsing.
* Scanning the S3 bucket for a filename should be reasonably performant.

### For Example
Each file would be named after the incoming asset, with the content right now consisting of a simple key-value pair.

`foobar_pm.json`

#### ... would contain

```json
{"nameInMMS":"foobar.mov"}
```

#### ... means

There is a capture in MMS, with the `original_file_name` "foobar.mov",
but the name of that same asset, in its bag is "foobar_pm".

## How to Use This Repo

1. Generate the mapping files

```
ruby ./bin/generate_mapping_files.rb /PATH/TO/CSV.csv
# output files go into ./output
```

2. Upload Mappings to S3

```
Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.  
```

See [the example CSV](examples/example_csv.csv) for guidance on how it's formatted.
