module YolkClient
  class Entity

    def initialize(attrs={})
      self.class.defaults.each do |key, val|
        send(:"#{key.to_s}=", val)
      end

      attrs.each do |key, val|
        send(:"#{key.to_s}=", val) if self.respond_to?("#{key.to_s}=", true)
      end
      dirty_properties.clear
    end

    def self.property(property_name, opts={})
      property_name = property_name.to_sym

      @properties ||= []
      @properties << property_name unless @properties.include?(property_name)

      class_eval <<-PROPERTY, __FILE__, __LINE__ + 1
        def #{property_name}
          @#{property_name}
        end
        def #{property_name}=(val)
          (dirty_properties << :#{property_name}).uniq! unless val == @#{property_name}
          @#{property_name} = val
        end
      PROPERTY

      if opts[:immutable]
        private :"#{property_name}="
      end

      if opts[:default]
        @defaults ||= {}
        @defaults[property_name] = opts[:default]
      end
    end

    def self.attribute(attr_name, opts={})
      attr_name = attr_name.to_sym
      @attributes ||= []
      @attributes << attr_name
      self.property(attr_name, opts)
    end

    def self.properties
      @properties.freeze
    end

    def self.attributes
      @attributes.freeze
    end

    def self.defaults
      @defaults.freeze
    end

    def dirty_properties
      @dirty_properties ||= Array.new
    end

    def dirty_attributes
      dirty_properties & self.class.attributes
    end

    def dirty?(prop=nil)
      prop.nil? ? !@dirty_properties.empty? : @dirty_properties.include?(prop)
    end

    def update(properties_and_attributes)
      return unless properties_and_attributes
      properties_and_attributes.each do |key, val|
        send(:"#{key.to_s}=", val) if self.respond_to?("#{key.to_s}=")
      end
    end

    def clean
      @dirty_properties.clear
    end

    def [](key)
      respond_to?(:"#{key}") ? send(:"#{key}") : nil
    end

    def valid?
      errors.empty?
    end

    def errors
      {}
    end

    def to_hash
      (self.class.properties || []).inject({}) do |hash, key|
        hash[key] = send(key) if respond_to?(key)
        hash
      end
    end

    def inspect
      ret = "#<#{self.class.to_s}"
      self.class.properties.each do |key|
        ret << " #{key}=#{self.instance_variable_get("@#{key}").inspect}"
      end
      ret << ">"
      ret
    end
  end

end
