import Foundation // For random numbers and file handling

/// Generates a 2D array of marks with mean 75 and std dev 10
/// - Parameters:
///   - students: list of student names
///   - assignments: list of assignment names
/// - Returns: 2D array of strings with header row and marks
func generateMarks(students: [String], assignments: [String]) -> [[String]] {
    let rowCount = students.count + 1 // Total rows (students + header)
    let colCount = assignments.count + 1 // Total columns (assignments + header)
    
    // Create empty table
    var table = Array(repeating: Array(repeating: "", count: colCount), count: rowCount)
    
    // Set headers
    table[0][0] = "Students" // Top-left corner
    for j in 0..<assignments.count { // Loop through assignments
        table[0][j + 1] = assignments[j] // Set assignment names
    }
    
    let totalMarks = students.count * assignments.count // Total number of marks
    var allMarks = [Double]() // Array to store all generated marks
    
    // Generate Gaussian random numbers
    for _ in 0..<totalMarks {
        let u1 = Double.random(in: 0..<1) // Random number 0..1
        let u2 = Double.random(in: 0..<1) // Random number 0..1
        let z0 = sqrt(-2.0 * log(u1)) * cos(2.0 * Double.pi * u2) // Box-Muller formula
        let mark = z0 * 10 + 75 // Multiply by 10 for std dev, add 75 for mean
        allMarks.append(mark) // Add mark to array
    }
    
    // Calculate actual mean
    var sum = 0.0
    for mark in allMarks { // Sum all marks
        sum += mark
    }
    let actualMean = sum / Double(totalMarks) // Average
    
    // Shift numbers to get mean exactly 75 and clamp 0-100
    var adjustedMarks = [Double]()
    for mark in allMarks {
        var newMark = mark + (75 - actualMean) // Shift mark
        if newMark < 0 { newMark = 0 } // Clamp min 0
        if newMark > 100 { newMark = 100 } // Clamp max 100
        adjustedMarks.append(newMark) // Store adjusted mark
    }
    
    // Fill table with student names and marks
    var index = 0
    for i in 1..<rowCount { // Loop through students
        table[i][0] = students[i - 1] // Set student name
        for j in 1..<colCount { // Loop through assignments
            table[i][j] = String(Int(round(adjustedMarks[index]))) // Set mark as integer
            index += 1 // Move to next mark
        }
    }
    
    return table // Return complete table
}

// Example usage
let students = ["Angel", "Beni", "Robbert"] // Student names
let assignments = ["Assign 1", "Assign 2"] // Assignment names
let marksTable = generateMarks(students: students, assignments: assignments) // Generate marks

// Print table
for row in marksTable { // Loop through rows
    print(row.joined(separator: ",")) // Print row as CSV line
}
