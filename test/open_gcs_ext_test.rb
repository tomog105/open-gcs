require "test_helper"
require "open-gcs/ext"

class OpenGCSExtTest < Test::Unit::TestCase
  using OpenGCSExt

  def test_success
    mock(OpenGCS).open_gcs("gs://test_bucket/foo", {}) { true }
    assert File.open("gs://test_bucket/foo")
  end

  def test_not_gcs_object
    dont_allow(OpenGCS).open_gcs
    Tempfile.open(["test-open-gcs-ext"]) do |fp|
      assert File.open(fp.path)
    end
  end
end
