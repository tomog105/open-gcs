require "test_helper"

class OpenGCSTest < Test::Unit::TestCase
  def setup
    @data = "foobarbaz\r\n"
    # Returning unauthenticated client
    stub(Google::Cloud::Storage).new { Google::Cloud::Storage.anonymous }
  end

  def test_success
    _stub_gcs_download
    f = OpenGCS.open_gcs("gs://test_bucket/foo")
    assert_instance_of File, f
    assert File.exist?(f.path)
    assert { @data == f.read }
  end

  def test_unlink_tempfile_if_block_given
    _stub_gcs_download
    path = nil
    OpenGCS.open_gcs("gs://test_bucket/foo") do |f|
      path = f.path
      assert File.exist?(f.path)
    end
    assert_false File.exist?(path)
  end

  def test_success_with_mode_arg
    _stub_gcs_download
    f = OpenGCS.open_gcs("gs://test_bucket/foo", "rt")
    assert { @data.gsub("\r\n", "\n") == f.read }
  end

  def test_success_with_mode_enc_arg
    data = "テスト文字列".encode("Shift_JIS")
    _stub_gcs_download(data)
    f = OpenGCS.open_gcs("gs://test_bucket/foo", "rt:Shift_JIS")
    assert { data == f.read }
  end

  def test_success_with_mode_option
    _stub_gcs_download
    f = OpenGCS.open_gcs("gs://test_bucket/foo", mode: "rt")
    assert { @data.gsub("\r\n", "\n") == f.read }
  end

  def test_error_with_uri_is_not_gcs_object
    assert_raise(ArgumentError) { OpenGCS.open_gcs("/tmp/foo/bar") }
  end

  def test_error_with_mode_arg_is_not_read_only
    assert_raise(ArgumentError) { OpenGCS.open_gcs("gs://test_bucket/foo", "r+") }
  end

  def test_error_with_mode_option_is_not_read_only
    assert_raise(ArgumentError) { OpenGCS.open_gcs("gs://test_bucket/foo", mode: "r+") }
  end

  def _stub_gcs_download(data = @data)
    # Replace of `Google::Cloud::Storage::File.download`
    any_instance_of(Google::Cloud::Storage::File) do |klass|
      stub(klass).download do |path|
        File.open(path, "wb") do |f|
          f.write data
          f.flush
        end
      end
    end
  end
end
