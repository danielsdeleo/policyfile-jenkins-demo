policy_document_native_api true
versioned_cookbooks true

#chef_server_url "http://localhost:8889/organizations/demo-org"
chef_server_url "http://localhost:8889/"
client_key File.expand_path("../user.pem", __FILE__)
node_name "workstation"
