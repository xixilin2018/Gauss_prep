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
const helpBtn = document.getElementById('help-btn');
const helpContainer = document.getElementById('help-container');

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
importBtn.addEventListener('click', () => pdfInput.click());
downloadCemcBtn.addEventListener('click', openCemcDownloadPage);
helpBtn.addEventListener('click', showHelp);
pdfInput.addEventListener('change', handlePdfFile);
submitBtn.addEventListener('click', submitAnswer);
nextBtn.addEventListener('click', nextQuestion);

function startPractice() {
  isTimedMode = false;
  currentProblems = [...problems].filter(p => p.level === currentDifficulty).sort(() => Math.random() - 0.5);
  if (currentProblems.length === 0) {
    currentProblems = [...problems].sort(() => Math.random() - 0.5); // Fallback to all problems
  }
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
  helpContainer.style.display = 'none';
  progressContainer.style.display = 'block';
}

function showHelp() {
  menu.style.display = 'none';
  questionContainer.style.display = 'none';
  timerDiv.style.display = 'none';
  progressContainer.style.display = 'none';
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

async function handlePdfFile(event) {
  const file = event.target.files && event.target.files[0];
  if (!file) return;
  importFeedback.textContent = 'Importing PDF...';
  try {
    const arrayBuffer = await file.arrayBuffer();
    const importedProblems = await parsePdfFile(arrayBuffer);
    if (!importedProblems.length) {
      importFeedback.textContent = 'No problems were found in the selected PDF.';
      return;
    }
    problems.unshift(...importedProblems);
    currentProblems = [...problems];
    importFeedback.textContent = `Imported ${importedProblems.length} problems from PDF.`;
  } catch (error) {
    console.error(error);
    importFeedback.textContent = 'Failed to import PDF. Please try a different file.';
  } finally {
    pdfInput.value = '';
  }
}

function openCemcDownloadPage() {
  window.open('https://www.cemc.uwaterloo.ca/contests/gauss/', '_blank');
}

async function parsePdfFile(arrayBuffer) {
  if (typeof pdfjsLib === 'undefined') {
    throw new Error('PDF.js is not loaded.');
  }

  const loadingTask = pdfjsLib.getDocument({ data: arrayBuffer });
  const pdf = await loadingTask.promise;
  let rawText = '';

  for (let pageNum = 1; pageNum <= pdf.numPages; pageNum++) {
    rawText += await getPageText(pdf, pageNum) + '\n\n';
  }

  return parseCemcPdfText(rawText);
}

async function getPageText(pdf, pageNum) {
  const page = await pdf.getPage(pageNum);
  const textContent = await page.getTextContent();
  return textContent.items.map(item => item.str).join(' ');
}

function parseCemcPdfText(rawText) {
  const text = normalizeText(rawText);
  const answerMap = extractAnswers(text);
  const answerSectionMatch = text.match(/(?:Answer Key|Answers|Solution Key|Solutions)([\s\S]*)/i);
  const questionText = answerSectionMatch ? text.slice(0, answerSectionMatch.index).trim() : text;
  const questionBlocks = questionText.split(/\n(?=\d{1,2}(?:\.|\))\s*)/g);
  const problemsFromPdf = [];

  for (const block of questionBlocks) {
    const problem = createProblemFromBlock(block, answerMap);
    if (problem) {
      problemsFromPdf.push(problem);
    }
  }

  return problemsFromPdf;
}

function normalizeText(text) {
  return text
    .replace(/\u2019/g, "'")
    .replace(/[\u2013\u2014]/g, '-')
    .replace(/[\u00A0\u202F]/g, ' ')
    .replace(/\r\n?/g, '\n')
    .replace(/\t/g, ' ')
    .replace(/ {2,}/g, ' ')
    .replace(/\n{2,}/g, '\n')
    .replace(/\u2028|\u2029/g, '\n')
    .trim();
}

function extractAnswers(text) {
  const answerMap = {};
  const answerSectionMatch = text.match(/(?:Answer Key|Answers|Solution Key|Solutions)([\s\S]*)/i);
  const answerText = answerSectionMatch ? answerSectionMatch[1] : text;
  const answerMatches = answerText.matchAll(/(\d{1,2})\s*[:\.)]?\s*([A-E])/gi);
  for (const match of answerMatches) {
    const index = parseInt(match[1], 10);
    const letter = match[2].toUpperCase();
    answerMap[index] = letter;
  }
  return answerMap;
}

function createProblemFromBlock(block, answerMap) {
  const headerMatch = block.match(/^\s*(\d{1,2})(?:\.|\))\s*(.*)$/s);
  if (!headerMatch) return null;

  const questionNumber = parseInt(headerMatch[1], 10);
  const body = headerMatch[2].trim();
  const optionPattern = /(A|B|C|D|E)(?:\.|\))\s*([\s\S]*?)(?=(?:[A-E](?:\.|\))\s*)|$)/gi;
  const options = [];
  let match;
  let firstOptionIndex = body.length;

  while ((match = optionPattern.exec(body))) {
    const letter = match[1].toUpperCase();
    const optionText = match[2].trim().replace(/\s+/g, ' ');
    if (optionText) {
      if (match.index < firstOptionIndex) firstOptionIndex = match.index;
      options.push(optionText);
    }
  }

  if (options.length < 2) return null;

  const questionText = body.slice(0, firstOptionIndex).trim() || `Question ${questionNumber}`;
  const answerLetter = answerMap[questionNumber];
  const answer = answerLetter && options[answerLetter.charCodeAt(0) - 65] ? options[answerLetter.charCodeAt(0) - 65] : '';
  const explanation = answer ? 'Imported from PDF with answer key.' : 'Imported from PDF; answer key not found.';

  // Infer level based on question number (simple heuristic)
  const level = Math.min(10, Math.max(1, Math.floor(questionNumber / 2) + 1));
  const topics = inferTopics(questionText);
  const style = inferStyle(questionText);

  return {
    id: questionNumber,
    question: questionText,
    options,
    answer,
    explanation,
    level,
    topics,
    style
  };
}

function inferTopics(questionText) {
  const text = questionText.toLowerCase();
  const topics = [];
  if (text.includes('triangle') || text.includes('angle') || text.includes('area')) topics.push('Geometry');
  if (text.includes('sum') || text.includes('factors') || text.includes('prime')) topics.push('Number Theory');
  if (text.includes('equation') || text.includes('variable') || text.includes('sequence')) topics.push('Algebra');
  if (text.includes('combination') || text.includes('permutation')) topics.push('Combinatorics');
  return topics.length ? topics : ['General'];
}

function inferStyle(questionText) {
  const text = questionText.toLowerCase();
  if (text.length > 100 || text.includes('logic') || text.includes('prove')) return 'Waterloo-style';
  return 'AMC-style';
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
  menu.style.display = 'block';
  alert(isTimedMode ? 'Timed test completed!' : 'Practice session completed!');
}

// Initialize
updateDisplay();