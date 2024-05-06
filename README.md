# Technical Task: Local Kubernetes Development Cluster Setup

*Objective:*
Design and develop a script that allows users to quickly spin up a local development Kubernetes cluster with specific requirements.
The solution should streamline the setup process and manage the deployment of necessary dependencies efficiently.

## Requirements:

Cluster Configuration:

- The script must set up a local Kubernetes cluster consisting of 3 nodes, each running on separate VMs.
- The solution should be operable on both macOS and Ubuntu systems.
- You may base your script on an existing project like [this example on GitHub](https://github.com/moukoublen/kubernetes-cluster),
  but ensure to customize or enhance it as per the task needs.

Functionality:

- The script must automate the entire setup process, waiting until the cluster is fully ready before proceeding to the next steps.
- Once the cluster setup is ready, the script should automatically install and, if necessary, update the dependencies required by our software stack.
  Check deps.sh to see how to install the required dependencies.
- If the cluster is already running, the script should skip the setup phase and only focus on installing or updating the required dependencies.
- After installing/updating dependencies the script should report that the cluster is now ready for confidential mind stack helm install

## Deliverables:

1. Implementation Description:

- Briefly explain your implementation approach. Provide a clear, concise description of how your script works,

So based on the project the reuqirement was to implement a method where i utilised the project which was on https://github.com/moukoublen/kubernetes-cluster, key changes is what i did  including any significant design decisions and technologies used (e.g., Ansible, Multipass, cri-o, kubeadm, Calico, etc)

1) The multipass VM creation was via bash scripting and the stack deployment via ansible so there was mix of two different scripting approach which required hopping from script to script, so i converted the bash code of multipass vm creation to ansible.
2) The whole execution consisted of tasks which involved playbook and galaxy executions so i moved it into playbooks and added the galaxy executions in scripts
3) I have moved the package and application deployments to playbooks (caveat i have an assumption that helm and kubectl is already installed, but if its an ambuguity i have added a playbook and relevant execution.)
4) One change which i wanted to introduce here was to introduce minikube and dockerd in place of k8 and cri-o for lightweight deployment in developers system but again in this scope i assume we will be dealing with heavyweight tasks involving GPU. still i have created a small script installation_script.sh we can explore this as an option if developers want to have a lightweight deployment.
5) For networking i have chosen calico because it supports multiple dataplane as opposed to cilium and has OOB support for istio and it has broad support for different kubernetes platform.
6) The reason for choosing ansible is it can run in multiple OS without any significant issues.

To spin up the environment please run the script create.sh from the project root, and to spin down please execute destroy.sh 
 
- Include a link to a Git repository containing your script or send the files as reponse to the email.

[link here ](https://github.com/Ghoshaya1/AIDevOps)

2. GPU Access from Kubernetes Pods:

- Describe whether it is possible for pods in the cluster to access the GPU on the host machine.
  Provide a brief explanation of the key configurations or changes needed to enable this capability,
  focusing on the conceptual level without implementing the solution.

Yes GPU access is possible on the host machine provided the below configs are done
GPU device plugin is installed which can be accessed by the kubernetes api if it is successfully installed it exposes a csr like amd.com/gpu or nvidia.com/gpu based on the vendor.

to deploy GPU enabled pods we need to use the limit & requests section (format vendor.com/gpu:)but both the values should be the same.
As a best practise it is rquired that we always label the nodes having GPU under the hood so that we can utilise that in a scenario where we want to deploy pods on GPU enabled nodes using nodeAffinity
One another way is to automating pod deployments on nodes with GPU is to utilize Node Feature discovery NFD, where a pod runs and detects all the feature available and creates a feature label, so at the time of deployment we can explicitly mention those feature label and during deployment the nodes with the required feature label for GPU are selected and other nodes are tainted.

3. Local vs. On-Premises Deployment:

- Describe how your local development setup might differ from an on-premises installation at a client company.
  Outline briefly what adaptations or enhancements would be necessary to make your script suitable for on-premises deployment,
  considering factors like security, scalability, and environmental differences.

The setup which i have created can service both local and on-premises deployment although with the below caveat

1) Client may not go with Multipass solution
2) in some cases the deployment will only be required for the application playbook and not other infrastructure related playooks
3) from a security POW yes this setup will require additional options like signed certificate for middleware and ip blocking which can be easily applied in the application deployment playbook
4) Inventory file needs to be manually updated with host IP's
5) In case of GPU related deployments we need to modify the GPU parameters i.e pod deployments to accomodate the changes because usage may differ from client to client
6) Keycloak Realm changes will be required, most of the clients may require custom realm imports for keycloak so in this scenario we might need to add another section in the playbook to enable custom realm imports
