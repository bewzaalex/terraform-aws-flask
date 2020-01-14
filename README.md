# terraform-aws-flask
This is an example how you can run flask helloworld on amazon EC2 conatainer by terraform script.
To run this example you need login in to AWS with credentials that have permissions to create and modify EC2 containers.
Command `make tf/init` check if `awscli` and `terraform` is installed in your system. Install it if not fouded (required sudo permissions). If you dont like to give this script sudo password install awscli and terraformcli by yourself first. Than `make tf/init` will login into aws and store credentials in default profile that be used in `make tf/apply`.

## How to run
Enter in the deployment directory and run make target

```shell
cd deployment
make tf/init
make tf/apply
```

To see what targets you also have

```shell
make help
```

**Dont forget to open SSH and WEB port in your Defaul AWS EC2 Security Group.**


