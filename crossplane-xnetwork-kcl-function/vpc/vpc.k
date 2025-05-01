import provider_aws_ec2.v1beta1.ec2_aws_upbound_io_v1beta1_v_p_c as ec2
import ..xcell as xcell

makeVPC = lambda cell: xcell.xCell {
    ec2.VPC {
        metadata: {
            annotations: {
                "crossplane.io/composition-resource-name": "vpc"
            }
        }
        spec: {
            forProvider: {
                cidrBlock: ""
                region: cell.spec.region
            }
        }
    }
}
