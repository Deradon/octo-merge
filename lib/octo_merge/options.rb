require "yaml"

module OctoMerge
  class Options
    def self.option(key)
      define_method(key) { self[key] }
    end

    option :login
    option :password

    option :dir
    option :pull_requests
    option :repo
    option :strategy

    def [](key)
      data[key]
    end

    def cli_options=(options)
      reset_cache
      @cli_options = options
    end

    private

    CONFIG_FILE = ".octo-merge.yml"
    DEFAULT_OPTIONS = {
      dir: ".",
      strategy: "MergeWithoutRebase"
    }
    USER_CONFIG_PATH = File.expand_path("~/#{CONFIG_FILE}")

    def data
      @data ||= begin
        options = default_options
          .merge(user_options)
          .merge(project_options)
          .merge(cli_options)


        # Sanitize input
        options[:dir] = File.expand_path(options[:dir])
        options[:strategy] = Object.const_get("OctoMerge::Strategy::#{options[:strategy]}")
        options[:pull_requests] = OctoMerge::InteractivePullRequests.get(options) if options[:interactive]
        options[:pull_requests] = options[:pull_requests].to_s.split(",")

        options
      end
    end

    def reset_cache
      @data = nil
    end

    def default_options
      DEFAULT_OPTIONS
    end

    def user_options
      if File.exist?(USER_CONFIG_PATH)
        body = File.read(USER_CONFIG_PATH)
        symbolize_keys YAML.load(body)
      else
        {}
      end
    end

    def project_options
      if File.exist?(CONFIG_FILE)
        body = File.read(CONFIG_FILE)
        symbolize_keys YAML.load(body)
      else
        {}
      end
    end

    def cli_options
      @cli_options ||= {}
    end

    def symbolize_keys(hash)
      hash.inject({}){ |memo, (k, v)| memo[k.to_sym] = v; memo }
    end
  end
end
