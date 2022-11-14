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
```terraform
module "eks" {
  source  = "WesleyCharlesBlake/eks/aws"

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
  db-subnet-cidr      = var.db-subnet-cidr
  eks-cw-logging      = var.eks-cw-logging
  ec2-key-public-key  = var.ec2-key
}
```

### IAM

As credenciais da AWS devem estar associadas a um usuário que tenha pelo menos as seguintes políticas de IAM gerenciadas pela AWS

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

```bash
terraform init
terraform plan
terraform apply
```

Salvar arquitetura em tfstate `terraform plan -out eks-state`
** Este projeto não foi salvo no armazenamento S3, mas poderia [S3 backend](https://www.terraform.io/docs/backends/types/s3.htm

### Setup kubectl

Setup your `KUBECONFIG`

```bash
terraform output kubeconfig > ~/.kube/eks-cluster
export KUBECONFIG=~/.kube/eks-cluster
```

### Autorizar usuários a acessar o cluster

Inicialmente, apenas o sistema que implantou o cluster poderá acessar o cluster. Para autorizar outros usuários a acessar o cluster, a configuração `aws-auth` precisa ser modificada usando as etapas abaixo:

* Abra o arquivo aws-auth no modo de edição na máquina que foi usada para implantar o cluster EKS:

```bash
sudo kubectl edit -n kube-system configmap/aws-auth
```

* Adicione a seguinte configuração nesse arquivo alterando os espaços reservados:


```yaml

mapUsers: |
  - userarn: arn:aws:iam::111122223333:user/<username>
    username: <username>
    groups:
      - system:masters
```
A configuração final deve ficar assim, ex:

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

* Depois que o mapa do usuário for adicionado à configuração, precisamos criar a vinculação de função do cluster para esse usuário:

```bash
kubectl create clusterrolebinding ops-user-cluster-admin-binding-<username> --clusterrole=cluster-admin --user=<username>
```

```bash
terraform plan -destroy
terraform destroy  --force
```
