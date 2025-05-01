import vpc
import ..xcell

test_create_vpc = lambda {
    oxr_mock: xcell.xCell = {
        metadata: {
            name: "test-cell"
        }
        spec: {
            region: "us-west-2"
        }
    }

    _vpc = vpc.makeVPC(oxr_mock)
    assert (_vpc.spec.forProvider.region == "us-west-2")
    assert (_vpc.metadata.name == "test-cell-vpc")
}
