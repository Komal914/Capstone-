import UIKit
import StoreKit
import MediaPlayer
import MusicKit
import AuthenticationServices

class signInViewController: UIViewController {
    
//MARK: OUTLETS
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func onSignInToAppleMusicButton(_ sender: Any) {
        //MARK: UNCOMMENT THIS AFTER
        //we need to authenticate the user here with the apple API
        //for now, you can log in by just clicking the button
        //performSegue(withIdentifier: "loginToAppleMusic", sender: self)
    }
    
    
//MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // sets up signIn apple button
        setupView()
        
        // gets user token
        getUserToken()
        
        
        // Gain Access to User's Media Library
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
        
        // request access to
/*        let controller = SKCloudServiceController()
        guard SKCloudServiceController.authorizationStatus() == .notDetermined else { return }
        
        SKCloudServiceController.requestAuthorization { [weak self] (authorizationStatus) in
            switch authorizationStatus {
            case .authorized:
                self?.requestCloudServiceCapabilities()
                self?.requestUserToken()
            default:
                break
            }
            
            NotificationCenter.default.post(name: AuthorizationManager.authorizationDidUpdateNotification, object: nil)
        }*/
        
        
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
            print("bad countryCode")
        }
        
        
        // developer token
        let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjQ1OVlDU0NWN04ifQ.eyJpc3MiOiI0VlMzWEFQWFRWIiwiZXhwIjoxNjYzNTcyNzMzLCJpYXQiOjE2NDc4MDQ3MzN9.J-jb_NnC82o7oSlFvLt84mf7AkNJ3o8Fhhld4ADIDmgY6NfUBVprpD7y1yqX3pjtIUFI85RDxE2yKS12TFmVuA"

        SKCloudServiceController().requestUserToken(forDeveloperToken: "\(developerToken)") { (userToken, err) in
            if let e = err {
                print(e)
            }
            
            if let token = userToken {
                print(token)
            }
        }
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
            appleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
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
        }
    }
    
    func getUserToken() {
        var userToken = String()
        let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjQ1OVlDU0NWN04ifQ.eyJpc3MiOiI0VlMzWEFQWFRWIiwiZXhwIjoxNjYzNTcyNzMzLCJpYXQiOjE2NDc4MDQ3MzN9.J-jb_NnC82o7oSlFvLt84mf7AkNJ3o8Fhhld4ADIDmgY6NfUBVprpD7y1yqX3pjtIUFI85RDxE2yKS12TFmVuA"
        
        SKCloudServiceController().requestUserToken(forDeveloperToken: developerToken) { (receivedToken, error) in
            guard error == nil else { return }
            
            if let token = receivedToken {
                userToken = token
                print(userToken)
            }
        }
    }
}


extension signInViewController: ASAuthorizationControllerDelegate {
    // if fails
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("uh oh!: ", error)
    }
    
    // if authorization passes
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        // checking to see if user signs in with apple credential
        switch authorization.credential {
        
        // if credentials are passed through and are correct, break and continue with authorization process
        case let credentials as ASAuthorizationAppleIDCredential:
            let user = User(credentials: credentials)
            performSegue(withIdentifier: "loginToAppleMusic", sender: user)
            break
            
        default:
            print("bad sign in")
        }
    }
}

extension signInViewController: ASAuthorizationControllerPresentationContextProviding {
    // what window are we presenting with
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
