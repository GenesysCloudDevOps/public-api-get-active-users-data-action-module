resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "pageNumber" = {
                "default" = "1",
                "type" = "integer"
            }
        },
        "type" = "object"
    })
    contract_output = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "divisionIds" = {
                "items" = {
                    "type" = "string"
                },
                "type" = "array"
            },
            "pageCount" = {
                "type" = "integer"
            },
            "userEmails" = {
                "items" = {
                    "type" = "string"
                },
                "type" = "array"
            },
            "userIds" = {
                "items" = {
                    "type" = "string"
                },
                "type" = "array"
            },
            "userNames" = {
                "items" = {
                    "type" = "string"
                },
                "type" = "array"
            }
        },
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/users?state=active&pageSize=100&pageNumber=$${input.pageNumber}"
        
    }

    config_response {
        success_template = "{ \"userIds\": $${ids}, \"userEmails\": $${emails}, \"userNames\": $${names},\"pageCount\": $${pageCount},\"divisionIds\": $${divIds} }"
        translation_map = { 
			emails = "$.entities[*].email"
			ids = "$.entities[*].id"
			pageCount = "$.pageCount"
			names = "$.entities[*].name"
			divIds = "$.entities[*].division.id"
		}
        translation_map_defaults = {       
			emails = "[]"
			ids = "[]"
			pageCount = "0"
			names = "[]"
			divIds = "[]"
		}
    }
}