
import Foundation


class FakeAppDelegate: AppDelegate {
    override func makeService() -> ApiServiceProtocol {
        return MockedApiService()
    }
}
