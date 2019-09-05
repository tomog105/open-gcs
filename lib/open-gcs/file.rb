require "google/cloud/storage"
require "tempfile"

module OpenGCS
  module File
    STORAGE_OPTION_KEYS = %i(
      project_id
      credentials
      scope
      retries
      timeout
      endpoint
      project
      keyfile
    )
    DOWNLOAD_OPTION_KEYS = %i(
      verify
      encryption_key
      range
      skip_decompress
    )
    OPTION_KEYS = STORAGE_OPTION_KEYS + DOWNLOAD_OPTION_KEYS

    def self.download(bucket, filename, **options)
      storage = Google::Cloud::Storage.new(**options.select { |o, v| v && STORAGE_OPTION_KEYS.include?(o) })
      file = storage.bucket(bucket, skip_lookup: true).file(filename, skip_lookup: true)

      tf = Tempfile.open(["open-gcs"])
      file.download(tf.path, **options.select { |o, v| v && DOWNLOAD_OPTION_KEYS.include?(o) })
      tf
    end
  end
end
