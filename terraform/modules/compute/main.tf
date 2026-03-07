resource "azurerm_log_analytics_workspace" "env" {
  name                = "log-${var.site_dns_prefix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Container App Environment (VNet-integrated so apps reach SQL/Redis private endpoints)
resource "azurerm_container_app_environment" "env" {
  name                           = "cae-${var.site_dns_prefix}"
  resource_group_name            = var.resource_group_name
  location                       = var.location
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.env.id
  infrastructure_subnet_id       = var.infrastructure_subnet_id
  internal_load_balancer_enabled = false
}

# API Container App (internal ingress; scaled by traffic)
resource "azurerm_container_app" "api" {
  name                         = "api-${var.site_dns_prefix}"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    min_replicas = var.api_min_replicas
    max_replicas = var.api_max_replicas

    container {
      name   = "api"
      image  = var.api_image
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "DB_CONNECTION_STRING"
        value = var.db_connection_string
      }

      liveness_probe {
        transport        = "HTTP"
        path             = "/health"
        port             = 8080
        interval_seconds = 10
      }

      readiness_probe {
        transport        = "HTTP"
        path             = "/health"
        port             = 8080
        interval_seconds = 5
      }
    }
  }

  ingress {
    external_enabled = false
    target_port      = 8080
    transport        = "http"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

# Site Container App (external ingress = load balancer; scaled by traffic)
resource "azurerm_container_app" "site" {
  name                         = "site-${var.site_dns_prefix}"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    min_replicas = var.site_min_replicas
    max_replicas = var.site_max_replicas

    container {
      name   = "site"
      image  = var.site_image
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "REDIS_CONNECTION_STRING"
        value = var.redis_connection_string
      }

      env {
        name  = "MarketingApi__BaseUrl"
        value = "https://${azurerm_container_app.api.ingress[0].fqdn}"
      }

      liveness_probe {
        transport        = "HTTP"
        path             = "/health"
        port             = 8080
        interval_seconds = 10
      }

      readiness_probe {
        transport        = "HTTP"
        path             = "/health"
        port             = 8080
        interval_seconds = 5
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8080
    transport        = "http"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
