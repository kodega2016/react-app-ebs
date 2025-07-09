# Deploy React Application to Elastic Beanstalk using Github Actions and provision with terraform

We are going to explore how we can provision the elastic beanstalk application in aws using terraform
and deploy containerized react application.

First of all,lets create elastic beantalk using the terraform.For this we must have terraform cli installed
and also we have aws credentials setup or you can set aws cli using the following guidelines.

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html

We can verify which aws identity is set using the following command.

```bash
aws sts get-caller-identity
```

After,the successul crenetials setup, lets create terraform scripts to create required resources.We
have defined the required variables in variables.tf file with the following structure.

```hcl
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

#### This is the configuration for the AWS Elastic Beanstalk application ####

variable "application_name" {
  description = "The name of the Elastic Beanstalk application"
  type        = string
  default     = "react-app"
}
```

We must have ec2 instance profile and service role for elastic beanstalk so to create such profile and role
we have defined the resources inside iam.tf file.

```hcl
resource "aws_iam_role" "eb_ec2_role" {
  name = "aws-elasticbeanstalk-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "aws-elasticbeanstalk-ec2-profile"
  role = aws_iam_role.eb_ec2_role.name
}

resource "aws_iam_role_policy_attachment" "eb_ec2_managed_policy" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

```

And we also attached the required permissions.
We also need security group for the elastic beanstalk to we created in sg.tf file
which allow http traffic from anywhere.

```hcl
urce "aws_security_group" "this" {
  name        = "react-app-allow-http"
  description = "Allow http and https inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id
  tags = {
    Name = "react-app-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}
```

After that we have defined the application resources in `ebs.tf` file.
```hcl
resource "aws_elastic_beanstalk_application" "this" {
  name        = var.application_name
  description = "This is a React application deployed on AWS Elastic Beanstalk"
}

resource "aws_elastic_beanstalk_environment" "this" {
  name                = var.environment_name
  application         = aws_elastic_beanstalk_application.this.name
  solution_stack_name = var.solution_stack_name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.this.id
  }
}
```

Here, we have defined additional configuration inside settings block of the configuration.We can
adjust the setting based on our requirements.

After all this,we can plan the terraform and apply to create the application.

```bash
terraform plan
terraform apply
```

We also defined the outputs of the resources,so that we can get the resources created by the
terraform scripts.

After the resources is created,we can deploy the application using Gtihub Actions.We have
set the secrets(AWS_REGION,AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY) in the repository.

```yaml
name: EBS Deployment
on:
  push:
    branches:
      - main
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: checkout the code
        uses: actions/checkout@v4

      - name: build docker image and run unit test
        run: |
          docker image build . -t react-app-dev -f Dockerfile.dev
          docker container run -e CI=true react-app-dev npm run test

      - name: Generate deployment package
        run: zip -r deploy.zip . -x '*.git*'

      - name: Deploy to EB
        uses: einaregilsson/beanstalk-deploy@v22
        with:
          aws_access_key: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws_secret_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          application_name: dockerize-react-app
          environment_name: react-app-env
          version_label: ${{ github.sha }}
          region: ${{ secrets.AWS_REGION }}
          deployment_package: deploy.zip
          use_existing_version_if_available: true
```

Which trigger on push to main branch,we can adjust this also based on the requirements.This
will generate the deployment package and deploy our application to elastic beanstalk.