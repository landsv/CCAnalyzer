import Foundation

public typealias JSON = [String: Any]
public typealias HTTPResponse = (body: JSON, headers: [String: String])

public enum HTTPMethod: String { case GET, POST }
public enum HTTPError: Error {
    case serverError
    case clientError(code: Int, details: JSON?)
    case timeOut
    case unknownError
}

private enum ServiceError: Error {
    case cannotMakeRequest
    case cannotParse
}
private enum HTTPCodeStatus {
    case successful, clientError, serverError, unknown
}

public enum Result<T> {
    case success(response: T)
    case fail(error: Error)
}

public class HTTPClient {
    
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // MARK: API
    
    public func GET(path: String, parameters: [String: Any]? = nil, completion: @escaping (Result<HTTPResponse>) -> Void) {
        let request = createRequest(withMethod: .GET, path: path, parameters: parameters)
        send(request: request, completion: completion)
    }
    
    // MARK: Requests
    
    private func createRequest(withMethod: HTTPMethod, path: String, parameters: [String: Any]?) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = path
        
        if let url = urlComponents.url { return URLRequest(url: url) }
        return nil
    }
    
    private func send(request: URLRequest?, completion: @escaping (Result<HTTPResponse>) -> Void) {
        guard let request = request else {
            completion(.fail(error: ServiceError.cannotMakeRequest))
            return
        }
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.fail(error: HTTPError.serverError))
                return
            }

            do {
                let statusCode = response.statusCode
                let headers = response.allHeaderFields as! [String: String]
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON {
                    switch self.status(fromCode: statusCode) {
                    case .successful:
                        completion(.success(response: (body: json, headers: headers)))
                    case .clientError:
                        completion(.fail(error: HTTPError.clientError(code: statusCode, details: json)))
                    case .serverError:
                        completion(.fail(error: HTTPError.serverError))
                    default:
                        completion(.fail(error: HTTPError.unknownError))
                    }
                } else {
                    completion(.fail(error: ServiceError.cannotParse))
                }
            } catch {
                completion(.fail(error: error))
                return
            }
        }
        task.resume()
    }
    
    private lazy var session: URLSession = {
        var config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        return URLSession(configuration: config)
    }()
    
    private func status(fromCode code: Int) -> HTTPCodeStatus {
        switch code {
        case 200 ..< 300:
            return .successful
        case 400 ..< 500:
            return .clientError
        case 500 ..< 600:
            return .serverError
        default:
            return .unknown
        }
    }
    
}
