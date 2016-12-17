resource "aws_network_acl" "dmz" {
  vpc_id     = "${var.aws_vpc_id}"
  subnet_ids = ["${var.aws_subnet_dmz}"]
  tags {
    name    = "${var.resource_name}-dmz-nacl"
    billing = "${var.billing}"
  }
}

# Allow flow from the vpc
resource "aws_network_acl_rule" "fromvpc" {
  network_acl_id = "${aws_network_acl.dmz.id}"
  rule_number    = 100
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "${var.aws_vpc_cidr_block}"
  from_port      = 0
  to_port        = 0
  lifecycle {
    ignore_changes = ["protocol"]
  }
}

# Allow http internet access into the dmz
resource "aws_network_acl_rule" "http" {
  network_acl_id = "${aws_network_acl.dmz.id}"
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# Allow https internet access into the dmz
resource "aws_network_acl_rule" "https" {
  network_acl_id = "${aws_network_acl.dmz.id}"
  rule_number    = 300
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "outbound" {
  network_acl_id = "${aws_network_acl.dmz.id}"
  rule_number    = 100
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
  lifecycle {
    ignore_changes = ["protocol"]
  }
}