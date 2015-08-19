require 'tsort'

module BDK
  class RecipeSorter
    include TSort

    def initialize(recipes)
      @recipes = {}
      recipes.each do |recipe|
        @recipes[recipe.name] = recipe
      end
    end

    def tsort_each_node(&block)
      @recipes.each_key &block
    end

    def tsort_each_child(node, &block)
      @recipes.fetch(node).dependencies.each(&block)
    end

    def tsort
      super.collect do |recipe_name|
        @recipes[recipe_name]
      end
    end
  end
end
