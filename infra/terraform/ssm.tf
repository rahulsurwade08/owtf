resource "aws_ssm_association" "ansible_playbook" {
  name = "AWS-RunAnsiblePlaybook"

  targets {
    key    = "InstanceIds"
    values = [aws_instance.ec2.id]
  }

  parameters = {
    "playbookurl"    = var.playbookurl
    "timeoutSeconds" = var.timeoutseconds
    "check"          = var.check
  }

  depends_on = [aws_instance.ec2, null_resource.wait_for_ec2]
}
