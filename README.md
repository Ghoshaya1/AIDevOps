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

To spin up the environment please run the script create.sh from the project root, and to spin down please execute destroy.sh 
 
- Include a link to a Git repository containing your script or send the files as reponse to the email.



2. GPU Access from Kubernetes Pods:

- Describe whether it is possible for pods in the cluster to access the GPU on the host machine.
  Provide a brief explanation of the key configurations or changes needed to enable this capability,
  focusing on the conceptual level without implementing the solution.

3. Local vs. On-Premises Deployment:

- Describe how your local development setup might differ from an on-premises installation at a client company.
  Outline briefly what adaptations or enhancements would be necessary to make your script suitable for on-premises deployment,
  considering factors like security, scalability, and environmental differences.
