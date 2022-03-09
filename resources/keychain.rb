resource_name :keychain
default_action :create

property :kc_file, String
property :kc_passwd, String, sensitive: true
property :user, String
property :sensitive, [true, false], default: false

action_class do
  def keychain
    new_resource.property_is_set?(:kc_file) ? new_resource.kc_file : nil
  end
end

action :create do
  keyc = SecurityCommand.new('', keychain)

  execute 'create a keychain' do
    command [*keyc.create_keychain(new_resource.kc_passwd)]
    sensitive new_resource.sensitive
    user new_resource.user
    not_if { ::File.exist?(keychain) }
  end
end

action :delete do
  keyc = SecurityCommand.new('', keychain)
  execute 'delete selected keychain' do
    command [*keyc.delete_keychain]
    sensitive new_resource.sensitive
    user new_resource.user
    only_if { ::File.exist?(keychain) }
  end
end

action :lock do
  keyc = SecurityCommand.new('', keychain)
  execute 'lock selected keychain' do
    command [*keyc.lock_keychain]
    sensitive new_resource.sensitive
    user new_resource.user
    only_if { ::File.exist?(keychain) }
  end
end

action :unlock do
  keyc = SecurityCommand.new('', keychain)
  execute 'unlock selected keychain' do
    command [*keyc.unlock_keychain(new_resource.kc_passwd)]
    sensitive new_resource.sensitive
    user new_resource.user
    only_if { ::File.exist?(keychain) }
  end
end
