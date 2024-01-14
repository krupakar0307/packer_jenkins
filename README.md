### Pre-baked AMIs with Jenkins_master and worker.

This consist of 2 folders one is jenkins_master and jenkins_agent.

Jenkins_master folder consists of jenkins AMI packer files, whick install required jenkins pre-requsistes and forms customized ami.
how to build ami: - steps are available in their respective folders.

Similarly jenkins_agent folder consists of packer files that creates an ami with pre-requsites needed for jenkins agent.

Once AMIs are available, just spin up the instance with this AMIs.