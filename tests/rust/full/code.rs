//! Solution for the Matrix exercise.
//! Rows and columns are stored as vectors.

#![allow(dead_code)]

extern crate itertools;

use std::collections::{
    BTreeMap,
    HashMap,
};
use std::fmt;

/* A grid of numbers.
 * It is parsed from a multi-line string.
 */
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
}
