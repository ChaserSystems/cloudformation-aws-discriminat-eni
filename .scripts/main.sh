#!/bin/bash

set -e
set -u
set -o pipefail
# set -x

_tmpdir=$(mktemp --directory)
myjq='jq --exit-status'


## 1az new vpc
cp .components/1az_new-vpc.json 1az_new-vpc.json
##


## 1az retrofit
$myjq '
  .Parameters.PublicSubnet = {"Description": "(existing)", "Type": "AWS::EC2::Subnet::Id"} |
  .Parameters.PrivateSubnet = {"Description": "(existing)", "Type": "AWS::EC2::Subnet::Id"} |
  .Parameters.VPC = {"Description": "(existing)", "Type": "AWS::EC2::VPC::Id"} |
  .Parameters.AvailabilityZone = {"Description": "(of PublicSubnet)", "Type": "AWS::EC2::AvailabilityZone::Name"} |
  .Parameters.VpcCidr.Description = "(existing)" |
  .Parameters.NewEIPs.Default = "no"
  ' \
  1az_new-vpc.json > ${_tmpdir}/1az_r_01.json

$myjq '
  .Metadata."AWS::CloudFormation::Interface".ParameterGroups[0].Parameters =
  .Metadata."AWS::CloudFormation::Interface".ParameterGroups[0].Parameters[0:2] +
  ["VPC", "AvailabilityZone"] +
  .Metadata."AWS::CloudFormation::Interface".ParameterGroups[0].Parameters[2:]
  ' \
  ${_tmpdir}/1az_r_01.json > ${_tmpdir}/1az_r_02.json

$myjq 'del(
  .Resources.VPC,
  .Resources.SubnetPublic,
  .Resources.SubnetPrivate,
  .Resources.InternetGateway,
  .Resources.InternetGatewayAttachment,
  .Resources.InternetGatewayRouteAssociation,
  .Resources.PrivateRouteTable,
  .Resources.PublicRoute,
  .Resources.PublicRouteTable,
  .Parameters.VpcCidr.Default,
  .Resources.DiscrimiNATRouteAssociation,
  .Resources.PrivateSubnetDefaultRoute,
  .Resources.DiscrimiNATTargetGroup,
  .Resources.DiscrimiNATAutoScalingGroup.Properties.TargetGroupARNs,
  .Resources.ElasticIPAssociation
  )' \
  ${_tmpdir}/1az_r_02.json > ${_tmpdir}/1az_r_03.json

$myjq 'walk(if type == "object" and has("VpcId") then .VpcId = {"Ref": "VPC"} else . end)' \
  ${_tmpdir}/1az_r_03.json > ${_tmpdir}/1az_r_04.json

$myjq '
  .Resources.DiscrimiNATNetworkInterface.Properties.SubnetId.Ref = "PublicSubnet" |
  .Resources.EC2VPCEndpoint.Properties.SubnetIds[0].Ref = "PrivateSubnet" |
  .Resources.DiscrimiNATAutoScalingGroup.Properties.AvailabilityZones[0] = {"Ref": "AvailabilityZone"}
  ' \
  ${_tmpdir}/1az_r_04.json > ${_tmpdir}/1az_r_05.json

$myjq '.Metadata."AWS::CloudFormation::Interface".ParameterGroups[0].Label.default = (.Metadata."AWS::CloudFormation::Interface".ParameterGroups[0].Label.default | gsub("OPTIONAL Example"; "REQUIRED"))' \
  ${_tmpdir}/1az_r_05.json > ${_tmpdir}/1az_r_06.json

$myjq --sort-keys . ${_tmpdir}/1az_r_06.json > ${_tmpdir}/1az_r_07.json

cp ${_tmpdir}/1az_r_07.json 1az_retrofit.json
##
