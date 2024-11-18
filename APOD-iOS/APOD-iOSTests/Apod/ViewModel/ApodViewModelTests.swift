import XCTest
@testable import APOD_iOS

final class ApodViewModelTestCases: XCTestCase {

    var viewModel: ApodViewModel!
    let networkManager = MockApodService()
    let databaseManager = MockApodDataBaseService.shared
    
    // Create ViewModel Object
    private func makeViewModel() -> ApodViewModel {
        return ApodViewModel(
            apodService: networkManager,
            apodDataRepo: databaseManager
        )
    }
    
    override func setUpWithError() throws {
        viewModel = makeViewModel()
    }
    
    // Test: Initial loading state
    func test_loading_state() {
        XCTAssertEqual(viewModel.state, .loading, "The initial state of the view model should be `.loading` when the view model is first initialized.")
    }
    
    // Test: Initially there is no data in the database so will call api. Incase error received then it will return dummy object to handle edge case
    func test_api_error_received_return_dummy_data() async {
        networkManager.isError = true
        
        let expectation = expectation(description: "AShould load dummy data on API error.")
        
        await viewModel.load(strDate: Constants.Dates.testDate)
        
        if case .loaded(let apod) = viewModel.state {
            XCTAssertEqual(apod, Apod.dummyObj, "Dummy data should be loaded when API fails.")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    // Test: On sucess response received and saved data to database
    func test_api_response_received() async {
        
        let expectation = expectation(description: "Should load data from API on success.")
        
        await viewModel.load(strDate: Constants.Dates.testDate)
        
        if case .loaded(let apod) = viewModel.state {
            expectation.fulfill()
            XCTAssertEqual(apod, Apod.testValue, "Loaded data should match the expected value.")
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    // Test: Fetch data from database.
    func test_fetch_data_from_database() async {
        
        let expectation = expectation(description: "Should fetch data from database if available.")
        
        await viewModel.load(strDate: Constants.Dates.testDate)
        
        if case .loaded(let apod) = viewModel.state {
            XCTAssertEqual(apod, Apod.testValue, "Fetched data should match the expected database value.")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func test_clean_resources() async {
        await viewModel.cleanUpResource()
        XCTAssertTrue(databaseManager.apods.count <= 1)
    }
}
