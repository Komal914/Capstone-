//
//  AppleMusicAPI.swift
//  Music2
//
//  Created by Komal Kaur on 3/20/22.
//




































///fejogihewoiuhweiotuhnirnronto other thngs
// 1
//




//import StoreKit
// 
//// 2
//class AppleMusicAPI {
//    // 3
//    let developerToken = "YOUR DEVELOPER TOKEN FROM PART 1"
// 
//    // 4
//    func getUserToken() -> String {
//        var userToken = String()
//     
//        // 1
//        let lock = DispatchSemaphore(value: 0)
//     
//        // 2
//        SKCloudServiceController().requestUserToken(forDeveloperToken: developerToken) { (receivedToken, error) in
//            // 3
//            guard error == nil else { return }
//            if let token = receivedToken {
//                userToken = token
//                lock.signal()
//            }
//        }
//     
//        // 4
//        lock.wait()
//        return userToken
//    }
//    
//    func fetchStorefrontID() -> String {
//        // 1
//        let lock = DispatchSemaphore(value: 0)
//        var storefrontID: String!
//     
//        // 2
//        let musicURL = URL(string: "https://api.music.apple.com/v1/me/storefront")!
//        var musicRequest = URLRequest(url: musicURL)
//        musicRequest.httpMethod = "GET"
//        musicRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
//        musicRequest.addValue(getUserToken(), forHTTPHeaderField: "Music-User-Token")
//     
//        // 3
//        URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
//            guard error == nil else { return }
//     
//            // 4
//            if let json = try? JSON(data: data!) {
//                print(json.rawString())
//            }
//        }.resume()
//     
//        // 5
//        lock.wait()
//        return storefrontID
//    }
//}

