//
//  NetworkManager.swift
//  
//
//  Created by Sasha on 19/03/2021.
//

import Foundation

public enum ResponseError: String, Error {
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case failNetworkConnection = "Please check your network connection."
}

public struct NetworkManager {
    static let environment: NetworkEnvironment = .production
    public static var APIKey = ""
    let router: Router<TotalizatorApi>
    
    public init(_ session: URLSessionProxy = URLSession.shared) {
        router = Router<TotalizatorApi>(session)
    }
    
    // MARK: Auth
    
    public func login(login: String,
                      password: String,
                      completion: @escaping (Result<TokenBag, ResponseError>) -> Void) {
        
        router.request(.login(login: login, password: password)) { data, response, error in
            
            self.responceDecodable(of: TokenBag.self,
                                   data: data,
                                   response: response,
                                   error: error) { result in
                completion(result)
            }
            
        }
        
    }
    
    public func registration(login: String,
                      password: String,
                      dateOfBirth: Date,
                      completion: @escaping (Result<TokenBag, ResponseError>) -> Void) {
        
        router.request(.registration(login: login,
                                     password: password,
                                     dateOfBirth: dateOfBirth)) { data, response, error in
            
            self.responceDecodable(of: TokenBag.self,
                                   data: data,
                                   response: response,
                                   error: error) { result in
                completion(result)
            }
            
        }
        
    }
    
    // MARK: Events
    
    public func feed(completion: @escaping (Result<Feed, ResponseError>) -> Void) {
        
        router.request(.feed) { data, response, error in
            
            self.responceDecodable(of: Feed.self,
                                   data: data,
                                   response: response,
                                   error: error) { result in
                completion(result)
            }
            
        }
        
    }
    
    public func getEvent(by id: String, completion: @escaping (Result<Event, ResponseError>) -> Void) {
        
        router.request(.getEvent(id: id)) { data, response, error in
            
            self.responceDecodable(of: Event.self,
                                   data: data,
                                   response: response,
                                   error: error) { result in
                completion(result)
            }
            
        }
        
    }
    
    // MARK: Wallet
    
    public func wallet(completion: @escaping (Result<WalletBag, ResponseError>) -> Void) {
        
        router.request(.wallet) { data, response, error in
            
            self.responceDecodable(of: WalletBag.self,
                                   data: data,
                                   response: response,
                                   error: error) { result  in
                completion(result)
            }
            
        }
        
    }
    
    public func walletHistory(completion: @escaping (Result<WalletHistory, ResponseError>) -> Void) {
        
        router.request(.walletHistory) { data, response, error in
            
            self.responceDecodable(of: WalletHistory.self,
                                   data: data,
                                   response: response,
                                   error: error) { result in
                completion(result)
            }
            
        }
        
    }
    
    public func makeTransaction(amount: Double,
                              type: TransactionType,
                              completion: @escaping (Result<WalletBag, ResponseError>) -> Void) {
        
        router.request(.makeTransaction(amount: amount, type: type)) { data, response, error in
            
            self.responceDecodable(of: WalletBag.self,
                                   data: data,
                                   response: response,
                                   error: error) { result in
                completion(result)
            }
            
        }
        
    }
    
    // MARK: Bets
    
    public func getBets(completion: @escaping (Result<Bets, ResponseError>) -> Void) {
        
        router.request(.bets) { data, response, error in
            
            self.responceDecodable(of: Bets.self,
                                   data: data,
                                   response: response,
                                   error: error) { result in
                completion(result)
            }
            
        }
        
    }
    
    public func makeBet(amount: Double,
                        choice: PossibleResult,
                        eventID: String,
                        completion: @escaping (Result<Data, ResponseError>) -> Void) {
        
        router.request(.makeBet(amount: amount, choice: choice, eventID: eventID)) { data, response, error in
            
            self.response(data: data, response: response, error: error) { result in
                completion(result)
            }
            
        }
        
    }
    
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> ResponseError? {
        switch response.statusCode {
        case 200...299:
            return  nil
        case 401...500:
            return .authenticationError
        case 501...599:
            return .badRequest
        case 600:
            return .outdated
        default:
            return .failed
        }
    }
}

private extension NetworkManager {
    
    func response(data: Data?,
                  response: URLResponse?,
                  error: Error?,
                  completion: @escaping (Result<Data, ResponseError>) -> Void) {
        
        NetworkLogger.log(data: data, response: response as? HTTPURLResponse, error: error)
        
        if error != nil {
            completion(.failure(.failNetworkConnection))
        }
        
        if let response = response as? HTTPURLResponse {
            
            if let error = self.handleNetworkResponse(response) {
                completion(.failure(error))
            } else {
                guard let responseData = data else {
                    completion(.failure(.noData))
                    return
                }
                completion(.success(responseData))
            }
            
        }
        
    }
    
    func responceDecodable<T: Decodable>(of type: T.Type,
                                         data: Data?,
                                         response: URLResponse?,
                                         error: Error?,
                                         completion: @escaping (Result<T, ResponseError>) -> Void) {
        
        
        self.response(data: data, response: response, error: error) { result in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let apiResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(apiResponse))
                } catch {
                    completion(.failure(.unableToDecode))
                }
            }
            
        }
        
        
    }
    
    
}
