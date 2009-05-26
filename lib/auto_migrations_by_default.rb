# AutoMigrationsByDefault
module AutoMigrationsByDefault
  # The schema class operates from within schema.rb
  class Migrate
    attr_reader :migrations
    
    def initialize(rails_root=RAILS_ROOT)
      @rails_root = rails_root
      @schema_rb  = "db/schema.rb"
      @our_files  = "#{rails_root}/vendor/plugins/auto_migrations_by_default/files"
      
      eval "class SchemaMigration < ActiveRecord::Base; end"
    end

    def load_migrations(rails_root=@rails_root)
      @migrations = []

      # find all migration files
      files =  Dir.glob("#{rails_root}/db/migrate/*.rb")

      # sort them and iterate through the list, making sure that each
      # migration has a self.up method before continuing
      puts "==  Verifying #{files.length} migrations"
      files.sort.each do |file|
        require file
        basefile = File.basename(file, '.rb').sub(/^(\d+)_/,'')
        version  = $1.to_s
        exists = false
        mig_class = basefile.camelize.constantize
        unless mig_class.respond_to? :up
          raise "Invalid migration: #{file} missing self.up method"
        end
        @migrations << [mig_class, version]
      end
      puts "==  All files verified, starting auto-migration\n\n"
    end

    # Now run the migrations
    def run
      load_migrations
      @migrations.each do |mig_class, version|
        mig_class.up
        # Add it to the schema_migrations table as well
        # This will fail if auto-migrations is only and always used,
        # as the schema_migrations table will not exist.
        SchemaMigration.find_or_create_by_version(version) rescue nil
      end
    end

  end
end