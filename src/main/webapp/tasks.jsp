<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Tasks - Time Keeper</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        /* Your existing CSS styles */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: linear-gradient(135deg, #1a2a6c, #b21f1f, #fdbb2d); color: white; min-height: 100vh; display: flex; flex-direction: column; }
        header { background-color: rgba(0, 0, 0, 0.7); padding: 1rem; text-align: center; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3); }
        nav { display: flex; justify-content: center; gap: 2rem; margin-top: 1rem; flex-wrap: wrap; }
        nav a { color: white; text-decoration: none; padding: 0.5rem 1rem; border-radius: 4px; transition: background-color 0.3s; }
        nav a:hover, nav a.active { background-color: rgba(255, 255, 255, 0.2); }
        .user-info { position: absolute; top: 1rem; right: 1rem; display: flex; align-items: center; gap: 1rem; }
        .logout-btn { background-color: #ff5252; color: white; border: none; padding: 0.5rem 1rem; border-radius: 4px; cursor: pointer; text-decoration: none; }
        .logout-btn:hover { background-color: #ff3838; }
        main { flex: 1; padding: 2rem; max-width: 1200px; margin: 0 auto; width: 100%; }
        section { background-color: rgba(255, 255, 255, 0.1); border-radius: 12px; padding: 1.5rem; margin-bottom: 2rem; box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); backdrop-filter: blur(10px); }
        h1 { font-size: 2.5rem; margin-bottom: 0.5rem; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5); }
        h2 { margin-bottom: 1rem; border-bottom: 1px solid rgba(255, 255, 255, 0.3); padding-bottom: 0.5rem; }
        button { background-color: #4CAF50; color: white; border: none; padding: 0.5rem 1rem; border-radius: 4px; cursor: pointer; transition: background-color 0.3s; }
        button:hover { background-color: #45a049; }
        footer { background-color: rgba(0, 0, 0, 0.7); padding: 1rem; text-align: center; margin-top: auto; }

        /* Tasks Specific Styles */
        .filter-controls { display: flex; gap: 1rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .filter-controls button { background-color: rgba(255, 255, 255, 0.2); }
        .filter-controls button.active { background-color: #4CAF50; }
        .filter-controls button:hover { background-color: rgba(255, 255, 255, 0.3); }

        #taskList { list-style-type: none; }
        .task-item { background-color: rgba(255, 255, 255, 0.1); padding: 1rem; margin-bottom: 0.5rem; border-radius: 8px; display: flex; justify-content: space-between; align-items: center; transition: all 0.3s; }
        .task-item:hover { background-color: rgba(255, 255, 255, 0.15); }
        .task-item.high { border-left: 4px solid #ff5252; }
        .task-item.medium { border-left: 4px solid #ffb142; }
        .task-item.low { border-left: 4px solid #2ed573; }
        .task-item.completed { opacity: 0.7; background-color: rgba(46, 213, 115, 0.1); }
        .task-info { flex: 1; }
        .task-actions { display: flex; gap: 0.5rem; }
        .task-actions button { padding: 0.25rem 0.5rem; font-size: 0.8rem; }
        .task-actions .complete { background-color: #2ed573; }
        .task-actions .complete:hover { background-color: #25c45c; }
        .task-actions .delete { background-color: #ff5252; }
        .task-actions .delete:hover { background-color: #ff3838; }

        .empty-state { text-align: center; padding: 3rem; color: rgba(255, 255, 255, 0.7); }
        .empty-state a { color: #4CAF50; text-decoration: none; }

        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem; margin-bottom: 2rem; }
        .stat-card { background-color: rgba(255, 255, 255, 0.1); border-radius: 8px; padding: 1rem; text-align: center; }
        .stat-number { font-size: 2rem; font-weight: bold; margin-bottom: 0.5rem; }

        .message { background-color: rgba(46, 213, 115, 0.2); padding: 1rem; border-radius: 8px; margin-bottom: 1rem; border-left: 4px solid #2ed573; }
        .error { background-color: rgba(255, 82, 82, 0.2); padding: 1rem; border-radius: 8px; margin-bottom: 1rem; border-left: 4px solid #ff5252; }

        @media (max-width: 768px) {
            .task-item { flex-direction: column; align-items: flex-start; gap: 1rem; }
            .task-actions { align-self: flex-end; }
            .filter-controls { justify-content: center; }
            .user-info { position: static; justify-content: center; margin-top: 1rem; }
        }
    </style>
</head>
<body>
    <header>
        <h1>Time Keeper</h1>
        <p>Manage Your Tasks</p>
        
        <div class="user-info">
            <span>Welcome, <strong>${sessionScope.username}</strong>!</span>
            <a href="login.jsp" class="logout-btn">Logout</a>
        </div>
        
        <nav>
            <a href="dashboard">Dashboard</a>
            <a href="#" class="active">Tasks</a>
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

        <section>
            <h2>Task Statistics</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number">${totalTasks}</div>
                    <div>Total Tasks</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${completedTasks}</div>
                    <div>Completed</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${pendingTasks}</div>
                    <div>Pending</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${highPriorityTasks}</div>
                    <div>High Priority</div>
                </div>
            </div>
        </section>

        <section>
            <h2>Your Tasks</h2>
            
            <div class="filter-controls">
                <button onclick="filterTasks('all')" class="${param.filter == 'all' or empty param.filter ? 'active' : ''}">All Tasks</button>
                <button onclick="filterTasks('today')" class="${param.filter == 'today' ? 'active' : ''}">Today</button>
                <button onclick="filterTasks('high')" class="${param.filter == 'high' ? 'active' : ''}">High Priority</button>
                <button onclick="filterTasks('completed')" class="${param.filter == 'completed' ? 'active' : ''}">Completed</button>
                <button onclick="filterTasks('pending')" class="${param.filter == 'pending' ? 'active' : ''}">Pending</button>
            </div>

            <c:choose>
                <c:when test="${not empty tasks}">
                    <ul id="taskList">
                        <c:forEach var="task" items="${tasks}">
                            <!-- FIXED: Use task.completed instead of task.completed -->
                            <li class="task-item ${task.priority.name().toLowerCase()} ${task.completed ? 'completed' : ''}">
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
                                        | Duration: ${not empty task.durationMinutes ? task.durationMinutes : 'N/A'} minutes
                                    </div>
                                    <c:if test="${not empty task.description}">
                                        <div style="margin-top: 0.5rem;">${task.description}</div>
                                    </c:if>
                                    <div style="margin-top: 0.5rem; font-size: 0.8rem; opacity: 0.7;">
                                        Created: <fmt:formatDate value="${task.createdAt}" pattern="MMM dd, yyyy"/>
                                    </div>
                                </div>
                                <div class="task-actions">
                                    <form action="tasks" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="toggle">
                                        <input type="hidden" name="taskId" value="${task.id}">
                                        <!-- FIXED: Use task.completed instead of task.completed -->
                                        <button type="submit" class="complete" title="${task.completed ? 'Mark as Pending' : 'Mark as Completed'}">
                                            ${task.completed ? '↶' : '✓'}
                                        </button>
                                    </form>
                                    <form action="tasks" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="taskId" value="${task.id}">
                                        <button type="submit" class="delete" onclick="return confirm('Are you sure you want to delete this task?')" title="Delete Task">✕</button>
                                    </form>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <h3>No tasks found</h3>
                        <p>
                            <c:choose>
                                <c:when test="${param.filter == 'completed'}">
                                    You haven't completed any tasks yet.
                                </c:when>
                                <c:when test="${param.filter == 'today'}">
                                    No tasks due today.
                                </c:when>
                                <c:when test="${param.filter == 'high'}">
                                    No high priority tasks.
                                </c:when>
                                <c:otherwise>
                                    You don't have any tasks yet. 
                                </c:otherwise>
                            </c:choose>
                            <a href="add-task.jsp">Create your first task!</a>
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>

    <footer>
        <p>Time Keeper &copy; 2023 - AI Digital Clock & Day Planner @harshit_Sinotiya</p>
    </footer>

    <script>
        function filterTasks(filter) {
            window.location.href = 'tasks?filter=' + filter;
        }

        // Auto-hide messages after 5 seconds
        setTimeout(() => {
            const messages = document.querySelectorAll('.message, .error');
            messages.forEach(msg => {
                msg.style.opacity = '0';
                setTimeout(() => msg.remove(), 500);
            });
        }, 5000);

        // Add confirmation for task deletion
        document.addEventListener('DOMContentLoaded', function() {
            const deleteForms = document.querySelectorAll('form[action="tasks"] input[name="action"][value="delete"]');
            deleteForms.forEach(input => {
                const form = input.closest('form');
                form.addEventListener('submit', function(e) {
                    if (!confirm('Are you sure you want to delete this task?')) {
                        e.preventDefault();
                    }
                });
            });
        });
    </script>
</body>
</html>