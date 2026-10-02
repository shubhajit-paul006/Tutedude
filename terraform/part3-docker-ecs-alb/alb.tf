# ========================================================
# Terraform Part 3: Application Load Balancer (alb.tf)
# ========================================================

resource aws_security_group alb_sg {
  name        = -alb-sg
  description = ALB public HTTP access
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = tcp
    cidr_blocks = [0.0.0.0/0]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [0.0.0.0/0]
  }
}

resource aws_lb main_alb {
  name               = -alb
  internal           = false
  load_balancer_type = application
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name        = -alb
    Environment = var.environment
  }
}

# Target Group: Frontend
resource aws_lb_target_group frontend_tg {
  name        = -frontend-tg
  port        = 3000
  protocol    = HTTP
  vpc_id      = aws_vpc.ecs_vpc.id
  target_type = ip

  health_check {
    path                = /health
    matcher             = 200
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

# Target Group: Backend
resource aws_lb_target_group backend_tg {
  name        = -backend-tg
  port        = 5000
  protocol    = HTTP
  vpc_id      = aws_vpc.ecs_vpc.id
  target_type = ip

  health_check {
    path                = /api
    matcher             = 200
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

# ALB Listener: HTTP Port 80
resource aws_lb_listener http_listener {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = 80
  protocol          = HTTP

  default_action {
    type             = forward
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

# Listener Rule: Path /api* -> Backend Target Group
resource aws_lb_listener_rule backend_rule {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100

  action {
    type             = forward
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }

  condition {
    path_pattern {
      values = [/api*]
    }
  }
}
