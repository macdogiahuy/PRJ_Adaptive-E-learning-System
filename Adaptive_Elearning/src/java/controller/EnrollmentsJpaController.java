/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import controller.exceptions.NonexistentEntityException;
import controller.exceptions.PreexistingEntityException;
import java.io.Serializable;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import model.Bills;
import model.Courses;
import model.Enrollments;
import model.EnrollmentsPK;
import model.Users;

/**
 *
 * @author LP
 */
public class EnrollmentsJpaController implements Serializable {

    public EnrollmentsJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Enrollments enrollments) throws PreexistingEntityException, Exception {
        if (enrollments.getEnrollmentsPK() == null) {
            enrollments.setEnrollmentsPK(new EnrollmentsPK());
        }
        enrollments.getEnrollmentsPK().setCourseId(enrollments.getCourses().getId());
        enrollments.getEnrollmentsPK().setCreatorId(enrollments.getUsers().getId());
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Bills billId = enrollments.getBillId();
            if (billId != null) {
                billId = em.getReference(billId.getClass(), billId.getId());
                enrollments.setBillId(billId);
            }
            Courses courses = enrollments.getCourses();
            if (courses != null) {
                courses = em.getReference(courses.getClass(), courses.getId());
                enrollments.setCourses(courses);
            }
            Users users = enrollments.getUsers();
            if (users != null) {
                users = em.getReference(users.getClass(), users.getId());
                enrollments.setUsers(users);
            }
            em.persist(enrollments);
            if (billId != null) {
                Enrollments oldEnrollmentsOfBillId = billId.getEnrollments();
                if (oldEnrollmentsOfBillId != null) {
                    oldEnrollmentsOfBillId.setBillId(null);
                    oldEnrollmentsOfBillId = em.merge(oldEnrollmentsOfBillId);
                }
                billId.setEnrollments(enrollments);
                billId = em.merge(billId);
            }
            if (courses != null) {
                courses.getEnrollmentsList().add(enrollments);
                courses = em.merge(courses);
            }
            if (users != null) {
                users.getEnrollmentsList().add(enrollments);
                users = em.merge(users);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findEnrollments(enrollments.getEnrollmentsPK()) != null) {
                throw new PreexistingEntityException("Enrollments " + enrollments + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Enrollments enrollments) throws NonexistentEntityException, Exception {
        enrollments.getEnrollmentsPK().setCourseId(enrollments.getCourses().getId());
        enrollments.getEnrollmentsPK().setCreatorId(enrollments.getUsers().getId());
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Enrollments persistentEnrollments = em.find(Enrollments.class, enrollments.getEnrollmentsPK());
            Bills billIdOld = persistentEnrollments.getBillId();
            Bills billIdNew = enrollments.getBillId();
            Courses coursesOld = persistentEnrollments.getCourses();
            Courses coursesNew = enrollments.getCourses();
            Users usersOld = persistentEnrollments.getUsers();
            Users usersNew = enrollments.getUsers();
            if (billIdNew != null) {
                billIdNew = em.getReference(billIdNew.getClass(), billIdNew.getId());
                enrollments.setBillId(billIdNew);
            }
            if (coursesNew != null) {
                coursesNew = em.getReference(coursesNew.getClass(), coursesNew.getId());
                enrollments.setCourses(coursesNew);
            }
            if (usersNew != null) {
                usersNew = em.getReference(usersNew.getClass(), usersNew.getId());
                enrollments.setUsers(usersNew);
            }
            enrollments = em.merge(enrollments);
            if (billIdOld != null && !billIdOld.equals(billIdNew)) {
                billIdOld.setEnrollments(null);
                billIdOld = em.merge(billIdOld);
            }
            if (billIdNew != null && !billIdNew.equals(billIdOld)) {
                Enrollments oldEnrollmentsOfBillId = billIdNew.getEnrollments();
                if (oldEnrollmentsOfBillId != null) {
                    oldEnrollmentsOfBillId.setBillId(null);
                    oldEnrollmentsOfBillId = em.merge(oldEnrollmentsOfBillId);
                }
                billIdNew.setEnrollments(enrollments);
                billIdNew = em.merge(billIdNew);
            }
            if (coursesOld != null && !coursesOld.equals(coursesNew)) {
                coursesOld.getEnrollmentsList().remove(enrollments);
                coursesOld = em.merge(coursesOld);
            }
            if (coursesNew != null && !coursesNew.equals(coursesOld)) {
                coursesNew.getEnrollmentsList().add(enrollments);
                coursesNew = em.merge(coursesNew);
            }
            if (usersOld != null && !usersOld.equals(usersNew)) {
                usersOld.getEnrollmentsList().remove(enrollments);
                usersOld = em.merge(usersOld);
            }
            if (usersNew != null && !usersNew.equals(usersOld)) {
                usersNew.getEnrollmentsList().add(enrollments);
                usersNew = em.merge(usersNew);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                EnrollmentsPK id = enrollments.getEnrollmentsPK();
                if (findEnrollments(id) == null) {
                    throw new NonexistentEntityException("The enrollments with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(EnrollmentsPK id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Enrollments enrollments;
            try {
                enrollments = em.getReference(Enrollments.class, id);
                enrollments.getEnrollmentsPK();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The enrollments with id " + id + " no longer exists.", enfe);
            }
            Bills billId = enrollments.getBillId();
            if (billId != null) {
                billId.setEnrollments(null);
                billId = em.merge(billId);
            }
            Courses courses = enrollments.getCourses();
            if (courses != null) {
                courses.getEnrollmentsList().remove(enrollments);
                courses = em.merge(courses);
            }
            Users users = enrollments.getUsers();
            if (users != null) {
                users.getEnrollmentsList().remove(enrollments);
                users = em.merge(users);
            }
            em.remove(enrollments);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Enrollments> findEnrollmentsEntities() {
        return findEnrollmentsEntities(true, -1, -1);
    }

    public List<Enrollments> findEnrollmentsEntities(int maxResults, int firstResult) {
        return findEnrollmentsEntities(false, maxResults, firstResult);
    }

    private List<Enrollments> findEnrollmentsEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Enrollments.class));
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

    public Enrollments findEnrollments(EnrollmentsPK id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Enrollments.class, id);
        } finally {
            em.close();
        }
    }

    public int getEnrollmentsCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Enrollments> rt = cq.from(Enrollments.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
