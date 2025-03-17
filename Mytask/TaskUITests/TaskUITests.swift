//
//  TaskUITests 2.swift
//  Mytask
//
//  Created by Vineet Rai on 17-Mar-25.
//


import XCTest

final class TaskListUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testTaskListUIElementsExist() {
        let taskList = app.otherElements["taskList"]
        let sortButton = app.buttons["sortButton"]
        let filterButton = app.buttons["filterButton"]
        
        XCTAssertTrue(taskList.waitForExistence(timeout: 5), "Task List should be visible after saving")
        XCTAssertTrue(sortButton.exists, "Sort button should be visible")
        XCTAssertTrue(filterButton.exists, "Filter button should be visible")
    }

    func testAddTask() {
        let addButton = app.buttons["Add Task"]
        XCTAssertTrue(addButton.exists, "Add button should be visible")
        
        addButton.tap()
        
        let titleField = app.textFields["Task title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 3), "Task title field should be visible")
        
        titleField.tap()
        titleField.typeText("New Task")
        
        let saveButton = app.buttons["Save task"]
        XCTAssertTrue(saveButton.exists, "Save button should be visible")
        saveButton.tap()
    }
    
    func testSortAndFilterMenus() {
        let sortButton = app.buttons["sortButton"]
        let filterButton = app.buttons["filterButton"]
        
        XCTAssertTrue(sortButton.exists, "Sort button should be visible")
        XCTAssertTrue(filterButton.exists, "Filter button should be visible")
        
        sortButton.tap()
        XCTAssertTrue(app.sheets.firstMatch.exists, "Sort menu should appear")
        app.sheets.firstMatch.buttons.firstMatch.tap()
        
        filterButton.tap()
        XCTAssertTrue(app.sheets.firstMatch.exists, "Filter menu should appear")
        app.sheets.firstMatch.buttons.firstMatch.tap()
    }
}
