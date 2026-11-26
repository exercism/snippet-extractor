#[derive(Debug, PartialEq)]
pub struct Matrix {
    rows: Vec<Vec<u32>>,
}

/// Creates a matrix from the given text.
impl Matrix {
    pub fn new(input: &str) -> Self {
        // Parse each line into a row
        let rows = input
            .lines()
            .map(|line| line.split(' ').map(|n| n.parse().unwrap()).collect())
            .collect();
        Matrix { rows }
    }
