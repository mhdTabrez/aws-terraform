    cluster_name        = "dev.cluster_name"
    env                 = dev
    cidr_block_vpc      =  [ "10.0.0.0/16" ]
    az                  = ["us-east-1a", "us-east-1b"]
    private_subnet      = ["10.0.0.0/19", "10.0.32.0/19"]
    public_subnet       = ["10.0.64.0/19", "10.0.96.0/19"]
    DB_subnet           = ["10.0.160.0/19", "10.0.192.0/19"]
    //private_subnet_tags = {

      //"kubernetes.io/role/internal-elb"  = 1
      //"kubernetes.io/cluster/${include.env.locals.env}-${include.env.locals.cluster_name}"           = "owned"
      #"kubernetes.io/cluster/${var.cluster_name_migration}" = "shared"
    //}
    //public_subnet_tags  = {
      //"kubernetes.io/role/elb"           = 1
      //"kubernetes.io/cluster/${include.env.locals.env}-${include.env.locals.cluster_name}"           = "owned"
      #"kubernetes.io/cluster/${var.cluster_name_migration}" = "shared"

    //}








