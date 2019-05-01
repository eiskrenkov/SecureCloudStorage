require 'active_storage/service/s3_service'

module ActiveStorage # rubocop:disable Style/ClassAndModuleChildren
  class Service::EncryptedS3Service < Service::S3Service
    attr_reader :encryption_client

    def initialize(bucket:, upload: {}, **options)
      super(bucket: bucket, upload: upload, **options.except(:kms_key_id))
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
        ).body
      end
    end

    def download_chunk(key, range)
      raise NotImplementedError
    end
  end
end
