/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import controller.exceptions.IllegalOrphanException;
import controller.exceptions.NonexistentEntityException;
import controller.exceptions.PreexistingEntityException;
import java.io.Serializable;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import model.Users;
import model.Courses;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.Instructors;

/**
 *
 * @author LP
 */
public class InstructorsJpaController implements Serializable {

    public InstructorsJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Instructors instructors) throws IllegalOrphanException, PreexistingEntityException, Exception {
        if (instructors.getCoursesList() == null) {
            instructors.setCoursesList(new ArrayList<Courses>());
        }
        List<String> illegalOrphanMessages = null;
        Users creatorIdOrphanCheck = instructors.getCreatorId();
        if (creatorIdOrphanCheck != null) {
            Instructors oldInstructorsOfCreatorId = creatorIdOrphanCheck.getInstructors();
            if (oldInstructorsOfCreatorId != null) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("The Users " + creatorIdOrphanCheck + " already has an item of type Instructors whose creatorId column cannot be null. Please make another selection for the creatorId field.");
            }
        }
        if (illegalOrphanMessages != null) {
            throw new IllegalOrphanException(illegalOrphanMessages);
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Users creatorId = instructors.getCreatorId();
            if (creatorId != null) {
                creatorId = em.getReference(creatorId.getClass(), creatorId.getId());
                instructors.setCreatorId(creatorId);
            }
            List<Courses> attachedCoursesList = new ArrayList<Courses>();
            for (Courses coursesListCoursesToAttach : instructors.getCoursesList()) {
                coursesListCoursesToAttach = em.getReference(coursesListCoursesToAttach.getClass(), coursesListCoursesToAttach.getId());
                attachedCoursesList.add(coursesListCoursesToAttach);
            }
            instructors.setCoursesList(attachedCoursesList);
            em.persist(instructors);
            if (creatorId != null) {
                creatorId.setInstructors(instructors);
                creatorId = em.merge(creatorId);
            }
            for (Courses coursesListCourses : instructors.getCoursesList()) {
                Instructors oldInstructorIdOfCoursesListCourses = coursesListCourses.getInstructorId();
                coursesListCourses.setInstructorId(instructors);
                coursesListCourses = em.merge(coursesListCourses);
                if (oldInstructorIdOfCoursesListCourses != null) {
                    oldInstructorIdOfCoursesListCourses.getCoursesList().remove(coursesListCourses);
                    oldInstructorIdOfCoursesListCourses = em.merge(oldInstructorIdOfCoursesListCourses);
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findInstructors(instructors.getId()) != null) {
                throw new PreexistingEntityException("Instructors " + instructors + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Instructors instructors) throws IllegalOrphanException, NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Instructors persistentInstructors = em.find(Instructors.class, instructors.getId());
            Users creatorIdOld = persistentInstructors.getCreatorId();
            Users creatorIdNew = instructors.getCreatorId();
            List<Courses> coursesListOld = persistentInstructors.getCoursesList();
            List<Courses> coursesListNew = instructors.getCoursesList();
            List<String> illegalOrphanMessages = null;
            if (creatorIdNew != null && !creatorIdNew.equals(creatorIdOld)) {
                Instructors oldInstructorsOfCreatorId = creatorIdNew.getInstructors();
                if (oldInstructorsOfCreatorId != null) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("The Users " + creatorIdNew + " already has an item of type Instructors whose creatorId column cannot be null. Please make another selection for the creatorId field.");
                }
            }
            for (Courses coursesListOldCourses : coursesListOld) {
                if (!coursesListNew.contains(coursesListOldCourses)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Courses " + coursesListOldCourses + " since its instructorId field is not nullable.");
                }
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            if (creatorIdNew != null) {
                creatorIdNew = em.getReference(creatorIdNew.getClass(), creatorIdNew.getId());
                instructors.setCreatorId(creatorIdNew);
            }
            List<Courses> attachedCoursesListNew = new ArrayList<Courses>();
            for (Courses coursesListNewCoursesToAttach : coursesListNew) {
                coursesListNewCoursesToAttach = em.getReference(coursesListNewCoursesToAttach.getClass(), coursesListNewCoursesToAttach.getId());
                attachedCoursesListNew.add(coursesListNewCoursesToAttach);
            }
            coursesListNew = attachedCoursesListNew;
            instructors.setCoursesList(coursesListNew);
            instructors = em.merge(instructors);
            if (creatorIdOld != null && !creatorIdOld.equals(creatorIdNew)) {
                creatorIdOld.setInstructors(null);
                creatorIdOld = em.merge(creatorIdOld);
            }
            if (creatorIdNew != null && !creatorIdNew.equals(creatorIdOld)) {
                creatorIdNew.setInstructors(instructors);
                creatorIdNew = em.merge(creatorIdNew);
            }
            for (Courses coursesListNewCourses : coursesListNew) {
                if (!coursesListOld.contains(coursesListNewCourses)) {
                    Instructors oldInstructorIdOfCoursesListNewCourses = coursesListNewCourses.getInstructorId();
                    coursesListNewCourses.setInstructorId(instructors);
                    coursesListNewCourses = em.merge(coursesListNewCourses);
                    if (oldInstructorIdOfCoursesListNewCourses != null && !oldInstructorIdOfCoursesListNewCourses.equals(instructors)) {
                        oldInstructorIdOfCoursesListNewCourses.getCoursesList().remove(coursesListNewCourses);
                        oldInstructorIdOfCoursesListNewCourses = em.merge(oldInstructorIdOfCoursesListNewCourses);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = instructors.getId();
                if (findInstructors(id) == null) {
                    throw new NonexistentEntityException("The instructors with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(String id) throws IllegalOrphanException, NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Instructors instructors;
            try {
                instructors = em.getReference(Instructors.class, id);
                instructors.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The instructors with id " + id + " no longer exists.", enfe);
            }
            List<String> illegalOrphanMessages = null;
            List<Courses> coursesListOrphanCheck = instructors.getCoursesList();
            for (Courses coursesListOrphanCheckCourses : coursesListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Instructors (" + instructors + ") cannot be destroyed since the Courses " + coursesListOrphanCheckCourses + " in its coursesList field has a non-nullable instructorId field.");
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            Users creatorId = instructors.getCreatorId();
            if (creatorId != null) {
                creatorId.setInstructors(null);
                creatorId = em.merge(creatorId);
            }
            em.remove(instructors);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Instructors> findInstructorsEntities() {
        return findInstructorsEntities(true, -1, -1);
    }

    public List<Instructors> findInstructorsEntities(int maxResults, int firstResult) {
        return findInstructorsEntities(false, maxResults, firstResult);
    }

    private List<Instructors> findInstructorsEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Instructors.class));
            Query q = em.createQuery(cq);
            if (!all) {
                q.setMaxResults(maxResults);
                q.setFirstResult(firstResult);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public Instructors findInstructors(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Instructors.class, id);
        } finally {
            em.close();
        }
    }

    public int getInstructorsCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Instructors> rt = cq.from(Instructors.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
