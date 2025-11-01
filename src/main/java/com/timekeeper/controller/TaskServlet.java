package com.timekeeper.controller;

import com.timekeeper.dao.TaskDAO;
import com.timekeeper.model.Task;
import com.timekeeper.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

public class TaskServlet extends HttpServlet {
    private TaskDAO taskDAO;
    
    @Override
    public void init() throws ServletException {
        taskDAO = new TaskDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String filter = request.getParameter("filter");
        
        try {
            List<Task> filteredTasks;
            
            switch (filter != null ? filter : "all") {
                case "today":
                    filteredTasks = taskDAO.getTodayTasks(user);
                    break;
                case "high":
                    filteredTasks = taskDAO.getTasksByUserAndPriority(user, Task.Priority.HIGH);
                    break;
                case "completed":
                    filteredTasks = taskDAO.getCompletedTasks(user);
                    break;
                case "pending":
                    filteredTasks = taskDAO.getTasksByUser(user).stream()
                            .filter(task -> !task.getIsCompleted())
                            .collect(Collectors.toList());
                    break;
                default:
                    filteredTasks = taskDAO.getTasksByUser(user);
            }
            
            filteredTasks.sort((t1, t2) -> {
                
                if (t1.getIsCompleted() && !t2.getIsCompleted()) return 1;
                if (!t1.getIsCompleted() && t2.getIsCompleted()) return -1;
                
               
                if (t1.getDeadline() != null && t2.getDeadline() != null) {
                    int deadlineCompare = t1.getDeadline().compareTo(t2.getDeadline());
                    if (deadlineCompare != 0) return deadlineCompare;
                } else if (t1.getDeadline() != null) {
                    return -1;
                } else if (t2.getDeadline() != null) {
                    return 1;
                }
                
               
                return t2.getPriority().compareTo(t1.getPriority());
            });
            
            request.setAttribute("tasks", filteredTasks);
            
          
            calculateTaskStats(request, user);
            
            request.getRequestDispatcher("/tasks.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading tasks: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        User user = (User) session.getAttribute("user");
        
        try {
            if ("add".equals(action)) {
                addTask(request, user);
                session.setAttribute("message", "Task added successfully!");
                response.sendRedirect("tasks");
                
            } else if ("delete".equals(action)) {
                deleteTask(request);
                session.setAttribute("message", "Task deleted successfully!");
                response.sendRedirect("tasks");
                
            } else if ("toggle".equals(action)) {
                toggleTask(request);
                session.setAttribute("message", "Task status updated successfully!");
                response.sendRedirect("tasks");
                
            } else if ("edit".equals(action)) {
                editTask(request);
                session.setAttribute("message", "Task updated successfully!");
                response.sendRedirect("tasks");
                
            } else if ("bulkDelete".equals(action)) {
                bulkDeleteTasks(request);
                session.setAttribute("message", "Selected tasks deleted successfully!");
                response.sendRedirect("tasks");
                
            } else if ("bulkComplete".equals(action)) {
                bulkCompleteTasks(request);
                session.setAttribute("message", "Selected tasks marked as completed!");
                response.sendRedirect("tasks");
                
            } else {
                session.setAttribute("error", "Invalid action");
                response.sendRedirect("tasks");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error: " + e.getMessage());
            response.sendRedirect("tasks");
        }
    }
    
    private void addTask(HttpServletRequest request, User user) throws Exception {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priorityStr = request.getParameter("priority");
        String deadlineStr = request.getParameter("deadline");
        String durationStr = request.getParameter("duration");
        
        System.out.println("Received task data:");
        System.out.println("Name: " + name);
        System.out.println("Priority: " + priorityStr);
        System.out.println("Deadline: " + deadlineStr);
        System.out.println("Duration: " + durationStr);
        System.out.println("Description: " + description);
        
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Task name is required");
        }
        
        Task.Priority priority;
        try {
            priority = Task.Priority.valueOf(priorityStr.toUpperCase());
        } catch (IllegalArgumentException e) {
            priority = Task.Priority.MEDIUM; 
        }
        
        Date deadline = null;
        Integer duration = null;
        
        if (deadlineStr != null && !deadlineStr.trim().isEmpty()) {
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                deadline = dateFormat.parse(deadlineStr);
            } catch (Exception e) {
                System.err.println("Error parsing deadline: " + e.getMessage());
               
            }
        }
        
        if (durationStr != null && !durationStr.trim().isEmpty()) {
            try {
                duration = Integer.parseInt(durationStr);
            } catch (NumberFormatException e) {
                System.err.println("Error parsing duration: " + e.getMessage());
                
            }
        }
        
        Task task = new Task(name.trim(), 
                           description != null ? description.trim() : null, 
                           priority, 
                           deadline, 
                           duration, 
                           user);
        
        taskDAO.saveTask(task);
        System.out.println("Task saved successfully with ID: " + task.getId());
    }
    
    private void deleteTask(HttpServletRequest request) {
        try {
            String taskIdStr = request.getParameter("taskId");
            if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Task ID is required");
            }
            
            Long taskId = Long.parseLong(taskIdStr);
            System.out.println("Deleting task with ID: " + taskId);
            
            taskDAO.deleteTask(taskId);
            
        } catch (NumberFormatException e) {
            throw new RuntimeException("Invalid task ID format", e);
        } catch (Exception e) {
            throw new RuntimeException("Error deleting task: " + e.getMessage(), e);
        }
    }
    
    private void toggleTask(HttpServletRequest request) {
        try {
            String taskIdStr = request.getParameter("taskId");
            if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Task ID is required");
            }
            
            Long taskId = Long.parseLong(taskIdStr);
            System.out.println("Toggling completion for task ID: " + taskId);
            
            taskDAO.toggleTaskCompletion(taskId);
            
        } catch (NumberFormatException e) {
            throw new RuntimeException("Invalid task ID format", e);
        } catch (Exception e) {
            throw new RuntimeException("Error updating task: " + e.getMessage(), e);
        }
    }
    
    private void editTask(HttpServletRequest request) throws Exception {
        String taskIdStr = request.getParameter("taskId");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priorityStr = request.getParameter("priority");
        String deadlineStr = request.getParameter("deadline");
        String durationStr = request.getParameter("duration");
        
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Task ID is required for editing");
        }
        
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Task name is required");
        }
        
        Long taskId = Long.parseLong(taskIdStr);
        Task task = taskDAO.getTaskById(taskId);
        
        if (task == null) {
            throw new RuntimeException("Task not found with ID: " + taskId);
        }
        

        task.setName(name.trim());
        task.setDescription(description != null ? description.trim() : null);
        
        try {
            task.setPriority(Task.Priority.valueOf(priorityStr.toUpperCase()));
        } catch (IllegalArgumentException e) {
         
        }
        
        if (deadlineStr != null && !deadlineStr.trim().isEmpty()) {
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                task.setDeadline(dateFormat.parse(deadlineStr));
            } catch (Exception e) {
                System.err.println("Error parsing deadline: " + e.getMessage());
            }
        } else {
            task.setDeadline(null);
        }
        
        if (durationStr != null && !durationStr.trim().isEmpty()) {
            try {
                task.setDurationMinutes(Integer.parseInt(durationStr));
            } catch (NumberFormatException e) {
                System.err.println("Error parsing duration: " + e.getMessage());
            }
        } else {
            task.setDurationMinutes(null);
        }
        
        taskDAO.updateTask(task);
        System.out.println("Task updated successfully: " + taskId);
    }
    
    private void bulkDeleteTasks(HttpServletRequest request) {
        try {
            String[] taskIds = request.getParameterValues("taskIds");
            if (taskIds == null || taskIds.length == 0) {
                throw new IllegalArgumentException("No tasks selected for deletion");
            }
            
            System.out.println("Bulk deleting " + taskIds.length + " tasks");
            
            for (String taskIdStr : taskIds) {
                try {
                    Long taskId = Long.parseLong(taskIdStr);
                    taskDAO.deleteTask(taskId);
                } catch (NumberFormatException e) {
                    System.err.println("Invalid task ID in bulk delete: " + taskIdStr);
                }
            }
            
        } catch (Exception e) {
            throw new RuntimeException("Error in bulk delete: " + e.getMessage(), e);
        }
    }
    
    private void bulkCompleteTasks(HttpServletRequest request) {
        try {
            String[] taskIds = request.getParameterValues("taskIds");
            if (taskIds == null || taskIds.length == 0) {
                throw new IllegalArgumentException("No tasks selected for completion");
            }
            
            System.out.println("Bulk completing " + taskIds.length + " tasks");
            
            for (String taskIdStr : taskIds) {
                try {
                    Long taskId = Long.parseLong(taskIdStr);
                    Task task = taskDAO.getTaskById(taskId);
                    if (task != null && !task.getIsCompleted()) {
                        taskDAO.toggleTaskCompletion(taskId);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Invalid task ID in bulk complete: " + taskIdStr);
                }
            }
            
        } catch (Exception e) {
            throw new RuntimeException("Error in bulk complete: " + e.getMessage(), e);
        }
    }
    
    private void calculateTaskStats(HttpServletRequest request, User user) {
        List<Task> tasks = taskDAO.getTasksByUser(user);
        int totalTasks = tasks.size();
        int completedTasks = 0;
        int highPriorityTasks = 0;
        int overdueTasks = 0;
        Date now = new Date();
        
        for (Task task : tasks) {
            if (task.getIsCompleted()) {
                completedTasks++;
            }
            if (task.getPriority() == Task.Priority.HIGH) {
                highPriorityTasks++;
            }
            if (!task.getIsCompleted() && task.getDeadline() != null && task.getDeadline().before(now)) {
                overdueTasks++;
            }
        }
        
        int pendingTasks = totalTasks - completedTasks;
        
        request.setAttribute("totalTasks", totalTasks);
        request.setAttribute("completedTasks", completedTasks);
        request.setAttribute("pendingTasks", pendingTasks);
        request.setAttribute("highPriorityTasks", highPriorityTasks);
        request.setAttribute("overdueTasks", overdueTasks);
        
        double completionRate = totalTasks > 0 ? (double) completedTasks / totalTasks * 100 : 0;
        request.setAttribute("completionRate", Math.round(completionRate));
    }
    
    @Override
    public void destroy() {
       
        super.destroy();
    }
}
