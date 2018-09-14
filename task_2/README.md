
# Project Title

1. Terraform templates to deploy a java app

### Prerequisites

1. Terraform v 0.11.3 (Other versions might support, not tested) 
```
https://www.terraform.io/downloads.html
```
2. AWS access key and secret key. Set them up
```
https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html
```

### How to run

1. Go inside terraform directory
```
cd terraform
```

2. Edit the terraform_secret.values file, the pupose of each variable mentioned in line.
```
vi terraform_secret.values 
```
For more fine tuning options, edit the terraform.values file.

3. Run terraform commands
```
terraform init
terraform plan -out=terraform.plan -var-file=terraform.values -var-file=terraform_secret.values 
terraform apply -state=terraform.state -var-file=terraform.values -var-file=terraform_secret.values 
```
Once the command promots for input, type 'yes'

4. At the end of execution, it will print a DNS (eg elb-glovostack-{somerandomnumbers}.{region}.elb.amazonaws.com) name. Hit it in the broswer. It takes a few mins for the nodes to fully initialize, so don't be disappointed if it does not work immediately.
```
http://elb-glovostack-{somerandomnumbers}.{region}.elb.amazonaws.com
https://elb-glovostack-{somerandomnumbers}.{region}.elb.amazonaws.com
```
### Verify
If everything works you'll see a page with the message
```
Hello Systems Engineer! :) (ip-xxx-xxx-xxx-xxx.ec2.internal)
```

## Versioning

Version 1.0

## Authors

* **Soumitra Kar**

