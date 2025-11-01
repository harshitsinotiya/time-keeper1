<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Task - Time Keeper</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        /* Include all the styles from dashboard.jsp */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: linear-gradient(135deg, #1a2a6c, #b21f1f, #fdbb2d); color: white; min-height: 100vh; display: flex; flex-direction: column; }
        header { background-color: rgba(0, 0, 0, 0.7); padding: 1rem; text-align: center; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3); }
        nav { display: flex; justify-content: center; gap: 2rem; margin-top: 1rem; flex-wrap: wrap; }
        nav a { color: white; text-decoration: none; padding: 0.5rem 1rem; border-radius: 4px; transition: background-color 0.3s; }
        nav a:hover, nav a.active { background-color: rgba(255, 255, 255, 0.2); }
        .user-info { position: absolute; top: 1rem; right: 1rem; display: flex; align-items: center; gap: 1rem; }
        .logout-btn { background-color: #ff5252; color: white; border: none; padding: 0.5rem 1rem; border-radius: 4px; cursor: pointer; text-decoration: none; }
        .logout-btn:hover { background-color: #ff3838; }
        main { flex: 1; padding: 2rem; max-width: 800px; margin: 0 auto; width: 100%; }
        section { background-color: rgba(255, 255, 255, 0.1); border-radius: 12px; padding: 1.5rem; margin-bottom: 2rem; box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); backdrop-filter: blur(10px); }
        h1 { font-size: 2.5rem; margin-bottom: 0.5rem; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5); }
        h2 { margin-bottom: 1rem; border-bottom: 1px solid rgba(255, 255, 255, 0.3); padding-bottom: 0.5rem; }
        button { background-color: #4CAF50; color: white; border: none; padding: 0.5rem 1rem; border-radius: 4px; cursor: pointer; transition: background-color 0.3s; }
        button:hover { background-color: #45a049; }
        footer { background-color: rgba(0, 0, 0, 0.7); padding: 1rem; text-align: center; margin-top: auto; }

        /* Form Styles */
        .form-group { margin-bottom: 1rem; }
        label { display: block; margin-bottom: 0.5rem; font-weight: bold; }
        input, select, textarea { 
            width: 100%; 
            padding: 0.75rem; 
            border: none; 
            border-radius: 4px; 
            background-color: rgba(255, 255, 255, 0.9);
            color: #333;
            font-size: 1rem;
        }
        textarea { 
            resize: vertical; 
            min-height: 100px; 
            font-family: inherit;
        }
        .input-group { 
            display: flex; 
            gap: 1rem; 
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }
        .input-group .form-group { 
            flex: 1; 
            min-width: 200px;
        }
        .form-actions { 
            display: flex; 
            gap: 1rem; 
            margin-top: 1.5rem;
            flex-wrap: wrap;
        }
        .btn-voice { 
            background-color: #2196F3; 
        }
        .btn-voice:hover { 
            background-color: #1976D2; 
        }
        .btn-secondary { 
            background-color: #6c757d; 
        }
        .btn-secondary:hover { 
            background-color: #5a6268; 
        }

        /* Quick Templates */
        .templates { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); 
            gap: 1rem; 
            margin-top: 1rem;
        }
        .template-btn { 
            background-color: rgba(255, 255, 255, 0.2); 
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 1rem;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
        }
        .template-btn:hover { 
            background-color: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }

        /* Messages */
        .message { background-color: rgba(46, 213, 115, 0.2); padding: 1rem; border-radius: 8px; margin-bottom: 1rem; border-left: 4px solid #2ed573; }
        .error { background-color: rgba(255, 82, 82, 0.2); padding: 1rem; border-radius: 8px; margin-bottom: 1rem; border-left: 4px solid #ff5252; }

        @media (max-width: 768px) {
            .user-info { position: static; justify-content: center; margin-top: 1rem; }
            nav { gap: 0.5rem; }
            nav a { padding: 0.5rem; font-size: 0.9rem; }
            .input-group { flex-direction: column; }
            .form-actions { flex-direction: column; }
        }
    </style>
</head>
<body>
    <header>
        <h1>Time Keeper</h1>
        <p>Add New Task</p>
        
        <div class="user-info">
            <span>Welcome, <strong>${sessionScope.username}</strong>!</span>
            <a href="login.jsp" class="logout-btn">Logout</a>
        </div>
        
        <nav>
            <a href="dashboard">Dashboard</a>
            <a href="tasks">Tasks</a>
            <a href="#" class="active">Add Task</a>
            <a href="clock.html">Digital Clock</a>
        </nav>
    </header>

    <main>
        <!-- Messages -->
        <c:if test="${not empty sessionScope.message}">
            <div class="message">
                ${sessionScope.message}
                <c:remove var="message" scope="session"/>
            </div>
        </c:if>
        
        <c:if test="${not empty sessionScope.error}">
            <div class="error">
                ${sessionScope.error}
                <c:remove var="error" scope="session"/>
            </div>
        </c:if>

        <section>
            <h2>Add New Task</h2>
            <form action="tasks" method="post" id="taskForm">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="taskName">Task Name *</label>
                    <input type="text" id="taskName" name="name" placeholder="Enter task name" required>
                </div>

                <div class="input-group">
                    <div class="form-group">
                        <label for="priority">Priority</label>
                        <select id="priority" name="priority">
                            <option value="low">Low Priority</option>
                            <option value="medium" selected>Medium Priority</option>
                            <option value="high">High Priority</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="duration">Duration (minutes)</label>
                        <input type="number" id="duration" name="duration" placeholder="e.g., 60" min="1">
                    </div>
                </div>

                <div class="form-group">
                    <label for="deadline">Deadline</label>
                    <input type="datetime-local" id="deadline" name="deadline">
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" placeholder="Task description (optional)"></textarea>
                </div>

                <div class="form-actions">
                    <button type="submit">Add Task</button>
                    <button type="button" class="btn-voice" onclick="startVoiceRecognition()">🎤 Voice Add</button>
                    <button type="button" class="btn-secondary" onclick="clearForm()">Clear Form</button>
                    <a href="tasks" class="btn-secondary" style="text-decoration: none; text-align: center;">Cancel</a>
                </div>
            </form>
        </section>

        <section>
            <h2>Quick Add Templates</h2>
            <div class="templates">
                <div class="template-btn" onclick="fillTemplate('meeting')">
                    <strong>Meeting</strong>
                    <div style="font-size: 0.8rem; opacity: 0.8;">60 min • Medium</div>
                </div>
                <div class="template-btn" onclick="fillTemplate('workout')">
                    <strong>Workout</strong>
                    <div style="font-size: 0.8rem; opacity: 0.8;">45 min • High</div>
                </div>
                <div class="template-btn" onclick="fillTemplate('study')">
                    <strong>Study</strong>
                    <div style="font-size: 0.8rem; opacity: 0.8;">90 min • High</div>
                </div>
                <div class="template-btn" onclick="fillTemplate('break')">
                    <strong>Break</strong>
                    <div style="font-size: 0.8rem; opacity: 0.8;">15 min • Low</div>
                </div>
                <div class="template-btn" onclick="fillTemplate('email')">
                    <strong>Email</strong>
                    <div style="font-size: 0.8rem; opacity: 0.8;">30 min • Medium</div>
                </div>
            </div>
        </section>
    </main>

    <footer>
        <p>Time Keeper &copy; 2023 - AI Digital Clock & Day Planner @harshit_Sinotiya</p>
    </footer>

    <script>
        // Set minimum datetime to current time
        window.onload = function() {
            const now = new Date();
            const localDateTime = new Date(now.getTime() - now.getTimezoneOffset() * 60000).toISOString().slice(0, 16);
            document.getElementById('deadline').min = localDateTime;
        };

        // Quick templates
        function fillTemplate(type) {
            const templates = {
                meeting: {
                    name: 'Team Meeting',
                    priority: 'medium',
                    duration: 60,
                    description: 'Team sync and discussion'
                },
                workout: {
                    name: 'Workout Session',
                    priority: 'high',
                    duration: 45,
                    description: 'Exercise and fitness routine'
                },
                study: {
                    name: 'Study Session',
                    priority: 'high',
                    duration: 90,
                    description: 'Focused learning time'
                },
                break: {
                    name: 'Break Time',
                    priority: 'low',
                    duration: 15,
                    description: 'Rest and recharge'
                },
                email: {
                    name: 'Email Management',
                    priority: 'medium',
                    duration: 30,
                    description: 'Process and respond to emails'
                }
            };

            const template = templates[type];
            if (template) {
                document.getElementById('taskName').value = template.name;
                document.getElementById('priority').value = template.priority;
                document.getElementById('duration').value = template.duration;
                document.getElementById('description').value = template.description;
                
                // Set deadline to 1 hour from now
                const now = new Date();
                now.setHours(now.getHours() + 1);
                const localDateTime = new Date(now.getTime() - now.getTimezoneOffset() * 60000).toISOString().slice(0, 16);
                document.getElementById('deadline').value = localDateTime;
            }
        }

        // Voice recognition
        function startVoiceRecognition() {
            if (!('webkitSpeechRecognition' in window) && !('SpeechRecognition' in window)) {
                alert('Your browser does not support speech recognition. Try Chrome or Edge.');
                return;
            }

            const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
            const recognition = new SpeechRecognition();

            recognition.lang = 'en-US';
            recognition.interimResults = false;
            recognition.maxAlternatives = 1;

            recognition.start();

            recognition.onresult = function(event) {
                const transcript = event.results[0][0].transcript;
                document.getElementById('taskName').value = transcript;
                
                // Auto-select priority for urgent-sounding tasks
                const lowerTranscript = transcript.toLowerCase();
                if (lowerTranscript.includes('urgent') || lowerTranscript.includes('important') || 
                    lowerTranscript.includes('asap') || lowerTranscript.includes('critical')) {
                    document.getElementById('priority').value = 'high';
                }
            };

            recognition.onspeechend = function() {
                recognition.stop();
            };

            recognition.onerror = function(event) {
                console.error('Speech recognition error', event.error);
                alert('Speech recognition failed. Please try again.');
            };
        }

        // Clear form
        function clearForm() {
            document.getElementById('taskForm').reset();
        }

        // Auto-hide messages after 5 seconds
        setTimeout(() => {
            const messages = document.querySelectorAll('.message, .error');
            messages.forEach(msg => {
                msg.style.opacity = '0';
                setTimeout(() => msg.remove(), 500);
            });
        }, 5000);
    </script>
</body>
</html>