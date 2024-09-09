import XCTest
@testable import DynamicTableView

final class DynamicTableViewTests: XCTestCase {

    var viewModel: DynamicTableViewModel!
    let mockTableData = [
        ["", "Col 1", "Col 2", "Col 3", "Col 4"],
        ["Row 1", "Data 11", "Data 12", "Data 13", "Data 14"],
        ["Row 2", "Data 21", "Data 22", "Data 23", "Data 24"],
        ["Row 3", "Data 31", "Data 32", "Data 33", "Data 34"],
        ["Row 4", "Data 41", "Data 42", "Data 43", "Data 44"],
    ]

    override func setUp() async throws {
        try await super.setUp()
    }

    override func tearDown() async throws {
        try await super.tearDown()
    }

    func testInitWithNumberOfRowsAndColumns() async {
        viewModel = DynamicTableViewModel(numberOfRows: 3, numberOfColumns: 3)
        XCTAssertEqual(viewModel.tableData.count, 3)
        XCTAssertEqual(viewModel.tableData[0].count, 3)
    }

    func testInitWithTableData() async {
        viewModel = DynamicTableViewModel(tableData: mockTableData)
        XCTAssertEqual(viewModel.tableData, mockTableData)
    }

    func testAddRow() async {
        let mockOnDynamicTableUpdated = MockOnDynamicTableUpdated()
        viewModel = DynamicTableViewModel(tableData: mockTableData, onDynamicTableUpdated: mockOnDynamicTableUpdated)
        let initialRowCount = viewModel.tableData.count
        viewModel.addRow()
        XCTAssertEqual(viewModel.tableData.count, initialRowCount + 1)
        XCTAssertEqual(mockOnDynamicTableUpdated.addRow, initialRowCount)
    }

    func testAddColumn() async {
        let mockOnDynamicTableUpdated = MockOnDynamicTableUpdated()
        viewModel = DynamicTableViewModel(tableData: mockTableData, onDynamicTableUpdated: mockOnDynamicTableUpdated)
        let initialColumnCount = viewModel.tableData[0].count
        viewModel.addColumn()
        XCTAssertEqual(viewModel.tableData[0].count, initialColumnCount + 1)
        XCTAssertEqual(mockOnDynamicTableUpdated.addColumn, initialColumnCount)
    }

    func testMoveRow() async {
        let mockOnDynamicTableUpdated = MockOnDynamicTableUpdated()
        viewModel = DynamicTableViewModel(tableData: mockTableData, onDynamicTableUpdated: mockOnDynamicTableUpdated)
        let initialRow = viewModel.selectedRow
        viewModel.moveRow(from: 1, to: 2)
        XCTAssertEqual(viewModel.selectedRow, initialRow)
        XCTAssertEqual(mockOnDynamicTableUpdated.movedRow?.0, 1)
        XCTAssertEqual(mockOnDynamicTableUpdated.movedRow?.1, 2)
    }

    func testMoveColumn() async {
        let mockOnDynamicTableUpdated = MockOnDynamicTableUpdated()
        viewModel = DynamicTableViewModel(tableData: mockTableData, onDynamicTableUpdated: mockOnDynamicTableUpdated)
        let initialColumn = viewModel.selectedColumn
        viewModel.moveColumn(from: 1, to: 2)
        XCTAssertEqual(viewModel.selectedColumn, initialColumn)
        XCTAssertEqual(mockOnDynamicTableUpdated.movedColumn?.0, 1)
        XCTAssertEqual(mockOnDynamicTableUpdated.movedColumn?.1, 2)

    }

    func testDeleteRow() async {
        let mockOnDynamicTableUpdated = MockOnDynamicTableUpdated()
        viewModel = DynamicTableViewModel(tableData: mockTableData, onDynamicTableUpdated: mockOnDynamicTableUpdated)
        let initialRowCount = viewModel.tableData.count
        viewModel.selectedRow = 1
        viewModel.deleteSelectedRow()
        XCTAssertEqual(viewModel.tableData.count, initialRowCount - 1)
        XCTAssertEqual(mockOnDynamicTableUpdated.deletedRow, 1)
    }

    func testDeleteColumn() async {
        let mockOnDynamicTableUpdated = MockOnDynamicTableUpdated()
        viewModel = DynamicTableViewModel(tableData: mockTableData, onDynamicTableUpdated: mockOnDynamicTableUpdated)
        let initialColumnCount = viewModel.tableData[0].count
        viewModel.selectedColumn = 2
        viewModel.deleteSelectedColumn()
        XCTAssertEqual(viewModel.tableData[0].count, initialColumnCount - 1)
        XCTAssertEqual(mockOnDynamicTableUpdated.deletedColumn, 2)
    }

    func testSaveTableData() async {
        let mockOnDynamicTableUpdated = MockOnDynamicTableUpdated()
        viewModel = DynamicTableViewModel(tableData: mockTableData, onDynamicTableUpdated: mockOnDynamicTableUpdated)
        viewModel.tableData[1][1] = "New Data11"
        viewModel.tableData[2][3] = "New Data12"
        viewModel.onSaveTableData()
        XCTAssertEqual(viewModel.tableData[1][1], "New Data11")
        XCTAssertEqual(viewModel.tableData[2][3], "New Data12")
        XCTAssertEqual(mockOnDynamicTableUpdated.savedData, viewModel.tableData)
    }

    func testCellSelection() async {
        let mockOnDynamicTableUpdated = MockOnDynamicTableUpdated()
        viewModel = DynamicTableViewModel(tableData: mockTableData, onDynamicTableUpdated: mockOnDynamicTableUpdated)
        viewModel.handleSelection(row: 1, column: 2)
        XCTAssertEqual(mockOnDynamicTableUpdated.selectedCell?.0, 1)
        XCTAssertEqual(mockOnDynamicTableUpdated.selectedCell?.1, 2)
    }

    func testIsHeading() async {
        viewModel = DynamicTableViewModel(tableData: mockTableData)
        viewModel.selectedRow = 1
        XCTAssertTrue(viewModel.isHeading(1, 0))
        XCTAssertTrue(viewModel.isHeading(1, 1))
        viewModel.selectedColumn = 1
        XCTAssertTrue(viewModel.isHeading(0, 1))
        XCTAssertTrue(viewModel.isHeading(1, 1))
    }

    func testHandleSelection() async {
        let mockOnDynamicTableUpdated = MockOnDynamicTableUpdated()
        viewModel = DynamicTableViewModel(tableData: mockTableData, onDynamicTableUpdated: mockOnDynamicTableUpdated)
        viewModel.handleSelection(row: 1, column: 2)
        XCTAssertEqual(mockOnDynamicTableUpdated.selectedCell?.0, 1)
        XCTAssertEqual(mockOnDynamicTableUpdated.selectedCell?.1, 2)
        viewModel.handleSelection(row: 0, column: 2)
        XCTAssertEqual(mockOnDynamicTableUpdated.selectedColumn, 2)
        viewModel.handleSelection(row: 1, column: 0)
        XCTAssertEqual(mockOnDynamicTableUpdated.selectedRow, 1)
    }

    func testRowMoved() async {
        let mockOnDynamicTableUpdated = MockOnDynamicTableUpdated()
        viewModel = DynamicTableViewModel(tableData: mockTableData, onDynamicTableUpdated: mockOnDynamicTableUpdated)
        viewModel.selectedRow = 1
        viewModel.moveRow(from: 1, to: 2)
        XCTAssertEqual(mockOnDynamicTableUpdated.movedRow?.0, 1)
        XCTAssertEqual(mockOnDynamicTableUpdated.movedRow?.1, 2)
    }

    func testColumnMoved() async {
        let mockOnDynamicTableUpdated = MockOnDynamicTableUpdated()
        viewModel = DynamicTableViewModel(tableData: mockTableData, onDynamicTableUpdated: mockOnDynamicTableUpdated)
        viewModel.selectedColumn = 1
        viewModel.moveColumn(from: 1, to: 2)
        XCTAssertEqual(mockOnDynamicTableUpdated.movedColumn?.0, 1)
        XCTAssertEqual(mockOnDynamicTableUpdated.movedColumn?.1, 2)
    }

}


class MockOnDynamicTableUpdated: OnDynamicTableUpdated {

    var addRow: Int?
    var addColumn: Int?
    var deletedRow: Int?
    var deletedColumn: Int?
    var movedRow: (Int, Int)?
    var movedColumn: (Int, Int)?
    var savedData: [[String]]?
    var selectedRow: Int?
    var selectedColumn: Int?
    var selectedCell: (Int, Int)?
    var dismissedCalled = false

    func onRowAdded(row: Int) {
        addRow = row
    }

    func onColumnAdded(column: Int) {
        addColumn = column
    }

    func onRowDeleted(row: Int) {
        deletedRow = row
    }

    func onColumnDeleted(column: Int) {
        deletedColumn = column
    }

    func onRowMoved(from: Int, to: Int) {
        movedRow = (from, to)
    }

    func onColumnMoved(from: Int, to: Int) {
        movedColumn = (from, to)
    }

    func onDynamicTableUpdated(tableData: [[String]]) {
        savedData = tableData
    }

    func onRowSelected(row: Int) {
        selectedRow = row
    }

    func onColumnSelected(column: Int) {
        selectedColumn = column
    }

    func onCellSelected(row: Int, column: Int) {
        selectedCell = (row, column)
    }
}
