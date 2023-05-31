import SecureAccess

class TapToAccessKisiDataProvider: TapToAccessDelegate {
    func tapToAccessSuccess(online: Bool, duration: TimeInterval) {
        
    }
    
    func tapToAccessFailure(error: TapToAccessError, duration: TimeInterval) {
        if error == .needsDeviceOwnerVerification {
            // This means that the reader has a setting turned on which requires that the phone has a passcode and is unlocked
            // So prompt user to unlock device or setup passcode.
            // Can be done via a notification if you have notification permission
            // Otherwise show some in-app banner/screen explaining it.
            print("User needs to unlock their device")
        }
    }
    
    func tapToAccessClientID() -> Int {
        return 1004 // Request proper id by emailing sdks@kisi.io. This is so we can better help you debug any issues you might run into.
    }
    
    func tapToAccessLoginForOrganization(_ organization: Int?) -> SecureAccess.Login? {
        // If you app supports being signed in to multiple organization use the id to lookup the corresponding login.
        // otherwise just return the login you have.
        
        return .init(id: 1, token: "", key: "", certificate: "")
    }
}
