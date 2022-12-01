module "athena-results" {
  source = "./modules/private-bucket"
  bucket-name = var.query_results_bucket_name
}

resource "aws_glue_catalog_database" "fg_glue_catalog_db" {
  name = "fg-glue-catalog-db"
}

resource "aws_glue_crawler" "fg_test_crawler" {
  database_name = aws_glue_catalog_database.fg_glue_catalog_db.name
  name = "fg-test-crawler"
  role = aws_iam_role.fg_glue_role.arn

  s3_target {
    path = "s3://${var.data_lake_bucket_name}/${var.datalake_data_prefix}/"
  }
}


resource "aws_athena_workgroup" "ath_wg" {
  name = "athena-query-workgroup"
  force_destroy = true

  configuration {
    enforce_workgroup_configuration = true
    publish_cloudwatch_metrics_enabled = true
    result_configuration {
      output_location = "s3://${var.query_results_bucket_name}/query-results/"
    }
  }
}




