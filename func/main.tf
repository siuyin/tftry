terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.10.0"
    }

    git = {
      source  = "metio/git"
      version = "2024.10.18"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "git" {}

# module "pubsub" {
#   source = "./modules/pubsub"
#   topic  = var.topic
# }

module "httpfunc" {
  depends_on = [module.pubsub]
  source     = "./modules/httpfunc"
  project_id = var.project_id
  region     = var.region
  tag        = substr(data.git_commit.refname.sha1, 0, 6)
  topic      = var.topic
}

data "git_commit" "refname" {
  directory = "${path.module}/.."
  revision  = "main"
}

output "tag" {
  value = substr(data.git_commit.refname.sha1, 0, 6)
}
