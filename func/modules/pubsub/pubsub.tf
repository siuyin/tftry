resource "google_pubsub_topic" "default" {
  name = var.topic
}

resource "google_pubsub_subscription" "default" {
  name  = "${google_pubsub_topic.default.name}-sub"
  topic = google_pubsub_topic.default.id
}
