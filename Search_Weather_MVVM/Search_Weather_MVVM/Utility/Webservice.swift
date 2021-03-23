//
//  Webservice.swift
//  Search_Weather_MVVM
//
//  Created by Mihin  Patel on 22/03/21.
//

import Foundation
import UIKit
import Alamofire

class Webservice{
    
    func webserviceCall(api:String, methode:HTTPMethod, data:[String:Any],isListing : Bool = false,isFrom : Bool, callBack: @escaping((_ response:[String:Any]?)->Void)){
        if Connectivity.isConnectedToInternet {
            let url : URL?
            
            guard let strUrl = URL(string: WS_Baseurl + api) else {
                //            Alertmessage
                callBack(nil)
                return
            }
            url = strUrl
 
            let param = data.count != 0 ? data : nil
            
            var requestHeaders : HTTPHeaders = [:]
            requestHeaders = ["content-type":"application/json"]
    
            AF.request(url!,
                       method: methode,
                       parameters: param,
                       encoding:JSONEncoding.default,
                       headers:requestHeaders)
                .validate()
                .responseJSON{ response in
                    
                    switch response.result {
                    case .success(let value):
                        
//                        let dataType:String = self.getClassName(obj: value as AnyObject)
//                        print("Response Type : ",dataType)
//                        if(dataType == "__NSCFString"){
//                            let response:String = value as? String ?? ""
//                            print("URL : ",url as Any)
//                            print("Request : ",param ?? "nil")
//                            print("Response : ",response)
//
//                            if(api == API.Login.rawValue){
//                                Constants.defaults.set(response, forKey: "Login_Response")
//                            }
//
//                            guard let responseValue = self.convertToDictionary(text: response) else {
//                                print("ERROR RESPONSE")
//                                callBack(nil)
//                                return
//                            }
//                            callBack(responseValue)
//                        }else if(dataType == "__NSArrayI"){
//
//                            print("URL : ",url as Any)
//                            print("Request : ",param ?? "nil")
//                            print("Response : ",value)
//
//                            guard let responseValue = value as? [[String: Any]] else {
//                                print("ERROR RESPONSE")
//                                callBack(nil)
//                                return
//                            }
//                            let responseData:[String:Any] = ["data":responseValue]
//
//                            callBack(responseData)
//                        }else if(dataType == "__NSSingleObjectArrayI"){
//                            print("URL : ",url as Any)
//                            print("Request : ",param ?? "nil")
//                            print("Response : ",value)
//
//                            guard let responseValue = value as? [[String: Any]] else {
//                                print("ERROR RESPONSE")
//                                callBack(nil)
//                                return
//                            }
//                            let responseData:[String:Any] = ["data":responseValue]
//
//                            callBack(responseData)
//                        }
//                        else if(dataType == "NSNull"){
//                            print("URL : ",url as Any)
//                            print("Request : ",param ?? "nil")
//                            print("Response : ",value)
//
//                            //                                guard let responseValue = value as? [[String: Any]] else {
//                            //                                    print("ERROR RESPONSE")
//                            //                                    callBack(nil)
//                            //                                    return
//                            //                                }
//                            let responseData:[String:Any] = ["data":value]
//
//                            callBack(responseData)
//                        }
//                        else
//                        {
                            print("URL : ",url as Any)
                            print("Request : ",param ?? "nil")
                            print("Response : ",value)
                            guard let responseValue = value as? [String: Any] else {
                                print("ERROR RESPONSE")
                                callBack(nil)
                                return
                            }
                            callBack(responseValue)
//                        }
                        break
                    case .failure(let error):
                        print("ERROR RESPONSE :",error)
                        callBack(nil)
                        break
                    }
            }
        }
        else
        {
            if isListing {
                callBack(["message":validationMessages.message_No_Internet])
            }else{
                SceneDelegate.shared?.window?.makeToast(message: validationMessages.message_No_Internet)
                GIFAnimator.shared.hideProgressView()
            }
        }
    }
    
    //MARK:- API -
    
    func getWeather(requestParam:String, withLoader:Bool = true,completionHandler : @escaping (WeatherForecast) -> Void){
        
        if (withLoader){
            GIFAnimator.shared.showProgressView()
        }
        
        self.webserviceCall(api: API.Weather.rawValue + requestParam, methode: .get, data: [:],isFrom: false) { (response) in
            if (withLoader){
                GIFAnimator.shared.hideProgressView()
            }
            let jsonDecoder = JSONDecoder()
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response ?? [:], options: .prettyPrinted)
                let responseModel = try jsonDecoder.decode(WeatherForecast.self, from: jsonData)
                completionHandler(responseModel)
            }catch{
                if (withLoader){
                    SceneDelegate.shared?.window?.makeToast(message: validationMessages.message_something_went_wrong)
                }
            }
        }
    }
    
    
//    //MARK:- HELPER -
//    func getClassName(obj : AnyObject) -> String
//    {
//        let objectClass : AnyClass! = object_getClass(obj)
//        let className = objectClass.description()
//
//        return className
//    }
//
//    func convertToDictionary(text: String) -> [String: Any]? {
//        if let data = text.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }
//    func readjson(fileName: String)  -> [String: Any]? {
//        //        let path = Bundle.main.path(forResource: fileName, ofType: "json")
//        //        let jsonData = NSData(contentsOfMappedFile: path!)
//        //        return jsonData!
//        if let filePath = Bundle.main.path(forResource: fileName, ofType: "json"), let data = NSData(contentsOfFile: filePath) {
//            do {
//                let json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
//                print(json)
//                return json as? [String:Any]
//            }
//            catch {
//
//            }
//
//        }
//        return [:]
//    }
}

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
