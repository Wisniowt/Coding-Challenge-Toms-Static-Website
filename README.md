# Coding-Challenge-Toms-Static-Website
Coding Challenge - 15/11/2025 2pm - Time Start!

Two webistes available:
PROD: dee5jv3ukeuf2.cloudfront.net
DEV: d3p0i3zcs69be8.cloudfront.net

# The challenge
There's a new product being planned and it requires a new website and the requisite infrastructure to support it.

# The requirements
1. Using either AWS or GCP, create a website that displays some static text (you will not
be judged on your HTML skills, and feel free to stick within the free/trial tiers for the
resources you create).
2. The text should include your name, for example, "This is Mary Smith’s website".
3. Document:
    - What else you would do with your website, and how you would go about doing it if you had more time.
    - Alternative solutions that you could have taken but didn’t and explain why.
    - What would be required to make this a production grade website that would be developed by various development teams. The more detail, the better!

# Design

This section will briefly explain my design, anything which I will not achieve in the next 3 hours will be moved into the Future Work section.
Due to the fact that we are hosting a static website using cloud infrastructure I will use my local terraform and AWS-Admin access to perform operations like `terraform plan` and then merge my code into the codebase. Later I will create CI to automate this process using IAM-Roles allowing the repo to be forked and the website to be brought up easily. 
Therefore the simple design for my infrasttucture will be as follows:

1. AWS - My chosen technology to server the website and the assests is AWS as AWS is what I am most familiar and comfortable with.
2. S3 Bucket - The website is a static file with no functionality this means I do not need a backend and can just focus on serving this file safely and reliably to the public for now.
3. Terraform - I will use terraform to bring up the infrastructure partially to present my skills and partially to allow for easy replication of the webiste. All components like IAMS, Buckets, CloudFront will be stored reliably in code.
4. GithubActions - The CI/CD I will use are Github Actions due to my extensive use of this technology in my current job. This will help me automate the process - I haven't yet used GHA on my personal account so I'm hoping for no hickups here
5. CloudFront - I will initially make the Buckets publicly available to host the website. Later if my deployments are asset serving is successful I will add cloudfront to isolate my buckets and have CloudFront server the asset from my bucket increasing security by a lot.
6. Prod/Dev - I will need two buckets and two IAM Roles, one for prod deployment of the webiste and another for development. This way I (the developer) will have least access privelage, where the reliable CI/CD will have Adming access.

Without further ado, lets start!

# Prerequisits To Development

1. AWS - to spin up this project you will need an AWS account as you will need to crate two IAM Roles manually so that the CI can assume these roles during deployment.

2. Terraform - Initial knoweladge of terraform to ensure connection and terraform infrastructure correctness. To install terraform please follow this link [Terraform-Install](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and later the following which will teach you how to connect terraform to your AWS account [Terraform-AWS](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-create)
Once the CI is in place this will be redundant.

# To Run the Project

1. Please for the repository.
2. After creating your AWS account you will posses an Admin IAM User which will allow you to create IAM Roles.
3. You will need to create 2 roles manually for the CI to work:
    - Github_Actions_Access_Dev
        1. Go to AMI then Roles
        2. Create role with Web Identity then create identity provider.
        3. In Identity Provider use OpenID Connect. For URL input: https://token.actions.githubusercontent.com
        4. Audience: Audience: sts.amazonaws.com
        5. Create the provider.
        6. Use the created identity provider in Web Identity when creating the Role.
        7. Again use Audience: sts.amazonaws.com
        8. Github Organization choose your Github Account name. Then go next.
        9. You will be prompted to add Permission policies. Find AdministratorAccess and add this policy for now.
        10. Role name input Github_Actions_Access_Dev.
        11. For TrustedPolicy you will see this:
        `
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": "sts:AssumeRoleWithWebIdentity",
                    "Principal": {
                        "Federated":"arn:aws:iam::<AWS-ACCOUNT-ID>:oidc-provider/token.actions.githubusercontent.com"
                    },
                    "Condition": {
                        "StringEquals": {
                            "token.actions.githubusercontent.com:aud": [
                                "sts.amazonaws.com"
                            ]
                        },
                        "StringLike": {
                            "token.actions.githubusercontent.com:sub": [
                                "repo:\<Github User Account\>/*",
                                "repo:\<Github User Account\>/*"
                            ]
                        }
                    }
                }
            ]
        }
        `
        Please Create the Role find it in IAM and edit the Trust Policy (Trust relationships Tab) it to the following:
                `
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": "sts:AssumeRoleWithWebIdentity",
                    "Principal": {
                        "Federated": "arn:aws:iam::<AWS-ACCOUNT-ID>:oidc-provider/token.actions.githubusercontent.com"
                    },
                    "Condition": {
                        "StringEquals": {
                            "token.actions.githubusercontent.com:aud": [
                                "sts.amazonaws.com"
                            ]
                        },
                        "StringLike": {
                            "token.actions.githubusercontent.com:sub": "repo:\<GITHUB-USER-ACCOUNT\>/\<NAME-OF-THE-FORKED-REPO\>:*"
                        }
                    }
                }
            ]
        }
        `
        12. Now add permissions to the Role using create-in-line-policy, choose JSON and add the following: 
            `{
                "Version": "2012-10-17",
                "Statement": [
                    {
                        "Effect": "Allow",
                        "Action": [
                            "s3:CreateBucket",
                            "s3:DeleteBucket",
                            "s3:PutBucketAcl",
                            "s3:GetBucketAcl",
                            "s3:PutBucketCors",
                            "s3:GetBucketCors",
                            "s3:PutBucketPolicy",
                            "s3:GetBucketPolicy",
                            "s3:DeleteBucketPolicy",
                            "s3:PutBucketPublicAccessBlock",
                            "s3:GetBucketPublicAccessBlock",
                            "s3:GetBucketLocation",
                            "s3:GetBucketLogging",
                            "s3:PutBucketLogging",
                            "s3:GetBucketNotification",
                            "s3:PutBucketNotification",
                            "s3:GetBucketTagging",
                            "s3:PutBucketTagging",
                            "s3:GetBucketVersioning",
                            "s3:PutBucketVersioning",
                            "s3:GetBucketWebsite",
                            "s3:PutBucketWebsite",
                            "s3:GetBucketRequestPayment",
                            "s3:GetEncryptionConfiguration",
                            "s3:PutEncryptionConfiguration",
                            "s3:GetLifecycleConfiguration",
                            "s3:PutLifecycleConfiguration",
                            "s3:GetReplicationConfiguration",
                            "s3:PutReplicationConfiguration",
                            "s3:GetAccelerateConfiguration",
                            "s3:PutAccelerateConfiguration",
                            "s3:GetBucketOwnershipControls",
                            "s3:PutBucketOwnershipControls",
                            "s3:GetAccessPoint",
                            "s3:GetAccessPointPolicy",
                            "s3:ListBucket",
                            "s3:ListBucketMultipartUploads",
                            "s3:ListBucketVersions",
                            "s3:GetBucketObjectLockConfiguration"
                        ],
                        "Resource": [
                            "arn:aws:s3:::toms-site-<AWS-ACCOUNT-ID>-dev",
                            "arn:aws:s3:::toms-site-<AWS-ACCOUNT-ID>-dev/*"
                        ]
                    }
                ]
            }`
        13. Call the Policy Toms_Site_Dev_Bucket_Permissions
        14. REVOKE THE AdministratorAccess GIVEN DURING CREATION OF ROLE!
        15. Create another Prod Role following steps 10 onwards replacing ever instance of dev with prod. Bucket permissions are the most important and should be:
        `
            {
                "Version": "2012-10-17",
                "Statement": [
                    {
                        "Effect": "Allow",
                        "Action": [
                            "s3:CreateBucket",
                            "s3:DeleteBucket",
                            "s3:PutBucketAcl",
                            "s3:GetBucketAcl",
                            "s3:PutBucketCors",
                            "s3:GetBucketCors",
                            "s3:PutBucketPolicy",
                            "s3:GetBucketPolicy",
                            "s3:DeleteBucketPolicy",
                            "s3:PutBucketPublicAccessBlock",
                            "s3:GetBucketPublicAccessBlock",
                            "s3:GetBucketLocation",
                            "s3:GetBucketLogging",
                            "s3:PutBucketLogging",
                            "s3:GetBucketNotification",
                            "s3:PutBucketNotification",
                            "s3:GetBucketTagging",
                            "s3:PutBucketTagging",
                            "s3:GetBucketVersioning",
                            "s3:PutBucketVersioning",
                            "s3:GetBucketWebsite",
                            "s3:PutBucketWebsite",
                            "s3:GetBucketRequestPayment",
                            "s3:GetEncryptionConfiguration",
                            "s3:PutEncryptionConfiguration",
                            "s3:GetLifecycleConfiguration",
                            "s3:PutLifecycleConfiguration",
                            "s3:GetReplicationConfiguration",
                            "s3:PutReplicationConfiguration",
                            "s3:GetAccelerateConfiguration",
                            "s3:PutAccelerateConfiguration",
                            "s3:GetBucketOwnershipControls",
                            "s3:PutBucketOwnershipControls",
                            "s3:GetAccessPoint",
                            "s3:GetAccessPointPolicy",
                            "s3:ListBucket",
                            "s3:ListBucketMultipartUploads",
                            "s3:ListBucketVersions",
                            "s3:GetBucketObjectLockConfiguration"
                        ],
                        "Resource": [
                            "arn:aws:s3:::toms-site-<AWS-ACCOUNT-ID>-dev",
                            "arn:aws:s3:::toms-site-<AWS-ACCOUNT-ID>-dev/*"
                            "arn:aws:s3:::toms-site-<AWS-ACCOUNT-ID>-prod",
                            "arn:aws:s3:::toms-site-<AWS-ACCOUNT-ID>-prod/*"
                        ]
                    },
                    {
                        "Effect": "Allow",
                        "Action": [
                            "cloudfront:CreateDistribution",
                            "cloudfront:GetDistribution",
                            "cloudfront:UpdateDistribution",
                            "cloudfront:DeleteDistribution",
                            "cloudfront:TagResource",
                            "cloudfront:CreateOriginAccessControl",
                            "cloudfront:GetOriginAccessControl",
                            "cloudfront:UpdateOriginAccessControl",
                            "cloudfront:DeleteOriginAccessControl",
                            "cloudfront:ListDistributions",
                            "cloudfront:ListTagsForResource"
                        ],
                        "Resource": "*"
                    },
                    {
                        "Effect": "Allow",
                        "Action": [
                            "s3:PutAccountPublicAccessBlock",
                            "s3:GetAccountPublicAccessBlock",
                            "s3:PutBucketPublicAccessBlock",
                            "s3:GetBucketPublicAccessBlock"
                        ],
                        "Resource": [
                            "*"
                        ]
                    }
                ]
            }
        `
    4. In your Github Repo got to Settings then Secrets and variables and finally Actions. In action create the following variables: 
        - variables: 
            - DEV_BUCKET - name of the dev bucket being created. Example: toms-site-AWS-ACCOUNT-ID-dev 
            - PROD_BUCKET - name of the prod bucket being created. Example: toms-site-AWS-ACCOUNT-ID-prod
            - AWS_REGION - region where you will be deploying your resources to.
        - secrets:
            - DEV_ROLE_ARN - The ARN of the dev role you created in step 3 found in IAM Roles tab
            - PROD_ROLE_ARN - The ARN of the prod role you created in step 3 found in IAM Roles tab

    5. Now please update any reference to \<329599628498\> which is my AWS account to your AWS account. 
    6. After doing so create a PR and run the deploy_terraform_infrastructure.yml workflow to create the S3 buckets with least privelage and the CloudFront for you. The website will not work yet.
    7. When you open up the PR the CI will run and automatically and attempt to push the html file into the buckets. This will fail if you have not yet ran step "6". If thats the case re-run the failed workflow after the AWS resources have been created. The workflow should pass and show green.
    8. If the two workflows are successful in deploying the resources and the website you can go to your AWS Account -> CloudFront -> Distributions -> Find the distribution you want to view (Dev or Prod) -> Click on the Distribution and find the URL for it.


# Alternative Solutions - Could Take but Didn't

The alternative solutions I could've taken but didn't are as follows:
1. Use an EC2 instead of S3. I did't peruse this approach as it was redundant. The challange involved a static website with some text, no backend or need for any request managment. Ec2 are more expensive than what I did here and would require maintnance in a real world scenario. 

2. Use python and boto3 library to create something simpler rather than terraform and GHA - I could've taken this approach and to be honest maybe it would be a better choice considering the time constraint but I wanted to show off my IaC skills. This is the first time I had to connect terraform to aws through GHA from scratch which probably wasn't the smartest idea and took up quite some time to get the permissions correct. 
I believe a simple python script could achieve what I've done but I also belive my solution is much more cleaner and reliable. 

# Future Work - If I had more time

Unfortuantely the github actions terraform integration took a significant portion of my time, therefore this section is quite extensive:

1. Dev/Prod - The DEV access role listed in this document till has too many permissions I believe all it needs is ObjectPut permissions for the CI to deploy the website and for Developers to be able to assume the role and push into their buckets, that would be following Least Privelage. Giving more time I would inspect the permissions and revoke the rights.

2. Terraform Sttate - I realised I wasn't saving the state in github action after running the first pipeline. This meant I then had to delete resources manually from the account if I wanted to redeploy again. I should save rge state in a separate S3 bucket (or some form of database) to which the PROD Role has access and allow actions to inspect this file when doing `terraform plan`, this wouldn't cause conflicts like for example attempting to create double resources. This would also allow me to run `terraform detroy` from CI to remove all created resourcs as the PROD Admin user. 

3. Logging - The we do not have any webiste logging at all here, I would add CloudWatch and implement some Alarms based on error rates, possibly add PagerDuty to alarm us if something is going wrong with our webiste. This would also monitor volume and see how well we're dealing with requests which would tell us if we need to scale or improve the caching for example.

5. AWS WAF - Implementing this would mean we could implement rate-limitng and protect us from DDoS attack. As well as XSS or SQLInjection later in the future if the website is built out into a bigger product with a backend.

6. Route53 - Give the webiste a proper domain rather than the generic cloud front.

7. Website Deployment - Improve CI output to return the URL of the created CloudFront CDN so it does not have to be found in the AWS Account UI.

# Production Website Requierments

For a production Grad-Webiste, we would require:

1. We only have 1 DEV bucket, if many developers started to use the CI I created resources would constantly be overriden. In this scenario we would have to create a bucket for each developer and override their individual assets depending on which PR they are working on assuming we would keep the structure I have here now. With a backend we would need to spin up DEV EC2s for example (maybe spot instances to reduce cost), patch these and then test on them. One such a tool is Cyperss testing which can be integrated into CI.
Sping up EC2 with all necessary webisite components, let CI test it.

2. Again if we're talking about a more functional webiste we would need a backend to deal with the request coming from customers, for exaample: purhcases, checking stock or delivery. In this scenario we would need a compltely different stack. I could create a web app with several micoservices packeged in docker containers and deployed into EC2 instances and exposed API endpoints for the mentioned functions. With this you would need much more logging per endpoint, more alerting.

3. We would also need a databse to store the transations utilisung RDS and possibly some type of message queue service like Kafka to deal with the traffic. 

4. Include dependancy, code and security scanning utulising tools Renovate, SonarQube and Snyk. Maybe other security scans for our docker images like artifactory x-ray (if thats where we will store our images) or nmap for open ports.

5. Features already mentioned in Future Work section: More Logging, Terraform stored IAM roles, better CI/CD with more building, testing and scanning features.

6. We would definately have to include an API Gatway for authentication and rate-limiting.

7. Finally some disaster recovery tools like PagerDuty to inform us if our webiste or infrasturecture is down and CI for dealing with a hotpatch and rollback situations.

