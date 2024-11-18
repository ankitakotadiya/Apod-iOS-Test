import XCTest
@testable import APOD_iOS

final class ApodServiceTests: XCTestCase {

    let networkManager = MockNetworkManager()
    var apodService: ApodService!
    
    private func makeApodService() -> ApodService {
        return ApodService(networkManager: networkManager)
    }
    
    override func setUpWithError() throws {
        apodService = makeApodService()
    }
    
    // Test: Successful API response returns expected data
    func test_api_response_received() async {
        let result = await apodService.getApod(for: [:])
        
        switch result {
        case .success(let apod):
            XCTAssertEqual(apod, Apod.testValue)
        case .failure:
            XCTFail("Expected success but got failure.")
        }
    }
    
    // Test: API error returns expected failure state
    func test_api_error_received() async {
        networkManager.isError = true
        let result = await apodService.getApod(for: [:])
        
        switch result {
        case .success:
            XCTFail("Expected failure but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .networkError, "Expected a network error.")
        }
    }
    
    override func tearDownWithError() throws {
        apodService = nil
    }

}
