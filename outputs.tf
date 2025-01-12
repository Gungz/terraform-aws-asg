output "this_launch_configuration_id" {
  description = "The ID of the launch configuration"
  value       = "${var.launch_configuration == "" && var.create_lc ? element(concat(aws_launch_configuration.this.*.id, tolist([""])), 0) : var.launch_configuration}"
}

output "this_launch_configuration_name" {
  description = "The name of the launch configuration"
  value       = "${var.launch_configuration == "" && var.create_lc ? element(concat(aws_launch_configuration.this.*.name, tolist([""])), 0) : ""}"
}

output "this_autoscaling_group_id" {
  description = "The autoscaling group id"
  value       = "${element(concat(aws_autoscaling_group.this.*.id, tolist([""])), 0)}"
}

output "this_autoscaling_group_name" {
  description = "The autoscaling group name"
  value       = "${element(concat(aws_autoscaling_group.this.*.name, tolist([""])), 0)}"
}

output "this_autoscaling_group_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = "${element(concat(aws_autoscaling_group.this.*.arn, tolist([""])), 0)}"
}

output "this_autoscaling_group_min_size" {
  description = "The minimum size of the autoscale group"
  value       = "${element(concat(aws_autoscaling_group.this.*.min_size, tolist([""])), 0)}"
}

output "this_autoscaling_group_max_size" {
  description = "The maximum size of the autoscale group"
  value       = "${element(concat(aws_autoscaling_group.this.*.max_size, tolist([""])), 0)}"
}

output "this_autoscaling_group_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  value       = "${element(concat(aws_autoscaling_group.this.*.desired_capacity, tolist([""])), 0)}"
}

output "this_autoscaling_group_default_cooldown" {
  description = "Time between a scaling activity and the succeeding scaling activity"
  value       = "${element(concat(aws_autoscaling_group.this.*.default_cooldown, tolist([""])), 0)}"
}

output "this_autoscaling_group_health_check_grace_period" {
  description = "Time after instance comes into service before checking health"
  value       = "${element(concat(aws_autoscaling_group.this.*.health_check_grace_period, tolist([""])), 0)}"
}

output "this_autoscaling_group_health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done"
  value       = "${element(concat(aws_autoscaling_group.this.*.health_check_type, tolist([""])), 0)}"
}

//output "this_autoscaling_group_vpc_zone_identifier" {
//  description = "The VPC zone identifier"
//  value       = "${element(concat(aws_autoscaling_group.this.vpc_zone_identifier, tolist([""])), 0)}"
//}
//
//output "this_autoscaling_group_load_balancers" {
//  description = "The load balancer names associated with the autoscaling group"
//  value       = "${aws_autoscaling_group.this.load_balancers}"
//}
//
//output "this_autoscaling_group_target_group_arns" {
//  description = "List of Target Group ARNs that apply to this AutoScaling Group"
//  value       = "${aws_autoscaling_group.this.target_group_arns}"
//}

