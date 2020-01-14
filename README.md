# terraform-aws-flask
This is an example how you can run flask helloworld on amazon EC2 conatainer by terraform script.
To run this example you need install [awscli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) and run `aws configure` on the machine that will runing the terraform script.
This will login you in aws and configure default aws config profile on your machine.

## How to run
Enter a deployment directory and run make target

```shell
cd deployment
make tf/init
make tf/apply
```

To see what targets you have run

```shell
make help
```

**Dont forget to open SSH and WEB port in your Defaul AWS EC2 Security Group.**


