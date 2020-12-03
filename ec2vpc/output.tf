output "vpc_id" {
    value = aws_vpc.javaserver_vpc.id  
} 

output "instance_public_ip" { 
    value = aws_instance.javaserver.public_ip  
}

