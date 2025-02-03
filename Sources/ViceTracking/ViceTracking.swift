import Foundation
import AdSupport
import AppTrackingTransparency
import os.log

public enum ViceTrackingError: Error {
    case notInitialized
    case invalidApiKey
    case networkError(Error)
}

@objc public class ViceTracking: NSObject {
    // MARK: - Properties
    private static var shared: ViceTracking?
    private let apiKey: String
    private let baseURL: String
    private let session: URLSession
    private var storedParameters: [String: String] = [:]
    private var installToken: String?
    
    // MARK: - Initialization
    @objc public static func initialize(apiKey: String, domain: String = "prostaff.me") {
        shared = ViceTracking(apiKey: apiKey, domain: domain)
    }
    
    private init(apiKey: String, domain: String) {
        self.apiKey = apiKey
        self.baseURL = "https://\(domain)"
        self.session = URLSession(configuration: .default)
        super.init()
        self.loadStoredParameters()
    }
    
    // MARK: - Public Methods
    @objc public static func handleDeepLink(_ url: URL) {
        guard let shared = shared else { return }
        shared.processDeepLink(url)
    }
    
    @objc public static func trackInstall(completion: ((Error?) -> Void)? = nil) {
        guard let shared = shared else {
            completion?(ViceTrackingError.notInitialized)
            return
        }
        shared.sendEvent("install", completion: completion)
    }
    
    @objc public static func trackEvent(_ event: String, revenue: Double? = nil, completion: ((Error?) -> Void)? = nil) {
        guard let shared = shared else {
            completion?(ViceTrackingError.notInitialized)
            return
        }
        shared.sendEvent(event, revenue: revenue, completion: completion)
    }
    
    // MARK: - Private Methods
    private func loadStoredParameters() {
        if let data = UserDefaults.standard.dictionary(forKey: "ViceTrackingParams") as? [String: String] {
            self.storedParameters = data
        }
    }
    
    // Update processDeepLink to handle install token
    private func processDeepLink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { 
            os_log("Failed to parse deep link URL", type: .error)
            return 
        }
        
        // Store all deep link parameters
        var deepLinkParams: [String: String] = [:]
        components.queryItems?.forEach { item in
            if let value = item.value {
                deepLinkParams[item.name] = value
                
                // Special handling for key parameters
                switch item.name {
                    case "token":
                        self.installToken = value
                        UserDefaults.standard.set(value, forKey: "ViceTrackingInstallToken")
                    case "click_id":
                        UserDefaults.standard.set(value, forKey: "ViceTrackingClickId")
                    default:
                        break
                }
            }
        }
        
        // Store all deep link parameters for future events
        UserDefaults.standard.set(deepLinkParams, forKey: "ViceTrackingDeepLinkParams")
        os_log("Stored deep link parameters: %{public}@", type: .debug, deepLinkParams)
    }
    
    private func getDeviceInfo() -> [String: Any] {
        var info: [String: Any] = [
            "platform": "ios",
            "device_type": UIDevice.current.model,
            "os_version": UIDevice.current.systemVersion,
            "bundle_id": Bundle.main.bundleIdentifier ?? "",
            "sdk_version": "1.0.0"
        ]
        
        // Add IDFA if available
        if #available(iOS 14, *) {
            if ATTrackingManager.trackingAuthorizationStatus == .authorized {
                info["advertising_id"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                info["advertising_id"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
        }
        
        return info
    }
    
    // Update sendEvent to include install token
    private func sendEvent(_ event: String, revenue: Double? = nil, completion: ((Error?) -> Void)? = nil) {
        var parameters = getDeviceInfo()
        parameters["api_key"] = apiKey
        parameters["event"] = event
        
        // Add all stored deep link parameters to every event
        if let deepLinkParams = UserDefaults.standard.dictionary(forKey: "ViceTrackingDeepLinkParams") as? [String: String] {
            parameters["deep_link_params"] = deepLinkParams
            
            // Add specific parameters directly for easier access
            parameters["click_id"] = deepLinkParams["click_id"]
            parameters["install_token"] = deepLinkParams["token"]
        }
        
        if let revenue = revenue {
            parameters["revenue"] = revenue
        }
        
        guard let url = URL(string: "\(baseURL)/sdk/event/\(apiKey)/") else {
            completion?(ViceTrackingError.invalidApiKey)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion?(error)
            return
        }
        
        let task = session.dataTask(with: request) { _, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion?(ViceTrackingError.networkError(error))
                } else {
                    completion?(nil)
                }
            }
        }
        task.resume()
    }
}