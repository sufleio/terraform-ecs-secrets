[
  {
    "name": "application",
    "image": "service/latest",
    "cpu": ${app_cpu},
    "memory": ${app_memory},
    "essential": true,
    "secrets": [
      {
        "name": "PASSWORD",
        "valueFrom": "${database_password}"
      }
    ]
  }
]
