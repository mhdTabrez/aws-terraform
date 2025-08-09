resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr_block_vpc

  enable_dns_support   = var.dns_support
  enable_dns_hostnames = var.dns_host
  instance_tenancy = "default"
  #owner_id = "if nessacary" 

  tags = {
    Name = "${var.env}-vpc"
  }
}

 resource "aws_subnet" "private" {
   count = length(var.private_subnet)
   vpc_id            = aws_vpc.myvpc.id
   cidr_block        = var.private_subnet[count.index]
   availability_zone = var.az[count.index]

  tags = merge ({
    //   "Name"      = "${var.env}-${var.az[count.index]}"}, var.private_subnet_tags)
     "kubernetes.io/role/internal-elb"  = "1"
     "kubernetes.io/cluster/${var.cluster_name}"           = "shared"
     "kubernetes.io/cluster/${var.cluster_name_migration}" = "shared"
   }
 
  resource "aws_subnet" "DB" {
   count = length(var.DB_subnet)
   vpc_id            = aws_vpc.myvpc.id
   cidr_block        = var.DB_subnet[count.index]
   availability_zone = var.az[count.index]

   tags = merge ({
      // "Name"      = "${var.env}-${var.az[count.index]}"}, var.DB_subnet_tags)
     "kubernetes.io/role/internal-elb"  = "1"
     "kubernetes.io/cluster/${var.cluster_name}"           = "shared"
     "kubernetes.io/cluster/${var.cluster_name_migration}" = "shared"
   }

 resource "aws_subnet" "public" {
   count             = length(var.public_subnet)
   vpc_id            = aws_vpc.myvpc.id
   cidr_block        = var.public_subnet[count.index]
   availability_zone = var.az[count.index]

   tags = merge( {
      // "Name"   = "${var.env}-${var.az[count.index]}"}, var.public_subnet_tags)
     "kubernetes.io/role/internal-elb"  = "1"
     "kubernetes.io/cluster/${var.cluster_name}"           = "shared"
     "kubernetes.io/cluster/${var.cluster_name_migration}" = "shared"
   }
 



# resource "aws_subnet" "private_us_east_1b" {
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = "10.0.32.0/19"
#   availability_zone = "us-east-1b"

#   tags = {
#     "Name"                             = "private-us-east-1b"
#     "kubernetes.io/role/internal-elb"  = "1"
#     "kubernetes.io/cluster/${var.cluster_name}"           = "shared"
#     "kubernetes.io/cluster/${var.cluster_name_migration}" = "shared"
#   }
# }

# resource "aws_subnet" "public_us_east_1a" {
#   vpc_id                  = aws_vpc.this.id
#   cidr_block              = "10.0.64.0/19"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = true

#   tags = {
#     "Name"                             = "public-us-east-1a"
#     "kubernetes.io/role/elb"           = "1"
#     "kubernetes.io/cluster/${var.cluster_name}"           = "shared"
#     "kubernetes.io/cluster/${var.cluster_name_migration}" = "shared"
#   }
# }

# resource "aws_subnet" "public_us_east_1b" {
#   vpc_id                  = aws_vpc.this.id
#   cidr_block              = "10.0.96.0/19"
#   availability_zone       = "us-east-1b"
#   map_public_ip_on_launch = true

#   tags = {
#     "Name"                             = "public-us-east-1b"
#     "kubernetes.io/role/elb"           = "1"
#     "kubernetes.io/cluster/${var.cluster_name}"           = "shared"
#     "kubernetes.io/cluster/${var.cluster_name_migration}" = "shared"

#   }
#   depends_on = [aws_vpc.this.id]
# }



resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "${var.env}-vpc"
  }
  depends_on = [aws_vpc.myvpc]
}

resource "aws_eip" "myeip" {
  //vpc = true

  tags = {
    Name = "${var.env}-eip"
  }
   depends_on = [aws_vpc.myvpc]
}

resource "aws_nat_gateway" "mynat" {
  allocation_id = aws_eip.myeip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.env}-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

###Routings N Associations###

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mynat.id
  }

  tags = {
    Name = "${var.env}-private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}






