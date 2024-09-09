import Foundation
import SwiftUI

/// Protocol for handling updates to the dynamic table
public protocol OnDynamicTableUpdated {
    /// Called when the table data is updated
    func onDynamicTableUpdated(tableData: [[String]])
    /// Called when a row is selected
    func onRowSelected(row: Int)
    /// Called when a column is selected
    func onColumnSelected(column: Int)
    /// Called when a new row is added
    func onRowAdded(row: Int)
    /// Called when a new column is added
    func onColumnAdded(column: Int)
    /// Called when
    func onRowDeleted(row: Int)
    /// Called when a column is deleted
    func onColumnDeleted(column: Int)
    /// Called when a cell is selected
    func onCellSelected(row: Int, column: Int)
    /// Called when a row is moved
    func onRowMoved(from: Int, to: Int)
    /// Called when a column is moved
    func onColumnMoved(from: Int, to: Int)
}

/// Enum representing the different types of keyboards
public enum KeyboardType {
    case `default`,
         numberPad,
         decimalPad

#if os(iOS)
        var uiKeyboardType: UIKeyboardType {
            switch self {
            case .default:
                return .default
            case .numberPad:
                return .numberPad
            case .decimalPad:
                return .decimalPad
            }
        }
#endif
}

/// Configuration for the dynamic table
public struct DynamicTableConfig {
    var isEditable: Bool = true
    var keyboardType: KeyboardType

    /// Initialize the configuration with the specified parameters
    /// - Parameters:
    /// - isEditable: Whether the table is editable
    /// - keyboardType: The keyboard type for the input fields
    public init(isEditable: Bool = true, keyboardType: KeyboardType = .default) {
        self.isEditable = isEditable
        self.keyboardType = keyboardType
    }
}

/// View model for the dynamic table
public class DynamicTableViewModel: ObservableObject {
    
    @Published public var tableData: [[String]]
    @Published public var selectedRow: Int? = nil
    @Published public var selectedColumn: Int? = nil

    /// Closure to be called when the table data is updated
    var onDynamicTableUpdated: OnDynamicTableUpdated? = nil
    var config: DynamicTableConfig

    /// Initialize the view model with a table of the specified size
    /// - Parameters:
    ///  - numberOfRows: The number of rows in the table
    ///  - numberOfColumns: The number of columns in the table
    ///  - onDynamicTableUpdated: Closure to be called when the table data is updated
    public init(numberOfRows: Int = 2, numberOfColumns: Int = 2, config: DynamicTableConfig = DynamicTableConfig(), onDynamicTableUpdated: OnDynamicTableUpdated? = nil) {
        self.onDynamicTableUpdated = onDynamicTableUpdated
        self.config = config
        self.tableData = Array(repeating: Array(repeating: "", count: numberOfColumns), count: numberOfRows)
        for i in 1..<numberOfRows {
            tableData[i][0] = "Row \(i)"
        }
        for j in 1..<numberOfColumns {
            tableData[0][j] = "Col \(j)"
        }
    }

    /// Initialize the view model with a table of the specified data
    /// - Parameters:
    /// - tableData: The initial data for the table
    /// - onDynamicTableUpdated: Closure to be called when the table data is updated
    public init(tableData: [[String]], config: DynamicTableConfig = DynamicTableConfig(), onDynamicTableUpdated: OnDynamicTableUpdated? = nil) {
        self.onDynamicTableUpdated = onDynamicTableUpdated
        self.config = config
        self.tableData = tableData
    }

    func addRow() {
        let newRow = Array(repeating: "", count: tableData[0].count)
        tableData.append(newRow)
        tableData[tableData.count - 1][0] = "Row \(tableData.count - 1)"
        onDynamicTableUpdated?.onRowAdded(row: tableData.count - 1)
    }

    func addColumn() {
        for i in 0..<tableData.count {
            tableData[i].append("")
        }
        tableData[0][tableData[0].count - 1] = "Col \(tableData[0].count - 1)"
        onDynamicTableUpdated?.onColumnAdded(column: tableData[0].count - 1)
    }

    func deleteSelectedRow() {
        if let row = selectedRow, row > 0 {
            tableData.remove(at: row)
            selectedRow = nil
            onDynamicTableUpdated?.onRowDeleted(row: row)
        }
    }

    func deleteSelectedColumn() {
        if let column = selectedColumn, column > 0 {
            for i in 0..<tableData.count {
                tableData[i].remove(at: column)
            }
            selectedColumn = nil
            onDynamicTableUpdated?.onColumnDeleted(column: column)
        }
    }

    func moveRow(from source: Int, to destination: Int) {
        guard source > 0, destination > 0 else { return }
        let movedRow = tableData.remove(at: source)
        tableData.insert(movedRow, at: destination)
        onDynamicTableUpdated?.onRowMoved(from: source, to: destination)
    }

    func moveColumn(from source: Int, to destination: Int) {
        guard source > 0, destination > 0 else { return }
        for i in 0..<tableData.count {
            let movedValue = tableData[i].remove(at: source)
            tableData[i].insert(movedValue, at: destination)
        }
        onDynamicTableUpdated?.onColumnMoved(from: source, to: destination)
    }

    func onSaveTableData() {
        onDynamicTableUpdated?.onDynamicTableUpdated(tableData: tableData)
    }

    func isHeading(_ row: Int, _ column: Int) -> Bool {
        return (selectedRow != nil && row == selectedRow) ||
               (selectedColumn != nil && column == selectedColumn)
    }

    func handleSelection(row: Int, column: Int) {
        if row == 0 && column > 0 {
            selectedColumn = column
            selectedRow = nil
            onDynamicTableUpdated?.onColumnSelected(column: column)
        } else if column == 0 && row > 0 {
            selectedRow = row
            selectedColumn = nil
            onDynamicTableUpdated?.onRowSelected(row: row)
        } else {
            selectedRow = nil
            selectedColumn = nil
            onDynamicTableUpdated?.onCellSelected(row: row, column: column)
        }
    }
}

