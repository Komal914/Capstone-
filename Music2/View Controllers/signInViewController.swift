import UIKit
import StoreKit
import MediaPlayer






class signInViewController: UIViewController {
    
   
    
//MARK: OUTLETS
    @IBOutlet weak var usernameTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func onSignInToAppleMusicButton(_ sender: Any) {
        
        //we need to authenticate the user here with the apple API
        //for now, you can log in by just clicking the button
        
//MARK: UNCOMMENT THIS AFTER
        //performSegue(withIdentifier: "loginToAppleMusic", sender: self)
        
    }
    
    
    
    
    
    
//MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .authorized: break
            // Get Media
        case .notDetermined:
            MPMediaLibrary.requestAuthorization() { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        // // Get Media
                    }
                }
            }
        case .denied:
            print("denied")
        case .restricted:
            print("res")
        @unknown default:
            print("unknown")
        }
        
        print("before ewuwsting perm")
        
        func requestAccess(_ completion: @escaping(Bool) -> Void) {
            SKCloudServiceController.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    completion(true)
                case .denied, .notDetermined, .restricted:
                    completion(false)
                @unknown default:
                    completion(false)
                }
            }
        }
        
        print("after ewuwsting perm")
        
        //store front
        let controller = SKCloudServiceController()

        controller.requestStorefrontCountryCode { countryCode, error in
            // Use the value in countryCode for subsequent API requests
        }
        
        
        //user token
        
        let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjQ1OVlDU0NWN04ifQ.eyJpc3MiOiI0VlMzWEFQWFRWIiwiZXhwIjoxNjYzNTcyNzMzLCJpYXQiOjE2NDc4MDQ3MzN9.J-jb_NnC82o7oSlFvLt84mf7AkNJ3o8Fhhld4ADIDmgY6NfUBVprpD7y1yqX3pjtIUFI85RDxE2yKS12TFmVuA"

        controller.requestUserToken(forDeveloperToken: developerToken) { userToken, error in
            // Use this value for recommendation requests.
            print("User token")
            //print(userToken)
        }
        
    

        let url = URL(string:"https://api.music.apple.com/v1/catalog/us/artists/36954")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        print("before task")
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
            
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                print(json)
                print("inside the do")
            }
            catch {
            }
        
        }
        task.resume()
        print("after task")

    }


}
