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
    
    func testAddTask() {
        let addButton = app.buttons["Add Task"]
        XCTAssertTrue(addButton.exists, "Add button should be visible")
        
        let initialScale = addButton.frame.size.width
        
        addButton.tap()
        
        sleep(1) // For Animation

        let scaledWidth = addButton.frame.size.width
        
        // Verify the scale and opacity changes for animation
        XCTAssertGreaterThan(initialScale, scaledWidth, "Add button should scale up during animation")
        
        let titleField = app.textFields["Task title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 3), "Task title field should be visible")
        
        titleField.tap()
        titleField.typeText("New Task")
        
        let description = app.textFields["Task description"]
        description.tap()
        description.typeText("New Task description")
        
        let saveButton = app.buttons["Save task"]
        XCTAssertTrue(saveButton.exists, "Save button should be visible")
        saveButton.tap()
    }

    func testFilterUIElementsExist() {
        let filterButton = app.images["Filter tasks"]
           XCTAssertTrue(filterButton.exists, "Filter button should exist")
           filterButton.tap()
    
        let filterOptionAll = app.buttons["All"]
        XCTAssertTrue(filterOptionAll.exists, "All Filter button should exist")
        let filterOptionPending = app.buttons["Pending"]
        XCTAssertTrue(filterOptionPending.exists, "Pending Filter button should exist")
        let filterOptionCompleted = app.buttons["Completed"]
        XCTAssertTrue(filterOptionCompleted.exists, "Completed Filter button should exist")
        filterOptionAll.tap()
        filterButton.tap()
        filterOptionPending.tap()
    }

    
    func testSortAndFilterMenus() {
        let sortButton = app.images["Sort tasks"]
        XCTAssertTrue(sortButton.exists, "Sort button should be visible")
        sortButton.tap()
        
        let dataButton = app.buttons["Due Date"]
        XCTAssertTrue(dataButton.exists, "All Filter button should exist")
        let priorityButton = app.buttons["Priority"]
        XCTAssertTrue(priorityButton.exists, "Pending Filter button should exist")
        let TitleButton = app.buttons["Title"]
        XCTAssertTrue(TitleButton.exists, "Completed Filter button should exist")
        dataButton.tap()
        sortButton.tap()
        priorityButton.tap()
        sortButton.tap()
        TitleButton.tap()
    }
}
