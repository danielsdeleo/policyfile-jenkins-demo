name "jenkins"

default_source :community

run_list "apt", "java", "jenkins::master", "recipe[policyfile_demo]"

cookbook "policyfile_demo", path: "cookbooks/policyfile_demo"
