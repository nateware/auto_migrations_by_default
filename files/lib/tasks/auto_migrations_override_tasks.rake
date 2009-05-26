namespace :db do
  Rake.application.instance_variable_get(:@tasks).delete('db:migrate')
  task :migrate => 'db:auto:migrate'
  
  Rake.application.instance_variable_get(:@tasks).delete('db:schema:dump')
  namespace :db do
    namespace :schema do
     task :dump do
       puts "Note: db:schema:dump disabled by db:auto:migrate"
     end
    end
  end
  
  
end