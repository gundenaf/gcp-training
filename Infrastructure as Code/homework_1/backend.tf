terraform {
  backend "gcs" {
    bucket         = "gcp-mikhalenka-gcs"
    prefix         = "terraform.tfstate"
  }
}