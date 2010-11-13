require 'yaml'

module FellowshipOneAPIClient # :nodoc:
  # This accesses the YAML-based F1 API config file
  # 
  # This class was written to take rails environment variables like +RAILS_ENV+ and +Rails.root+ into account
  class Configuration
    # Gets the specified key from the configuration file
    # [Example]    FellowshipTechAPIClient.Configuration["consumer_key"] <i># "2"</i><br />
    #              FellowshipTechAPIClient.Configuration["consumer_secret"] <i># "12345678-9abc-def0-1234-567890abcdef"</i>
    def self.[](value)
      load_yaml if @config_yaml.nil?
      @config_yaml[self.environment][value]
    end
    
    # Gets the current environment
    def self.environment
      @environment ||= "development" 
      @environment ||= ::Rails.env if defined? ::Rails
      @environment
    end
    
    # Set the current environment
    def self.environment=(env_value)
      @environment = env_value
    end
    
    # Overridden method_missing to facilitate a more pleasing ruby-like syntax for accessing
    # configuration values
    def self.method_missing(name, *args, &block)
      return self[name.to_s] unless self[name.to_s].nil?
      super
    end
    
    private
    
    # Load the YAML file
    def self.load_yaml
      if File.exists? "./f1-oauth.yml"
        @config_yaml = YAML.load_file("./f1-oauth.yml")
      elsif defined? ::Rails
        @config_yaml = YAML.load_file("#{::Rails.root}/config/f1-oauth.yml")
      else
        path = File.dirname(__FILE__) + "/../../config/f1-oauth.yml"
        @config_yaml = YAML.load_file(path)
      end
    end
  end
end
