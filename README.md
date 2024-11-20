# 🌟 "Automate the deployment of an RDS MySQL instance in multi AZs with AWS Secrets Manager integration using Terraform." 🌟






![arch](https://github.com/user-attachments/assets/822d16bc-df47-45c8-a06f-0bcda5d66ea7)








## Overview

In this repo, we will explore how to handle sensitive information such as passwords, and how to integrate AWS Secrets Manager for securely storing sensitive data. We also demonstrate deploying an RDS MySQL instance with Terraform.

## Topics Covered
1. **Working with Sensitive Information**
2. **Using AWS Secrets Manager with Terraform**
3. **Deploying RDS MySQL Instance**



## Handling Sensitive Information

When working with sensitive data like usernames and passwords, it is important to avoid hardcoding them in the Terraform scripts. Instead, use variables marked as `sensitive`.

### Example

In your `variables.tf`:

```hcl
variable "username" {
  type      = string
  sensitive = true
}

variable "password" {
  type      = string
  sensitive = true
}
```


# Infra creation using terraform:


Lets create vpc, subnets, internet gateway, route table, route table association and security group.










![1-secrets](https://github.com/user-attachments/assets/8d142c18-1282-48d4-96dd-ec0b2c3c3133)










##############################################################################################


### Storing Passwords Securely with AWS Secrets Manager

To securely store and retrieve sensitive information like passwords, you can use AWS Secrets Manager.

1. **Generate a random password:**

    ```hcl
    resource "random_password" "master" {
      length           = 16
      special          = true
      override_special = "_!%^"
    }
    ```

2. **Store the password in AWS Secrets Manager:**

    ```hcl
    resource "aws_secretsmanager_secret" "password" {
      name = "test-db-password"
    }

    resource "aws_secretsmanager_secret_version" "password" {
      secret_id     = aws_secretsmanager_secret.password.id
      secret_string = random_password.master.result
    }
    ```












    ![2-secrets](https://github.com/user-attachments/assets/c69c69e1-8acc-4147-b237-b23a789c6d97)



















#####################################################################################################################










![3-secrets](https://github.com/user-attachments/assets/735ebbda-a484-4089-bc7d-2cd9cf212240)
















################################################################################################################

















![4-secrets](https://github.com/user-attachments/assets/d1352782-109f-4673-9a06-1b1d4885ac61)


























#############################################################################################################







![5-secrets](https://github.com/user-attachments/assets/b64a480d-6277-476d-8165-7870b249c8c1)













###########################################################################################################################




 # secrets created in Aws Secrets Manager:







 ![6-secretmanager](https://github.com/user-attachments/assets/71b1fa5c-b119-4e00-853e-858da408e4ad)











 

##################################################################################################



4. **Retrieve the password when deploying RDS:**

    ```hcl
    data "aws_secretsmanager_secret_version" "password" {
      secret_id = aws_secretsmanager_secret.password.id
    }

    resource "aws_db_instance" "test_db_instance" {
    identifier           = "testdb"
    allocated_storage    = 10
    engine               = "mysql"
    engine_version       = "8.0.39"
    instance_class       = "db.t3.medium"
    db_name              = "mydb"
    username             = "dbadmin"
    password             = data.aws_secretsmanager_secret_version.password.secret_string
    publicly_accessible  = true
    db_subnet_group_name = aws_db_subnet_group.test_subnet_group.id
    }
    ```

## Deploying RDS MySQL Instance

### Steps:

1. **Create a subnet group:**

    ```hcl
    resource "aws_db_subnet_group" "test_subnet_group" {
      name       = "test_subnet_group"
      subnet_ids = [
        aws_subnet.subnet1-public.id,
        aws_subnet.subnet2-public.id,
      ]
      tags = {
        Name = "My DB subnet group"
      }
    }
    ```

2. **Deploy the RDS instance:**

  ```hcl
  resource "aws_db_instance" "test_db_instance" {
  identifier           = "testdb"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0.39"
  instance_class       = "db.t3.medium"
  db_name              = "mydb"
  username             = "dbadmin"
  password             = data.aws_secretsmanager_secret_version.password.secret_string
  publicly_accessible  = true
  db_subnet_group_name = aws_db_subnet_group.test_subnet_group.id
}
```









################################################################################################################





![7-rds-instance](https://github.com/user-attachments/assets/3cd35ef4-35a3-454d-818c-9e88e495e8f4)






















#################################################################################################################





![8-rds-instance](https://github.com/user-attachments/assets/3894b525-b22c-43d1-a708-c6c8a2ba397d)























##########################################################################################################





![9-rds-instance](https://github.com/user-attachments/assets/0a57a65b-3d2a-4abb-9a36-71bf208a3265)

















################################################################################################



# RDS DB got created:

















![10-rds-instance](https://github.com/user-attachments/assets/9b059b80-ce44-4c2f-b555-8c592abb59e2)







######################################################################################################

    



### Connecting to RDS via MySQL Workbench:

1. In AWS Console, go to **RDS > Databases > testdb** and copy the **endpoint**.















![11-rds-endpoint](https://github.com/user-attachments/assets/824038bd-4b69-45b4-ab15-a705327bdcbc)





















################################################################################################




























2. In **MySQL Workbench**, use:
   - Hostname: `<copied endpoint>`
   - Username: `dbadmin`
   - Password: Fetch from **AWS Secrets Manager**.
  




     










































![12-mysql-workbench](https://github.com/user-attachments/assets/73e2a295-cdb1-4c50-a060-59ad0cb5789a)



















































###########################################################################################################


![13-mysql-workbench](https://github.com/user-attachments/assets/078f9cbe-7f80-4c70-8073-8bafc8b256c4)





















####################################################################################################



# Lets create a table and insert record:

















![14-db-created](https://github.com/user-attachments/assets/0cdb5960-5717-4bc7-9fe3-7cfd293dce92)

















  #########################################################################################################

### Destroy the Infrastructure

After testing, remember to clean up:

```bash
terraform destroy
```



