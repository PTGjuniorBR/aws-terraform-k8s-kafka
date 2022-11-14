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

Using variables.tf or a tfvars file:

```terraform
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
```
