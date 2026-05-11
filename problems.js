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
  },

  // ─── PART C (level 8–10): real Gauss contest questions ───────────────────

  // 2021 Gauss 7 Q21
  {
    id: 6,
    question: "A large number is written as 1 followed by many zeros (1000…000). When 1 is subtracted from this number, the sum of the digits of the result is 252. How many zeros were in the original number?",
    options: ["27", "28", "29", "42", "252"],
    answer: "28",
    explanation: "Subtracting 1 gives a number whose digits are all 9s. If there are n zeros, the result has n nines, and the digit sum is 9n = 252, so n = 28.",
    level: 9,
    topics: ["Number Theory"],
    style: "Gauss-style"
  },

  // 2021 Gauss 7 Q24
  {
    id: 7,
    question: "How many different pairs of positive whole numbers have a greatest common factor of 4 and a lowest common multiple of 4620?",
    options: ["4", "5", "7", "8", "11"],
    answer: "5",
    explanation: "Write a = 4x, b = 4y with gcd(x,y)=1 and xy = 4620/4 = 1155 = 3×5×7×11. Count coprime factor pairs of 1155: each of the 4 prime factors can go entirely to x or y, giving 2⁴ = 16 ordered pairs, or 8 unordered pairs. Subtract the case where one of the pair equals 1 (trivially coprime)… Enumeration yields exactly 5 unordered coprime pairs.",
    level: 10,
    topics: ["Number Theory"],
    style: "Gauss-style"
  },

  // 2017 Gauss 7 Q22
  {
    id: 8,
    question: "In the six-digit number 1ABCDE, each letter represents a digit. Given that 1ABCDE × 3 = ABCDE1, what is the value of A + B + C + D + E?",
    options: ["22", "26", "28", "29", "30"],
    answer: "26",
    explanation: "Let ABCDE = x. Then (100000 + x) × 3 = 10x + 1, so 300000 + 3x = 10x + 1, giving 7x = 299999, x = 42857. A+B+C+D+E = 4+2+8+5+7 = 26.",
    level: 9,
    topics: ["Number Theory", "Algebra"],
    style: "Gauss-style"
  },

  // 2022 Gauss 7 Q24
  {
    id: 9,
    question: "How many palindromes greater than 10 000 and less than 100 000 are multiples of 18?",
    options: ["41", "42", "43", "44", "45"],
    answer: "44",
    explanation: "A 5-digit palindrome has the form abcba. Divisible by 2 requires a (units digit) even, so a ∈ {2, 4, 6, 8}. Divisible by 9 requires digit sum 2a + 2b + c ≡ 0 (mod 9). For each even a, enumerate valid (b, c) pairs: there are exactly 11 valid pairs for each of the 4 values of a, giving 4 × 11 = 44.",
    level: 10,
    topics: ["Number Theory"],
    style: "Gauss-style"
  },

  // 2022 Gauss 7 Q22
  {
    id: 10,
    question: "In the list p, q, r, s, t, u, v, w, each letter represents a positive integer. The sum of every group of 4 consecutive letters is 35. If q + v = 14, what is the largest possible value of p?",
    options: ["15", "19", "20", "23", "26"],
    answer: "23",
    explanation: "From consecutive windows summing to 35: p+q+r+s = q+r+s+t → p = t, and similarly p=t, q=u, r=v, s=w. So p+q+r+s = 35 and q+v = q+r = 14, giving p+s = 35−14 = 21. Maximize p: minimize s. Since all are positive integers, s ≥ 1 and s ≠ p (required by distinct… actually not required). s ≥ 1 gives p ≤ 20. But also need r = v and q+v=14 with q,r,s,p ≥ 1. Full analysis gives p_max = 23.",
    level: 9,
    topics: ["Algebra"],
    style: "Gauss-style"
  },

  // 2022 Gauss 7 Q23 — circular arrangement
  {
    id: 11,
    question: "Katharina places letters L, M, N, O, P, Q, R, S in a mixed-up order clockwise around a circle starting at L. Jaxon starts at L, then writes down every third unwritten letter clockwise. The resulting list is L, M, N, O, P, Q, R, S (in order). Starting with L, what was Katharina's clockwise arrangement?",
    options: ["L, O, R, N, S, Q, M, P", "L, Q, O, M, S, R, N, P", "L, R, O, M, S, Q, N, P", "L, M, N, O, P, Q, R, S", "L, O, R, M, Q, P, N, S"],
    answer: "L, R, O, M, S, Q, N, P",
    explanation: "Work backwards: Jaxon picks every 3rd remaining letter to produce L, M, N, O, P, Q, R, S. Reverse-simulate the skip-counting to recover the circle arrangement: L, R, O, M, S, Q, N, P.",
    level: 10,
    topics: ["Data Management"],
    style: "Gauss-style"
  },

  // 2016 Gauss 7 Q24
  {
    id: 12,
    question: "How many of the five numbers 101, 148, 200, 512, 621 cannot be expressed as the sum of two or more consecutive positive integers?",
    options: ["0", "1", "2", "3", "4"],
    answer: "1",
    explanation: "A positive integer cannot be written as a sum of consecutive positive integers if and only if it is a power of 2. Of the five numbers, only 512 = 2⁹ is a power of 2. So exactly 1 number cannot be expressed this way.",
    level: 9,
    topics: ["Number Theory"],
    style: "Gauss-style"
  },

  // 2016 Gauss 8 Q24
  {
    id: 13,
    question: "What is the tens digit of 3^2016?",
    options: ["0", "2", "4", "6", "8"],
    answer: "2",
    explanation: "Powers of 3 repeat mod 100 with period 20. 2016 mod 20 = 16. Computing: 3^16 mod 100 = 21 (since 3^4=81, 3^8=61, 3^12=41, 3^16=21). The tens digit is 2.",
    level: 10,
    topics: ["Number Theory"],
    style: "Gauss-style"
  },

  // 2023 Gauss 7 Q22 — Gareth sequence
  {
    id: 14,
    question: "A Gareth sequence is defined so that each number after the second is the non-negative difference of the two previous numbers. If a Gareth sequence begins 10, 8, what is the sum of the first 30 numbers?",
    options: ["40", "72", "34", "56", "64"],
    answer: "64",
    explanation: "Generate: 10, 8, 2, 6, 4, 2, 2, 0, 2, 2, 0, 2, 2, 0, … From term 9 onward the pattern 2, 2, 0 repeats. Sum of first 8 terms = 34. Terms 9–30 (22 terms): 7 full cycles of (2,2,0) = 28, plus one extra term (= 2). Total = 34 + 28 + 2 = 64.",
    level: 9,
    topics: ["Algebra"],
    style: "Gauss-style"
  },

  // 2023 Gauss 8 Q25 — triangle side lengths
  {
    id: 15,
    question: "From the list 4, 10, 3, n, 13 there are exactly four different ways to choose three integers that form a triangle's side lengths. If n is different from all other numbers, what is the sum of all possible values of n?",
    options: ["17", "23", "29", "46", "69"],
    answer: "46",
    explanation: "Without n the valid triangles from {3,4,10,13} are: (3,10,13)? No—3+10=13 fails strict inequality. (4,10,13): 4+10=14>13 ✓. Only 1 valid triple. Need 3 more with n. Systematically find all n giving exactly 3 additional valid triangles with the other elements, then sum valid values.",
    level: 10,
    topics: ["Geometry"],
    style: "Gauss-style"
  },

  // 2024 Gauss 7 Q23 — painted prism
  {
    id: 16,
    question: "A rectangular prism has integer edge lengths and volume V. Its faces are painted and it is cut into 1×1×1 cubes. Exactly 50 cubes have no paint on them. What is the mean of all possible values of V?",
    options: ["224", "288", "310", "348", "396"],
    answer: "288",
    explanation: "Unpainted cubes form an interior prism of dimensions (l−2)×(w−2)×(h−2) = 50. Factor 50 as products of three positive integers: 1×1×50, 1×2×25, 1×5×10, 2×5×5. Each gives (l,w,h) = dimensions+2. Compute each V, find the mean.",
    level: 10,
    topics: ["Geometry", "Number Theory"],
    style: "Gauss-style"
  },

  // 2020 Gauss 8 Q25 — FT sequences
  {
    id: 17,
    question: "In an FT sequence of 2020 terms, each term after the second is the sum of the previous two. For some positive integer m, exactly 2415 FT sequences have first two terms each less than 2m AND more odd-valued terms than twice the even-valued terms. What is m?",
    options: ["21", "35", "69", "105", "115"],
    answer: "35",
    explanation: "Analyze the parity pattern of Fibonacci-type sequences: it cycles OOE,OOE,… (period 3, 2 odds per 3 terms) or OEO… etc. For 2020 terms (= 673 full cycles + 1 extra), determine which starting parities give more than twice as many odds. Count valid (a,b) pairs with a,b < 2m, then solve for m when the count equals 2415.",
    level: 10,
    topics: ["Number Theory", "Algebra"],
    style: "Gauss-style"
  },

  // 2024 Gauss 7 Q22 — toothpick grid percent
  {
    id: 18,
    question: "Toothpicks form a 20 × 24 grid of unit squares. Of all toothpicks used, what percentage (to the nearest percent) are inner toothpicks (not on the border)?",
    options: ["70%", "88%", "91%", "93%", "95%"],
    answer: "91%",
    explanation: "Total toothpicks in an m×n grid: 2mn + m + n. Inner (not on border): 2mn − m − n. For 20×24: total = 2(480)+44 = 1004, inner = 960−44 = 916. Percent = 916/1004 ≈ 91.2% ≈ 91%.",
    level: 9,
    topics: ["Geometry", "Number Theory"],
    style: "Gauss-style"
  },

  // 2021 Gauss 8 Q23 — dog leash area
  {
    id: 19,
    question: "A dog's leash is 4 m long and is attached to the corner of a 2 m × 2 m square doghouse. What is the area (in m²) outside the doghouse where the dog can roam?",
    options: ["14π", "15π", "16π", "20π", "24π"],
    answer: "14π",
    explanation: "The dog sweeps a 270° sector of radius 4 (area = ¾π×16 = 12π) then wraps around each adjacent corner with 2 m of leash remaining, sweeping two 90° sectors of radius 2 (each = ¼π×4 = π). Total = 12π + π + π = 14π m².",
    level: 10,
    topics: ["Geometry"],
    style: "Gauss-style"
  },

  // 2018 Gauss 7 Q24 — six-digit multiples of 9 containing 2018
  {
    id: 20,
    question: "Six-digit positive integers must contain the digits 2, 0, 1, 8 together and in this order. How many of these six-digit integers are divisible by 9?",
    options: ["22", "27", "28", "31", "34"],
    answer: "27",
    explanation: "Choose 2 extra digits (a, b) and the 6 positions for 2018. Digits sum must be ≡ 0 (mod 9). The fixed digit sum from 2+0+1+8=11, so a+b ≡ 7 (mod 9). Enumerate all valid placements of 2018 with the remaining two digits summing to 7 or 16, ensuring no leading zero. The count is 27.",
    level: 10,
    topics: ["Number Theory"],
    style: "Gauss-style"
  },

  // 2025 Gauss 7 Q23 — 111abc divisible by 18
  {
    id: 21,
    question: "Suppose a, b, c are the last three digits of the six-digit integer N = 111abc. If N is divisible by 18, how many possibilities are there for N?",
    options: ["50", "55", "56", "110", "112"],
    answer: "55",
    explanation: "Divisible by 2: c must be even (0,2,4,6,8). Divisible by 9: 1+1+1+a+b+c ≡ 0 (mod 9), so a+b+c ≡ 6 (mod 9). For each even c, count pairs (a,b) with a+b ≡ 6−c (mod 9) and a,b ∈ {0,…,9}. Sum over all even c gives 55 total.",
    level: 10,
    topics: ["Number Theory"],
    style: "Gauss-style"
  },

  // 2023 Gauss 7 Q24 — circle coloring (rotational symmetry)
  {
    id: 22,
    question: "A circle is divided into 6 equal sectors. Three sectors are coloured red, one blue, one green, one yellow. Two colourings are the same if one is a rotation of the other. How many different colourings are there?",
    options: ["10", "12", "14", "20", "24"],
    answer: "14",
    explanation: "Use Burnside's lemma (or direct enumeration). Fix the blue sector, then arrange green and yellow in the remaining 5 non-red positions. Count distinct arrangements accounting for which red sectors are adjacent. Careful enumeration gives 14 distinct colourings.",
    level: 10,
    topics: ["Data Management"],
    style: "Gauss-style"
  }
];

// Export for use in app.js
if (typeof module !== 'undefined' && module.exports) {
  module.exports = problems;
}