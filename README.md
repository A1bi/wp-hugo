# wp-hugo

This small script transfers posts from a Wordpress XML export to a Hugo static website.

The following post attributes are supported:

- title
- author
- publication date
- content
- images contained in the content

Images found in the content are downloaded and copied to the corresponding page bundle. The post's thumbnail currently is not supported since it is only referenced by ID in the export.

## Usage

```ruby
ruby app.rb
```

Don't forget to create a proper `.env` file from the sample.
