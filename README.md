# DynamicTableView
A SPM package for displaying dynamic table view with multiple sections and rows.

## installation
Using SPM:

```swift

dependencies: [.package(url: "git@github.com:dipeshdhakal/DynamicTableView.git", .upToNextMinor(from: "1.0.0"))]
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

## Screenshots:
<img width="225" alt="Screenshot 2024-09-09 at 3 08 29 PM" src="https://github.com/user-attachments/assets/a45e7aa1-3674-475e-b81f-ccc5f73248c7">
<img width="228" alt="Screenshot 2024-09-09 at 3 07 48 PM" src="https://github.com/user-attachments/assets/8ad33cd1-b694-4082-adc0-5a4f74d47b66">
<img width="481" alt="Screenshot 2024-09-09 at 3 09 07 PM" src="https://github.com/user-attachments/assets/82571db1-56a7-44f4-90a6-8104b88267fc">



