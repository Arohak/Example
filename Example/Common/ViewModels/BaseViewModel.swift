import Foundation

@MainActor
protocol BaseViewModel: Sendable {
    associatedtype State: Sendable
    
    var state: State { get }
    func handleError(_ error: Error)
}

extension BaseViewModel {
    func handleError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
} 
