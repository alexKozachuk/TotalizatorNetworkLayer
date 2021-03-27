import XCTest
@testable import TotalizatorNetworkLayer

final class TotalizatorNetworkLayerTests: XCTestCase {
    
    var router: Router<TotalizatorApi>!
    var networkManager: NetworkManager!
    var session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        router = Router<TotalizatorApi>(session)
        networkManager = NetworkManager(session)
    }
    
    func testRouterSimpleRequest() {
        let exp = expectation(description: "should response")
        
        let expectedData =
            """
            {
                "id": 1,
                "title": "someTitle"
            }
            """.data(using: .utf8)
        
        let expextedStatusCode = 200
        
        session.nextData = expectedData
        session.nextStatusCode = expextedStatusCode
        
        router.request(.feed) { data, response, error in
            
            guard let response = response as? HTTPURLResponse else {
                assertionFailure()
                return
            }
            
            XCTAssertEqual(data, expectedData)
            XCTAssertEqual(response.statusCode, expextedStatusCode)
            XCTAssert(error == nil)
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testLogin() {
        let exp = expectation(description: "should response")
        
        let expectedData =
            """
            {
                "jwtString": "some token",
            }
            """.data(using: .utf8)
        
        let expectedObject = TokenBag(jwtString: "some token")
        
        session.nextData = expectedData
        
        networkManager.login(login: "Login", password: "password") { result in
            
            guard let token = try? result.get() else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(token, expectedObject)
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testRegistration() {
        let exp = expectation(description: "should register")
        
        let expectedData =
        """
        {
            "jwtString": "token",
        }
        """.data(using: .utf8)
        
        let expectedObject = TokenBag(jwtString: "token")
        
        session.nextData = expectedData
        
        networkManager.registration(login: "Login", password: "password", dateOfBirth: Date(timeIntervalSinceNow: -599581594)) { result in
            
            guard let token = try? result.get() else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(token, expectedObject)
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testWalletAmount() {
        let exp = expectation(description: "should get wallet ammount")
        
        let expectedData =
            """
            {
              "amount": 333
            }
            """.data(using: .utf8)
        
        let expectedAmmount = WalletBag(amount: 333)
        
        session.nextData = expectedData
        
        networkManager.wallet { result in
            
            guard let amount = try? result.get() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(amount)
            XCTAssertEqual(amount, expectedAmmount)
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
    }

    func testAddingMoneyToWallet() {
        let exp = expectation(description: "should add money to wallet")
        
        let expectedData =
            """
            {
              "amount": 333
            }
            """.data(using: .utf8)
        
        let expectedAmmount = WalletBag(amount: 333)
        
        session.nextData = expectedData
        
        networkManager.makeTransaction(amount: 333, type: .deposit) { result in
            
            guard let amount = try? result.get() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(amount)
            XCTAssertEqual(amount, expectedAmmount)
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testWithdrawingMoneyFromWallet() {
        let exp = expectation(description: "should withdraw money from wallet")
        
        let expectedData =
            """
            {
              "amount": 3
            }
            """.data(using: .utf8)
        
        let expectedAmmount = WalletBag(amount: 3)
        
        session.nextData = expectedData
        
        networkManager.makeTransaction(amount: 330, type: .withdraw) { result in
            
            guard let amount = try? result.get() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(amount)
            XCTAssertEqual(amount, expectedAmmount)
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    static var allTests = [
        ("testRouterRequest", testRouterSimpleRequest),
        ("testLogin", testLogin),
        ("testRegistration", testRegistration),
        ("testWalletAmount", testWalletAmount),
        ("testAddingMoneyToWallet", testAddingMoneyToWallet),
        ("testWithdrawingMoneyFromWallet", testWithdrawingMoneyFromWallet)
    ]
}
