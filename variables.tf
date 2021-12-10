variable "env" {
  description = "Ambiente onde será criado. Prod, Homol, Dev"

  default = "devmvpc"
  validation {
      condition = contains(
          [
               "devmvpc"
              ,"homolmvpc"
              ,"prodmvpc"
          ], var.env
      )
      error_message = "ERROR: Variable have this types of environments prod, homol or dev."
  }
}

variable "env_full" {
    type = map

    default = {
        "devmvpc"   = "desenvolvimento"
        "homolmvpc" = "homologacao"
        "prodmvpc"  = "producao"
    }
}

variable "location" {
  description = "Região do Azure aonde os recursos serão criados"
  default = "East US"
}

variable "location_alt" {
  description = "Região alternativa onde serão criados recursos de contigencia"
  default = "West US"
}

variable "network" {
    description = "Rede Virtual"
    type = list(string)
}

variable "subnet_front" {
    description = "Subnet para frontend"
    type = list(string)
}

variable "subnet_back" {
    description = "Subnet para backend"
    type = list(string)
}

variable "subnet_database" {
    description = "Subnet para banco de dados"
    type = list(string)
}

variable "subnet_container" {
    description = "Subnet para Containers"
    type = list(string)
}

variable "docker_hub_user" {
  description = "Usuario do Docker Hub"
}

variable "docker_hub_passwd" {
  description = "Senha do Docker Hub"
  sensitive   = true
}

variable "sqlvm_user_passwd" {
  description = "Senha do Usuario Administrador da Maquina do SQL Server"
  sensitive   = true
}

variable "sql_user_passwd" {
  description = "Senha do Usuario Sysadmindo SQL Servers"
  sensitive   = true
}

variable "num_vm_instances" {
  description = "Numero de instancias virtuais que iremos criar num Scale-Set"
}
