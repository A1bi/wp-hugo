# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'date'
require 'dotenv/load'
require 'erb'
require 'fileutils'
require 'nokogiri'
require 'open-uri'

xml_content = File.open(ENV['XML_FILE_PATH'])
xml = Nokogiri::XML(xml_content)

posts = xml.root.xpath('channel/item')
posts.each do |post|
  title = post.xpath('title').text
  slug = title.parameterize
  pub_date = DateTime.parse(post.xpath('pubDate').text)
  content = post.xpath('content:encoded').text
  content_html = Nokogiri::HTML(content)

  content.gsub!(%r{</?(a|img).+>}, '')
  content.gsub!(/\n+/, "\n")

  post_path = "#{ENV['PAGE_BUNDLE_PATH']}/#{slug}"
  FileUtils.mkdir_p(post_path)

  images = []
  content_html.root.xpath('//a').each_with_index do |image, i|
    url = image['href']
    ext = File.extname(url)
    filename = "image#{i + 1}#{ext}"
    path = "#{post_path}/#{filename}"
    IO.copy_stream(URI.parse(url).open, path) unless File.exist?(path)
    images << filename
  end

  template = ERB.new(File.read('post.md.erb'), trim_mode: '-')
  markdown_content = template.result(binding)
  File.write("#{post_path}/index.md", markdown_content)
end
