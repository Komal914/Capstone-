import UIKit
import StoreKit
import MediaPlayer
import AuthenticationServices
import Parse



class signInViewController: UIViewController {
    
//MARK: OUTLETS
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
//MARK: FIREBASE FUNCTIONS
    
    
    
//MARK: SIGN IN BUTTON
    @IBAction func onSignInToAppleMusicButton(_ sender: Any) {
        
        //we need to authenticate the user here with the apple API
        //for now, you can log in by just clicking the button
                performSegue(withIdentifier: "loginToAppleMusic", sender: self)
        
    }
    
    
//MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // sets up signIn apple button
        setupView()
        
        
//MARK: REQUEST MUSIC LIBRARY
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
        
        //store front
        let controller = SKCloudServiceController()
        controller.requestStorefrontCountryCode { countryCode, error in
            // Use the value in countryCode for subsequent API requests
        }
        
        
        //user token
        let developerToken = "[REDACTED]"

        /*
        controller.requestUserToken(forDeveloperToken: developerToken) { userToken, error in
            // Use this value for recommendation requests.
            print("User token")
            //print(userToken)
        }*/
        
        
        func getUserToken() {
            var userToken = String()
            
            SKCloudServiceController().requestUserToken(forDeveloperToken: developerToken) { (receivedToken, error) in
                guard error == nil else { return }
                
                if let token = receivedToken {
                    userToken = token
                    print("userToken below:" )
                print(userToken)
                }
            }
        }
        
        // MARK: API REQUEST
        let url = URL(string:"https://api.music.apple.com/v1/catalog/us/artists/36954")!

        var request = URLRequest(url: url)
        request.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared

        //print("Starting task")
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {

                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            }
            catch {
            }

        }
        task.resume()
    }
    
    func setupView() {
        // creates apple logo button
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        
        //target for button goes to didTapAppleButton function
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        
        // add button to view
        view.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70)
        ])
    }
    
    // provider call for authentication VIA APPLE
    @objc
    func didTapAppleButton() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
    }
    
    // segue to send info over
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainVC = segue.destination as? HomeViewController, let user =
            sender as? User {
            mainVC.user = user
            print("The User: ", user.firstName)
        
        }
    }


}


extension signInViewController: ASAuthorizationControllerDelegate {
    // if fails
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //print("Error in authorization: ", error)
    }
    
    // if authorization passes
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        // checking to see if user signs in with apple credential
        switch authorization.credential {
        
        // if credentials are passed through and are correct, break and continue with authorization process
        case let credentials as ASAuthorizationAppleIDCredential:
            var user = User(credentials: credentials)
            print("the user ID here: ", user.id)
            print("user name: ", user.firstName)
            performSegue(withIdentifier: "loginToAppleMusic", sender: user)
            
    //MARK: PARSE
            

//            var parseUser = PFUser()
//            parseUser.username = user.id
//            parseUser.password = "no password"
//
//            parseUser.signUpInBackground{(success, error) in
//                if success {
//                    self.performSegue(withIdentifier: "loginToAppleMusic", sender: nil)
//                }
//                else{
//                    print("error on sign up: \(error) ")
//                }
//            }
            
            break
            
        default: break
        }
    }
}

extension signInViewController: ASAuthorizationControllerPresentationContextProviding {
    // what window are we presenting with
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
