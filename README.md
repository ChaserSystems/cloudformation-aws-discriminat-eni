# DiscrimiNAT instance with ENI-based routing

DiscrimiNAT Firewall for egress filtering by FQDNs on AWS. Architecture with ENIs in VPCs for Private Subnets' route table entries to the Internet.

`deployment-with-vpc.json`: Example deployment with VPC and Subnets included.

`demo-environment.json`: Example deployment with two VMs for demo included with a VPC and Subnets like above.

## The Region2AMI JSON key

The templates include a `Region2AMI` key under `Mappings`. This includes a map of AMI IDs to AWS Regions, and will be updated from time to time.

> [!IMPORTANT]\
> If you wish to always run the latest version of DiscrimiNAT, please subscribe to the changes in this repository by clicking Watch -> Custom -> Releases.

## Documentation

https://chasersystems.com/docs/discriminat/aws/installation-overview/

## Support

`devsecops@chasersystems.com`
