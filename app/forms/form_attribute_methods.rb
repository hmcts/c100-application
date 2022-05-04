module FormAttributeMethods
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    # Add the ability to read/write attributes without calling their accessor methods.
    # Needed to behave more like an ActiveRecord model, where you can manipulate the
    # database attributes making use of `self[:attribute]`
    def [](attr_name)
      instance_variable_get("@#{attr_name}".to_sym)
    end

    def []=(attr_name, value)
      instance_variable_set("@#{attr_name}".to_sym, value)
    end

    def attributes_map
      self.class.attributes_map(self)
    end
  end

  module ClassMethods
    # A shortcut to declaring multiple attributes of the same type
    def attributes(collection, type, opts = {})
      collection.each { |name| attribute(name, type, opts) }
    end

    def attribute_names
      attribute_set.map(&:name)
    end

    # Iterates through all declared attributes in the form object, mapping its values
    def attributes_map(origin)
      attribute_set.map { |attr| [attr.name, origin.try(attr.name)] }.to_h
    end
  end
end
