# Demo App. Deploys Jenkins in a VM with a Policyfile

This repo is demo content for showing the Policyfile feature of ChefDK.

## Prerequisites:

* VM automation tooling doesn't support `chef-client` policyfile mode,
so you have to bring your own VM with `chef-client` installed.
* ChefDK 0.3.0; This isn't released as of this writing, so you have to
run off of master (which implies you need to set `BUNDLE_GEMFILE` and
run the `chef` commands via `bundle exec`).

## Running the Demo:

Start your VM, then run `bin/serve` to start Chef Zero (via `knife serve`).
This runs in the foreground, so leave it running.

To compile the policy from scratch, `rm Policyfile.lock.json`, then run
`chef install`. You should have a `Policyfile.lock.json` describing your
cookbook bundle in the current directory, and the cookbooks should be
installed to `~/.chefdk/cache/cookbooks`.

To demonstrate installation of locked cookbooks, you can blow away your
`~/.chefdk/cache/cookbooks` directory and re-run `chef install`.

To upload the cookbooks and policy, run `chef push demo -c etc/zero.rb`
Your data should now be copied to Chef Zero's storage dir which is the
`chef-zero-cache` dir located in the current working directory.

Login to your VM via SSH, using ssh to tunnel port 8889 to the VM (edit
`bin/login.sh` with your username and VM's hostname to make this easier):

```
ssh -R 8889:localhost:8889 USER@HOST
```

Use the following `/etc/chef/client.rb`:

```ruby
# Enables policyfile mode:
use_policyfile true

# This means you want the policy named 'jenkins' as applied to the
# 'demo' group:
deployment_group 'jenkins-demo'

# A good idea
ssl_verify_mode :verify_peer

# Tunneled Chef Zero
chef_server_url "http://localhost:8889"
```

Copy `etc/clientnode.pem` from this repo to `/etc/chef/client.pem` on
the VM.

### Patch Client Bug

In 11.16 and lower, `chef-client` has a bug in policyfile mode. To check
for the bug, run 

```
grep -n api_service /opt/chef/embedded/lib/ruby/gems/1.9.1/gems/chef-11.16.2/lib/chef/policy_builder/policyfile.rb
```

If you see:

```
160:        Chef::Cookbook::FileVendor.on_create { |manifest| Chef::Cookbook::RemoteFileVendor.new(manifest, api_service) }
```

Then change that line to:

```ruby
Chef::Cookbook::FileVendor.on_create { |manifest| Chef::Cookbook::RemoteFileVendor.new(manifest, http_api) }
```

A fix for this is in master, but wasn't released with 11.16.x


Now run `chef-client`, it will create a working Jenkins master for you.


