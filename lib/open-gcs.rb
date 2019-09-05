require "uri"
require "open-gcs/file"
require "open-gcs/version"

module OpenGCS
  TARGET_SCHEME = "gs"

  def self.open_gcs(uri, *rest, **options, &block)
    scheme, bucket, path = get_path_info(uri)

    unless scheme == TARGET_SCHEME
      raise(ArgumentError, "Invalid uri: #{uri} (This method is only support for gcs object uri.")
    end

    if String === rest.first || Integer === rest.first
      mode = rest.first
    else
      mode = options[:mode]
    end
    if !mode.nil? && !mode.match?(/\Ar[bt]?(?:\Z|:([^:]+))/) && mode != ::File::RDONLY
      raise(ArgumentError, "Invalid access mode: #{mode}. (This method is only support for read mode.)")
    end

    begin
      tf = File.download(bucket, path, **options.select { |key| File::OPTION_KEYS.include?(key) })
      file = ::File.open(tf.path, *rest, **options.reject { |key| File::OPTION_KEYS.include?(key) })
      if block_given?
        begin
          yield file
        ensure
          tf.close!
        end
      else
        file
      end
    ensure
      tf&.close if tf&.path
    end
  end

  def self.get_path_info(uri)
    unless String === uri
      []
    else
      parsed_uri = URI.parse(uri)
      [*parsed_uri.select(:scheme, :host), parsed_uri&.path.delete_prefix("/")]
    end
  end
end
