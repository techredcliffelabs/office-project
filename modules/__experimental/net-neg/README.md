# Network Endpoint Group Module

This modules allows creating zonal network endpoint groups.

Note: this module will integrated into a general-purpose load balancing module in the future.

## Example
```hcl
module "neg" {
  source     = "./fabric/modules/__experimental/net-neg/"
  project_id = "myproject"
  name       = "myneg"
  network    = var.vpc.self_link
  subnetwork = var.subnet.self_link
  zone       = "europe-west1-b"
  endpoints = [
    for instance in module.vm.instances :
    {
      instance   = instance.name
      port       = 80
      ip_address = instance.network_interface[0].network_ip
    }
  ]
}
# tftest skip
```
<!-- BEGIN TFDOC -->

## Variables

| name | description | type | required | default |
|---|---|:---:|:---:|:---:|
| [endpoints](variables.tf#L17) | List of (instance, port, address) of the NEG. | <code title="list&#40;object&#40;&#123;&#10;  instance   &#61; string&#10;  port       &#61; number&#10;  ip_address &#61; string&#10;&#125;&#41;&#41;">list&#40;object&#40;&#123;&#8230;&#125;&#41;&#41;</code> | ✓ |  |
| [name](variables.tf#L26) | NEG name. | <code>string</code> | ✓ |  |
| [network](variables.tf#L31) | Name or self link of the VPC used for the NEG. Use the self link for Shared VPC. | <code>string</code> | ✓ |  |
| [project_id](variables.tf#L36) | NEG project id. | <code>string</code> | ✓ |  |
| [subnetwork](variables.tf#L41) | VPC subnetwork name or self link. | <code>string</code> | ✓ |  |
| [zone](variables.tf#L46) | NEG zone. | <code>string</code> | ✓ |  |

## Outputs

| name | description | sensitive |
|---|---|:---:|
| [id](outputs.tf#L17) | Network endpoint group ID. |  |
| [self_lnk](outputs.tf#L22) | Network endpoint group self link. |  |
| [size](outputs.tf#L27) | Size of the network endpoint group. |  |

<!-- END TFDOC -->
