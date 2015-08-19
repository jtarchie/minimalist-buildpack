require 'bdk/recipes'
require 'bdk/recipter_sorter'

module BDK
  class CLI
    def self.start(args)
      command = args.shift
      new.public_send(command, *args)
    end

    def detect(build_dir)
      found_recipes = Recipes.all.select{|r| r.detect? build_dir }
      if found_recipes.empty?
        exit 1
      else
        puts "Found Recipes: #{found_recipes.collect(&:name).join(', ')}"
        exit 0
      end
    end

    def compile(build_dir, cache_dir)
      found_recipes = Recipes.all.select{|r| r.detect? build_dir }

      if found_recipes.empty?
        exit 1
      else
        RecipeSorter.new(found_recipes).tsort.each do |r|
          puts "Recipe: #{r.name}"
          r.compile!(build_dir)
        end

        exit 0
      end
    end
  end
end
