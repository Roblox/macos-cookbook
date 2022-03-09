resource_name :certificate

property :certfile, String
property :cert_password, String, sensitive: true
property :keychain, String
property :kc_passwd, String, required: true, sensitive: true
property :apps, Array, default: []
property :user, String
property :sensitive, [true, false], default: false

action_class do
  def keychain
    new_resource.property_is_set?(:keychain) ? new_resource.keychain : ''
  end
end

action :install do
  cert = SecurityCommand.new(new_resource.certfile, keychain)

  execute 'unlock keychain' do
    command [*cert.unlock_keychain(new_resource.kc_passwd)]
    user new_resource.user
    sensitive new_resource.sensitive
  end

  execute 'install-certificate' do
    command [*cert.install_certificate(new_resource.cert_password, new_resource.apps)]
    user new_resource.user
    sensitive new_resource.sensitive
  end
end
