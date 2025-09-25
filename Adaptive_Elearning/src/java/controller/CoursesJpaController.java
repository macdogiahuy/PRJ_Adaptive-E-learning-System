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
import model.Categories;
import model.Instructors;
import model.Users;
import model.CourseReviews;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.Sections;
import model.CourseMeta;
import model.Courses;
import model.Enrollments;

/**
 *
 * @author LP
 */
public class CoursesJpaController implements Serializable {

    public CoursesJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Courses courses) throws PreexistingEntityException, Exception {
        if (courses.getCourseReviewsList() == null) {
            courses.setCourseReviewsList(new ArrayList<CourseReviews>());
        }
        if (courses.getSectionsList() == null) {
            courses.setSectionsList(new ArrayList<Sections>());
        }
        if (courses.getCourseMetaList() == null) {
            courses.setCourseMetaList(new ArrayList<CourseMeta>());
        }
        if (courses.getEnrollmentsList() == null) {
            courses.setEnrollmentsList(new ArrayList<Enrollments>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Categories leafCategoryId = courses.getLeafCategoryId();
            if (leafCategoryId != null) {
                leafCategoryId = em.getReference(leafCategoryId.getClass(), leafCategoryId.getId());
                courses.setLeafCategoryId(leafCategoryId);
            }
            Instructors instructorId = courses.getInstructorId();
            if (instructorId != null) {
                instructorId = em.getReference(instructorId.getClass(), instructorId.getId());
                courses.setInstructorId(instructorId);
            }
            Users creatorId = courses.getCreatorId();
            if (creatorId != null) {
                creatorId = em.getReference(creatorId.getClass(), creatorId.getId());
                courses.setCreatorId(creatorId);
            }
            List<CourseReviews> attachedCourseReviewsList = new ArrayList<CourseReviews>();
            for (CourseReviews courseReviewsListCourseReviewsToAttach : courses.getCourseReviewsList()) {
                courseReviewsListCourseReviewsToAttach = em.getReference(courseReviewsListCourseReviewsToAttach.getClass(), courseReviewsListCourseReviewsToAttach.getId());
                attachedCourseReviewsList.add(courseReviewsListCourseReviewsToAttach);
            }
            courses.setCourseReviewsList(attachedCourseReviewsList);
            List<Sections> attachedSectionsList = new ArrayList<Sections>();
            for (Sections sectionsListSectionsToAttach : courses.getSectionsList()) {
                sectionsListSectionsToAttach = em.getReference(sectionsListSectionsToAttach.getClass(), sectionsListSectionsToAttach.getId());
                attachedSectionsList.add(sectionsListSectionsToAttach);
            }
            courses.setSectionsList(attachedSectionsList);
            List<CourseMeta> attachedCourseMetaList = new ArrayList<CourseMeta>();
            for (CourseMeta courseMetaListCourseMetaToAttach : courses.getCourseMetaList()) {
                courseMetaListCourseMetaToAttach = em.getReference(courseMetaListCourseMetaToAttach.getClass(), courseMetaListCourseMetaToAttach.getCourseMetaPK());
                attachedCourseMetaList.add(courseMetaListCourseMetaToAttach);
            }
            courses.setCourseMetaList(attachedCourseMetaList);
            List<Enrollments> attachedEnrollmentsList = new ArrayList<Enrollments>();
            for (Enrollments enrollmentsListEnrollmentsToAttach : courses.getEnrollmentsList()) {
                enrollmentsListEnrollmentsToAttach = em.getReference(enrollmentsListEnrollmentsToAttach.getClass(), enrollmentsListEnrollmentsToAttach.getEnrollmentsPK());
                attachedEnrollmentsList.add(enrollmentsListEnrollmentsToAttach);
            }
            courses.setEnrollmentsList(attachedEnrollmentsList);
            em.persist(courses);
            if (leafCategoryId != null) {
                leafCategoryId.getCoursesList().add(courses);
                leafCategoryId = em.merge(leafCategoryId);
            }
            if (instructorId != null) {
                instructorId.getCoursesList().add(courses);
                instructorId = em.merge(instructorId);
            }
            if (creatorId != null) {
                creatorId.getCoursesList().add(courses);
                creatorId = em.merge(creatorId);
            }
            for (CourseReviews courseReviewsListCourseReviews : courses.getCourseReviewsList()) {
                Courses oldCourseIdOfCourseReviewsListCourseReviews = courseReviewsListCourseReviews.getCourseId();
                courseReviewsListCourseReviews.setCourseId(courses);
                courseReviewsListCourseReviews = em.merge(courseReviewsListCourseReviews);
                if (oldCourseIdOfCourseReviewsListCourseReviews != null) {
                    oldCourseIdOfCourseReviewsListCourseReviews.getCourseReviewsList().remove(courseReviewsListCourseReviews);
                    oldCourseIdOfCourseReviewsListCourseReviews = em.merge(oldCourseIdOfCourseReviewsListCourseReviews);
                }
            }
            for (Sections sectionsListSections : courses.getSectionsList()) {
                Courses oldCourseIdOfSectionsListSections = sectionsListSections.getCourseId();
                sectionsListSections.setCourseId(courses);
                sectionsListSections = em.merge(sectionsListSections);
                if (oldCourseIdOfSectionsListSections != null) {
                    oldCourseIdOfSectionsListSections.getSectionsList().remove(sectionsListSections);
                    oldCourseIdOfSectionsListSections = em.merge(oldCourseIdOfSectionsListSections);
                }
            }
            for (CourseMeta courseMetaListCourseMeta : courses.getCourseMetaList()) {
                Courses oldCoursesOfCourseMetaListCourseMeta = courseMetaListCourseMeta.getCourses();
                courseMetaListCourseMeta.setCourses(courses);
                courseMetaListCourseMeta = em.merge(courseMetaListCourseMeta);
                if (oldCoursesOfCourseMetaListCourseMeta != null) {
                    oldCoursesOfCourseMetaListCourseMeta.getCourseMetaList().remove(courseMetaListCourseMeta);
                    oldCoursesOfCourseMetaListCourseMeta = em.merge(oldCoursesOfCourseMetaListCourseMeta);
                }
            }
            for (Enrollments enrollmentsListEnrollments : courses.getEnrollmentsList()) {
                Courses oldCoursesOfEnrollmentsListEnrollments = enrollmentsListEnrollments.getCourses();
                enrollmentsListEnrollments.setCourses(courses);
                enrollmentsListEnrollments = em.merge(enrollmentsListEnrollments);
                if (oldCoursesOfEnrollmentsListEnrollments != null) {
                    oldCoursesOfEnrollmentsListEnrollments.getEnrollmentsList().remove(enrollmentsListEnrollments);
                    oldCoursesOfEnrollmentsListEnrollments = em.merge(oldCoursesOfEnrollmentsListEnrollments);
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findCourses(courses.getId()) != null) {
                throw new PreexistingEntityException("Courses " + courses + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Courses courses) throws IllegalOrphanException, NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Courses persistentCourses = em.find(Courses.class, courses.getId());
            Categories leafCategoryIdOld = persistentCourses.getLeafCategoryId();
            Categories leafCategoryIdNew = courses.getLeafCategoryId();
            Instructors instructorIdOld = persistentCourses.getInstructorId();
            Instructors instructorIdNew = courses.getInstructorId();
            Users creatorIdOld = persistentCourses.getCreatorId();
            Users creatorIdNew = courses.getCreatorId();
            List<CourseReviews> courseReviewsListOld = persistentCourses.getCourseReviewsList();
            List<CourseReviews> courseReviewsListNew = courses.getCourseReviewsList();
            List<Sections> sectionsListOld = persistentCourses.getSectionsList();
            List<Sections> sectionsListNew = courses.getSectionsList();
            List<CourseMeta> courseMetaListOld = persistentCourses.getCourseMetaList();
            List<CourseMeta> courseMetaListNew = courses.getCourseMetaList();
            List<Enrollments> enrollmentsListOld = persistentCourses.getEnrollmentsList();
            List<Enrollments> enrollmentsListNew = courses.getEnrollmentsList();
            List<String> illegalOrphanMessages = null;
            for (CourseReviews courseReviewsListOldCourseReviews : courseReviewsListOld) {
                if (!courseReviewsListNew.contains(courseReviewsListOldCourseReviews)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain CourseReviews " + courseReviewsListOldCourseReviews + " since its courseId field is not nullable.");
                }
            }
            for (Sections sectionsListOldSections : sectionsListOld) {
                if (!sectionsListNew.contains(sectionsListOldSections)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Sections " + sectionsListOldSections + " since its courseId field is not nullable.");
                }
            }
            for (CourseMeta courseMetaListOldCourseMeta : courseMetaListOld) {
                if (!courseMetaListNew.contains(courseMetaListOldCourseMeta)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain CourseMeta " + courseMetaListOldCourseMeta + " since its courses field is not nullable.");
                }
            }
            for (Enrollments enrollmentsListOldEnrollments : enrollmentsListOld) {
                if (!enrollmentsListNew.contains(enrollmentsListOldEnrollments)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Enrollments " + enrollmentsListOldEnrollments + " since its courses field is not nullable.");
                }
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            if (leafCategoryIdNew != null) {
                leafCategoryIdNew = em.getReference(leafCategoryIdNew.getClass(), leafCategoryIdNew.getId());
                courses.setLeafCategoryId(leafCategoryIdNew);
            }
            if (instructorIdNew != null) {
                instructorIdNew = em.getReference(instructorIdNew.getClass(), instructorIdNew.getId());
                courses.setInstructorId(instructorIdNew);
            }
            if (creatorIdNew != null) {
                creatorIdNew = em.getReference(creatorIdNew.getClass(), creatorIdNew.getId());
                courses.setCreatorId(creatorIdNew);
            }
            List<CourseReviews> attachedCourseReviewsListNew = new ArrayList<CourseReviews>();
            for (CourseReviews courseReviewsListNewCourseReviewsToAttach : courseReviewsListNew) {
                courseReviewsListNewCourseReviewsToAttach = em.getReference(courseReviewsListNewCourseReviewsToAttach.getClass(), courseReviewsListNewCourseReviewsToAttach.getId());
                attachedCourseReviewsListNew.add(courseReviewsListNewCourseReviewsToAttach);
            }
            courseReviewsListNew = attachedCourseReviewsListNew;
            courses.setCourseReviewsList(courseReviewsListNew);
            List<Sections> attachedSectionsListNew = new ArrayList<Sections>();
            for (Sections sectionsListNewSectionsToAttach : sectionsListNew) {
                sectionsListNewSectionsToAttach = em.getReference(sectionsListNewSectionsToAttach.getClass(), sectionsListNewSectionsToAttach.getId());
                attachedSectionsListNew.add(sectionsListNewSectionsToAttach);
            }
            sectionsListNew = attachedSectionsListNew;
            courses.setSectionsList(sectionsListNew);
            List<CourseMeta> attachedCourseMetaListNew = new ArrayList<CourseMeta>();
            for (CourseMeta courseMetaListNewCourseMetaToAttach : courseMetaListNew) {
                courseMetaListNewCourseMetaToAttach = em.getReference(courseMetaListNewCourseMetaToAttach.getClass(), courseMetaListNewCourseMetaToAttach.getCourseMetaPK());
                attachedCourseMetaListNew.add(courseMetaListNewCourseMetaToAttach);
            }
            courseMetaListNew = attachedCourseMetaListNew;
            courses.setCourseMetaList(courseMetaListNew);
            List<Enrollments> attachedEnrollmentsListNew = new ArrayList<Enrollments>();
            for (Enrollments enrollmentsListNewEnrollmentsToAttach : enrollmentsListNew) {
                enrollmentsListNewEnrollmentsToAttach = em.getReference(enrollmentsListNewEnrollmentsToAttach.getClass(), enrollmentsListNewEnrollmentsToAttach.getEnrollmentsPK());
                attachedEnrollmentsListNew.add(enrollmentsListNewEnrollmentsToAttach);
            }
            enrollmentsListNew = attachedEnrollmentsListNew;
            courses.setEnrollmentsList(enrollmentsListNew);
            courses = em.merge(courses);
            if (leafCategoryIdOld != null && !leafCategoryIdOld.equals(leafCategoryIdNew)) {
                leafCategoryIdOld.getCoursesList().remove(courses);
                leafCategoryIdOld = em.merge(leafCategoryIdOld);
            }
            if (leafCategoryIdNew != null && !leafCategoryIdNew.equals(leafCategoryIdOld)) {
                leafCategoryIdNew.getCoursesList().add(courses);
                leafCategoryIdNew = em.merge(leafCategoryIdNew);
            }
            if (instructorIdOld != null && !instructorIdOld.equals(instructorIdNew)) {
                instructorIdOld.getCoursesList().remove(courses);
                instructorIdOld = em.merge(instructorIdOld);
            }
            if (instructorIdNew != null && !instructorIdNew.equals(instructorIdOld)) {
                instructorIdNew.getCoursesList().add(courses);
                instructorIdNew = em.merge(instructorIdNew);
            }
            if (creatorIdOld != null && !creatorIdOld.equals(creatorIdNew)) {
                creatorIdOld.getCoursesList().remove(courses);
                creatorIdOld = em.merge(creatorIdOld);
            }
            if (creatorIdNew != null && !creatorIdNew.equals(creatorIdOld)) {
                creatorIdNew.getCoursesList().add(courses);
                creatorIdNew = em.merge(creatorIdNew);
            }
            for (CourseReviews courseReviewsListNewCourseReviews : courseReviewsListNew) {
                if (!courseReviewsListOld.contains(courseReviewsListNewCourseReviews)) {
                    Courses oldCourseIdOfCourseReviewsListNewCourseReviews = courseReviewsListNewCourseReviews.getCourseId();
                    courseReviewsListNewCourseReviews.setCourseId(courses);
                    courseReviewsListNewCourseReviews = em.merge(courseReviewsListNewCourseReviews);
                    if (oldCourseIdOfCourseReviewsListNewCourseReviews != null && !oldCourseIdOfCourseReviewsListNewCourseReviews.equals(courses)) {
                        oldCourseIdOfCourseReviewsListNewCourseReviews.getCourseReviewsList().remove(courseReviewsListNewCourseReviews);
                        oldCourseIdOfCourseReviewsListNewCourseReviews = em.merge(oldCourseIdOfCourseReviewsListNewCourseReviews);
                    }
                }
            }
            for (Sections sectionsListNewSections : sectionsListNew) {
                if (!sectionsListOld.contains(sectionsListNewSections)) {
                    Courses oldCourseIdOfSectionsListNewSections = sectionsListNewSections.getCourseId();
                    sectionsListNewSections.setCourseId(courses);
                    sectionsListNewSections = em.merge(sectionsListNewSections);
                    if (oldCourseIdOfSectionsListNewSections != null && !oldCourseIdOfSectionsListNewSections.equals(courses)) {
                        oldCourseIdOfSectionsListNewSections.getSectionsList().remove(sectionsListNewSections);
                        oldCourseIdOfSectionsListNewSections = em.merge(oldCourseIdOfSectionsListNewSections);
                    }
                }
            }
            for (CourseMeta courseMetaListNewCourseMeta : courseMetaListNew) {
                if (!courseMetaListOld.contains(courseMetaListNewCourseMeta)) {
                    Courses oldCoursesOfCourseMetaListNewCourseMeta = courseMetaListNewCourseMeta.getCourses();
                    courseMetaListNewCourseMeta.setCourses(courses);
                    courseMetaListNewCourseMeta = em.merge(courseMetaListNewCourseMeta);
                    if (oldCoursesOfCourseMetaListNewCourseMeta != null && !oldCoursesOfCourseMetaListNewCourseMeta.equals(courses)) {
                        oldCoursesOfCourseMetaListNewCourseMeta.getCourseMetaList().remove(courseMetaListNewCourseMeta);
                        oldCoursesOfCourseMetaListNewCourseMeta = em.merge(oldCoursesOfCourseMetaListNewCourseMeta);
                    }
                }
            }
            for (Enrollments enrollmentsListNewEnrollments : enrollmentsListNew) {
                if (!enrollmentsListOld.contains(enrollmentsListNewEnrollments)) {
                    Courses oldCoursesOfEnrollmentsListNewEnrollments = enrollmentsListNewEnrollments.getCourses();
                    enrollmentsListNewEnrollments.setCourses(courses);
                    enrollmentsListNewEnrollments = em.merge(enrollmentsListNewEnrollments);
                    if (oldCoursesOfEnrollmentsListNewEnrollments != null && !oldCoursesOfEnrollmentsListNewEnrollments.equals(courses)) {
                        oldCoursesOfEnrollmentsListNewEnrollments.getEnrollmentsList().remove(enrollmentsListNewEnrollments);
                        oldCoursesOfEnrollmentsListNewEnrollments = em.merge(oldCoursesOfEnrollmentsListNewEnrollments);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = courses.getId();
                if (findCourses(id) == null) {
                    throw new NonexistentEntityException("The courses with id " + id + " no longer exists.");
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
            Courses courses;
            try {
                courses = em.getReference(Courses.class, id);
                courses.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The courses with id " + id + " no longer exists.", enfe);
            }
            List<String> illegalOrphanMessages = null;
            List<CourseReviews> courseReviewsListOrphanCheck = courses.getCourseReviewsList();
            for (CourseReviews courseReviewsListOrphanCheckCourseReviews : courseReviewsListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Courses (" + courses + ") cannot be destroyed since the CourseReviews " + courseReviewsListOrphanCheckCourseReviews + " in its courseReviewsList field has a non-nullable courseId field.");
            }
            List<Sections> sectionsListOrphanCheck = courses.getSectionsList();
            for (Sections sectionsListOrphanCheckSections : sectionsListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Courses (" + courses + ") cannot be destroyed since the Sections " + sectionsListOrphanCheckSections + " in its sectionsList field has a non-nullable courseId field.");
            }
            List<CourseMeta> courseMetaListOrphanCheck = courses.getCourseMetaList();
            for (CourseMeta courseMetaListOrphanCheckCourseMeta : courseMetaListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Courses (" + courses + ") cannot be destroyed since the CourseMeta " + courseMetaListOrphanCheckCourseMeta + " in its courseMetaList field has a non-nullable courses field.");
            }
            List<Enrollments> enrollmentsListOrphanCheck = courses.getEnrollmentsList();
            for (Enrollments enrollmentsListOrphanCheckEnrollments : enrollmentsListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Courses (" + courses + ") cannot be destroyed since the Enrollments " + enrollmentsListOrphanCheckEnrollments + " in its enrollmentsList field has a non-nullable courses field.");
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            Categories leafCategoryId = courses.getLeafCategoryId();
            if (leafCategoryId != null) {
                leafCategoryId.getCoursesList().remove(courses);
                leafCategoryId = em.merge(leafCategoryId);
            }
            Instructors instructorId = courses.getInstructorId();
            if (instructorId != null) {
                instructorId.getCoursesList().remove(courses);
                instructorId = em.merge(instructorId);
            }
            Users creatorId = courses.getCreatorId();
            if (creatorId != null) {
                creatorId.getCoursesList().remove(courses);
                creatorId = em.merge(creatorId);
            }
            em.remove(courses);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Courses> findCoursesEntities() {
        return findCoursesEntities(true, -1, -1);
    }

    public List<Courses> findCoursesEntities(int maxResults, int firstResult) {
        return findCoursesEntities(false, maxResults, firstResult);
    }

    private List<Courses> findCoursesEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Courses.class));
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

    public Courses findCourses(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Courses.class, id);
        } finally {
            em.close();
        }
    }

    public int getCoursesCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Courses> rt = cq.from(Courses.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
