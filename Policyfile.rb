name "jenkins"

default_source :supermarket
default_source :chef_repo, "cookbooks"

run_list "apt:oops", "java", "jenkins::master", "recipe[policyfile_demo]"

named_run_list :update_jenkins, "jenkins::master", "recipe[policyfile_demo]"

default["greeting"] = "Attributes, f*** yeah"

override["attr_only_updating"] = "use -a"
