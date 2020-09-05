provider "aws" {
    region = "us-east-2"
}

resource "aws_security_group" "sg_webserver_in" {
    name = "webserver ingress rule"
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "sg_ssh_in" {
    name = "ssh ingress rule"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "ec2_webserver" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"    
    key_name      = "chapter2_webserver"
    tags = {
        Name = "webserver"
    }
    user_data = file("install.sh")   
    vpc_security_group_ids = [
        aws_security_group.sg_webserver_in.id, 
        aws_security_group.sg_ssh_in.id
    ]
}

output "public_ip" {
    description = "The public IP of the webserver"
    value = aws_instance.ec2_webserver.public_ip
}

