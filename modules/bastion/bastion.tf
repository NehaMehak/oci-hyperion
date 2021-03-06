/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/

resource "oci_core_instance" "bastion" {
  compartment_id      = "${var.compartment_ocid}"
  count               = "${length(var.availability_domain)}"
  availability_domain = "${element(var.availability_domain, count.index)}" 
  display_name        = "${var.bastion_hostname_prefix}${element(var.AD,count.index)}${count.index+1}"
  fault_domain        = "${element(var.fault_domain, count.index)}"  
  shape               = "${var.bastion_instance_shape}"
    
  create_vnic_details {
    subnet_id         = "${var.bastion_subnet}"
    display_name      = "${var.bastion_hostname_prefix}${element(var.AD,count.index)}${count.index+1}"
    assign_public_ip  = true
    hostname_label    = "${var.bastion_hostname_prefix}${element(var.AD,count.index)}${count.index+1}"
  },
  
  source_details {
    source_type             = "image"
    source_id               = "${var.bastion_image}"
    boot_volume_size_in_gbs = "60"
  }

  metadata {
    ssh_authorized_keys =  "${var.bastion_ssh_public_key}"
  }
}
