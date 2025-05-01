schema xCellMetadata:
    name: str
    [...str]: any

schema xCellSpec:
    region: str

schema xCell:
    apiVersion: "infra.kszpakowski.com/v1alpha1"
    kind: "xCell"
    metadata: xCellMetadata
    spec: xCellSpec
    status?: any

