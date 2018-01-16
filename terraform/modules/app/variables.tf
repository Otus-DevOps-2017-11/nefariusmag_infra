variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable zone {
  description = "Zone"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable user {
  description = "Name user"
}

variable private_key_path {
  description = "Path to the private key used to connect to instance"
}

variable host_db {
  description = "Host database"
  default     = "127.0.0.1"
}
