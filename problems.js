const problems = [
  {
    id: 1,
    question: "What is the sum of the first 10 positive integers?",
    options: ["45", "50", "55", "60"],
    answer: "55",
    explanation: "The formula for the sum of the first n positive integers is n(n+1)/2. For n=10, 10*11/2 = 55.",
    level: 2,
    topics: ["Number Theory"],
    style: "Waterloo-style"
  },
  {
    id: 2,
    question: "If a triangle has sides 3, 4, and 5, what type of triangle is it?",
    options: ["Equilateral", "Isosceles", "Scalene", "Right-angled"],
    answer: "Right-angled",
    explanation: "Using Pythagoras' theorem: 3² + 4² = 9 + 16 = 25 = 5², so it's a right-angled triangle.",
    level: 4,
    topics: ["Geometry"],
    style: "AMC-style"
  },
  {
    id: 3,
    question: "What is 25% of 200?",
    options: ["25", "50", "75", "100"],
    answer: "50",
    explanation: "25% of 200 is (25/100) * 200 = 50.",
    level: 1,
    topics: ["Algebra"],
    style: "Waterloo-style"
  },
  {
    id: 4,
    question: "How many factors does 12 have?",
    options: ["4", "5", "6", "7"],
    answer: "6",
    explanation: "The factors of 12 are 1, 2, 3, 4, 6, 12. That's 6 factors.",
    level: 3,
    topics: ["Number Theory"],
    style: "AMC-style"
  },
  {
    id: 5,
    question: "What is the next number in the sequence: 2, 4, 8, 16, ...?",
    options: ["24", "32", "64", "128"],
    answer: "32",
    explanation: "Each number is double the previous: 2*2=4, 4*2=8, 8*2=16, 16*2=32.",
    level: 2,
    topics: ["Algebra"],
    style: "Waterloo-style"
  }
];

// Export for use in app.js
if (typeof module !== 'undefined' && module.exports) {
  module.exports = problems;
}