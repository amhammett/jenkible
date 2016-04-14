Jenkins-Ansible
===============

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

These playbooks expect that you have your aws profile credentials configured in `~/.aws/credentials`

These credentials should map to the aws_account variable defined above
