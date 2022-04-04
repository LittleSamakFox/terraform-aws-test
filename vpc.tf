#VPC 설정
resource "aws_vpc" "k5s_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "k5s_vpc_main"
    }
}


#Subnet 생성
#특정 Availability Zone 에 속한 네트워크 그룹으로 VPC 내에서도 나눠진 독립적인 네트워크 구역
#Public Subnet 생성
resource "aws_subnet" "k5s_public_subnet_1" {
    vpc_id = aws_vpc.k5s_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-northeast-2a"
    map_public_ip_on_launch = true //자동으로 퍼블릭 IP 할당
    tags = {
        Name = "k5s_vpc_public_subnet_1"
    }
}
resource "aws_subnet" "k5s_public_subnet_2" {
    vpc_id = aws_vpc.k5s_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-northeast-2c"
    map_public_ip_on_launch = true //자동으로 퍼블릭 IP 할당
    tags = {
        Name = "k5s_vpc_public_subnet_2"
    }
}
#Private Subnet 생성
resource "aws_subnet" "k5s_private_subnet_1" {
    vpc_id = aws_vpc.k5s_vpc.id
    cidr_block = "10.0.10.0/24"
    availability_zone = "ap-northeast-2a"
    tags = {
        Name = "k5s_vpc_private_subnet_1"
    }
}
resource "aws_subnet" "k5s_private_subnet_2" {
    vpc_id = aws_vpc.k5s_vpc.id
    cidr_block = "10.0.11.0/24"
    availability_zone = "ap-northeast-2c"
    tags = {
        Name = "k5s_vpc_private_subnet_2"
    }
}


#Internet Gateway 생성
#VPC 내부와 외부 인터넷 통신하기 위한 게이트웨이
#인터넷게이트웨이가 연결된 서브넷 == public subnet
resource "aws_internet_gateway" "k5s_igw" {
    vpc_id = aws_vpc.k5s_vpc.id
    tags = {
        Name = "k5s_igw_main"
    }
}
#Route Table 생성
#트래픽을 규칙에 맞게 전달해주기 위해 필요한 일종의 테이블
resource "aws_route_table" "k5s_public_route_table" {
    vpc_id = aws_vpc.k5s_vpc.id
    tags = {
        Name = "k5s_public_route_table"
    }
}
#퍼블릭라우트 생성
resource "aws_route" "k5s_public_ig_route" {
    route_table_id = aws_route_table.k5s_public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k5s_igw.id
}


#Nat Gateway 생성
#Private 서브넷에서 외부와 통신하기 위해서 필요한 일종의 게이트웨이
#Nat게이트웨이는 public subnet에 있지만, 연결은 private서브넷과 함
#고정IP(Elastic IP)필요
resource "aws_eip" "k5s_nat_eip_1" {
    vpc = true
    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_eip" "k5s_nat_eip_2" {
    vpc = true
    lifecycle {
        create_before_destroy = true
    }
}
#Nat게이트 웨이 생성
resource "aws_nat_gateway" "k5s_ngw_1" {
    allocation_id = aws_eip.k5s_nat_eip_1.id
    subnet_id = aws_subnet.k5s_public_subnet_1.id//public subnet을 연결해야함
    tags = {
        Name = "k5s_ngw_1"
    }
}
resource "aws_nat_gateway" "k5s_ngw_2" {
    allocation_id = aws_eip.k5s_nat_eip_2.id
    subnet_id = aws_subnet.k5s_public_subnet_2.id//public subnet을 연결해야함
    tags = {
        Name = "k5s_ngw_2"
    }
}
#라우트 테이블 생성해서 연결
resource "aws_route_table" "k5s_route_table_private_1" {
    vpc_id = aws_vpc.k5s_vpc.id
    tags = {
        Name = "k5s_route_table_private_1"
    }
}
resource "aws_route_table" "k5s_route_table_private_2" {
    vpc_id = aws_vpc.k5s_vpc.id
    tags = {
        Name = "k5s_route_table_private_2"
    }
}
#라우트생성
resource "aws_route" "k5s_private_nat_1" {
    route_table_id = aws_route_table.k5s_route_table_private_1.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.k5s_ngw_1.id    
}
resource "aws_route" "k5s_private_nat_2" {
    route_table_id = aws_route_table.k5s_route_table_private_2.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.k5s_ngw_2.id    
}

#Association을 사용하면, 라우트 테이블을 여러 서브넷에서 동시 사용 가능
resource "aws_route_table_association" "k5s_route_table_association_1" {
    subnet_id = aws_subnet.k5s_public_subnet_1.id
    route_table_id = aws_route_table.k5s_public_route_table.id
}
resource "aws_route_table_association" "k5s_route_table_association_2" {
    subnet_id = aws_subnet.k5s_public_subnet_2.id
    route_table_id = aws_route_table.k5s_public_route_table.id
}
#라우트테이블 서브넷 연결
resource "aws_route_table_association" "k5s_route_table_private_association_1" {
    subnet_id = aws_subnet.k5s_private_subnet_1.id
    route_table_id = aws_route_table.k5s_route_table_private_1.id
}
resource "aws_route_table_association" "k5s_route_table_private_association_2" {
    subnet_id = aws_subnet.k5s_private_subnet_2.id
    route_table_id = aws_route_table.k5s_route_table_private_2.id
}