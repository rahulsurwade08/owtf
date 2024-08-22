# OWTF Terraform Scripts

## Overview of the Bash Script

This script automates the process of modifying a Terraform configuration file, checking for unsafe modifications, and running Terraform commands. It also handles different operating systems (macOS and Linux) and allows the user to choose whether to run the script in a "safe mode" or "unsafe mode."

## Deployment Steps

1. **Clone the Repository**

    First, clone the repository containing the deployment script and Kubernetes manifests:
    ```bash
    git clone https://github.com/owtf/owtf.git

    cd owtf/infra/terraform
    ```
2. **Create AWS Access Keys**

    Follow this [link](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey) and read the document to create access keys.
3. **Install Terraform and AWS CLI**

    Make sure to install [Terraform](https://developer.hashicorp.com/terraform/install) and [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

4. **Configure AWS CLI**

    ```
    aws configure
    ```
    Run this command to configure aws access key and secret access key of your aws iam user.

    ```
    AWS Access Key ID [None]: 
    AWS Secret Access Key [None]: 
    Default region name [None]: 
    Default output format [None]: 
    ```
    It would prompt you to paste these details.
5. **Define Variables**

   ```bash
   variables.tf
   ```
   This file holds the variables of the Terraform configuration that can be modified as user required.

6. **Run the script**

    ```bash
    bash apply-script.sh
    ```

    Run this command which initiate, format, validate, plan and apply terraform scripts. 

7. **Logs Location**    
    You can connect to the machine using session manager to check the logs as well at this location using this command

    ```
    tail -f /var/log/nat_instance_setup.log
    ```
    
    **Please wait for atleast 15 min for terraform to apply scripts and 30 min more for docker containers to build and run.**

    > Note: If your have not configured SMTP for your OWTF application, use logs of owtf docker container and get the verification link during login. Make sure to replace approriate IP address in that link with **ALB DNS Name**. 
    
    Use this command to get the logs of the docker container inside the EC2 Instance.

    ```
    docker logs <Container_ID/Container_Name>
    ```
7. **Destroy Infrastructure**

    ```
    terraform destroy --auto-approve
    ```
    Run this command if you want to destroy the created infrastructure on AWS account.
### Creating and Adding SSL Certificates to an Application Load Balancer (ALB)

> Note: If you want to use HTTPS for your application, follow below steps. Else these steps can we skipped.
### Creating an SSL Certificate

#### Using AWS Certificate Manager (ACM)

1. **Sign in to AWS Management Console**: Open the [AWS Certificate Manager Console](https://console.aws.amazon.com/acm/home).

2. **Request a Public Certificate**:
   - Click on **Request a certificate**.
   - Choose **Request a public certificate** and click **Next**.

3. **Add Domain Names**:
   - Enter the domain name(s) for the certificate. Wildcards like `*.example.com` are supported.
   - Click **Next**.

4. **Choose Validation Method**:
   - **DNS Validation**: Add the CNAME record provided to your DNS settings for your Domain Provider.
   - Select the validation method and click **Next**.

5. **Review and Confirm**:
   - Confirm the details and click **Confirm and request**.

6. **Complete Domain Validation**:
   - Follow the necessary steps to validate your domain.
   - Once validated, the certificate status will change to **Issued**.

### Adding SSL Certificates to an Application Load Balancer (ALB)

1. **Sign in to AWS Management Console**: Open the [EC2 Dashboard](https://console.aws.amazon.com/ec2/v2/home).

2. **Navigate to Load Balancers**:
   - In the EC2 Dashboard, click on **Load Balancers** under **Load Balancing**.

3. **Select Your Load Balancer**:
   - Choose the ALB to which you want to add the SSL certificate.

4. **Configure Listener for Port 80 (HTTP)**:
   - Click on the **Listeners** tab.
   - Click **View/edit rules** for the HTTP listener on port 80.
   - **Add/Edit Rule**:
     - Ensure there is a rule that forwards traffic to the target group on port `8009`.
   - Click **Save**.

5. **Configure Listener for Port 443 (HTTPS)**:
   - Click on the **Listeners** tab.
   - Click **View/edit rules** for the HTTPS listener on port 443.
   - **Add or Edit HTTPS Listener**:
     - Click **Add listener** if one does not already exist for port 443.
     - Set the **Protocol** to `HTTPS` and **Port** to `443`.
     - **Add ACM Certificate**:
       - Click on **Add certificate**.
       - Choose **ACM Certificate** from the options and select your certificate from the dropdown menu.
       - Click **Save**.
     - Configure a **Forward to** action:
       - Choose the **Target Group** that listens on port `8009`.
     - Set up a **Redirect** rule (optional):
       - Choose **Redirect to** and set the **Protocol** to `HTTP`, **Port** to `80`, and **Path** to `#{path}`.
       - This redirects HTTPS traffic to HTTP, then HTTP traffic will be forwarded to port 8009.
     - Click **Save**.

6. **Update Security Groups**:
   - Ensure your ALB's security group allows inbound traffic on ports 80 and 443.
   - Navigate to **Security Groups** in the EC2 Dashboard.
   - Check or update the inbound rules to allow HTTP (port 80) and HTTPS (port 443) traffic.

7. **Test the Configuration**:
   - Visit your domain using `http://` and `https://`.
   - Verify that HTTP traffic is forwarded correctly to port 8009 on the target group.
   - Verify that HTTPS traffic is either redirected to HTTP and then forwarded to port 8009 or directly forwarded if redirection is not applied.

---