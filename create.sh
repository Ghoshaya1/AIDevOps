#!/bin/bash

# Execute the playbook for setting up Multipass
ansible-playbook multipass_setup.yml

# Install collections and roles using ansible-galaxy
ansible-galaxy install -r requirements.yml
ansible-galaxy install -r disable-swap.yml

# Uncomment the below playbook if you need to install helm and kubectl on your localsystem
# ansible-playbook  kubectl_helm_playbook.yml

# Execute the playbook for tasks with the updated inventory
ansible-playbook -u ubuntu -i inventory --private-key ./keys/multipass-ssh-key tasks_playbook.yml

# Execute the playbook to retrieve kubeconfig
ansible-playbook -u ubuntu -i inventory --private-key ./keys/multipass-ssh-key get_kubeconfig.yml

# Execute the playbook to deploy applications
ansible-playbook deploy_application.yml

# Print a message indicating that the stack is up
echo "The cluster is now ready for confidential mind stack helm install"