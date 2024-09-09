# DynamicTableView
A SPM package for displaying dynamic table view with multiple sections and rows.

## installation
Using SPM:

```swift

dependencies: [.package(url: "https://github.expedia.biz/eg-ios/stability-tracker-ios.git", .upToNextMinor(from: "1.0.0"))]
```

## Usage
### Init by populating existing data: 
```swift
        let viewModel = DynamicTableView(viewModel: DynamicTableViewModel(tableData: [["R1", "R2", "R3"], ["C1", "2", "3"], ["C2", "5", "6"]], config: DynamicTableConfig(isEditable: true, keyboardType: .decimalPad), onDynamicTableUpdated: MyImplementation()))
        let view = DynamicTableView(viewModel: viewModel)
        
```
### Init by specifying number of rows and columns: 
```swift
        let viewModel = DynamicTableView(viewModel: DynamicTableViewModel(numberOfRows: 4, numberOfColumns: 4, config: DynamicTableConfig(isEditable: true, keyboardType: .decimalPad), onDynamicTableUpdated: MyImplementation()))
        let view = DynamicTableView(viewModel: viewModel)
        
```
### Init for read only mode: 
```swift
        let viewModel = DynamicTableView(viewModel: DynamicTableViewModel(tableData: [["R1", "R2", "R3"], ["C1", "2", "3"], ["C2", "5", "6"]], config: DynamicTableConfig(isEditable: false, keyboardType: .decimalPad), onDynamicTableUpdated: MyImplementation()))
        let view = DynamicTableView(viewModel: viewModel)
        
```
