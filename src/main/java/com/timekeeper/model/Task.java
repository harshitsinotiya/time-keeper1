package com.timekeeper.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "tasks")
public class Task {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "name", nullable = false, length = 255)
    private String name;
    
    @Column(name = "description", columnDefinition = "TEXT")
    private String description;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "priority", nullable = false)
    private Priority priority;
    
    @Column(name = "deadline")
    @Temporal(TemporalType.TIMESTAMP)
    private Date deadline;
    
    @Column(name = "duration_minutes")
    private Integer durationMinutes;
    
    @Column(name = "is_completed")
    private Boolean isCompleted = false;
    
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    public enum Priority {
        LOW, MEDIUM, HIGH
    }
    
    // Constructors
    public Task() {
        this.createdAt = new Date();
        this.isCompleted = false;
        this.priority = Priority.MEDIUM;
    }
    
    public Task(String name, String description, Priority priority, Date deadline, Integer durationMinutes, User user) {
        this();
        this.name = name;
        this.description = description;
        this.priority = priority;
        this.deadline = deadline;
        this.durationMinutes = durationMinutes;
        this.user = user;
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public Priority getPriority() { return priority; }
    public void setPriority(Priority priority) { this.priority = priority; }
    
    public Date getDeadline() { return deadline; }
    public void setDeadline(Date deadline) { this.deadline = deadline; }
    
    public Integer getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }
    
    // FIXED: Use getCompleted() instead of getIsCompleted() for JSP EL
    public Boolean getCompleted() { return isCompleted; }
    public Boolean getIsCompleted() { return isCompleted; } // Keep both for compatibility
    public void setIsCompleted(Boolean isCompleted) { this.isCompleted = isCompleted; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    @Override
    public String toString() {
        return "Task{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", priority=" + priority +
                ", deadline=" + deadline +
                ", durationMinutes=" + durationMinutes +
                ", isCompleted=" + isCompleted +
                ", createdAt=" + createdAt +
                ", userId=" + (user != null ? user.getId() : "null") +
                '}';
    }
}