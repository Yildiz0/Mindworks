import Foundation
import Combine

class BaseViewModel: ObservableObject {
    
    func getDataCall<T>(
        dataCall: @escaping () async throws -> T,
        onSuccess: @escaping (T) -> Void,
        onLoading: @escaping () -> Void,
        onError: @escaping (Error?) -> Void
        
    ) {
        Task {
            do {
                DispatchQueue.main.async { onLoading() }
                let result = try await dataCall()
                DispatchQueue.main.async {
                    onSuccess(result)
                }
            } catch {
                DispatchQueue.main.async {
                    onError(error)
                }
            }
        }
    }
}
