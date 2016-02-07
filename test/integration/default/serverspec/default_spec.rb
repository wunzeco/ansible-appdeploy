require 'spec_helper'

app_user = 'eeuser'
app_group = app_user
app_name = 'products'
app_version = '0.0.1'
app_port = 9080
app_work_dir = "/opt/ee/#{app_name}"
app_log_dir = "/var/log/#{app_name}"

describe group(app_group) do
  it { should exist }
end

describe user(app_user) do
  it { should exist }
  it { should belong_to_group app_group }
end

describe file(app_work_dir) do
  it { should be_directory }
  it { should be_owned_by app_user }
  it { should be_mode 755 }
end

describe file(app_log_dir) do
  it { should be_directory }
  it { should be_owned_by app_user }
  it { should be_mode 755 }
end

describe file("/etc/init/#{app_name}.conf") do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_mode 644 }
end

%W( 
  bin/#{app_name}
  lib/#{app_name}-#{app_version}.jar
  config/config.yml 
).each do |f|
  describe file("#{app_work_dir}/#{f}") do
    it { should be_file }
    it { should be_owned_by app_user }
  end
end

describe service(app_name) do
  it { should be_running }
end

describe port(app_port) do
  it { should be_listening }
end
