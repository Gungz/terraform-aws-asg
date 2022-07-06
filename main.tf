#######################
# Launch configuration
#######################
resource "aws_launch_configuration" "this" {
  count = var.create_lc ? 1 : 0

  name_prefix                 = "${coalesce(var.lc_name, var.name)}-"
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  key_name                    = "${var.key_name}"
  security_groups             = var.security_groups
  associate_public_ip_address = "${var.associate_public_ip_address}"
  user_data                   = "${var.user_data}"
  enable_monitoring           = "${var.enable_monitoring}"
  spot_price                  = "${var.spot_price}"
  placement_tenancy           = "${var.spot_price == "" ? var.placement_tenancy : ""}"
  ebs_optimized               = "${var.ebs_optimized}"
  
  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      device_name = ebs_block_device.value["device_name"]
      volume_type = ebs_block_device.value["volume_type"]
      volume_size = ebs_block_device.value["volume_size"]
      iops = lookup(ebs_block_device.value, "iops", 3000)
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", false)
      encrypted = lookup(ebs_block_device.value, "encrypted", false)
    }
  }
  
#  ebs_block_device            = var.ebs_block_device
  
  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      volume_type = root_block_device.value["volume_type"]
      volume_size = root_block_device.value["volume_size"]
      iops = lookup(root_block_device.value, "iops", 3000)
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", false)
      encrypted = lookup(root_block_device.value, "encrypted", false)
    }
  }
  
  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name = ephemeral_block_device.value["device_name"]
      virtual_name = ephemeral_block_device.value["virtual_name"]
    }
  }
  
#  ephemeral_block_device      = var.ephemeral_block_device
#  root_block_device           = var.root_block_device

  lifecycle {
    create_before_destroy = true
  }
}

####################
# Autoscaling group
####################
resource "aws_autoscaling_group" "this" {
  count = "${var.create_asg}"

  name_prefix          = "${join("-", compact(tolist([coalesce(var.asg_name, var.name), var.recreate_asg_when_lc_changes ? element(concat(random_pet.asg_name.*.id, tolist([""])), 0) : ""])))}-"
  launch_configuration = "${var.create_lc ? element(aws_launch_configuration.this.*.name, 0) : var.launch_configuration}"
  vpc_zone_identifier  = var.vpc_zone_identifier
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  desired_capacity     = "${var.desired_capacity}"

  load_balancers            = ["${var.load_balancers}"]
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${var.health_check_type}"

  min_elb_capacity          = "${var.min_elb_capacity}"
  wait_for_elb_capacity     = "${var.wait_for_elb_capacity}"
  target_group_arns         = ["${var.target_group_arns}"]
  default_cooldown          = "${var.default_cooldown}"
  force_delete              = "${var.force_delete}"
  termination_policies      = "${var.termination_policies}"
  suspended_processes       = "${var.suspended_processes}"
  placement_group           = "${var.placement_group}"
  enabled_metrics           = var.enabled_metrics
  metrics_granularity       = "${var.metrics_granularity}"
  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"
  protect_from_scale_in     = "${var.protect_from_scale_in}"

  tags = ["${concat(
      tolist([tomap({"key" = "Name", "value" = var.name, "propagate_at_launch" = true})]),
      var.tags,
      local.tags_asg_format
   )}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "random_pet" "asg_name" {
  count = "${var.recreate_asg_when_lc_changes ? 1 : 0}"

  separator = "-"
  length    = 2

  keepers = {
    # Generate a new pet name each time we switch launch configuration
    lc_name = "${var.create_lc ? element(aws_launch_configuration.this.*.name, 0) : var.launch_configuration}"
  }
}
