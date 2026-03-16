//
//  AuthInterceptor.swift
//  CompoApp
//
//  Created by GH w on 3/17/26.
//

import Alamofire
import Foundation

final class AuthInterceptor: RequestInterceptor {
    private var accessToken: String {
        // Retrieve the access token from secure storage (e.g., Keychain)
        // This is a placeholder; implement your own secure storage logic
        return UserInfo.shared.token ?? ""
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest

        // Add the Authorization header to all requests
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        urlRequest.timeoutInterval = APIConfig.timeout

        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        // Optional: Implement retry logic here (e.g., refreshing an expired token)
        // If the error is a 401 Unauthorized, you could trigger a token refresh
        if let response = request.response, response.statusCode == 401 {
            // Logic to refresh token
            print("Token expired, attempting to refresh...")
            // Call completion(.retry) after successful token refresh
            completion(.doNotRetry) // Placeholder
        } else {
            completion(.doNotRetry)
        }
    }
}

