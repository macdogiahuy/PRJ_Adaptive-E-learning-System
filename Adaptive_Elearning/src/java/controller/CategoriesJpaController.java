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
import model.Courses;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.Categories;

/**
 *
 * @author LP
 */
public class CategoriesJpaController implements Serializable {

    public CategoriesJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Categories categories) throws PreexistingEntityException, Exception {
        if (categories.getCoursesList() == null) {
            categories.setCoursesList(new ArrayList<Courses>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            List<Courses> attachedCoursesList = new ArrayList<Courses>();
            for (Courses coursesListCoursesToAttach : categories.getCoursesList()) {
                coursesListCoursesToAttach = em.getReference(coursesListCoursesToAttach.getClass(), coursesListCoursesToAttach.getId());
                attachedCoursesList.add(coursesListCoursesToAttach);
            }
            categories.setCoursesList(attachedCoursesList);
            em.persist(categories);
            for (Courses coursesListCourses : categories.getCoursesList()) {
                Categories oldLeafCategoryIdOfCoursesListCourses = coursesListCourses.getLeafCategoryId();
                coursesListCourses.setLeafCategoryId(categories);
                coursesListCourses = em.merge(coursesListCourses);
                if (oldLeafCategoryIdOfCoursesListCourses != null) {
                    oldLeafCategoryIdOfCoursesListCourses.getCoursesList().remove(coursesListCourses);
                    oldLeafCategoryIdOfCoursesListCourses = em.merge(oldLeafCategoryIdOfCoursesListCourses);
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findCategories(categories.getId()) != null) {
                throw new PreexistingEntityException("Categories " + categories + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Categories categories) throws IllegalOrphanException, NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Categories persistentCategories = em.find(Categories.class, categories.getId());
            List<Courses> coursesListOld = persistentCategories.getCoursesList();
            List<Courses> coursesListNew = categories.getCoursesList();
            List<String> illegalOrphanMessages = null;
            for (Courses coursesListOldCourses : coursesListOld) {
                if (!coursesListNew.contains(coursesListOldCourses)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Courses " + coursesListOldCourses + " since its leafCategoryId field is not nullable.");
                }
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            List<Courses> attachedCoursesListNew = new ArrayList<Courses>();
            for (Courses coursesListNewCoursesToAttach : coursesListNew) {
                coursesListNewCoursesToAttach = em.getReference(coursesListNewCoursesToAttach.getClass(), coursesListNewCoursesToAttach.getId());
                attachedCoursesListNew.add(coursesListNewCoursesToAttach);
            }
            coursesListNew = attachedCoursesListNew;
            categories.setCoursesList(coursesListNew);
            categories = em.merge(categories);
            for (Courses coursesListNewCourses : coursesListNew) {
                if (!coursesListOld.contains(coursesListNewCourses)) {
                    Categories oldLeafCategoryIdOfCoursesListNewCourses = coursesListNewCourses.getLeafCategoryId();
                    coursesListNewCourses.setLeafCategoryId(categories);
                    coursesListNewCourses = em.merge(coursesListNewCourses);
                    if (oldLeafCategoryIdOfCoursesListNewCourses != null && !oldLeafCategoryIdOfCoursesListNewCourses.equals(categories)) {
                        oldLeafCategoryIdOfCoursesListNewCourses.getCoursesList().remove(coursesListNewCourses);
                        oldLeafCategoryIdOfCoursesListNewCourses = em.merge(oldLeafCategoryIdOfCoursesListNewCourses);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = categories.getId();
                if (findCategories(id) == null) {
                    throw new NonexistentEntityException("The categories with id " + id + " no longer exists.");
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
            Categories categories;
            try {
                categories = em.getReference(Categories.class, id);
                categories.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The categories with id " + id + " no longer exists.", enfe);
            }
            List<String> illegalOrphanMessages = null;
            List<Courses> coursesListOrphanCheck = categories.getCoursesList();
            for (Courses coursesListOrphanCheckCourses : coursesListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Categories (" + categories + ") cannot be destroyed since the Courses " + coursesListOrphanCheckCourses + " in its coursesList field has a non-nullable leafCategoryId field.");
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            em.remove(categories);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Categories> findCategoriesEntities() {
        return findCategoriesEntities(true, -1, -1);
    }

    public List<Categories> findCategoriesEntities(int maxResults, int firstResult) {
        return findCategoriesEntities(false, maxResults, firstResult);
    }

    private List<Categories> findCategoriesEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Categories.class));
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

    public Categories findCategories(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Categories.class, id);
        } finally {
            em.close();
        }
    }

    public int getCategoriesCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Categories> rt = cq.from(Categories.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
