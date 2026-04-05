// Load problems from problems.js
let currentProblems = [...problems];
let currentIndex = 0;
let correctCount = parseInt(localStorage.getItem('correctCount')) || 0;
let totalCount = parseInt(localStorage.getItem('totalCount')) || 0;
let streak = parseInt(localStorage.getItem('streak')) || 0;
let points = parseInt(localStorage.getItem('points')) || 0;
let timerInterval;
let timeRemaining = 600; // 10 minutes in seconds
let isTimedMode = false;

// DOM elements
const menu = document.getElementById('menu');
const questionContainer = document.getElementById('question-container');
const progressContainer = document.getElementById('progress-container');
const questionDiv = document.getElementById('question');
const optionsDiv = document.getElementById('options');
const submitBtn = document.getElementById('submit-btn');
const feedbackDiv = document.getElementById('feedback');
const nextBtn = document.getElementById('next-btn');
const timerDiv = document.getElementById('timer');
const timeRemainingSpan = document.getElementById('time-remaining');

// Update display
function updateDisplay() {
  document.getElementById('correct-count').textContent = correctCount;
  document.getElementById('total-count').textContent = totalCount;
  document.getElementById('streak').textContent = streak;
  document.getElementById('points').textContent = points;
}

updateDisplay();

// Event listeners
document.getElementById('practice-btn').addEventListener('click', startPractice);
document.getElementById('timed-btn').addEventListener('click', startTimedTest);
document.getElementById('progress-btn').addEventListener('click', showProgress);
document.getElementById('reset-progress').addEventListener('click', resetProgress);
submitBtn.addEventListener('click', submitAnswer);
nextBtn.addEventListener('click', nextQuestion);

function startPractice() {
  isTimedMode = false;
  currentProblems = [...problems].sort(() => Math.random() - 0.5);
  currentIndex = 0;
  menu.style.display = 'none';
  progressContainer.style.display = 'none';
  timerDiv.style.display = 'none';
  questionContainer.style.display = 'block';
  showQuestion();
}

function startTimedTest() {
  isTimedMode = true;
  timeRemaining = 600;
  currentProblems = [...problems].sort(() => Math.random() - 0.5);
  currentIndex = 0;
  menu.style.display = 'none';
  progressContainer.style.display = 'none';
  questionContainer.style.display = 'block';
  timerDiv.style.display = 'block';
  startTimer();
  showQuestion();
}

function showProgress() {
  menu.style.display = 'none';
  questionContainer.style.display = 'none';
  timerDiv.style.display = 'none';
  progressContainer.style.display = 'block';
}

function resetProgress() {
  correctCount = 0;
  totalCount = 0;
  streak = 0;
  points = 0;
  localStorage.clear();
  updateDisplay();
}

function showQuestion() {
  if (currentIndex >= currentProblems.length) {
    endSession();
    return;
  }
  
  const problem = currentProblems[currentIndex];
  questionDiv.textContent = problem.question;
  optionsDiv.innerHTML = '';
  
  problem.options.forEach((option, index) => {
    const optionDiv = document.createElement('div');
    optionDiv.className = 'option';
    optionDiv.textContent = option;
    optionDiv.addEventListener('click', () => selectOption(optionDiv, index));
    optionsDiv.appendChild(optionDiv);
  });
  
  feedbackDiv.style.display = 'none';
  nextBtn.style.display = 'none';
  submitBtn.style.display = 'block';
}

let selectedOption = null;

function selectOption(optionDiv, index) {
  document.querySelectorAll('.option').forEach(opt => opt.classList.remove('selected'));
  optionDiv.classList.add('selected');
  selectedOption = index;
}

function submitAnswer() {
  if (selectedOption === null) return;
  
  const problem = currentProblems[currentIndex];
  const selectedAnswer = problem.options[selectedOption];
  const isCorrect = selectedAnswer === problem.answer;
  
  totalCount++;
  if (isCorrect) {
    correctCount++;
    streak++;
    points += 10 + (streak * 2); // Base 10 points + streak bonus
    feedbackDiv.className = 'correct';
    feedbackDiv.textContent = 'Correct! ' + problem.explanation;
  } else {
    streak = 0;
    feedbackDiv.className = 'incorrect';
    feedbackDiv.textContent = 'Incorrect. The correct answer is ' + problem.answer + '. ' + problem.explanation;
  }
  
  localStorage.setItem('correctCount', correctCount);
  localStorage.setItem('totalCount', totalCount);
  localStorage.setItem('streak', streak);
  localStorage.setItem('points', points);
  
  updateDisplay();
  
  feedbackDiv.style.display = 'block';
  submitBtn.style.display = 'none';
  nextBtn.style.display = 'block';
}

function nextQuestion() {
  currentIndex++;
  selectedOption = null;
  showQuestion();
}

function startTimer() {
  timerInterval = setInterval(() => {
    timeRemaining--;
    const minutes = Math.floor(timeRemaining / 60);
    const seconds = timeRemaining % 60;
    timeRemainingSpan.textContent = `${minutes}:${seconds.toString().padStart(2, '0')}`;
    
    if (timeRemaining <= 0) {
      endSession();
    }
  }, 1000);
}

function endSession() {
  clearInterval(timerInterval);
  questionContainer.style.display = 'none';
  timerDiv.style.display = 'none';
  menu.style.display = 'block';
  alert(isTimedMode ? 'Timed test completed!' : 'Practice session completed!');
}

// Initialize
updateDisplay();