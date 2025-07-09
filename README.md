# Dockerize Application to EBS

<!--toc:start-->

- [Dockerize Application to EBS](#dockerize-application-to-ebs)
<!--toc:end-->

We are going to deploy a Dockerized react application to AWS Elastic Beanstalk (EBS).

So first, we need to create a Dockerfile for our React application. The Dockerfile
will define how our application is built and run in a container.

After that we have created infrastructure using Terraform to deploy our Dockerized
application to AWS Elastic Beanstalk.

After,the elastic beanstalk application is created,we are using github actions to
deploy our application to EBS.

> [!NOTE]
> We need to create an application in the EBS console first.We
> must have service role and ec2 instance profile.
>
> - service role: `aws-elasticbeanstalk-service-role`
> - ec2 instance profile: `aws-elasticbeanstalk-ec2-role`
