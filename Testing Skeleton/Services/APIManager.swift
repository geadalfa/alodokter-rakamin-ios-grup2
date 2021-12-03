//
//  APIManager.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 02/12/21.
//

import Foundation
import Alamofire

class APIManager {
    static let shareInstance = APIManager()
    
    func callingRegisterAPI(register: RegisterModel, completionHandler: @escaping (Bool) -> ()) {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(registerURL, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(json)
                    
                    if response.response?.statusCode == 200 {
                        completionHandler(true)
                        
                    } else {
                        completionHandler(false)
                    }
                } catch {
                    print(error.localizedDescription)
                    completionHandler(false)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(false)
            }
        }
    }
    
    
}
