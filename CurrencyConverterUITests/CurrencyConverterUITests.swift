//
//  Created by Ireneusz Sołek
//

import XCTest

class CurrencyConverterUITests: XCTestCase {
    private let app = XCUIApplication()
  
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launchArguments.append(CurrencyConverterLaunchArgument.automatedTestRun.rawValue)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use recording to get started writing UI tests.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
  
  func test_dashboard_hasAllRequiredUIElements() {
    app.launchArguments.append(CurrencyConverterLaunchArgument.dashboardStartScreen.rawValue)
    app.launch()
    let iconButton = app.buttons[AccessibilityIdentifier.Dashboard.addCurrencyPairIconButton]
    XCTAssertTrue(iconButton.exists, "add currency pair icon button does not exists")
    let addCurrencyPairButton = app.buttons[AccessibilityIdentifier.Dashboard.addCurrencyPairButton]
    XCTAssertTrue(addCurrencyPairButton.exists, "add currency pair button does not exists")
    let chooseCurrencyPairDescription = app.staticTexts[AccessibilityIdentifier.Dashboard.chooseCurrencyPairDescription]
    XCTAssertTrue(chooseCurrencyPairDescription.exists, "Choose currency pair description label does not exists")
  }
}
