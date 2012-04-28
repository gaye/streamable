class SendToAmazonJob < Struct.new(:stream_id)
  def perform
    Stream.find(stream_id).async_send_to_s3
  end
end
