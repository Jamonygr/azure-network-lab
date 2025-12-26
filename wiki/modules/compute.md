# Compute modules

## vm-windows

Creates a Windows Server 2022 Datacenter Core VM with:

- A single NIC with dynamic private IP.
- Standard_LRS OS disk.
- Optional attachment to the internal load balancer backend pool.

## vm-windows-nva

Creates a Windows Server 2022 Datacenter Core VM used as an RRAS NVA:

- Static private IP and IP forwarding enabled.
- Custom Script extension installs RemoteAccess and Routing features.
- Startup scheduled task re-applies RRAS and BGP config after reboots.
- BGP peers are created only when Route Server IPs are supplied.

## Operational notes

- Credentials are shared across all VMs (`admin_username`, `admin_password`).
- VM size is controlled by `vm_size`.
- Logs for the RRAS setup live at `C:\rras-config.log`.

## Extension ideas

- Install IIS on workload VMs for LB/App Gateway testing.
- Add additional data disks or NICs for multi-homed NVA scenarios.
