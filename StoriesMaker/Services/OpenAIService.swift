//
//  OpenAIService.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 20/09/2023.
//

import Foundation

final class OpenAIService {
    
    private let model = "gpt-4o-mini"
    private let maxTokens = 1500
    private let temperature: Double = 0.9
    
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private lazy var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private var currentTask: URLSessionDataTask?
    
    func sendRequest(
        with prompt: String,
        completion: @escaping (Result<String, CustomError>) -> Void
    ) {
        guard let request = self.request(with: prompt) else {
            let error = CustomError.openAIRequest(nil)
            completion(.failure(error))
            return
        }
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { [weak self] data, _, error in
            if let error = error {
                let cError = CustomError.openAIRequest(error)
                completion(.failure(cError))
            } else if let data = data {
                self?.handleData(data, completion: completion)
            }
        }
        dataTask.resume()
        self.currentTask = dataTask
    }
    
    func cancelCurrentTask() {
        self.currentTask?.cancel()
    }
}

private extension OpenAIService {
    
    func request(with prompt: String) -> URLRequest? {
        guard let token = ApiTokenGenerator.makeToken() else { return nil }
        let openAIRequest = OpenAIDTO.Request(
            token: token,
            data: .init(
                model: self.model,
                messages: [.init(role: "user", content: prompt, functionCall: nil)],
                maxTokens: self.maxTokens,
                temperature: self.temperature,
                functions: [OpenAIDTO.Function()],
                functionCall: OpenAIDTO.FunctionCall()
            )
        )
        guard let url = URL(string: "https://stratum.amitrafanau.com/api/open-ai/generic"),
              let encodedData = try? self.jsonEncoder.encode(openAIRequest) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = encodedData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func handleData(
        _ data: Data,
        completion: @escaping (Result<String, CustomError>) -> Void
    ) {
        guard let decodedResponse = try? self.jsonDecoder.decode(OpenAIDTO.Response.self, from: data) else {
            let error = CustomError.openAIRequest(nil)
            completion(.failure(error))
            return
        }
        guard let responseString = decodedResponse.choices.first?.message.functionCall?.arguments else {
            let error = CustomError.openAIRequest(nil)
            completion(.failure(error))
            return
        }
        completion(.success(responseString))
    }
}
