package com.timekeeper.dao;

import com.timekeeper.model.Task;
import com.timekeeper.model.User;
import com.timekeeper.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import java.util.Date;
import java.util.List;

public class TaskDAO {
    
    public void saveTask(Task task) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.save(task);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }
    
    public Task getTaskById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Task.class, id);
        }
    }
    
    public List<Task> getTasksByUser(User user) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Task> query = session.createQuery("FROM Task WHERE user = :user ORDER BY createdAt DESC", Task.class);
            query.setParameter("user", user);
            return query.list();
        }
    }
    
    public List<Task> getTasksByUserAndPriority(User user, Task.Priority priority) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Task> query = session.createQuery(
                "FROM Task WHERE user = :user AND priority = :priority ORDER BY createdAt DESC", Task.class);
            query.setParameter("user", user);
            query.setParameter("priority", priority);
            return query.list();
        }
    }
    
    public List<Task> getTodayTasks(User user) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Date today = new Date();
            Date tomorrow = new Date(today.getTime() + 24 * 60 * 60 * 1000);
            
            Query<Task> query = session.createQuery(
                "FROM Task WHERE user = :user AND deadline BETWEEN :today AND :tomorrow ORDER BY deadline ASC", Task.class);
            query.setParameter("user", user);
            query.setParameter("today", today);
            query.setParameter("tomorrow", tomorrow);
            return query.list();
        }
    }
    
    public List<Task> getCompletedTasks(User user) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Task> query = session.createQuery(
                "FROM Task WHERE user = :user AND isCompleted = true ORDER BY createdAt DESC", Task.class);
            query.setParameter("user", user);
            return query.list();
        }
    }
    
    public void updateTask(Task task) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.update(task);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }
    
    public void deleteTask(Long id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Task task = session.get(Task.class, id);
            if (task != null) {
                session.delete(task);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }
    
    public void toggleTaskCompletion(Long id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Task task = session.get(Task.class, id);
            if (task != null) {
                task.setIsCompleted(!task.getIsCompleted());
                session.update(task);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }
}