# # Initialize AWS configuration
# unless Rails.env.test?
#   Aws.config = {
#     access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
#     secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
#     region: Rails.application.credentials.dig(:aws, :region)
#   }
# end