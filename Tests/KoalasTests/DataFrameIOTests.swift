//
//  DataFrameIOTests.swift
//  
//
//  Created by AI Assistant on 2024.
//

import XCTest
@testable import Koalas

final class DataFrameIOTests: XCTestCase {
    
    // MARK: - toStringRowLines Tests
    
    func test_toStringRowLines_WithValidData() {
        let s1 = DataSeries([1, 2, 3, 4])
        let s2 = DataSeries([5, 6, 7, 8])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.toStringRowLines(separator: ",")
        
        XCTAssertEqual(result.count, 5) // Header + 4 data rows
        XCTAssertEqual(result[0], "col1,col2") // Header
        XCTAssertEqual(result[1], "1,5") // First row
        XCTAssertEqual(result[2], "2,6") // Second row
        XCTAssertEqual(result[3], "3,7") // Third row
        XCTAssertEqual(result[4], "4,8") // Fourth row
    }
    
    func test_toStringRowLines_WithNilValues() {
        let s1 = DataSeries([1, nil, 3, 4])
        let s2 = DataSeries([5, 6, nil, 8])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.toStringRowLines(separator: ";")
        
        XCTAssertEqual(result.count, 5) // Header + 4 data rows
        XCTAssertEqual(result[0], "col1;col2") // Header
        XCTAssertEqual(result[1], "1;5") // First row
        XCTAssertEqual(result[2], "nil;6") // Second row
        XCTAssertEqual(result[3], "3;nil") // Third row
        XCTAssertEqual(result[4], "4;8") // Fourth row
    }
    
    func test_toStringRowLines_WithDifferentSeparator() {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let result = df.toStringRowLines(separator: "|")
        
        XCTAssertEqual(result.count, 4) // Header + 3 data rows
        XCTAssertEqual(result[0], "col1|col2") // Header
        XCTAssertEqual(result[1], "1|4") // First row
        XCTAssertEqual(result[2], "2|5") // Second row
        XCTAssertEqual(result[3], "3|6") // Third row
    }
    
    func test_toStringRowLines_WithEmptyDataFrame() {
        let df: DataFrame<String, Int> = [:]
        
        let result = df.toStringRowLines(separator: ",")
        
        XCTAssertEqual(result.count, 1) // Only header
        XCTAssertEqual(result[0], "") // Empty header
    }
    
    // MARK: - write Tests
    
    func test_write_WithValidData() throws {
        let s1 = DataSeries([1, 2, 3, 4])
        let s2 = DataSeries([5, 6, 7, 8])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let fileManager = FileManager.default
        let fileURL = fileManager.temporaryDirectory.appendingPathComponent("test_write").appendingPathExtension("csv")
        
        try df.write(toFile: fileURL.path, columnSeparator: ",")
        
        // Verify file was created
        XCTAssertTrue(fileManager.fileExists(atPath: fileURL.path))
        
        // Read and verify content
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        XCTAssertEqual(lines.count, 5) // Header + 4 data rows
        XCTAssertEqual(lines[0], "col1,col2")
        XCTAssertEqual(lines[1], "1,5")
        XCTAssertEqual(lines[2], "2,6")
        XCTAssertEqual(lines[3], "3,7")
        XCTAssertEqual(lines[4], "4,8")
        
        // Clean up
        try fileManager.removeItem(at: fileURL)
    }
    
    func test_write_WithNilValues() throws {
        let s1 = DataSeries([1, nil, 3, 4])
        let s2 = DataSeries([5, 6, nil, 8])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let fileManager = FileManager.default
        let fileURL = fileManager.temporaryDirectory.appendingPathComponent("test_write_nil").appendingPathExtension("csv")
        
        try df.write(toFile: fileURL.path, columnSeparator: ";")
        
        // Verify file was created
        XCTAssertTrue(fileManager.fileExists(atPath: fileURL.path))
        
        // Read and verify content
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        XCTAssertEqual(lines.count, 5) // Header + 4 data rows
        XCTAssertEqual(lines[0], "col1;col2")
        XCTAssertEqual(lines[1], "1;5")
        XCTAssertEqual(lines[2], "nil;6")
        XCTAssertEqual(lines[3], "3;nil")
        XCTAssertEqual(lines[4], "4;8")
        
        // Clean up
        try fileManager.removeItem(at: fileURL)
    }
    
    func test_write_WithCustomEncoding() throws {
        let s1 = DataSeries([1, 2, 3])
        let s2 = DataSeries([4, 5, 6])
        
        let df = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2))
        
        let fileManager = FileManager.default
        let fileURL = fileManager.temporaryDirectory.appendingPathComponent("test_write_encoding").appendingPathExtension("csv")
        
        try df.write(toFile: fileURL.path, encoding: .utf8, columnSeparator: "|")
        
        // Verify file was created
        XCTAssertTrue(fileManager.fileExists(atPath: fileURL.path))
        
        // Read and verify content
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        XCTAssertEqual(lines.count, 4) // Header + 3 data rows
        XCTAssertEqual(lines[0], "col1|col2")
        XCTAssertEqual(lines[1], "1|4")
        XCTAssertEqual(lines[2], "2|5")
        XCTAssertEqual(lines[3], "3|6")
        
        // Clean up
        try fileManager.removeItem(at: fileURL)
    }
    
    // MARK: - init from file Tests
    
    func test_initFromFile_WithValidData() throws {
        let fileManager = FileManager.default
        let fileURL = fileManager.temporaryDirectory.appendingPathComponent("test_init").appendingPathExtension("csv")
        
        // Create test file
        let content = """
        col1,col2,col3
        1,5,9
        2,6,10
        3,7,11
        4,8,12
        """
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        
        let df = try DataFrame<String, Int>(contentsOfFile: fileURL.path, columnSeparator: ",")
        
        XCTAssertEqual(df.count, 3) // 3 columns
        XCTAssertEqual(df["col1"]?.count, 4) // 4 rows
        XCTAssertEqual(df["col2"]?.count, 4)
        XCTAssertEqual(df["col3"]?.count, 4)
        
        XCTAssertEqual(df["col1"]?[0], 1)
        XCTAssertEqual(df["col1"]?[1], 2)
        XCTAssertEqual(df["col1"]?[2], 3)
        XCTAssertEqual(df["col1"]?[3], 4)
        
        XCTAssertEqual(df["col2"]?[0], 5)
        XCTAssertEqual(df["col2"]?[1], 6)
        XCTAssertEqual(df["col2"]?[2], 7)
        XCTAssertEqual(df["col2"]?[3], 8)
        
        XCTAssertEqual(df["col3"]?[0], 9)
        XCTAssertEqual(df["col3"]?[1], 10)
        XCTAssertEqual(df["col3"]?[2], 11)
        XCTAssertEqual(df["col3"]?[3], 12)
        
        // Clean up
        try fileManager.removeItem(at: fileURL)
    }
    
    func test_initFromFile_WithNilValues() throws {
        let fileManager = FileManager.default
        let fileURL = fileManager.temporaryDirectory.appendingPathComponent("test_init_nil").appendingPathExtension("csv")
        
        // Create test file with nil values
        let content = """
        col1,col2,col3
        1,5,9
        nil,6,10
        3,nil,11
        4,8,nil
        """
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        
        let df = try DataFrame<String, Int>(contentsOfFile: fileURL.path, columnSeparator: ",")
        
        XCTAssertEqual(df.count, 3) // 3 columns
        XCTAssertEqual(df["col1"]?.count, 4) // 4 rows
        
        XCTAssertEqual(df["col1"]?[0], 1)
        XCTAssertNil(df["col1"]?[1])
        XCTAssertEqual(df["col1"]?[2], 3)
        XCTAssertEqual(df["col1"]?[3], 4)
        
        XCTAssertEqual(df["col2"]?[0], 5)
        XCTAssertEqual(df["col2"]?[1], 6)
        XCTAssertNil(df["col2"]?[2])
        XCTAssertEqual(df["col2"]?[3], 8)
        
        XCTAssertEqual(df["col3"]?[0], 9)
        XCTAssertEqual(df["col3"]?[1], 10)
        XCTAssertEqual(df["col3"]?[2], 11)
        XCTAssertNil(df["col3"]?[3])
        
        // Clean up
        try fileManager.removeItem(at: fileURL)
    }
    
    func test_initFromFile_WithDifferentSeparator() throws {
        let fileManager = FileManager.default
        let fileURL = fileManager.temporaryDirectory.appendingPathComponent("test_init_separator").appendingPathExtension("csv")
        
        // Create test file with different separator
        let content = """
        col1|col2
        1|5
        2|6
        3|7
        """
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        
        let df = try DataFrame<String, Int>(contentsOfFile: fileURL.path, columnSeparator: "|")
        
        XCTAssertEqual(df.count, 2) // 2 columns
        XCTAssertEqual(df["col1"]?.count, 3) // 3 rows
        XCTAssertEqual(df["col2"]?.count, 3)
        
        XCTAssertEqual(df["col1"]?[0], 1)
        XCTAssertEqual(df["col1"]?[1], 2)
        XCTAssertEqual(df["col1"]?[2], 3)
        
        XCTAssertEqual(df["col2"]?[0], 5)
        XCTAssertEqual(df["col2"]?[1], 6)
        XCTAssertEqual(df["col2"]?[2], 7)
        
        // Clean up
        try fileManager.removeItem(at: fileURL)
    }
    
    func test_initFromFile_WithEmptyFile() throws {
        let fileManager = FileManager.default
        let fileURL = fileManager.temporaryDirectory.appendingPathComponent("test_init_empty").appendingPathExtension("csv")
        
        // Create empty file
        try "".write(to: fileURL, atomically: true, encoding: .utf8)
        
        let df = try DataFrame<String, Int>(contentsOfFile: fileURL.path, columnSeparator: ",")
        
        XCTAssertEqual(df.count, 0) // No columns
        
        // Clean up
        try fileManager.removeItem(at: fileURL)
    }
    
    func test_initFromFile_WithOnlyHeader() throws {
        let fileManager = FileManager.default
        let fileURL = fileManager.temporaryDirectory.appendingPathComponent("test_init_header").appendingPathExtension("csv")
        
        // Create file with only header
        let content = "col1,col2,col3"
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        
        let df = try DataFrame<String, Int>(contentsOfFile: fileURL.path, columnSeparator: ",")
        
        XCTAssertEqual(df.count, 3) // 3 columns
        XCTAssertEqual(df["col1"]?.count, 0) // No data rows
        XCTAssertEqual(df["col2"]?.count, 0)
        XCTAssertEqual(df["col3"]?.count, 0)
        
        // Clean up
        try fileManager.removeItem(at: fileURL)
    }
    
    func test_initFromFile_WithInvalidPath() {
        let invalidPath = "/nonexistent/path/file.csv"
        
        XCTAssertThrowsError(try DataFrame<String, Int>(contentsOfFile: invalidPath, columnSeparator: ","))
    }
    
    // MARK: - Round-trip Tests
    
    func test_writeAndRead_RoundTrip() throws {
        let s1 = DataSeries([1, 2, 3, 4])
        let s2 = DataSeries([5, 6, 7, 8])
        let s3 = DataSeries([9, 10, 11, 12])
        
        let originalDF = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2), ("col3", s3))
        
        let fileManager = FileManager.default
        let fileURL = fileManager.temporaryDirectory.appendingPathComponent("test_roundtrip").appendingPathExtension("csv")
        
        // Write DataFrame
        try originalDF.write(toFile: fileURL.path, columnSeparator: ",")
        
        // Read DataFrame back
        let readDF = try DataFrame<String, Int>(contentsOfFile: fileURL.path, columnSeparator: ",")
        
        // Verify they are equal
        XCTAssertTrue(originalDF.equalsTo(dataframe: readDF))
        
        // Clean up
        try fileManager.removeItem(at: fileURL)
    }
    
    func test_writeAndRead_RoundTripWithNilValues() throws {
        let s1 = DataSeries([1, nil, 3, 4])
        let s2 = DataSeries([5, 6, nil, 8])
        let s3 = DataSeries([9, 10, 11, nil])
        
        let originalDF = DataFrame(dictionaryLiteral: ("col1", s1), ("col2", s2), ("col3", s3))
        
        let fileManager = FileManager.default
        let fileURL = fileManager.temporaryDirectory.appendingPathComponent("test_roundtrip_nil").appendingPathExtension("csv")
        
        // Write DataFrame
        try originalDF.write(toFile: fileURL.path, columnSeparator: ",")
        
        // Read DataFrame back
        let readDF = try DataFrame<String, Int>(contentsOfFile: fileURL.path, columnSeparator: ",")
        
        // Verify they are equal
        XCTAssertTrue(originalDF.equalsTo(dataframe: readDF))
        
        // Clean up
        try fileManager.removeItem(at: fileURL)
    }
} 