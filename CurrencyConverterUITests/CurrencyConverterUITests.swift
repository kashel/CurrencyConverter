//
//  Created by Ireneusz Sołek
//

import XCTest

class CurrencyConverterUITests: XCTestCase {
    private let app = XCUIApplication()
  
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append(CurrencyConverterLaunchArgument.automatedTestRun.rawValue)
    }
  
  func test_dashboard_hasAllRequiredUIElements() {
    app.launchArguments.append(CurrencyConverterLaunchArgument.dashboardStartScreen.rawValue)
    app.launch()
    let iconButton = app.buttons[AccessibilityIdentifier.Dashboard.addCurrencyPairIconButton]
    let addCurrencyPairButton = app.buttons[AccessibilityIdentifier.Dashboard.addCurrencyPairButton]
    let chooseCurrencyPairDescription = app.staticTexts[AccessibilityIdentifier.Dashboard.chooseCurrencyPairDescription]
    
    XCTAssertTrue(iconButton.exists, "add currency pair icon button does not exists")
    XCTAssertTrue(addCurrencyPairButton.exists, "add currency pair button does not exists")
    XCTAssertTrue(chooseCurrencyPairDescription.exists, "Choose currency pair description label does not exists")
  }
  
  func test_converter_hasRequiredHeader() {
    app.launchArguments.append(CurrencyConverterLaunchArgument.converterStartScreen.rawValue)
    app.launch()
    let addCurrencyPairButton = app.buttons[AccessibilityIdentifier.Converter.addCurrencyPairButton]
    let editButton = app.buttons[AccessibilityIdentifier.Converter.editButton]
    
    XCTAssertTrue(addCurrencyPairButton.exists, "add currency pair button does not exists")
    XCTAssertTrue(editButton.exists, "edit button does not exists")
  }
  
  func test_converter_containsExchangeRateCellWithCorrectContent() {
    app.launchArguments.append(CurrencyConverterLaunchArgument.converterStartScreen.rawValue)
    app.launch()
    let cell = app.tables.cells.element(boundBy: 0)
    let sourceCurrencyCodeLabel = cell.staticTexts[AccessibilityIdentifier.Converter.ExchangeRateCell.sourceCurrencyCode]
    let exchangeRateLabel = cell.staticTexts[AccessibilityIdentifier.Converter.ExchangeRateCell.exchangeRate]
    let sourceCurrencyName = cell.staticTexts[AccessibilityIdentifier.Converter.ExchangeRateCell.sourceCurrencyName]
    let receiveCurrencyNameAndCode = cell.staticTexts[AccessibilityIdentifier.Converter.ExchangeRateCell.receiveCurrencyNameAndCode]
    
    XCTAssertTrue(sourceCurrencyCodeLabel.exists, "source curency code label does not exists")
    XCTAssertEqual(sourceCurrencyCodeLabel.label, "1 PLN")
    XCTAssertTrue(exchangeRateLabel.exists, "exchange rate label does not exists")
    XCTAssertEqual(exchangeRateLabel.label, "4.1234")
    XCTAssertTrue(sourceCurrencyName.exists, "source currency name label does not exists")
    XCTAssertEqual(sourceCurrencyName.label, "Polish Zloty")
    XCTAssertTrue(receiveCurrencyNameAndCode.exists, "receive currency name and code label does not exists")
    XCTAssertEqual(receiveCurrencyNameAndCode.label, "US Dollar · USD")
  }
  
  func test_editButtonTap_triggerViewStateChange() {
    app.launchArguments.append(CurrencyConverterLaunchArgument.converterStartScreen.rawValue)
    app.launch()
    let deleteButton = app.buttons[AccessibilityIdentifier.Converter.deleteButton]
    
    XCTAssertFalse(deleteButton.exists)
    tapOnEditButton()
    XCTAssertTrue(deleteButton.exists)
  }
  
  private func tapOnEditButton() {
    app.buttons[AccessibilityIdentifier.Converter.editButton].tap()
  }
  
  func test_editingState_containsRequiredUIElements() {
    app.launchArguments.append(CurrencyConverterLaunchArgument.converterStartScreen.rawValue)
    app.launch()
    let deleteButton = app.buttons[AccessibilityIdentifier.Converter.deleteButton]
    let editButton = app.buttons[AccessibilityIdentifier.Converter.editButton]
    let addCurrencyPairButton = app.buttons[AccessibilityIdentifier.Converter.addCurrencyPairButton]
    
    tapOnEditButton()
    XCTAssertFalse(deleteButton.isEnabled)
    XCTAssertEqual(editButton.label, "Cancel")
    XCTAssertFalse(addCurrencyPairButton.isEnabled)
  }
  
  func test_selectingExchangeRateCell_activateDeleteButton() {
    app.launchArguments.append(CurrencyConverterLaunchArgument.converterStartScreen.rawValue)
    app.launch()
    let deleteButton = app.buttons[AccessibilityIdentifier.Converter.deleteButton]
    let cell = app.tables.cells.element(boundBy: 0)
    
    tapOnEditButton()
    cell.tap()
    XCTAssertTrue(deleteButton.isEnabled)
  }
  
  func test_deleteButtonTap_removesRowFromTableView() {
    app.launchArguments.append(CurrencyConverterLaunchArgument.converterStartScreen.rawValue)
    app.launch()
    let deleteButton = app.buttons[AccessibilityIdentifier.Converter.deleteButton]
    XCTAssertEqual(app.tables.cells.count, 1)
    let cell = app.tables.cells.element(boundBy: 0)
    tapOnEditButton()
    cell.tap()
    deleteButton.tap()
    XCTAssertEqual(app.tables.cells.count, 0)
  }
  
  func test_addCurrencyPairButtonTap_presetsCurrencySelectionScreen() {
    app.launchArguments.append(CurrencyConverterLaunchArgument.converterStartScreen.rawValue)
    app.launch()
    let addCurrencyPairButton = app.buttons[AccessibilityIdentifier.Converter.addCurrencyPairButton]
    XCTAssertEqual(app.tables.count, 1)
    addCurrencyPairButton.tap()
    XCTAssertEqual(app.tables.count, 2)
    
    let navigationBar = app.navigationBars.element(boundBy: 0)
    let sendCurrencyLabel = navigationBar.staticTexts["Send currency"]
    XCTAssertTrue(sendCurrencyLabel.exists)
  }
  
  func test_addingNewCurrencyPair_addsNewExchangeRateRow() {
    app.launchArguments.append(CurrencyConverterLaunchArgument.converterStartScreen.rawValue)
    app.launch()
    let exchangeRateTable = app.tables.element(boundBy: 0)
    XCTAssertEqual(exchangeRateTable.cells.count, 1)
    let addCurrencyPairButton = app.buttons[AccessibilityIdentifier.Converter.addCurrencyPairButton]
    addCurrencyPairButton.tap()
    let selectCurrencyTable = app.tables.element(boundBy: 1)
    let sendCurrencyCell = selectCurrencyTable.cells.element(boundBy: 0)
    print("selectCurrencyTable.cells.count", selectCurrencyTable.cells.count)
    sendCurrencyCell.tap()
    let receiveCurrencyTable = app.tables.element(boundBy: 1)
    print("receiveCurrencyTable.cells.count", receiveCurrencyTable.cells.count)
    let receiveCurrencyCell = receiveCurrencyTable.cells.element(boundBy: 2)
    receiveCurrencyCell.tap()
    
    XCTAssertEqual(exchangeRateTable.cells.count, 2)
  }
}
