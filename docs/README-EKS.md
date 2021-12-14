## Create service account IAM role for qTest Manager
```
Policies:
- PolicyName: 's3-attachments'
    PolicyDocument:
    Version: '2012-10-17'
    Statement:
        - Effect: 'Allow'
        Action:
            - 's3:AbortMultipartUpload'
            - 's3:DeleteObject'
            - 's3:DeleteObjectTagging'
            - 's3:DeleteObjectVersion'
            - 's3:DeleteObjectVersionTagging'
            - 's3:Get*'
            - 's3:PutObject'
            - 's3:PutObjectTagging'
            - 's3:RestoreObject'
            - 's3:ListMultipartUploadParts'
```