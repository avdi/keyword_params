require 'English'
require 'bundler'

LIB_PATH     = File.expand_path("lib", File.dirname(__FILE__))
EXAMPLE_FILE = File.expand_path("README", File.dirname(__FILE__))

Bundler::GemHelper.install_tasks

task "load_path" do
  $LOAD_PATH.unshift(LIB_PATH)
end

desc "Run the tests"
task "test" => %w[load_path] do
  require 'rcodetools/xmpfilter'
  require 'rcodetools/options'
  include Rcodetools
  example_file = EXAMPLE_FILE
  example_code = File.read(example_file)
  xmp_options = {
    include_paths: [LIB_PATH]
  }
  output = ::XMPFilter.run(example_code,xmp_options)
  diff   = IO.popen("diff #{example_file} -", "r+")
  diff.write(output)
  diff.close_write
  results = diff.read
  diff.close_read
  if $CHILD_STATUS.success?
    puts "Green!"
    exit 0
  else
    puts results
    exit 1
  end
end

desc "Run the examples"
task "example" do
  $LOAD_PATH.unshift(LIB_PATH)
  load EXAMPLE_FILE
end
