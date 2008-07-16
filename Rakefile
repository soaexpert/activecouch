require 'rubygems'
require 'spec/rake/spectask'

desc "Run all dependency-neutral tests"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

task :default => [:spec]