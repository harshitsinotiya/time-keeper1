<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Digital Clock - Time Keeper</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #1a2a6c, #b21f1f, #fdbb2d);
            color: white;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        header {
            background-color: rgba(0, 0, 0, 0.7);
            padding: 1rem;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        }
        
        nav {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin-top: 1rem;
            flex-wrap: wrap;
        }
        
        nav a {
            color: white;
            text-decoration: none;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            transition: background-color 0.3s;
        }
        
        nav a:hover, nav a.active {
            background-color: rgba(255, 255, 255, 0.2);
        }
        
        .user-info {
            position: absolute;
            top: 1rem;
            right: 1rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .logout-btn {
            background-color: #ff5252;
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }
        
        .logout-btn:hover {
            background-color: #ff3838;
        }
        
        main {
            flex: 1;
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
        }
        
        section {
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            backdrop-filter: blur(10px);
        }
        
        h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }
        
        h2 {
            margin-bottom: 1rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.3);
            padding-bottom: 0.5rem;
        }
        
        button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
            font-size: 1rem;
            margin: 0.25rem;
        }
        
        button:hover {
            background-color: #45a049;
        }
        
        button:disabled {
            background-color: #6c757d;
            cursor: not-allowed;
        }
        
        input, select, textarea {
            padding: 0.75rem;
            border-radius: 4px;
            border: 1px solid #ccc;
            background-color: rgba(255, 255, 255, 0.9);
            width: 100%;
            margin-bottom: 1rem;
            font-size: 1rem;
            color: #333;
        }
        
        footer {
            background-color: rgba(0, 0, 0, 0.7);
            padding: 1rem;
            text-align: center;
            margin-top: auto;
        }

        /* Clock Page Styles */
        #clock {
            font-size: 5rem;
            font-weight: bold;
            text-align: center;
            margin: 2rem 0;
            text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.5);
            font-family: 'Courier New', monospace;
        }
        
        #date {
            font-size: 1.5rem;
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .timer-controls {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            align-items: center;
        }
        
        .timer-display {
            text-align: center;
            font-size: 3rem;
            margin: 2rem 0;
            font-family: 'Courier New', monospace;
            font-weight: bold;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }
        
        .alarm-controls {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
            flex-wrap: wrap;
        }
        
        .input-group {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        
        .input-group input, .input-group select {
            flex: 1;
            min-width: 150px;
        }
        
      
        .btn-start { background-color: #4CAF50; }
        .btn-stop { background-color: #ff5252; }
        .btn-reset { background-color: #2196F3; }
        .btn-set { background-color: #FF9800; }
        .btn-clear { background-color: #9C27B0; }
        
        .btn-start:hover { background-color: #45a049; }
        .btn-stop:hover { background-color: #ff3838; }
        .btn-reset:hover { background-color: #1976D2; }
        .btn-set:hover { background-color: #F57C00; }
        .btn-clear:hover { background-color: #7B1FA2; }
        
        .status-message {
            text-align: center;
            padding: 1rem;
            margin: 1rem 0;
            border-radius: 8px;
            font-weight: bold;
        }
        
        .status-active {
            background-color: rgba(46, 213, 115, 0.2);
            border-left: 4px solid #2ed573;
        }
        
        .status-inactive {
            background-color: rgba(255, 82, 82, 0.2);
            border-left: 4px solid #ff5252;
        }
        
        .controls-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1rem;
        }
        
        .time-input {
            width: 120px !important;
            text-align: center;
            font-size: 1.2rem;
        }
        
        .quick-timers {
            margin-top: 1rem;
            text-align: center;
        }
        
        .quick-timers h3 {
            margin-bottom: 0.5rem;
        }
        
        .quick-timers button {
            background-color: #2196F3;
        }
        
        @media (max-width: 768px) {
            #clock {
                font-size: 3rem;
            }
            
            .timer-display {
                font-size: 2rem;
            }
            
            .timer-controls {
                flex-direction: column;
            }
            
            .user-info {
                position: static;
                justify-content: center;
                margin-top: 1rem;
            }
            
            nav {
                gap: 0.5rem;
            }
            
            nav a {
                padding: 0.5rem;
                font-size: 0.9rem;
            }
            
            button {
                width: 100%;
                margin: 0.25rem 0;
            }
        }
    </style>
</head>
<body>
    <header>
        <h1>Time Keeper</h1>
        <p>Digital Clock, Timer & Stopwatch</p>
        
        <div class="user-info">
            <c:choose>
                <c:when test="${not empty sessionScope.username}">
                    <span>Welcome, <strong>${sessionScope.username}</strong>!</span>
                    <a href="auth?action=logout" class="logout-btn">Logout</a>
                </c:when>
                <c:otherwise>
                    <span>Welcome, <strong>Guest</strong>!</span>
                    <a href="login.jsp" class="logout-btn">Login</a>
                </c:otherwise>
            </c:choose>
        </div>
        
        <nav>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="tasks.jsp">Tasks</a>
            <a href="add-task.jsp">Add Task</a>
            <a href="#" class="active">Digital Clock</a>
        </nav>
    </header>

    <main>
 
        <section>
            <div id="clock">--:--:--</div>
            <p id="date">Loading...</p>
        </section>
        
        <section>
            <h2>Timer</h2>
            <div class="timer-display" id="timer-display">00:00:00</div>
            <div class="controls-container">
                <div class="input-group">
                    <input type="number" id="timer-hours" placeholder="Hours" min="0" value="0" class="time-input">
                    <input type="number" id="timer-minutes" placeholder="Minutes" min="0" max="59" value="0" class="time-input">
                    <input type="number" id="timer-seconds" placeholder="Seconds" min="0" max="59" value="0" class="time-input">
                </div>
                <div class="timer-controls">
                    <button onclick="startTimer()" class="btn-start" id="timer-start">Start Timer</button>
                    <button onclick="stopTimer()" class="btn-stop" id="timer-stop" disabled>Stop Timer</button>
                    <button onclick="resetTimer()" class="btn-reset">Reset Timer</button>
                </div>
                <div class="quick-timers">
                    <h3>Quick Timers</h3>
                    <div class="timer-controls">
                        <button onclick="setQuickTimer(1)">1 Min</button>
                        <button onclick="setQuickTimer(5)">5 Min</button>
                        <button onclick="setQuickTimer(10)">10 Min</button>
                        <button onclick="setQuickTimer(15)">15 Min</button>
                        <button onclick="setQuickTimer(30)">30 Min</button>
                    </div>
                </div>
            </div>
        </section>
        
    
        <section>
            <h2>Stopwatch</h2>
            <div class="timer-display" id="stopwatch-display">00:00:00</div>
            <div class="timer-controls">
                <button onclick="startStopwatch()" class="btn-start" id="stopwatch-start">Start Stopwatch</button>
                <button onclick="stopStopwatch()" class="btn-stop" id="stopwatch-stop" disabled>Stop Stopwatch</button>
                <button onclick="resetStopwatch()" class="btn-reset">Reset Stopwatch</button>
            </div>
        </section>
        
        
        <section>
            <h2>Alarm</h2>
            <div class="input-group">
                <input type="time" id="alarm-time">
                <button onclick="setAlarm()" class="btn-set">Set Alarm</button>
                <button onclick="clearAlarm()" class="btn-clear">Clear Alarm</button>
            </div>
            <div id="alarm-status" class="status-message status-inactive">No alarm set</div>
        </section>
    </main>

    <footer>
        <p>Time Keeper &copy; 2023 - AI Digital Clock & Day Planner</p>
    </footer>

    <script>
        // Clock functionality
        function updateClock() {
            const now = new Date();
            const timeString = now.toLocaleTimeString();
            const dateString = now.toLocaleDateString('en-US', { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric' 
            });
            
            document.getElementById('clock').textContent = timeString;
            document.getElementById('date').textContent = dateString;
            
            // Check alarm
            checkAlarm(now);
        }
        
        // Timer functionality
        let timerInterval;
        let timerSeconds = 0;
        let isTimerRunning = false;
        
        function startTimer() {
            if (isTimerRunning) {
                console.log("Timer is already running");
                return;
            }
            
            const hours = parseInt(document.getElementById('timer-hours').value) || 0;
            const minutes = parseInt(document.getElementById('timer-minutes').value) || 0;
            const seconds = parseInt(document.getElementById('timer-seconds').value) || 0;
            
            timerSeconds = hours * 3600 + minutes * 60 + seconds;
            
            console.log("Starting timer with:", hours, "hours,", minutes, "minutes,", seconds, "seconds =", timerSeconds, "total seconds");
            
            if (timerSeconds <= 0) {
                alert("Please set a valid timer duration!");
                return;
            }
            
            clearInterval(timerInterval);
            updateTimerDisplay();
            isTimerRunning = true;
            
            // Update button states
            document.getElementById('timer-start').disabled = true;
            document.getElementById('timer-stop').disabled = false;
            
            timerInterval = setInterval(() => {
                timerSeconds--;
                updateTimerDisplay();
                
                if (timerSeconds <= 0) {
                    clearInterval(timerInterval);
                    isTimerRunning = false;
                    console.log("Timer finished!");
                    alert("⏰ Timer finished!");
                    playAlertSound();
                    
                    // Reset button states
                    document.getElementById('timer-start').disabled = false;
                    document.getElementById('timer-stop').disabled = true;
                }
            }, 1000);
            
            console.log("Timer started successfully");
        }
        
        function stopTimer() {
            if (!isTimerRunning) {
                console.log("Timer is not running");
                return;
            }
            
            clearInterval(timerInterval);
            isTimerRunning = false;
            console.log("Timer stopped at:", timerSeconds, "seconds");
            
            // Update button states
            document.getElementById('timer-start').disabled = false;
            document.getElementById('timer-stop').disabled = true;
        }
        
        function resetTimer() {
            clearInterval(timerInterval);
            timerSeconds = 0;
            isTimerRunning = false;
            updateTimerDisplay();
            console.log("Timer reset");
            
            // Reset button states
            document.getElementById('timer-start').disabled = false;
            document.getElementById('timer-stop').disabled = true;
            
            // Reset input fields
            document.getElementById('timer-hours').value = 0;
            document.getElementById('timer-minutes').value = 0;
            document.getElementById('timer-seconds').value = 0;
        }
        
        function updateTimerDisplay() {
            const hours = Math.floor(timerSeconds / 3600);
            const minutes = Math.floor((timerSeconds % 3600) / 60);
            const seconds = timerSeconds % 60;
            
            const displayText = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
            document.getElementById('timer-display').textContent = displayText;
        }
        
        // Stopwatch functionality - FIXED
        let stopwatchInterval;
        let stopwatchStartTime = 0;
        let stopwatchElapsedTime = 0;
        let isStopwatchRunning = false;
        
        function startStopwatch() {
            if (isStopwatchRunning) {
                console.log("Stopwatch is already running");
                return;
            }
            
            isStopwatchRunning = true;
            stopwatchStartTime = Date.now() - stopwatchElapsedTime;
            
            console.log("Starting stopwatch");
            
            // Update button states
            document.getElementById('stopwatch-start').disabled = true;
            document.getElementById('stopwatch-stop').disabled = false;
            
            stopwatchInterval = setInterval(() => {
                stopwatchElapsedTime = Date.now() - stopwatchStartTime;
                updateStopwatchDisplay();
            }, 10); // Update every 10ms for smooth display
        }
        
        function stopStopwatch() {
            if (!isStopwatchRunning) {
                console.log("Stopwatch is not running");
                return;
            }
            
            clearInterval(stopwatchInterval);
            isStopwatchRunning = false;
            console.log("Stopwatch stopped");
            
            // Update button states
            document.getElementById('stopwatch-start').disabled = false;
            document.getElementById('stopwatch-stop').disabled = true;
        }
        
        function resetStopwatch() {
            clearInterval(stopwatchInterval);
            stopwatchElapsedTime = 0;
            isStopwatchRunning = false;
            updateStopwatchDisplay();
            console.log("Stopwatch reset");
            
            // Reset button states
            document.getElementById('stopwatch-start').disabled = false;
            document.getElementById('stopwatch-stop').disabled = true;
        }
        
        function updateStopwatchDisplay() {
            const totalSeconds = Math.floor(stopwatchElapsedTime / 1000);
            const hours = Math.floor(totalSeconds / 3600);
            const minutes = Math.floor((totalSeconds % 3600) / 60);
            const seconds = totalSeconds % 60;
            const milliseconds = Math.floor((stopwatchElapsedTime % 1000) / 10);
            
            const displayText = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
            document.getElementById('stopwatch-display').textContent = displayText;
        }
        
        // Alarm functionality
        let alarmTime = null;
        let alarmInterval;
        
        function setAlarm() {
            const alarmInput = document.getElementById('alarm-time').value;
            if (!alarmInput) {
                alert('Please set an alarm time');
                return;
            }
            
            const now = new Date();
            const [hours, minutes] = alarmInput.split(':');
            alarmTime = new Date(now);
            alarmTime.setHours(parseInt(hours), parseInt(minutes), 0, 0);
            
            // If alarm time is in the past, set it for tomorrow
            if (alarmTime < now) {
                alarmTime.setDate(alarmTime.getDate() + 1);
            }
            
            const alarmStatus = `Alarm set for ${alarmTime.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}`;
            document.getElementById('alarm-status').textContent = alarmStatus;
            document.getElementById('alarm-status').className = 'status-message status-active';
            
            console.log("Alarm set:", alarmStatus);
            
            // Start checking for alarm
            if (alarmInterval) clearInterval(alarmInterval);
            alarmInterval = setInterval(() => {
                checkAlarm(new Date());
            }, 1000);
        }
        
        function clearAlarm() {
            alarmTime = null;
            if (alarmInterval) clearInterval(alarmInterval);
            document.getElementById('alarm-status').textContent = 'No alarm set';
            document.getElementById('alarm-status').className = 'status-message status-inactive';
            document.getElementById('alarm-time').value = '';
            console.log("Alarm cleared");
        }
        
        function checkAlarm(now) {
            if (alarmTime && now >= alarmTime) {
                console.log("Alarm triggered!");
                playAlertSound();
                alert('⏰ ALARM! Time is up!');
                clearAlarm();
            }
        }
        
        // Alert sound function
        function playAlertSound() {
            try {
                // Create audio context
                const AudioContext = window.AudioContext || window.webkitAudioContext;
                const audioCtx = new AudioContext();
                
                // Create oscillator
                const oscillator = audioCtx.createOscillator();
                const gainNode = audioCtx.createGain();
                
                oscillator.connect(gainNode);
                gainNode.connect(audioCtx.destination);
                
                // Configure sound - beep pattern
                oscillator.type = 'sine';
                
                // Create a beeping pattern
                let beepCount = 0;
                const maxBeeps = 6;
                
                function playBeep() {
                    if (beepCount >= maxBeeps) {
                        oscillator.stop();
                        audioCtx.close();
                        return;
                    }
                    
                    oscillator.frequency.setValueAtTime(800, audioCtx.currentTime);
                    gainNode.gain.setValueAtTime(0.5, audioCtx.currentTime);
                    
                    setTimeout(() => {
                        gainNode.gain.setValueAtTime(0, audioCtx.currentTime);
                        beepCount++;
                        setTimeout(playBeep, 200);
                    }, 300);
                }
                
                // Start the beep pattern
                oscillator.start();
                playBeep();
                
            } catch (error) {
                console.log('Audio not supported, using visual alert only');
                // Fallback: just use the alert
            }
        }
        
        // Input validation for timer
        document.getElementById('timer-hours').addEventListener('input', function() {
            if (this.value < 0) this.value = 0;
            if (this.value > 23) this.value = 23;
        });
        
        document.getElementById('timer-minutes').addEventListener('input', function() {
            if (this.value < 0) this.value = 0;
            if (this.value > 59) this.value = 59;
        });
        
        document.getElementById('timer-seconds').addEventListener('input', function() {
            if (this.value < 0) this.value = 0;
            if (this.value > 59) this.value = 59;
        });
        
      
        function setQuickTimer(minutes) {
            document.getElementById('timer-hours').value = 0;
            document.getElementById('timer-minutes').value = minutes;
            document.getElementById('timer-seconds').value = 0;
            console.log("Quick timer set for", minutes, "minutes");
        }
        
       
        function init() {
            
            updateClock();
            setInterval(updateClock, 1000);
            
          
            updateTimerDisplay();
            updateStopwatchDisplay();
            
            console.log('⏰ Time Keeper Clock initialized successfully');
        }
        
      
        window.onload = init;
    </script>
</body>
</html>
