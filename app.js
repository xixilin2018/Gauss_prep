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
let isPartCMode = false;
let currentDifficulty = parseInt(localStorage.getItem('currentDifficulty')) || 5; // Start at medium difficulty
let consecutiveCorrect = 0;
let consecutiveWrong = 0;

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
const sessionModeDiv = document.getElementById('session-mode');
const helpBtn = document.getElementById('help-btn');
const helpContainer = document.getElementById('help-container');

const practiceBtn = document.getElementById('practice-btn');
const partCBtn = document.getElementById('partc-btn');
const timedBtn = document.getElementById('timed-btn');
const progressBtn = document.getElementById('progress-btn');
const resetProgressBtn = document.getElementById('reset-progress');

// Update display
function updateDisplay() {
  document.getElementById('correct-count').textContent = correctCount;
  document.getElementById('total-count').textContent = totalCount;
  document.getElementById('streak').textContent = streak;
  document.getElementById('points').textContent = points;
}

updateDisplay();

// Event listeners
if (practiceBtn) practiceBtn.addEventListener('click', startPractice);
if (partCBtn) partCBtn.addEventListener('click', startPartCPractice);
if (timedBtn) timedBtn.addEventListener('click', startTimedTest);
if (progressBtn) progressBtn.addEventListener('click', showProgress);
if (resetProgressBtn) resetProgressBtn.addEventListener('click', resetProgress);
if (helpBtn) helpBtn.addEventListener('click', showHelp);
if (submitBtn) submitBtn.addEventListener('click', submitAnswer);
if (nextBtn) nextBtn.addEventListener('click', nextQuestion);

function startPractice() {
  isTimedMode = false;
  isPartCMode = false;
  currentProblems = [...problems].filter(p => p.level === currentDifficulty).sort(() => Math.random() - 0.5);
  if (currentProblems.length === 0) {
    currentProblems = [...problems].sort(() => Math.random() - 0.5); // Fallback to all problems
  }
  currentIndex = 0;
  menu.style.display = 'none';
  progressContainer.style.display = 'none';
  timerDiv.style.display = 'none';
  setSessionModeLabel('Practice Mode');
  questionContainer.style.display = 'block';
  showQuestion();
}

function startPartCPractice() {
  isTimedMode = false;
  isPartCMode = true;
  currentProblems = [...problems]
    .filter(p => p.level >= 8)
    .sort(() => Math.random() - 0.5);

  if (currentProblems.length === 0) {
    // Fallback: use the top-difficulty slice so this mode is always usable.
    const sortedByDifficulty = [...problems].sort((a, b) => b.level - a.level);
    const cutoff = sortedByDifficulty[Math.max(0, Math.floor(sortedByDifficulty.length * 0.4) - 1)]?.level ?? 1;
    currentProblems = sortedByDifficulty
      .filter(p => p.level >= cutoff)
      .sort(() => Math.random() - 0.5);
  }

  currentIndex = 0;
  menu.style.display = 'none';
  progressContainer.style.display = 'none';
  timerDiv.style.display = 'none';
  setSessionModeLabel('Part C Practice');
  questionContainer.style.display = 'block';
  showQuestion();
}

function startTimedTest() {
  isTimedMode = true;
  isPartCMode = false;
  timeRemaining = 600;
  currentProblems = [...problems].sort(() => Math.random() - 0.5);
  currentIndex = 0;
  menu.style.display = 'none';
  progressContainer.style.display = 'none';
  questionContainer.style.display = 'block';
  timerDiv.style.display = 'block';
  setSessionModeLabel('Timed Test');
  startTimer();
  showQuestion();
}

function setSessionModeLabel(text) {
  if (!text) {
    sessionModeDiv.style.display = 'none';
    sessionModeDiv.textContent = '';
    return;
  }
  sessionModeDiv.textContent = text;
  sessionModeDiv.style.display = 'inline-block';
}

function showProgress() {
  menu.style.display = 'none';
  questionContainer.style.display = 'none';
  timerDiv.style.display = 'none';
  helpContainer.style.display = 'none';
  setSessionModeLabel('');
  progressContainer.style.display = 'block';
}

function showHelp() {
  menu.style.display = 'none';
  questionContainer.style.display = 'none';
  timerDiv.style.display = 'none';
  progressContainer.style.display = 'none';
  setSessionModeLabel('');
  helpContainer.style.display = 'block';
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

  if (!problem.answer) {
    feedbackDiv.className = '';
    feedbackDiv.textContent = 'Answer key unavailable for this imported problem. Review mode only.';
    feedbackDiv.style.display = 'block';
    submitBtn.style.display = 'none';
    nextBtn.style.display = 'block';
    return;
  }

  const isCorrect = selectedAnswer === problem.answer;
  
  totalCount++;
  if (isCorrect) {
    correctCount++;
    streak++;
    points += 10 + (streak * 2); // Base 10 points + streak bonus
    feedbackDiv.className = 'correct';
    feedbackDiv.textContent = 'Correct! ' + problem.explanation;
    consecutiveCorrect++;
    consecutiveWrong = 0;
    if (consecutiveCorrect >= 3 && currentDifficulty < 10) {
      currentDifficulty++;
      consecutiveCorrect = 0;
    }
  } else {
    streak = 0;
    feedbackDiv.className = 'incorrect';
    feedbackDiv.textContent = 'Incorrect. The correct answer is ' + problem.answer + '. ' + problem.explanation;
    consecutiveWrong++;
    consecutiveCorrect = 0;
    if (consecutiveWrong >= 1 && currentDifficulty > 1) {
      currentDifficulty--;
      consecutiveWrong = 0;
    }
  }
  
  localStorage.setItem('correctCount', correctCount);
  localStorage.setItem('totalCount', totalCount);
  localStorage.setItem('streak', streak);
  localStorage.setItem('points', points);
  localStorage.setItem('currentDifficulty', currentDifficulty);
  
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
  helpContainer.style.display = 'none';
  setSessionModeLabel('');
  menu.style.display = 'block';
  if (isTimedMode) {
    alert('Timed test completed!');
  } else if (isPartCMode) {
    alert('Part C practice session completed!');
  } else {
    alert('Practice session completed!');
  }
}

// Initialize
updateDisplay();