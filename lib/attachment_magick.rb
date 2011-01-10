require "attachment_magick/configuration/configuration"
require "attachment_magick/dragonfly/dragonfly_mongo"
require "attachment_magick/dsl"
require "attachment_magick/image"

module AttachmentMagick
  attr_accessor :attachment_magick_default_options
  
  class << self
    attr_accessor :configuration
  end
  
  def self.setup
    self.configuration ||= Configuration.new
    yield(configuration)
  end
  
  def attachment_magick(&block)
    embeds_many :images, :class_name => "AttachmentMagick::Image"
    
    default_grids = generate_grids
    map           = DSL.new(self, default_grids)
    map.instance_eval(&block)
        
    @attachment_magick_default_options = {:styles => map.styles || default_grids}
    grid_methods  
  end

  def generate_grids(column_amount=19, column_width=54, gutter=0, only=[])
    hash = {}
    grids_to_create = only.empty? ? 1.upto(column_amount) : only
    
    grids_to_create.each do |key|
      grid  = ("grid_#{key}").to_sym
      value = (key * column_width) + (gutter * (key - 1))
      hash.merge!({grid => {:width => value}})
    end
    
    AttachmentMagick.configuration.custom_styles.styles.each do |key, value|
      option = value
      if value.is_a?(String)
        width, height = value.split("x")
        option        = {:width => width.to_i}
        option.merge!({:height => height.to_i}) if height
      end
      
      hash.merge!({key.to_sym => option})
    end

    return hash
  end
  
  def grid_methods
    @attachment_magick_default_options[:styles].each do |key, value|
      define_method "#{key.to_s}" do
        metric = "#{value[:width]}x#{value[:height]}"
        metric = "#{metric}#" if value[:height]
        
        return metric
      end
    end
  end
  
  private :generate_grids
  private :grid_methods
end