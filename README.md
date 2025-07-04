# Koalas

<p align="left">
  <img src="logo.svg?raw=true" alt="Koalas Logo" width="200"/>
</p>

A powerful Swift library for multidimensional data manipulation, inspired by Python's pandas. Koalas provides native Swift implementations of DataSeries, DataFrame, and DataPanel for efficient data analysis and manipulation.

## Features

- **Multi-dimensional Data Structures**: DataSeries (1D), DataFrame (2D), DataPanel (3D)
- **Comprehensive Arithmetic Operations**: Memberwise operations with automatic alignment
- **Statistical Functions**: Sum, mean, standard deviation, expanding and rolling windows
- **Missing Data Handling**: Multiple strategies for nil value management
- **Data Manipulation**: Shifting, filling, conditional operations, and reshaping
- **IO Operations**: CSV read/write, JSON encoding/decoding
- **Type Safety**: Full Swift type system integration with generics and protocols
- **Performance**: Built on Swift's collections

## Installation

### Swift Package Manager

Add Koalas to your project using Swift Package Manager:

1. In Xcode, go to **File** → **Add Package Dependencies**
2. Enter the repository URL: `https://github.com/your-username/Koalas.git`
3. Select the version you want to use
4. Click **Add Package**


```swift
import Koalas
```

## Quick Start

### Creating DataFrames

```swift
import Koalas

// Create a DataFrame with multiple columns
let df = DataFrame(dictionaryLiteral:
    ("A", DataSeries([1, 2, 3, 4, 5])),
    ("B", DataSeries([10, 20, 30, 40, 50])),
    ("C", DataSeries([100, 200, 300, 400, 500]))
)

// Create a constant DataFrame with the same shape
let constDf = df.mapTo(constant: 10.0)
```

### Basic Operations

```swift
// Arithmetic operations
let sum = df + constDf
let diff = df - constDf
let product = df * constDf
let quotient = df / constDf

// Statistical operations
let columnSums = df.columnSum()
let means = df.mean()
let stdDevs = df.std()

// Expanding operations
let expandingSums = df.expandingSum(initial: 0)
let expandingMax = df.expandingMax()
let expandingMin = df.expandingMin()
```

### Working with Missing Data

```swift
// Create DataFrame with nil values
var dfWithNils = DataFrame(dictionaryLiteral:
    ("A", DataSeries([1, nil, 3, nil, 5])),
    ("B", DataSeries([10, 20, nil, 40, 50]))
)

// Fill nil values
let filledForward = dfWithNils.fillNils(method: .forward(initial: 0))
let filledBackward = dfWithNils.fillNils(method: .backward(initial: nil))
let filledConstant = dfWithNils.fillNils(method: .all(0))
```

### Time Series Operations

```swift
// Shift data (useful for time series)
let shifted = df.shiftedBy(2)  // Shift forward by 2 positions

// Rolling window operations
let rollingSum = df.rollingSum(window: 3)
let rollingMean = df.rollingMean(window: 3)

// Custom rolling function
let rollingCustom = df.rollingFunc(initial: 0, window: 3) { window in
    // Custom aggregation logic
    return window.compactMap { $0 }.reduce(0, +)
}
```

### Conditional Operations

```swift
// Create condition DataFrame
let condition = df > 25

// Apply conditional logic
let result = whereCondition(condition, then: df * 2, else: df / 2)
```

### Data Import/Export

```swift
// Write DataFrame to CSV
try df.write(toFile: "data.csv", columnSeparator: ",")

// Read DataFrame from CSV
let importedDf = try DataFrame<String, Double>(
    contentsOfFile: "data.csv",
    columnSeparator: ","
)

// Convert to string representation
let csvLines = df.toStringRowLines(separator: ",")
```

## Data Structures

### DataSeries

A 1-dimensional data structure for handling arrays with optional values:

```swift
// Create DataSeries
let series = DataSeries([1, 2, nil, 4, 5])

// Basic operations
let doubled = series * 2
let shifted = series.shiftedBy(1)
let filled = series.fillNils(method: .forward(initial: 0))

// Statistical functions
let sum = series.sum()
let mean = series.mean()
let std = series.std()
```

### DataFrame

A 2-dimensional data structure implemented as a dictionary of DataSeries:

```swift
// Create DataFrame
let df = DataFrame(dictionaryLiteral:
    ("col1", DataSeries([1, 2, 3])),
    ("col2", DataSeries([4, 5, 6]))
)

// Access shape
let (width, height) = df.shape()

// Column operations
let columnSums = df.columnSum()
let rowSums = df.sum()
```

### DataPanel

A 3-dimensional data structure for handling multiple DataFrames:

```swift
// Create DataPanel
let panel = DataPanel(dictionaryLiteral:
    ("group1", DataFrame(dictionaryLiteral:
        ("A", DataSeries([1, 2, 3])),
        ("B", DataSeries([4, 5, 6]))
    )),
    ("group2", DataFrame(dictionaryLiteral:
        ("A", DataSeries([7, 8, 9])),
        ("B", DataSeries([10, 11, 12]))
    ))
)

// Transpose panel
let transposed = panel.transposed()
```

## Advanced Features

### Custom Aggregations

```swift
// Custom rolling function
let customRolling = df.rollingFunc(initial: 0, window: 3) { window in
    // Calculate median of window
    let sorted = window.compactMap { $0 }.sorted()
    let mid = sorted.count / 2
    return sorted.count % 2 == 0 ? 
        (sorted[mid - 1] + sorted[mid]) / 2 : 
        sorted[mid]
}
```

### Data Alignment

```swift
// DataFrames are automatically aligned by keys
let df1 = DataFrame(dictionaryLiteral:
    ("A", DataSeries([1, 2, 3])),
    ("B", DataSeries([4, 5, 6]))
)

let df2 = DataFrame(dictionaryLiteral:
    ("B", DataSeries([7, 8, 9])),
    ("A", DataSeries([10, 11, 12]))
)

// Operations automatically align by column names
let result = df1 + df2
```

### Type Safety

```swift
// Strong typing ensures type safety
let intDf = DataFrame(dictionaryLiteral:
    ("A", DataSeries([1, 2, 3]))
)

let doubleDf = DataFrame(dictionaryLiteral:
    ("A", DataSeries([1.0, 2.0, 3.0]))
)

// Type-safe operations
let result: DataFrame<String, Double> = intDf + doubleDf //Error
```

## Performance Considerations

- **Memory Efficiency**: Built on Swift's native `Array` and `Dictionary` types
- **Type Safety**: Compile-time type checking prevents runtime errors
- **Generic Operations**: Efficient operations through Swift's generic system

## Requirements

- **Swift**: 5.2 or later
- **Platforms**: macOS 10.15+, iOS 8.0+
- **Xcode**: 11.0 or later

## License

Koalas is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
