//
//  APIManager.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 02/12/21.
//

import Foundation
import Alamofire

enum APIError: Error {
    case custom(message: String)
}

typealias Handler = (Swift.Result<Any?, APIError>) -> Void

class APIManager {
    static let shareInstance = APIManager()
    let url = "https://unitedpaper.backendless.app/api/users/\(userDefault.object(forKey: "userID") ?? "")"
}


// MARK: - RegisterAPI
extension APIManager {
    
    func callingRegisterAPI(register: RegisterModel, completionHandler: @escaping (Bool, String) -> ()) {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(registerURL, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                    print(json)
                    
                    if response.response?.statusCode == 200 {
                        completionHandler(true, "Terima Kasih Sudah Mendaftar di Alodokter")
                        
                    } else {
                        completionHandler(false, "Mohon periksa kembali data anda")
                    }
                } catch {
                    print(error.localizedDescription)
                    completionHandler(false, "Mohon periksa kembali data anda")
                }
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(false, "Mohon periksa kembali data anda")
            }
        }
    }
}


// MARK: - LoginAPI
extension APIManager {
    
    func callingLoginAPI(login: LoginModel, completionHandler: @escaping Handler) {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(loginURL, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode(LoginResponseModel.self, from: data!)
//                    print(json)
                    if response.response?.statusCode == 200 {
                        completionHandler(.success(json))
                        
                    } else {
                        completionHandler(.failure(.custom(message: "Mohon periksa kembali data dan koneksi internet anda")))
                    }
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "Mohon periksa kembali data anda")))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(.failure(.custom(message: "Mohon periksa kembali data anda")))
            }
        }
    }
}


// MARK: - LogoutAPI
extension APIManager {
    
    func callingLogoutAPI(_ viewController: UIViewController) {
        let headers: HTTPHeaders = [
            "user-token": "\(Token.tokenInstance.getToken)"
        ]
        
        AF.request(logoutURL, method: .get, headers: headers).response {
            response in
            switch response.result {
            case .success(_):
                Token.tokenInstance.removeToken()
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
}



// MARK: - UpdateUserData
extension APIManager {
    
    func callingUpdateUserAPI(userProfile: UserProfile, completionHandler: @escaping Handler) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "user-token": "\(userDefault.object(forKey: "userLoginKey")!)"
        ]
        
        AF.request(url, method: .put, parameters: userProfile, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode(UserResponseModel.self, from: data!)
//                    print(json)
                    if response.response?.statusCode == 200 {
                        completionHandler(.success(json))
                        
                    } else {
                        completionHandler(.failure(.custom(message: "Mohon periksa kembali data dan koneksi internet anda")))
                    }
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "Mohon periksa kembali data anda")))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(.failure(.custom(message: "Mohon periksa kembali data anda")))
            }
        }
    }
}


// MARK: - UpdateUserPassword
extension APIManager {
    
    func callingUpdateUserAPI(userPassword: UserPassword, completionHandler: @escaping Handler) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "user-token": "\(userDefault.object(forKey: "userLoginKey")!)"
        ]
        
        AF.request(url, method: .put, parameters: userPassword, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode(UserResponseModel.self, from: data!)
//                    print(json)
                    if response.response?.statusCode == 200 {
                        completionHandler(.success(json))
                        
                    } else {
                        completionHandler(.failure(.custom(message: "Mohon periksa kembali data dan koneksi internet anda")))
                    }
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "Mohon periksa kembali data anda")))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(.failure(.custom(message: "Mohon periksa kembali data anda")))
            }
        }
    }
}
