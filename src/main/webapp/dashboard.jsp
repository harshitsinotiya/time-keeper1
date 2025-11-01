<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Time Keeper</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        /* Global Styles */
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
            padding: 0.5rem 1rem;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        button:hover {
            background-color: #45a049;
        }
        
        /* Dashboard Specific Styles */
        .welcome-section {
            text-align: center;
            padding: 3rem 1rem;
        }
        
        .welcome-section h1 {
            font-size: 3.5rem;
            margin-bottom: 1rem;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }
        
        .stat-card {
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }
        
        .action-card {
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .action-card:hover {
            background-color: rgba(255, 255, 255, 0.2);
            transform: translateY(-3px);
        }
        
        .action-card h3 {
            margin-bottom: 1rem;
        }
        
        .recent-tasks {
            list-style-type: none;
        }
        
        .task-item {
            background-color: rgba(255, 255, 255, 0.1);
            padding: 1rem;
            margin-bottom: 0.5rem;
            border-radius: 8px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .task-item.high {
            border-left: 4px solid #ff5252;
        }
        
        .task-item.medium {
            border-left: 4px solid #ffb142;
        }
        
        .task-item.low {
            border-left: 4px solid #2ed573;
        }
        
        .task-info {
            flex: 1;
        }
        
        footer {
            background-color: rgba(0, 0, 0, 0.7);
            padding: 1rem;
            text-align: center;
            margin-top: auto;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .welcome-section h1 {
                font-size: 2.5rem;
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
        }
        
        .message {
            background-color: rgba(46, 213, 115, 0.2);
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            border-left: 4px solid #2ed573;
        }
        
        .error {
            background-color: rgba(255, 82, 82, 0.2);
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            border-left: 4px solid #ff5252;
        }
    </style>
</head>
<body>
    <header>
        <h1>Time Keeper</h1>
        <p>Digital Clock, Timer & Day Planner</p>
        
        <div class="user-info">
            <span>Welcome, <strong>${sessionScope.username}</strong>!</span>
            <a href="login.jsp" class="logout-btn">Logout</a>
        </div>
        
        <nav>
            <a href="#" class="active">Dashboard</a>
            <a href="tasks">Tasks</a>
            <a href="add-task.jsp">Add Task</a>
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

        <section class="welcome-section">
            <h1>Welcome to Your Dashboard</h1>
            <p>Manage your time effectively with AI-powered task planning and tracking</p>
        </section>
        
        <section>
            <h2>Quick Statistics</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number">${totalTasks}</div>
                    <div>Total Tasks</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${pendingTasks}</div>
                    <div>Pending Tasks</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${completedTasks}</div>
                    <div>Completed Tasks</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${highPriorityTasks}</div>
                    <div>High Priority</div>
                </div>
            </div>
        </section>
        
        <section>
            <h2>Quick Actions</h2>
            <div class="quick-actions">
                <div class="action-card" onclick="location.href='add-task.jsp'">
                    <h3>➕ Add New Task</h3>
                    <p>Create a new task with priority and deadline</p>
                </div>
                <div class="action-card" onclick="location.href='tasks'">
                    <h3>📋 View All Tasks</h3>
                    <p>See all your tasks and manage them</p>
                </div>
                <div class="action-card" onclick="location.href='clock.html'">
                    <h3>⏰ Digital Clock</h3>
                    <p>Use timer, stopwatch and alarms</p>
                </div>
                <div class="action-card" onclick="location.href='tasks?filter=today'">
                    <h3>📅 Today's Tasks</h3>
                    <p>View tasks due today</p>
                </div>
            </div>
        </section>
        
        <section>
            <h2>Recent Tasks</h2>
            <c:choose>
                <c:when test="${not empty recentTasks}">
                    <ul class="recent-tasks">
                        <c:forEach var="task" items="${recentTasks}">
                            <li class="task-item ${task.priority.name().toLowerCase()}">
                                <div class="task-info">
                                    <strong>${task.name}</strong>
                                    <div>
                                        Priority: ${task.priority.name()} | 
                                        <c:choose>
                                            <c:when test="${not empty task.deadline}">
                                                Deadline: <fmt:formatDate value="${task.deadline}" pattern="MMM dd, yyyy HH:mm"/>
                                            </c:when>
                                            <c:otherwise>
                                                No deadline
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <c:if test="${not empty task.description}">
                                        <div>${task.description}</div>
                                    </c:if>
                                </div>
                                <div style="color: ${task.completed ? '#2ed573' : '#ffb142'};">
                                    ${task.completed ? '✓ Completed' : '⏳ Pending'}
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <p>No tasks found. <a href="add-task.jsp" style="color: #4CAF50;">Create your first task!</a></p>
                </c:otherwise>
            </c:choose>
        </section>
        
        <section>
            <h2>Upcoming Deadlines</h2>
            <c:choose>
                <c:when test="${not empty upcomingTasks}">
                    <ul class="recent-tasks">
                        <c:forEach var="task" items="${upcomingTasks}">
                            <li class="task-item ${task.priority.name().toLowerCase()}">
                                <div class="task-info">
                                    <strong>${task.name}</strong>
                                    <div>
                                        Due: <fmt:formatDate value="${task.deadline}" pattern="MMM dd, yyyy HH:mm"/> |
                                        Priority: ${task.priority.name()}
                                    </div>
                                </div>
                                <c:if test="${not task.completed}">
                                    <span style="color: #ff5252;">⚠️ Due Soon</span>
                                </c:if>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <p>No upcoming deadlines. Great job!</p>
                </c:otherwise>
            </c:choose>
        </section>
    </main>

    <footer>
        <p>Time Keeper &copy; 2025 - AI Digital Clock & Day Planner @harshit_Sinotiya</p>
    </footer>

    <script>
        // Simple clock for dashboard
        function updateTime() {
            const now = new Date();
            document.getElementById('current-time').textContent = now.toLocaleTimeString();
        }
        
        setInterval(updateTime, 1000);
        updateTime();
        
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