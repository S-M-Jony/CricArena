//
//  ApiService.swift
//  cricArena
//
//  Created by bjit on 14/2/23.
//
import Foundation
final class APIService {
    enum serviceError: Error {
        case noDataError
        case jsonDecodingError
        var localizeDescription: String {
            switch self {
            case .noDataError:
                return NSLocalizedString("No Data Found", comment: "")
            case .jsonDecodingError:
                return NSLocalizedString("Json Decoding Failed", comment: "")
            }
        }
    }
    class func fetchData<T: Codable> (
        from url: URL,
        using parameters: [String: String] = [:],
        completion: @escaping (Result<T,Error>) -> ()) {
            URLSession.shared.dataTask(with: url) { data ,response , error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(serviceError.noDataError))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                   // dump(result)
                    completion(.success(result))
                    
                } catch {
                    completion(.failure(serviceError.jsonDecodingError))
                }
            }.resume()
        }
}
