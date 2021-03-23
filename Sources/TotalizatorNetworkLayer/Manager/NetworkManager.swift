//
//  NetworkManager.swift
//  
//
//  Created by Sasha on 19/03/2021.
//

import Foundation

public enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

public enum Result<String> {
    case success
    case failure(String)
}

public struct NetworkManager {
    static let environment : NetworkEnvironment = .production
    public static var APIKey = ""
    let router = Router<TotalizatorApi>()
    
    public init() {}
    
    // MARK: Auth
    
    public func login(login: String,
                      password: String,
                      completion: @escaping (_ jwtToken: TokenBag?,_ error: String?) -> Void) {
        
        router.request(.login(login: login, password: password)) { data, response, error in
            
            self.responceDecodable(of: TokenBag.self,
                                   data: data,
                                   response: response,
                                   error: error) { data, error in
                completion(data, error)
            }
            
        }
        
    }
    
    public func registration(login: String,
                      password: String,
                      dateOfBirth: Date,
                      completion: @escaping (_ jwtToken: TokenBag?,_ error: String?) -> Void) {
        
        router.request(.registration(login: login,
                                     password: password,
                                     dateOfBirth: dateOfBirth)) { data, response, error in
            
            self.responceDecodable(of: TokenBag.self,
                                   data: data,
                                   response: response,
                                   error: error) { data, error in
                completion(data, error)
            }
            
        }
        
    }
    
    // MARK: Events
    
    public func feed(completion: @escaping (_ feed: Feed?,_ error: String?) -> Void) {
        
        router.request(.feed) { data, response, error in
            
            self.responceDecodable(of: Feed.self,
                                   data: data,
                                   response: response,
                                   error: error) { data, error in
                completion(data, error)
            }
            
        }
        
    }
    
    // MARK: Wallet
    
    public func wallet(completion: @escaping (_ wallet: WalletBag?,_ error: String?) -> Void) {
        
        router.request(.wallet) { data, response, error in
            
            self.responceDecodable(of: WalletBag.self,
                                   data: data,
                                   response: response,
                                   error: error) { data, error in
                completion(data, error)
            }
            
        }
        
    }
    
    public func walletHistory(completion: @escaping (_ walletHistory: WalletHistory?,_ error: String?) -> Void) {
        
        router.request(.walletHistory) { data, response, error in
            
            self.responceDecodable(of: WalletHistory.self,
                                   data: data,
                                   response: response,
                                   error: error) { data, error in
                completion(data, error)
            }
            
        }
        
    }
    
    public func makeTransaction(amount: Double,
                              type: TransactionType,
                              completion: @escaping (_ wallet: WalletBag?,_ error: String?) -> Void) {
        
        router.request(.makeTransaction(amount: amount, type: type)) { data, response, error in
            
            self.responceDecodable(of: WalletBag.self,
                                   data: data,
                                   response: response,
                                   error: error) { data, error in
                completion(data, error)
            }
            
        }
        
    }
    
    // MARK: Bets
    
    public func getBets(completion: @escaping (_ bets: Bets?,_ error: String?) -> Void) {
        
        router.request(.bets) { data, response, error in
            
            self.responceDecodable(of: Bets.self,
                                   data: data,
                                   response: response,
                                   error: error) { data, error in
                completion(data, error)
            }
            
        }
        
    }
    
    public func makeBet(amount: Double,
                        choice: PossibleResult,
                        eventID: String,
                        completion: @escaping (_ error: String?) -> Void) {
        
        router.request(.makeBet(amount: amount, choice: choice, eventID: eventID)) { data, response, error in
            
            self.response(data: data, response: response, error: error) { error in
                completion(error)
            }
            
        }
        
    }
    
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

private extension NetworkManager {
    
    func response(data: Data?,
                  response: URLResponse?,
                  error: Error?,
                  completion: @escaping (String?) -> Void) {
        
        if error != nil {
            completion("Please check your network connection.")
        }
        
        if let response = response as? HTTPURLResponse {
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                completion(nil)
            case .failure(let networkFailureError):
                completion(networkFailureError)
            }
        }
        
    }
    
    func responceDecodable<T: Decodable>(of type: T.Type,
                                         data: Data?,
                                         response: URLResponse?,
                                         error: Error?,
                                         completion: @escaping (_ bets: T?,_ error: String?) -> Void) {
        
        
        if error != nil {
            completion(nil, "Please check your network connection.")
        }
        
        if let response = response as? HTTPURLResponse {
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                guard let responseData = data else {
                    completion(nil, NetworkResponse.noData.rawValue)
                    return
                }
                do {
                    let apiResponse = try JSONDecoder().decode(T.self, from: responseData)
                    completion(apiResponse,nil)
                } catch {
                    completion(nil, NetworkResponse.unableToDecode.rawValue)
                }
            case .failure(let networkFailureError):
                completion(nil, networkFailureError)
            }
        }
        
        
    }
    
    
}
