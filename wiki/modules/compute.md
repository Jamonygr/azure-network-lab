# Compute modules

## vm-windows
Creates a Windows Server 2022 VM with a NIC in the target subnet. Optionally joins the VM to a load balancer backend pool.

## vm-windows-nva
Creates a Windows Server 2022 NVA VM with IP forwarding enabled. A Custom Script extension installs RRAS and configures BGP peers for Route Server when enabled.

## Notes
- All VMs use the shared `admin_username` and `admin_password`.
- VM size is controlled by `vm_size` in `terraform.tfvars`.
