<p align="left">
  <img src="logo.svg?raw=true" alt="Sublime's custom image"/>
</p>

  

## Multidimensional data manipulation library in Swift
 


# Features

- DataSeries, DataFrame, DataPanel for 1D, 2D, 3D data sets
- Missing data handling
- Automatic and explicit data alignment
- Memberwise arithmetic operations
- Flexible reshaping of data sets
- IO tools: read/write to csv, JSON encoding/decoding
- Data series-specific functionality: rolling and expanding window functions, shifting, conditional operations


# Example

### Define DataFrame

```swift
let df1 = DataFrame(dictionaryLiteral:
            ("1", DataSeries(repeating: 10.0, count: 10)),
            ("2", DataSeries(repeating: 20.0, count: 10)),
            ("3", DataSeries(repeating: 30.0, count: 10)),
            ("4", DataSeries(repeating: 40.0, count: 10)),
            ("5", DataSeries(repeating: 50.0, count: 10))
        )

```
1 | 2 | 3 | 4 | 5
--- | --- | --- | --- | ---
10.0 | 20.0 | 30.0 | 40.0 | 50.0
10.0 | 20.0 | 30.0 | 40.0 | 50.0
10.0 | 20.0 | 30.0 | 40.0 | 50.0
10.0 | 20.0 | 30.0 | 40.0 | 50.0
10.0 | 20.0 | 30.0 | 40.0 | 50.0
10.0 | 20.0 | 30.0 | 40.0 | 50.0
10.0 | 20.0 | 30.0 | 40.0 | 50.0
10.0 | 20.0 | 30.0 | 40.0 | 50.0
10.0 | 20.0 | 30.0 | 40.0 | 50.0
10.0 | 20.0 | 30.0 | 40.0 | 50.0

### Define const DataFrame with shape of existing:

```swift
let constDf = df1.mapTo(constant: 10.0)
```
### Substract DataFrames memberwise: 

```swift
let df2 = df1 - constDf      
```

1 | 2 | 3 | 4 | 5
--- | --- | --- | --- | ---
0.0 | 10.0 | 20.0 | 30.0 | 40.0
0.0 | 10.0 | 20.0 | 30.0 | 40.0
0.0 | 10.0 | 20.0 | 30.0 | 40.0
0.0 | 10.0 | 20.0 | 30.0 | 40.0
0.0 | 10.0 | 20.0 | 30.0 | 40.0
0.0 | 10.0 | 20.0 | 30.0 | 40.0
0.0 | 10.0 | 20.0 | 30.0 | 40.0
0.0 | 10.0 | 20.0 | 30.0 | 40.0
0.0 | 10.0 | 20.0 | 30.0 | 40.0
0.0 | 10.0 | 20.0 | 30.0 | 40.0

### Divide DataFrames memberwise: 

```swift
let df3 = df1 / constDf
```

1 | 2 | 3 | 4 | 5
--- | --- | --- | --- | ---
1.0 | 2.0 | 3.0 | 4.0 | 5.0
1.0 | 2.0 | 3.0 | 4.0 | 5.0
1.0 | 2.0 | 3.0 | 4.0 | 5.0
1.0 | 2.0 | 3.0 | 4.0 | 5.0
1.0 | 2.0 | 3.0 | 4.0 | 5.0
1.0 | 2.0 | 3.0 | 4.0 | 5.0
1.0 | 2.0 | 3.0 | 4.0 | 5.0
1.0 | 2.0 | 3.0 | 4.0 | 5.0
1.0 | 2.0 | 3.0 | 4.0 | 5.0
1.0 | 2.0 | 3.0 | 4.0 | 5.0

### Calculate series-wise expanding sum: 

```swift
let df4 = df3.expandingSum(initial: 0)
```
1 | 2 | 3 | 4 | 5
--- | --- | --- | --- | ---
1.0 | 2.0 | 3.0 | 4.0 | 5.0
2.0 | 4.0 | 6.0 | 8.0 | 10.0
3.0 | 6.0 | 9.0 | 12.0 | 15.0
4.0 | 8.0 | 12.0 | 16.0 | 20.0
5.0 | 10.0 | 15.0 | 20.0 | 25.0
6.0 | 12.0 | 18.0 | 24.0 | 30.0
7.0 | 14.0 | 21.0 | 28.0 | 35.0
8.0 | 16.0 | 24.0 | 32.0 | 40.0
9.0 | 18.0 | 27.0 | 36.0 | 45.0
10.0 | 20.0 | 30.0 | 40.0 | 50.0

### Shift DataFrame:

```swift
let df5 = df4.shiftedBy(5)
```

1 | 2 | 3 | 4 | 5
--- | --- | --- | --- | ---
nil | nil | nil | nil | nil
nil | nil | nil | nil | nil
nil | nil | nil | nil | nil
nil | nil | nil | nil | nil
nil | nil | nil | nil | nil
1.0 | 2.0 | 3.0 | 4.0 | 5.0
2.0 | 4.0 | 6.0 | 8.0 | 10.0
3.0 | 6.0 | 9.0 | 12.0 | 15.0
4.0 | 8.0 | 12.0 | 16.0 | 20.0
5.0 | 10.0 | 15.0 | 20.0 | 25.0


### Fill nils with backward filling:

```swift
let df6 = df5.fillNils(method: .backward(initial: nil))
```

1 | 2 | 3 | 4 | 5
--- | --- | --- | --- | ---
1.0 | 2.0 | 3.0 | 4.0 | 5.0
1.0 | 2.0 | 3.0 | 4.0 | 5.0
1.0 | 2.0 | 3.0 | 4.0 | 5.0
1.0 | 2.0 | 3.0 | 4.0 | 5.0
1.0 | 2.0 | 3.0 | 4.0 | 5.0
1.0 | 2.0 | 3.0 | 4.0 | 5.0
2.0 | 4.0 | 6.0 | 8.0 | 10.0
3.0 | 6.0 | 9.0 | 12.0 | 15.0
4.0 | 8.0 | 12.0 | 16.0 | 20.0
5.0 | 10.0 | 15.0 | 20.0 | 25.0


### Sum across columns, and turn result DataSeries into DataFrame of the initial shape:

```swift
let series1 = df6.columnSum()
let df7 = df6.mapTo(series: series1)
```


1 | 2 | 3 | 4 | 5
--- | --- | --- | --- | ---
15.0 | 15.0 | 15.0 | 15.0 | 15.0
15.0 | 15.0 | 15.0 | 15.0 | 15.0
15.0 | 15.0 | 15.0 | 15.0 | 15.0
15.0 | 15.0 | 15.0 | 15.0 | 15.0
15.0 | 15.0 | 15.0 | 15.0 | 15.0
15.0 | 15.0 | 15.0 | 15.0 | 15.0
30.0 | 30.0 | 30.0 | 30.0 | 30.0
45.0 | 45.0 | 45.0 | 45.0 | 45.0
60.0 | 60.0 | 60.0 | 60.0 | 60.0
75.0 | 75.0 | 75.0 | 75.0 | 75.0


# Installation:

### Coming soon...

# For more details check out the Docs:

### Coming soon...


# Licensing

Koalas is licensed under MIT license.
