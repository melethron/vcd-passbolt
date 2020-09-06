variable "vcd_user" {
  type        = string
  description = "vCD user name"
}

variable "vcd_pass" {
  type        = string
  description = "vCD password"
}

variable "vcd_org" {
  type        = string
  description = "vCD organization"
  default     = "CloudMTS-CPD"
}

variable "vcd_vdc" {
  type        = string
  description = "Virtual cloud datacenter"
  default     = "CloudMTS-CPD-VDC"
}

variable "vcd_url" {
  type        = string
  description = "vCD API endpoint URL"
  default     = "https://iaas.cloud.mts.ru/api"
}

variable "vcd_allow_unverified_ssl" {
  type        = string
  description = "vSphere user name"
  default     = "true"
}

variable "vm_name" {
  type        = string
  description = "vm name"
  default     = "passbolt"
}
