# encoding: utf-8

require 'rake/clean'
require 'bundler/gem_tasks'

task :default => :test

Dir['gem_tasks/**/*.rake'].each { |rake| load rake }

CLEAN.include '**/*.rbc', '.rbx'
CLOBBER.include 'pkg', 'doc', 'coverage'
