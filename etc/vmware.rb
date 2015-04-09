policy_document_native_api true
versioned_cookbooks true

chef_server_url "https://192.168.99.144/organizations/ecs"
client_key File.expand_path("../erchef-admin.pem", __FILE__)
node_name "admin"

ssl_verify_mode :verify_none
