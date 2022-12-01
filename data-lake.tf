module "main-data-lake" {
  source = "./modules/private-bucket"
  bucket-name = var.data_lake_bucket_name
}