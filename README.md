# DiscrimiNAT OTF instance with ENI-based routing

HTTPS, TLS, SSH, SFTP least-privilege Outbound Traffic Filtering (OTF) to monitor and filter VPC egress by domain names. Architecture with an ENI in the VPC for Private Subnet's route table entries to the internet. See [reference architectures here](https://chasersystems.com/docs/discriminat/aws/reference-architectures/).

`1az_new-vpc.json`: A single DiscrimiNAT instance in high-availability in one AZ in a completely new VPC (also deployed by this stack).

`1az_retrofit.json`: A single DiscrimiNAT instance in high-availability in one AZ in an existing VPC.

For multi-AZ, load-balanced and auto-scaling deployment, see https://github.com/ChaserSystems/cloudformation-aws-discriminat-gwlb .

## Map of AMI IDs

The templates include a `Region2PaygAmi` key (or `Region2ByolAmi` if using a licence key) under `Mappings`. This includes a map of AMI IDs to AWS Regions, and will be updated as per [our updates policy](https://chasersystems.com/discriminat/faq/#what-about-images-security-updates).

> [!IMPORTANT]\
> If you wish to always run the latest version of DiscrimiNAT, please subscribe to changes in this repository by clicking Watch -> Custom -> Releases -> Apply.

## Documentation

https://chasersystems.com/docs/discriminat/aws/installation-overview/

## Support

`devsecops@chasersystems.com`
