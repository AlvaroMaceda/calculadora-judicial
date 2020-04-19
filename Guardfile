# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"
# guard :rspec, cmd: 'bundle exec rspec', failed_mode: :keep do
#     watch('spec/spec_helper.rb')                        { "spec" }
#     watch('config/routes.rb')                           { "spec/routing" }
#     watch('app/controllers/application_controller.rb')  { "spec/controllers" }
#     watch(%r{^spec/.+_spec\.rb$})
#     watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
#     watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
#     watch(%r{^app/(.*)(\.jbuilder)$})
#     watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
#     watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
#   end

  guard :rspec, cmd: "bundle exec rspec", :all_on_start => true do
    require "guard/rspec/dsl"
    dsl = Guard::RSpec::Dsl.new(self)
  
    # Feel free to open issues for suggestions and improvements
  
    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)
  
    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)
  
    # Rails files
    rails = dsl.rails(view_extensions: %w(erb haml slim))
    dsl.watch_spec_files_for(rails.app_files)
    dsl.watch_spec_files_for(rails.views)

    watch(rails.controllers) do |m|
      [
        rspec.spec.call("routing/#{m[1]}_routing"),
        rspec.spec.call("controllers/#{m[1]}_controller"),
        rspec.spec.call("acceptance/#{m[1]}")
      ]
    end
  
    # Rails config changes
    watch(rails.spec_helper)     { rspec.spec_dir }
    watch(rails.routes)          { "#{rspec.spec_dir}/routing" }
    watch(rails.app_controller)  { "#{rspec.spec_dir}/controllers" }
  
    # Capybara features specs
    watch(rails.view_dirs)     { |m| rspec.spec.call("features/#{m[1]}") }
    watch(rails.layouts)       { |m| rspec.spec.call("features/#{m[1]}") }

    # JBuilder views
    watch(%r{^app\/(views\/.+\/[^\/]*\.(?:erb|haml|slim|jbuilder))$}) { rspec.spec_dir }
    # Rspec support files
    watch(%r{spec\/support.*$}) { rspec.spec_dir }
  end