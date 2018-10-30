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
# output files go into ./output/[TIMESTAMP]/
```
See [the example CSV](examples/example_csv.csv) for guidance on how it's formatted.

**We keep the lastest CSV in source control - [here](./mms_name_match.csv)**

2. Upload Mappings to S3

```
aws s3 sync ./PATH/TO/TODAYS/OUTPUT/DIR/ s3://bucket-name/ --acl public-read --delete --profile aws-profile-name
```
This will delete JSON files that are on S3 but not in the output directory.

For more info see [s3 sync's documentation](https://docs.aws.amazon.com/cli/latest/reference/s3/sync.html).
