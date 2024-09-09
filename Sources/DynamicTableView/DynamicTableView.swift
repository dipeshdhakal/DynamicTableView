// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import SwiftData

/// A view that displays a dynamic table
public struct DynamicTableView: View {

    @StateObject private var viewModel: DynamicTableViewModel

    /// Initialize the dynamic table view with the specified view model
    /// - Parameter viewModel: The view model for the dynamic table
    public init(viewModel: DynamicTableViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack {
            ScrollView([.vertical,.horizontal]) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(0..<viewModel.tableData.count, id: \.self) { rowIndex in
                        HStack(spacing: 0) {
                            ForEach(0..<viewModel.tableData[rowIndex].count, id: \.self) { columnIndex in
                                if viewModel.config.isEditable {
                                    TextField("", text: $viewModel.tableData[rowIndex][columnIndex])
                                        .font(columnIndex == 0 || rowIndex == 0 ? .headline : .body)
                                        .frame(width: 80, height: 40)
                                        .border(Color.gray)
                                        .multilineTextAlignment(.center)
                                        .background(viewModel.isHeading(rowIndex, columnIndex) ? Color.accentColor.opacity(0.3) : Color.clear)
                                        .onTapGesture {
                                            viewModel.handleSelection(row: rowIndex, column: columnIndex)
                                        }
                                        .apply {
                                            #if os(iOS)
                                                $0.keyboardType(viewModel.config.keyboardType.uiKeyboardType)
                                            #endif
                                        }
                                } else {
                                    Text(viewModel.tableData[rowIndex][columnIndex])
                                        .frame(width: 80, height: 40)
                                        .font(columnIndex == 0 || rowIndex == 0 ? .headline : .body)
                                        .border(Color.gray)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            if rowIndex == 0, viewModel.config.isEditable {
                                Button {
                                    viewModel.addColumn()
                                } label: {
                                    Image(systemName: "plus.app")
                                        .font(.title)
                                        .padding(.horizontal, 10)
                                }
                            }
                        }
                    }
                    if viewModel.config.isEditable {
                        Button {
                            viewModel.addRow()
                        } label: {
                            Image(systemName: "plus.app")
                                .font(.title)
                                .padding(.vertical, 10)
                        }
                    }
                }
            }
            .padding()
            Spacer()
            if viewModel.config.isEditable {
                HStack {
                    // Move row up and down
                    if let selectedRow = viewModel.selectedRow {
                        Button("Move Up") {
                            if selectedRow > 1 {
                                viewModel.moveRow(from: selectedRow, to: selectedRow - 1)
                                viewModel.selectedRow = selectedRow - 1
                            }
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Move Down") {
                            if selectedRow < viewModel.tableData.count - 1 {
                                viewModel.moveRow(from: selectedRow, to: selectedRow + 1)
                                viewModel.selectedRow = selectedRow + 1
                            }
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Delete") {
                            viewModel.deleteSelectedRow()
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    // Move column left and right
                    if let selectedColumn = viewModel.selectedColumn {
                        Button("Move Left") {
                            if selectedColumn > 1 {
                                viewModel.moveColumn(from: selectedColumn, to: selectedColumn - 1)
                                viewModel.selectedColumn = selectedColumn - 1
                            }
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Move Right") {
                            if selectedColumn < viewModel.tableData[0].count - 1 {
                                viewModel.moveColumn(from: selectedColumn, to: selectedColumn + 1)
                                viewModel.selectedColumn = selectedColumn + 1
                            }
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Delete") {
                            viewModel.deleteSelectedColumn()
                        }
                        .buttonStyle(.borderedProminent)

                    }
                }
            }

            if viewModel.config.isEditable {
                Button("Save changes") {
                    viewModel.onSaveTableData()
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

extension View {
    func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V { block(self) }
}

#Preview {
    VStack {
        DynamicTableView(viewModel: DynamicTableViewModel(numberOfRows: 4, numberOfColumns: 4, config: DynamicTableConfig(isEditable: true, keyboardType: .decimalPad)))
        DynamicTableView(viewModel: DynamicTableViewModel(tableData: [["R1", "R2", "R3"], ["C1", "2", "3"], ["C2", "5", "6"]], config: DynamicTableConfig(isEditable: false)))
    }
}
