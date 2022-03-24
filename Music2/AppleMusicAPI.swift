//
//  AppleMusicAPI.swift
//  Music2
//
//  Created by Komal Kaur on 3/20/22.
//











//
//
//["attributes": Optional({
//    artistName = "Selena Gomez";
//    artwork =     {
//        bgColor = 38332d;
//        height = 1072;
//        textColor1 = e8d9d2;
//        textColor2 = d9ccce;
//        textColor3 = c4b8b1;
//        textColor4 = b9aeae;
//        url = "https://is4-ssl.mzstatic.com/image/thumb/Video124/v4/1a/54/02/1a5402a4-48bb-dee3-c0c4-368bfee4158d/21UMGIM01401.crop.jpg/{w}x{h}mv.jpg";
//        width = 1912;
//    };
//    durationInMillis = 168467;
//    genreNames =     (
//        Latin
//    );
//    has4K = 0;
//    hasHDR = 0;
//    isrc = USUMV2100129;
//    name = "De Una Vez";
//    playParams =     {
//        id = 1549013065;
//        kind = musicVideo;
//    };
//    previews =     (
//                {
//            artwork =             {
//                bgColor = 0c040c;
//                height = 1072;
//                textColor1 = eb707e;
//                textColor2 = e75b6b;
//                textColor3 = be5a67;
//                textColor4 = bb4a58;
//                url = "https://is5-ssl.mzstatic.com/image/thumb/Video124/v4/ae/b6/41/aeb64141-a00e-d4b4-e19e-7fd00eff0534/Jobc9e8f50e-a109-4976-9f16-ee7871899a6c-108689753-PreviewImage_preview_image_45000_video_sdr-Time1610655522053.png/{w}x{h}bb.jpg";
//                width = 1912;
//            };
//            hlsUrl = "https://play.itunes.apple.com/WebObjects/MZPlay.woa/hls/playlist.m3u8?cc=US&a=1549013065&id=224630612&l=en&aec=HD";
//            url = "https://video-ssl.itunes.apple.com/itunes-assets/Video124/v4/e0/5f/88/e05f8810-e2c5-8b06-d9da-d58829fe590b/mzvf_12665898235115114036.720w.h264lc.U.p.m4v";
//        }
//    );
//    releaseDate = "2021-01-14";
//    url = "https://music.apple.com/us/music-video/de-una-vez/1549013065";
//}), "href": Optional(/v1/catalog/us/music-videos/1549013065), "type": Optional(music-videos), "relationships": Optional({
//    albums =     {
//        data =         (
//        );
//        href = "/v1/catalog/us/music-videos/1549013065/albums";
//    };
//    artists =     {
//        data =         (
//                        {
//                href = "/v1/catalog/us/artists/280215834";
//                id = 280215834;
//                type = artists;
//            }
//        );
//        href = "/v1/catalog/us/music-videos/1549013065/artists";
//    };
//}), "id": Optional(1549013065)]





















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

