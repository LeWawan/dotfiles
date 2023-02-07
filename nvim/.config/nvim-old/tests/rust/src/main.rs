fn main() {
    println!("Hello, world!");
    print!("hello: {}", truthy());
}
fn truthy() -> bool {
   true
}

#[cfg(test)]

mod tests {
    use crate::*;


    #[test]
    fn is_truthy() {
        assert!(truthy());
    }
}
