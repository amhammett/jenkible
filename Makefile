VAULT_PASSWORD_FILE = --vault-password-file ~/.secrets/jenkins.vault
ANSIBLE_VAULT = $(shell which "ansible-vault" 2>/dev/null || echo "/usr/bin/ansible-vault" ) ${VAULT_PASSWORD_FILE}
ANSIBLE_PLAYBOOK = $(shell which "ansible-playbook" 2>/dev/null || echo "/usr/bin/ansible-playbook" )
ANSIBLE_CMD = ${ANSIBLE_PLAYBOOK} ${VAULT_PASSWORD_FILE}

# rewrite account
ifneq ($(strip $(aws_account)),)
  ANSIBLE_CMD=AWS_PROFILE=$(aws_account) ${ANSIBLE_PLAYBOOK} ${VAULT_PASSWORD_FILE}
  a=-e aws_account=$(aws_account)
else
  a=
endif

# rewrite env
ifneq ($(strip $(env)),)
  e=-e env=$(env)
else
  e=
endif

# check flag
ifneq (,$(findstring check,$(MAKECMDGOALS)))
  check=--check
else
  check=
endif

# rewrite region
ifneq (,$(findstring -, $(aws_region)))
  r=-e aws_region=$(aws_region)
else
  r=
endif

# rewrite commit
ifneq ($(strip $(commit)),)
  c=-e commit=$(commit)
else
  c=
endif

help:
## show this help
	@echo 'Available make targets:'
	@echo ''
	@grep -B1 '^## .*' ${MAKEFILE_LIST} | grep -v -- '^--$$' | sed -e 's/^## /	/' -e 's/^\([^:]*\):.*/  \1/'
	@echo ''

jenkins:
## provision and configure a jenkins prime server
	${ANSIBLE_CMD} jenkins.yml $(e) $(a) $(r) $(c) $(debug) $(check)

jenkins-deploy:
## configure a jenkins prime server
	${ANSIBLE_CMD} jenkins-deploy.yml $(e) $(a) $(r) $(c) $(debug) $(check)

jenkins-service:
## jenkins service [started|stopped|restarted|reloaded]
	${ANSIBLE_CMD} jenkins-service.yml $(e) $(a) $(r) -e state=$(state)

minion:
## provision and apply base configuration a jenkins minion server
	${ANSIBLE_CMD} minion.yml $(e) $(a) $(r) $(c) $(debug) $(check)

minion-ansible:
## apply ansible configuration to jenkins minion
	${ANSIBLE_CMD} minion-ansible.yml $(e) $(a) $(r) $(c) $(debug) $(check)

minion-python2:
## apply ansible configuration to jenkins minion
	${ANSIBLE_CMD} minion-python2.yml $(e) $(a) $(r) $(c) $(debug) $(check)

minion-python3:
## apply ansible configuration to jenkins minion
	${ANSIBLE_CMD} minion-python3.yml $(e) $(a) $(r) $(c) $(debug) $(check)

minion-node:
## apply ansible configuration to jenkins minion
	${ANSIBLE_CMD} minion-node.yml $(e) $(a) $(r) $(c) $(debug) $(check)

check:
## hack for check flag
	@echo check mode applied

edit-secrets:
## Edit staging secrets
	${ANSIBLE_VAULT} edit vars/secrets.yml
