# Provider

[Docs overview | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

```json
provider "aws" {
  # profile = "default"
  region  = "us-east-2"
  access_key = "AKIAYSL2GUB6FTQRBZZQ"
  secret_key = "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"
}
```





# Resource

[aws_ami | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ami)

## EC2

![image-20220614161926792](readme.assets/image-20220614161926792.png)

```json
resource "aws_instance" "res-web" {
  ami           = "ami-0aeb7c931a5a61206"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
```



## VPC

[aws_vpc | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

### VPC Tenancy 

```
Default: 共享主机，价格便宜
Dedicated: 独占主机，价格昂贵
Default tenancy is shared. You and other customers all have VM's on the same hypervisor, and the separation is programmatic.

Dedicated tenancy means you're the only customer running anything on that host. Which is more expensive.

The only reason to use dedicated tenancy is if your servers are performing functions regulated heavily and require the additional separation.

I would highly recommend you study the material for the Cloud Practitioner test, as this is one of the most basic pieces of foundational information taught about the AWS infrastructures
```



### NAT Gateway

![image-20220614173220862](readme.assets/image-20220614173220862.png)

Private subnet 不能直接接入internet

public subnet 可以通过 internet gateway 接入 internet

如果private subnet也需要接入 internet，那么需要部署NAT gateway

```json
resource "aws_vpc" "res-main-vpc" {
  cidr_block       = "10.0.1.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "res-main-vpc"
  }
}
```





## Subnet

[aws_subnet | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)



```json
resource "aws_subnet" "res-subnet-01" {
  vpc_id     = aws_vpc.res-main-vpc.id
  cidr_block = "10.0.1.0/25"

  tags = {
    Name = "res-subnet-01"
  }
}

resource "aws_subnet" "res-subnet-02" {
  vpc_id     = aws_vpc.res-main-vpc.id
  cidr_block = "10.0.1.128/25"

  tags = {
    Name = "res-subnet-02"
  }
}
```







## ECR





## EKS









# Module









# Terraform show

```shell
$ terraform state list

$ terraform state show <list_item>
```

