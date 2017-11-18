module RefinementBuilder

  def build_refinement(class_name, namespace: Object, refines: Object, &blk)
    const = namespace.const_set class_name, Module.new(&blk)
    const.instance_methods(false).each do |method_name|
      orig_method = const.instance_method method_name
      const.send :define_method, method_name do |*args, **keywords, &blk|
        if eql?(const)
          if keywords.empty?
            orig_method.bind(const).call *args, &blk
          else
            orig_method.bind(const).call *args, **keywords, &blk
          end
        else
          if keywords.empty?
            const.send method_name, *args, &blk
          else
            const.send method_name, *args, **keywords, &blk
          end
        end
      end
      const.send :module_function, method_name
      const.send(:refine, refines) { include const }
    end
  end

  module_function :build_refinement

  refine Object do
    include RefinementBuilder
  end

end
