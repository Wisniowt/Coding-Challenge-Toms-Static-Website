# Coding-Challenge-Toms-Static-Website
Coding Challenge - 15/11/2025 2pm - Time Start!

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

1. 

# Alternative Solutions - Could Take but Didn't

# Future Work - If I had more time

# Production Website Requierments
