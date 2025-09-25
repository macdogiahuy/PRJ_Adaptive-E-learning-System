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
import model.Assignments;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.Lectures;
import model.Sections;

/**
 *
 * @author LP
 */
public class SectionsJpaController implements Serializable {

    public SectionsJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Sections sections) throws PreexistingEntityException, Exception {
        if (sections.getAssignmentsList() == null) {
            sections.setAssignmentsList(new ArrayList<Assignments>());
        }
        if (sections.getLecturesList() == null) {
            sections.setLecturesList(new ArrayList<Lectures>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Courses courseId = sections.getCourseId();
            if (courseId != null) {
                courseId = em.getReference(courseId.getClass(), courseId.getId());
                sections.setCourseId(courseId);
            }
            List<Assignments> attachedAssignmentsList = new ArrayList<Assignments>();
            for (Assignments assignmentsListAssignmentsToAttach : sections.getAssignmentsList()) {
                assignmentsListAssignmentsToAttach = em.getReference(assignmentsListAssignmentsToAttach.getClass(), assignmentsListAssignmentsToAttach.getId());
                attachedAssignmentsList.add(assignmentsListAssignmentsToAttach);
            }
            sections.setAssignmentsList(attachedAssignmentsList);
            List<Lectures> attachedLecturesList = new ArrayList<Lectures>();
            for (Lectures lecturesListLecturesToAttach : sections.getLecturesList()) {
                lecturesListLecturesToAttach = em.getReference(lecturesListLecturesToAttach.getClass(), lecturesListLecturesToAttach.getId());
                attachedLecturesList.add(lecturesListLecturesToAttach);
            }
            sections.setLecturesList(attachedLecturesList);
            em.persist(sections);
            if (courseId != null) {
                courseId.getSectionsList().add(sections);
                courseId = em.merge(courseId);
            }
            for (Assignments assignmentsListAssignments : sections.getAssignmentsList()) {
                Sections oldSectionIdOfAssignmentsListAssignments = assignmentsListAssignments.getSectionId();
                assignmentsListAssignments.setSectionId(sections);
                assignmentsListAssignments = em.merge(assignmentsListAssignments);
                if (oldSectionIdOfAssignmentsListAssignments != null) {
                    oldSectionIdOfAssignmentsListAssignments.getAssignmentsList().remove(assignmentsListAssignments);
                    oldSectionIdOfAssignmentsListAssignments = em.merge(oldSectionIdOfAssignmentsListAssignments);
                }
            }
            for (Lectures lecturesListLectures : sections.getLecturesList()) {
                Sections oldSectionIdOfLecturesListLectures = lecturesListLectures.getSectionId();
                lecturesListLectures.setSectionId(sections);
                lecturesListLectures = em.merge(lecturesListLectures);
                if (oldSectionIdOfLecturesListLectures != null) {
                    oldSectionIdOfLecturesListLectures.getLecturesList().remove(lecturesListLectures);
                    oldSectionIdOfLecturesListLectures = em.merge(oldSectionIdOfLecturesListLectures);
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findSections(sections.getId()) != null) {
                throw new PreexistingEntityException("Sections " + sections + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Sections sections) throws IllegalOrphanException, NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Sections persistentSections = em.find(Sections.class, sections.getId());
            Courses courseIdOld = persistentSections.getCourseId();
            Courses courseIdNew = sections.getCourseId();
            List<Assignments> assignmentsListOld = persistentSections.getAssignmentsList();
            List<Assignments> assignmentsListNew = sections.getAssignmentsList();
            List<Lectures> lecturesListOld = persistentSections.getLecturesList();
            List<Lectures> lecturesListNew = sections.getLecturesList();
            List<String> illegalOrphanMessages = null;
            for (Assignments assignmentsListOldAssignments : assignmentsListOld) {
                if (!assignmentsListNew.contains(assignmentsListOldAssignments)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Assignments " + assignmentsListOldAssignments + " since its sectionId field is not nullable.");
                }
            }
            for (Lectures lecturesListOldLectures : lecturesListOld) {
                if (!lecturesListNew.contains(lecturesListOldLectures)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Lectures " + lecturesListOldLectures + " since its sectionId field is not nullable.");
                }
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            if (courseIdNew != null) {
                courseIdNew = em.getReference(courseIdNew.getClass(), courseIdNew.getId());
                sections.setCourseId(courseIdNew);
            }
            List<Assignments> attachedAssignmentsListNew = new ArrayList<Assignments>();
            for (Assignments assignmentsListNewAssignmentsToAttach : assignmentsListNew) {
                assignmentsListNewAssignmentsToAttach = em.getReference(assignmentsListNewAssignmentsToAttach.getClass(), assignmentsListNewAssignmentsToAttach.getId());
                attachedAssignmentsListNew.add(assignmentsListNewAssignmentsToAttach);
            }
            assignmentsListNew = attachedAssignmentsListNew;
            sections.setAssignmentsList(assignmentsListNew);
            List<Lectures> attachedLecturesListNew = new ArrayList<Lectures>();
            for (Lectures lecturesListNewLecturesToAttach : lecturesListNew) {
                lecturesListNewLecturesToAttach = em.getReference(lecturesListNewLecturesToAttach.getClass(), lecturesListNewLecturesToAttach.getId());
                attachedLecturesListNew.add(lecturesListNewLecturesToAttach);
            }
            lecturesListNew = attachedLecturesListNew;
            sections.setLecturesList(lecturesListNew);
            sections = em.merge(sections);
            if (courseIdOld != null && !courseIdOld.equals(courseIdNew)) {
                courseIdOld.getSectionsList().remove(sections);
                courseIdOld = em.merge(courseIdOld);
            }
            if (courseIdNew != null && !courseIdNew.equals(courseIdOld)) {
                courseIdNew.getSectionsList().add(sections);
                courseIdNew = em.merge(courseIdNew);
            }
            for (Assignments assignmentsListNewAssignments : assignmentsListNew) {
                if (!assignmentsListOld.contains(assignmentsListNewAssignments)) {
                    Sections oldSectionIdOfAssignmentsListNewAssignments = assignmentsListNewAssignments.getSectionId();
                    assignmentsListNewAssignments.setSectionId(sections);
                    assignmentsListNewAssignments = em.merge(assignmentsListNewAssignments);
                    if (oldSectionIdOfAssignmentsListNewAssignments != null && !oldSectionIdOfAssignmentsListNewAssignments.equals(sections)) {
                        oldSectionIdOfAssignmentsListNewAssignments.getAssignmentsList().remove(assignmentsListNewAssignments);
                        oldSectionIdOfAssignmentsListNewAssignments = em.merge(oldSectionIdOfAssignmentsListNewAssignments);
                    }
                }
            }
            for (Lectures lecturesListNewLectures : lecturesListNew) {
                if (!lecturesListOld.contains(lecturesListNewLectures)) {
                    Sections oldSectionIdOfLecturesListNewLectures = lecturesListNewLectures.getSectionId();
                    lecturesListNewLectures.setSectionId(sections);
                    lecturesListNewLectures = em.merge(lecturesListNewLectures);
                    if (oldSectionIdOfLecturesListNewLectures != null && !oldSectionIdOfLecturesListNewLectures.equals(sections)) {
                        oldSectionIdOfLecturesListNewLectures.getLecturesList().remove(lecturesListNewLectures);
                        oldSectionIdOfLecturesListNewLectures = em.merge(oldSectionIdOfLecturesListNewLectures);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = sections.getId();
                if (findSections(id) == null) {
                    throw new NonexistentEntityException("The sections with id " + id + " no longer exists.");
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
            Sections sections;
            try {
                sections = em.getReference(Sections.class, id);
                sections.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The sections with id " + id + " no longer exists.", enfe);
            }
            List<String> illegalOrphanMessages = null;
            List<Assignments> assignmentsListOrphanCheck = sections.getAssignmentsList();
            for (Assignments assignmentsListOrphanCheckAssignments : assignmentsListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Sections (" + sections + ") cannot be destroyed since the Assignments " + assignmentsListOrphanCheckAssignments + " in its assignmentsList field has a non-nullable sectionId field.");
            }
            List<Lectures> lecturesListOrphanCheck = sections.getLecturesList();
            for (Lectures lecturesListOrphanCheckLectures : lecturesListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Sections (" + sections + ") cannot be destroyed since the Lectures " + lecturesListOrphanCheckLectures + " in its lecturesList field has a non-nullable sectionId field.");
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            Courses courseId = sections.getCourseId();
            if (courseId != null) {
                courseId.getSectionsList().remove(sections);
                courseId = em.merge(courseId);
            }
            em.remove(sections);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Sections> findSectionsEntities() {
        return findSectionsEntities(true, -1, -1);
    }

    public List<Sections> findSectionsEntities(int maxResults, int firstResult) {
        return findSectionsEntities(false, maxResults, firstResult);
    }

    private List<Sections> findSectionsEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Sections.class));
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

    public Sections findSections(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Sections.class, id);
        } finally {
            em.close();
        }
    }

    public int getSectionsCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Sections> rt = cq.from(Sections.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
