resource "aws_ssm_document" "run_ansible_playbook" {
  name          = "RunAnsiblePlaybook"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "1.2",
    "description": "Run Ansible Playbook from Git",
    "parameters": {

    },
    "runtimeConfig": {
      "aws:runShellScript": {
        "properties": [
          {
            "id": "0.aws:runShellScript",
            "runCommand": [
              "sudo apt-add-repository ppa:ansible/ansible",
              "sudo apt-get update -y",
              "sudo apt-get install -y git ansible",
              "git clone https://github.com/rahulsurwade08/owtf.git /home/ubuntu/owtf",
              "cd /home/ubuntu/owtf && git checkout terraform",
              "ansible-playbook /home/ubuntu/owtf/infra/terraform/playbook-ubuntu.yaml"
            ]
          }
        ]
      }
    }
  }
DOC

  tags = {
    Name = "RunAnsiblePlaybook"
  }
}
