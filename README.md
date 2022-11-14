Olá Guilherme,

Seguindo a nossa entrevista de sexta-feira, propomos o seguinte desafio:

1. Criação de uma infra-estrutura em cloud (Cloud à tua escolha) utilizando Terraform composta pelos seguintes elementos:
   a) um cluster simples de kubernetes (sem acesso externo);
   b) uma máquina "bastion" que permita acesso ao cluster de kubernetes e que exponha a porta ssh para login remoto;
   c) uma virtual network que permita unir estes elementos adequadamente.

2. Instalação e configuração de um cluster de Apache Kafka neste cluster anterior.

Deve ter pelo menos dois nós, e poderá utilizar/adaptar helm charts existentes embora, poderá ser alvo de perguntas durante a revisão do desafio numa 
entrevista posterior, pelo qual deve conhecer bem a ferramenta Helm.

Poderá completar o desafio até dia 14 de Novembro ao final do dia. Idealmente, até ao dia 11 de Novembro.

```

Using variables.tf:
```
### EKS
terraform
  module "eks" {
  source  = "terraform-aws-modules/eks/aws"

  aws-region          = var.aws-region
  availability-zones  = var.availability-zones
  cluster-name        = var.cluster-name
  k8s-version         = var.k8s-version
  node-instance-type  = var.node-instance-type
  root-block-size     = var.root-block-size
  desired-capacity    = var.desired-capacity
  max-size            = var.max-size
  min-size            = var.min-size
  vpc-subnet-cidr     = var.vpc-subnet-cidr
  private-subnet-cidr = var.private-subnet-cidr
  public-subnet-cidr  = var.public-subnet-cidr
  ec2-key-public-key  = var.ec2-key
}
```
### IAM

The AWS credentials must be associated with a user having at least the following AWS managed IAM policies

* IAMFullAccess
* AutoScalingFullAccess
* AmazonEKSClusterPolicy
* AmazonEKSWorkerNodePolicy
* AmazonVPCFullAccess
* AmazonEKSServicePolicy
* AmazonEKS_CNI_Policy
* AmazonEC2FullAccess
```
*EKS*

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        }
    ]
}
```

### Terraform

You need to run the following commands to create the resources with Terraform:

```bash
terraform init
terraform plan
terraform apply
```

Save architeture in tfstate `terraform plan -out eks-state` 
** This project wasn´t save in S3 storage but it can [S3 backend](https://www.terraform.io/docs/backends/types/s3.htm

### Setup kubectl

Setup your `KUBECONFIG`

```bash
terraform output kubeconfig > ~/.kube/eks-cluster
export KUBECONFIG=~/.kube/eks-cluster
```

### Authorize users to access the cluster

Initially, only the system that deployed the cluster will be able to access the cluster. To authorize other users for accessing the cluster, `aws-auth` config needs to be modified by using the steps given below:

* Open the aws-auth file in the edit mode on the machine that has been used to deploy EKS cluster:

```bash
sudo kubectl edit -n kube-system configmap/aws-auth
```

* Add the following configuration in that file by changing the placeholders:


```yaml

mapUsers: |
  - userarn: arn:aws:iam::111122223333:user/<username>
    username: <username>
    groups:
      - system:masters
```

So, the final configuration would look like this:

```yaml
apiVersion: v1
data:
  mapRoles: |
    - rolearn: arn:aws:iam::555555555555:role/devel-worker-nodes-NodeInstanceRole-74RF4UBDUKL6
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
  mapUsers: |
    - userarn: arn:aws:iam::111122223333:user/<username>
      username: <username>
      groups:
        - system:masters
```

* Once the user map is added in the configuration we need to create cluster role binding for that user:

```bash
kubectl create clusterrolebinding ops-user-cluster-admin-binding-<username> --clusterrole=cluster-admin --user=<username>
```

```bash
terraform plan -destroy
terraform destroy  --force
```
