require 'active_storage/service/s3_service'
require 'openssl'

module ActiveStorage
  class Service::EncryptedS3Service < Service::S3Service
    attr_reader :encryption_client

    def initialize(bucket:, upload: {}, **options)
      options[:encryption_key] = OpenSSL::PKey::RSA.new(1024)
      super(bucket: bucket, upload: upload, **options.except(:encryption_key))
      @encryption_client = Aws::S3::Encryption::Client.new(options)
    end

    def upload(key, io, checksum: nil, **)
      instrument :upload, key: key, checksum: checksum do
        encryption_client.put_object(
          upload_options.merge(
            body: io,
            content_md5: checksum,
            bucket: bucket.name,
            key: key
          )
        )
      rescue Aws::S3::Errors::BadDigest
        raise ActiveStorage::IntegrityError
      end
    end

    def download(key, &block)
      raise NotImplementedError if block_given?

      instrument :download, key: key do
        encryption_client.get_object(
          bucket: bucket.name,
          key: key
        ).body.string.force_encoding(Encoding::BINARY)
      end
    end

    def download_chunk(key, range)
      raise NotImplementedError
    end
  end
end
