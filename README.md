Jenkible
========

Sample ansible code to provision, configure and deploy jenkins and minion hosts

## Usage

Playbooks can be run directly or via the Makefile. See `./Makefile` for more information

```bash
make jenkins aws_account=stg aws_region=us-west-2 env=prime
```

where
- aws_account is the name of your aws account/profile
- aws_region maps to the aws region
- env is the name of the environment

hosts created will be in the form of `jenkins-{{env}}-{{instance-type}}`

## Requirements

These playbooks expect that you have your

- aws profile credentials configured in `~/.aws/credentials`. These credentials should map to the aws_account variable defined above
- ssh keys stored within `~/.ssh/id_rsa.jenkins-{{aws_account}}`. These keys are used by ansible and set within the dynamic inventory

## Dynamic Inventory

See `./inventory` for more information. Current setup limits hosts that match `dyn_jenkins_{{env}}_prime` for jenkins prime servers


## Keys and Access

One key-pair is created per account.


## Vault

The secrets are stored in `./vars/secrets.yml` the file's password is not `notpassword`... or is it?

`Secrets.yml` is used to keep

- ssh keys
- other secrets


## ERROR!

```bash
ERROR! The file ./inventory/ec2.py is marked as executable
```

either you didn't specify aws_account or your aws_account wasn't found in `~/.aws/credentials`
