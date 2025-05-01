import provider_aws_ec2.v1beta1.ec2_aws_upbound_io_v1beta1_v_p_c as ec2

_vpc = ec2.VPC {
    metadata:{
        annotations: {
            "crossplane.io/composition-resource-name": "vpc"
        }
    }
    spec: {
        forProvider: {
            cidrBlock: ""
            region: "us-west-1"
        }
    }
}