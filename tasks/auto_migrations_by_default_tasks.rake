
require 'find'
require 'fileutils'
namespace :db do
  namespace :auto do
    task :enable do
      dir = 'vendor/plugins/auto_migrations_by_default/files'
      Dir.chdir(dir) do
        puts "Copying files from #{dir}"
        Find.find('.') do |path|
          next unless File.file?(path)
          puts "  create #{path}"
          FileUtils.copy(path, "#{RAILS_ROOT}/#{path}")
        end
      end
    end
  end
  
  namespace :auto do
    task :disable do
      dir = 'vendor/plugins/auto_migrations_by_default/files'
      Dir.chdir(dir) do
        puts "Removing files installed by auto_migrations_by_default plugin"
        Find.find('.') do |path|
          next unless File.file?(path)
          puts "  rm -f #{path}"
          File.unlink("#{RAILS_ROOT}/#{path}") if File.exists?("#{RAILS_ROOT}/#{path}")
        end
      end
    end
  end
  
end