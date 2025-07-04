#!/usr/bin/env ruby
require "nokogiri"
require "pathname"

# Prefix to add, passed as first argument
PREFIX = ARGV[0] || ""
BASE_DIR = Pathname.new("public")

ATTRS = {
  "a"      => ["href"],
  "link"   => ["href"],
  "script" => ["src"],
  "img"    => ["src"],
  "iframe" => ["src"],
  "source" => ["src", "srcset"],
  "form"   => ["action"]
}

def should_rewrite?(url)
  return false if url.nil? || url.empty?
  return false if url.start_with?("http://", "https://", "//")
  return true if url.start_with?("/")
  false
end

def rewrite_url(url)
  should_rewrite?(url) ? "#{PREFIX}#{url}" : url
end

def process_html_file(file)
  content = File.read(file)
  doc = Nokogiri::HTML(content)

  doc.traverse do |node|
    next unless node.element?

    ATTRS[node.name]&.each do |attr|
      next unless node.has_attribute?(attr)
      old = node[attr]
      node[attr] = rewrite_url(old)
    end
  end

  File.write(file, doc.to_html)
end

Dir.glob("#{BASE_DIR}/**/*.html") do |file|
  process_html_file(file)
end
