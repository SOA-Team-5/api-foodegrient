require "aws-sdk-s3"
require 'httpclient'
require 'net/http'

# Wraps Amazon S3 object actions.
class ObjectPutWrapper
  attr_reader :object

  # @param object [Aws::S3::Object] An existing Amazon S3 object.
  def initialize(object)
    @object = object
  end

  def put_object(url)
    # client = HTTPClient.new
    # cont = client.get_content url
    uri = URI(url)
    cont = Net::HTTP.get(uri)
    # File.open(source_file_path, "rb") do |file|
    #   @object.put(body: file)
    # end
    @object.put(body: cont)
    true
  rescue Aws::Errors::ServiceError => e
    puts "Couldn't, Here's why: #{e.message}"
    false
  end
#   def object_uploaded?(bucket_name, object_key)
#     response = $CFR2.put_object(
#       bucket: bucket_name,
#       key: object_key
#     )
#     if response.etag
#       return true
#     else
#       return false
#     end
#   rescue StandardError => e
#     puts "Error uploading object: #{e.message}"
#     return false
#   end
end

def run(key, url)
  bucket_name = "foodegrient"
  object_key = key
#   file_path = "my-local-file.txt"

  wrapper = ObjectPutWrapper.new(Aws::S3::Object.new(bucket_name, object_key))
  success = wrapper.put_object(url)
  return unless success

  puts "Put file #{url} into #{object_key} in #{bucket_name}."
end

run_demo if $PROGRAM_NAME == __FILE__