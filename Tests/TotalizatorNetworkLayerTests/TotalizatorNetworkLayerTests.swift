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
    
    func testGettingActiveEvents() {
        let exp = expectation(description: "should get all active events")
        
        guard let result = PossibleResult(rawValue: "W1") else { return }
        
        let expectedFeed = Feed(events: [Event(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", participant1: Participant(id: "id", name: "name", photoLink: "photo", parameters: [ParticipantParameters(type: "type", value: "value")]), participant2: Participant(id: "id", name: "name", photoLink: "photo", parameters: [ParticipantParameters(type: "type", value: "value")]), startTime: "start", sportName: "sport", margin: 3, possibleResults: [result], isEnded: true, amountW1: 0, amountW2: 0, amountX: 0)])
        
        let expectedData = try? JSONEncoder().encode(expectedFeed)
        
        session.nextData = expectedData
        
        networkManager.feed { response in
            
            guard let feed = try? response.get() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(feed)
            XCTAssertEqual(feed, expectedFeed)
            
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5)
    }
    
    func testSendMessage() {
        let exp = expectation(description: "should send message to chat")

        let expectedData =
        """
        true
        """.data(using: .utf8)

        let expextedStatusCode = 200
        
        session.nextData = expectedData
        session.nextStatusCode = expextedStatusCode

        router.request(.sendMessage(text: "Message")) { data, response, error in
            
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
    
    func testMakeBet() {
        let exp = expectation(description: "should make a bet")

        let expextedStatusCode = 200
        
        session.nextStatusCode = expextedStatusCode

        router.request(.makeBet(amount: 333, choice: PossibleResult.w1, eventID: "id")) { data, response, error in
            
            guard let response = response as? HTTPURLResponse else {
                assertionFailure()
                return
            }
            
            XCTAssertEqual(response.statusCode, expextedStatusCode)
            XCTAssert(error == nil)
            
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5)
    }
    
    func testUsersBettingHistory() {
        let exp = expectation(description: "should get user's betting history")
        
        guard let result = PossibleResult(rawValue: "W1") else { return }
        
        let expectedBets = Bets(betsPreviewForUsers: [BetsPreviewForUser(betID: "id", teamConfrontation: "team", choice: result, eventStartime: "time", betTime: "time", amount: 333, status: "status")])
        
        let expectedData = try? JSONEncoder().encode(expectedBets)
        
        session.nextData = expectedData
        
        networkManager.getBets { response in
            
            guard let bets = try? response.get() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(bets)
            XCTAssertEqual(bets, expectedBets)
            
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5)
    }
    
    func testGettingEventInfo() {
        let exp = expectation(description: "should get event's info")
        
        guard let result = PossibleResult(rawValue: "W1") else { return }
        
        let expectedEvent = Event(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", participant1: Participant(id: "id", name: "name", photoLink: "photo", parameters: [ParticipantParameters(type: "type", value: "value")]), participant2: Participant(id: "id", name: "name", photoLink: "photo", parameters: [ParticipantParameters(type: "type", value: "value")]), startTime: "start", sportName: "sport", margin: 3, possibleResults: [result], isEnded: true, amountW1: 0, amountW2: 0, amountX: 0)
        
        let expectedData = try? JSONEncoder().encode(expectedEvent)
        
        session.nextData = expectedData
        
        networkManager.getEvent(by: "3fa85f64-5717-4562-b3fc-2c963f66afa6") { response in
            
            guard let event = try? response.get() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(event)
            XCTAssertEqual(event, expectedEvent)
            
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5)
    }
    
    func testWalletHistory() {
        let exp = expectation(description: "should get wallet history")
        
        let expectedHistory = WalletHistory()
        
        let expectedData = try? JSONEncoder().encode(expectedHistory)
        
        session.nextData = expectedData
        
        networkManager.walletHistory { response in
            
            guard let history = try? response.get() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(history)
            XCTAssertEqual(history, expectedHistory)
            
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5)
    }
    
    func testUserInfo() {
        let exp = expectation(description: "should get user's info")
        
        let expectedUser = UserInfo(id: "id", username: "username", avatarLink: "link")
        
        let expectedData = try? JSONEncoder().encode(expectedUser)
        
        session.nextData = expectedData
        
        networkManager.getUserInfo { response in
            
            guard let user = try? response.get() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(user)
            XCTAssertEqual(user, expectedUser)
            
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5)
    }
    
    func testGettingChat() {
        let exp = expectation(description: "should get chat")
        
        let expectedChat = Messages(messages: [Message(id: "id", text: "message", username: "username", accountID: "accountId", avatarLink: "link", time: "time")])
        
        let expectedData = try? JSONEncoder().encode(expectedChat)
        
        session.nextData = expectedData
        
        networkManager.getChat { response in
            
            guard let chat = try? response.get() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(chat)
            XCTAssertEqual(chat, expectedChat)
            
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
        ("testWithdrawingMoneyFromWallet", testWithdrawingMoneyFromWallet),
        ("testGettingActiveEvents", testGettingActiveEvents),
        ("testSendMessage", testSendMessage),
        ("testMakeBet", testMakeBet),
        ("testUsersBettingHistory", testUsersBettingHistory),
        ("testGettingEventInfo", testGettingEventInfo),
        ("testWalletHistory", testWalletHistory),
        ("testUserInfo", testUserInfo),
        ("testGettingChat", testGettingChat)
    ]
}
