resource "aws_secretsmanager_secret" "database_password_secret" {
  name = "/production/database/password/master"
}

resource "aws_secretsmanager_secret_version" "database_password_secret_version" {
  secret_id     = aws_secretsmanager_secret.database_password_secret.id
  secret_string = random_password.database_password.result
}

resource "aws_iam_role_policy" "password_policy_secretsmanager" {
  name = "password-policy-secretsmanager"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "secretsmanager:GetSecretValue"
        ],
        "Effect": "Allow",
        "Resource": [
          "${aws_secretsmanager_secret.database_password_secret.arn}"
        ]
      }
    ]
  }
  EOF
}

data "template_file" "task_template_secretsmanager" {
  template = file("./templates/task.json.tpl")

  vars = {
    app_cpu           = var.cpu
    app_memory        = var.memory
    database_password = aws_secretsmanager_secret.database_password_secret.arn
  }
}

resource "aws_ecs_task_definition" "task_definition_secretsmanager" {
  family                   = "task-secretsmanager"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["EC2"]
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = "awsvpc"
  container_definitions    = data.template_file.task_template_secretsmanager.rendered
}
