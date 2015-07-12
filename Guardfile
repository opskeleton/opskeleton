
guard :shell do
  watch %r{^docs/.*adoc} do |m|
    `rake asciidoc:create`
  end
end

guard :minitest do
  watch(%r{^test/(.*)\/?test_(.*)\.rb$}){'test'}
  watch(%r{^lib/(.*/)?([^/]+)\.rb$}){'test'}
  watch(%r{^test/test_helper\.rb$}){'test'}
end
