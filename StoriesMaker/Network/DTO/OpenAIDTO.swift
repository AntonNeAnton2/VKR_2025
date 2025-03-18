//
//  OpenAIDTO.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 20/09/2024.
//

import Foundation

// TODO: Make the request structure generic, without binding to concrete function/function_call
enum OpenAIDTO {
    
    struct Request: Encodable {
        
        private static let jsonEncoder: JSONEncoder = {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return encoder
        }()
        
        struct RequestData: Encodable {
            let model: String
            let messages: [Message]
            let maxTokens: Int
            let temperature: Double
            let functions: [Function]
            let functionCall: FunctionCall
        }
        
        let token: String
        let data: String
        
        init(token: String, data: RequestData) {
            self.token = token
            var jsonString = ""
            if let json = try? Self.jsonEncoder.encode(data),
               let string = String(data: json, encoding: .utf8) {
                jsonString = string
            }
            self.data = jsonString
        }
    }
    
    struct Message: Codable {
        
        struct FunctionCall: Codable {
            
            let arguments: String
        }
        
        let role: String
        let content: String?
        let functionCall: FunctionCall?
    }

    struct Response: Decodable {
        
        struct Choice: Decodable {
            
            let message: Message
        }
        
        let choices: [Choice]
    }
    
    class Function: Encodable {
        
        class Schema: Encodable {
            
            struct Property: Encodable {
                let type: String
                let description: String
                
                init(type: String, description: String) {
                    self.type = type
                    self.description = description
                }
            }
            
            struct Properties: Encodable {
                let name = Property(type: "string", description: "name of the story, max symbols - 50")
                let text = Property(type: "string", description: "text of the story")
            }
            
            let type = "object"
            let properties = Properties()
        }
        
        let name = "create_story"
        let parameters = Schema()
    }
    
    class FunctionCall: Encodable {
        
        let name = "create_story"
    }
}
