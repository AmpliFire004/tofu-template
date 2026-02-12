# Variables template
variable "name" {
  type        = string
  description = "Name for this module"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}
