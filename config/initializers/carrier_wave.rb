if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Amazon S3用の設定
      provider: 'AWS',
      aws_access_key_id: Rails.application.credentials.s3[:aws_access_key_id],
      aws_secret_access_key: Rails.application.credentials.s3[:aws_secret_access_key],
      region: 'ap-northeast-1'
    }
    config.fog_directory = 'tabipla'
    config.cache_storage = :fog
  end
end