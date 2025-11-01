


package com.timekeeper.controller;

import com.timekeeper.dao.TaskDAO;
import com.timekeeper.model.Task;
import com.timekeeper.model.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private TaskDAO taskDAO;

    @Override
    public void init() throws ServletException {
        taskDAO = new TaskDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        try {
            // Get all tasks for statistics
            List<Task> allTasks = taskDAO.getTasksByUser(user);
            
            // Calculate statistics
            int totalTasks = allTasks.size();
            int completedTasks = (int) allTasks.stream().filter(Task::getIsCompleted).count();
            int pendingTasks = totalTasks - completedTasks;
            int highPriorityTasks = (int) allTasks.stream()
                    .filter(task -> task.getPriority() == Task.Priority.HIGH)
                    .count();

            // Get recent tasks (last 5 tasks) - using collect(Collectors.toList()) instead of toList()
            List<Task> recentTasks = allTasks.stream()
                    .sorted((t1, t2) -> t2.getCreatedAt().compareTo(t1.getCreatedAt()))
                    .limit(5)
                    .collect(Collectors.toList());

            // Get upcoming tasks (due in next 7 days and not completed)
            List<Task> upcomingTasks = allTasks.stream()
                    .filter(task -> !task.getIsCompleted() && task.getDeadline() != null)
                    .filter(task -> {
                        Date now = new Date();
                        Date sevenDaysFromNow = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000);
                        return task.getDeadline().after(now) && task.getDeadline().before(sevenDaysFromNow);
                    })
                    .sorted((t1, t2) -> t1.getDeadline().compareTo(t2.getDeadline()))
                    .limit(5)
                    .collect(Collectors.toList());

            // Set attributes for JSP
            request.setAttribute("totalTasks", totalTasks);
            request.setAttribute("completedTasks", completedTasks);
            request.setAttribute("pendingTasks", pendingTasks);
            request.setAttribute("highPriorityTasks", highPriorityTasks);
            request.setAttribute("recentTasks", recentTasks);
            request.setAttribute("upcomingTasks", upcomingTasks);
            request.setAttribute("username", user.getUsername());

            // Forward to dashboard JSP
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}