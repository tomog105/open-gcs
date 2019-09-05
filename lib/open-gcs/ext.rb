require "open-gcs"

module OpenGCSExt
  refine File.singleton_class do
    def open(uri, *rest, **options, &block)
      if OpenGCS.get_path_info(uri).first == OpenGCS::TARGET_SCHEME
        OpenGCS.open_gcs(uri, *rest, **options, &block)
      else
        super
      end
    end
  end
end
