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
import model.Sections;
import model.Users;
import model.McqQuestions;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.Assignments;
import model.Submissions;

/**
 *
 * @author LP
 */
public class AssignmentsJpaController implements Serializable {

    public AssignmentsJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Assignments assignments) throws PreexistingEntityException, Exception {
        if (assignments.getMcqQuestionsList() == null) {
            assignments.setMcqQuestionsList(new ArrayList<McqQuestions>());
        }
        if (assignments.getSubmissionsList() == null) {
            assignments.setSubmissionsList(new ArrayList<Submissions>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Sections sectionId = assignments.getSectionId();
            if (sectionId != null) {
                sectionId = em.getReference(sectionId.getClass(), sectionId.getId());
                assignments.setSectionId(sectionId);
            }
            Users creatorId = assignments.getCreatorId();
            if (creatorId != null) {
                creatorId = em.getReference(creatorId.getClass(), creatorId.getId());
                assignments.setCreatorId(creatorId);
            }
            List<McqQuestions> attachedMcqQuestionsList = new ArrayList<McqQuestions>();
            for (McqQuestions mcqQuestionsListMcqQuestionsToAttach : assignments.getMcqQuestionsList()) {
                mcqQuestionsListMcqQuestionsToAttach = em.getReference(mcqQuestionsListMcqQuestionsToAttach.getClass(), mcqQuestionsListMcqQuestionsToAttach.getId());
                attachedMcqQuestionsList.add(mcqQuestionsListMcqQuestionsToAttach);
            }
            assignments.setMcqQuestionsList(attachedMcqQuestionsList);
            List<Submissions> attachedSubmissionsList = new ArrayList<Submissions>();
            for (Submissions submissionsListSubmissionsToAttach : assignments.getSubmissionsList()) {
                submissionsListSubmissionsToAttach = em.getReference(submissionsListSubmissionsToAttach.getClass(), submissionsListSubmissionsToAttach.getId());
                attachedSubmissionsList.add(submissionsListSubmissionsToAttach);
            }
            assignments.setSubmissionsList(attachedSubmissionsList);
            em.persist(assignments);
            if (sectionId != null) {
                sectionId.getAssignmentsList().add(assignments);
                sectionId = em.merge(sectionId);
            }
            if (creatorId != null) {
                creatorId.getAssignmentsList().add(assignments);
                creatorId = em.merge(creatorId);
            }
            for (McqQuestions mcqQuestionsListMcqQuestions : assignments.getMcqQuestionsList()) {
                Assignments oldAssignmentIdOfMcqQuestionsListMcqQuestions = mcqQuestionsListMcqQuestions.getAssignmentId();
                mcqQuestionsListMcqQuestions.setAssignmentId(assignments);
                mcqQuestionsListMcqQuestions = em.merge(mcqQuestionsListMcqQuestions);
                if (oldAssignmentIdOfMcqQuestionsListMcqQuestions != null) {
                    oldAssignmentIdOfMcqQuestionsListMcqQuestions.getMcqQuestionsList().remove(mcqQuestionsListMcqQuestions);
                    oldAssignmentIdOfMcqQuestionsListMcqQuestions = em.merge(oldAssignmentIdOfMcqQuestionsListMcqQuestions);
                }
            }
            for (Submissions submissionsListSubmissions : assignments.getSubmissionsList()) {
                Assignments oldAssignmentIdOfSubmissionsListSubmissions = submissionsListSubmissions.getAssignmentId();
                submissionsListSubmissions.setAssignmentId(assignments);
                submissionsListSubmissions = em.merge(submissionsListSubmissions);
                if (oldAssignmentIdOfSubmissionsListSubmissions != null) {
                    oldAssignmentIdOfSubmissionsListSubmissions.getSubmissionsList().remove(submissionsListSubmissions);
                    oldAssignmentIdOfSubmissionsListSubmissions = em.merge(oldAssignmentIdOfSubmissionsListSubmissions);
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findAssignments(assignments.getId()) != null) {
                throw new PreexistingEntityException("Assignments " + assignments + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Assignments assignments) throws IllegalOrphanException, NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Assignments persistentAssignments = em.find(Assignments.class, assignments.getId());
            Sections sectionIdOld = persistentAssignments.getSectionId();
            Sections sectionIdNew = assignments.getSectionId();
            Users creatorIdOld = persistentAssignments.getCreatorId();
            Users creatorIdNew = assignments.getCreatorId();
            List<McqQuestions> mcqQuestionsListOld = persistentAssignments.getMcqQuestionsList();
            List<McqQuestions> mcqQuestionsListNew = assignments.getMcqQuestionsList();
            List<Submissions> submissionsListOld = persistentAssignments.getSubmissionsList();
            List<Submissions> submissionsListNew = assignments.getSubmissionsList();
            List<String> illegalOrphanMessages = null;
            for (McqQuestions mcqQuestionsListOldMcqQuestions : mcqQuestionsListOld) {
                if (!mcqQuestionsListNew.contains(mcqQuestionsListOldMcqQuestions)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain McqQuestions " + mcqQuestionsListOldMcqQuestions + " since its assignmentId field is not nullable.");
                }
            }
            for (Submissions submissionsListOldSubmissions : submissionsListOld) {
                if (!submissionsListNew.contains(submissionsListOldSubmissions)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Submissions " + submissionsListOldSubmissions + " since its assignmentId field is not nullable.");
                }
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            if (sectionIdNew != null) {
                sectionIdNew = em.getReference(sectionIdNew.getClass(), sectionIdNew.getId());
                assignments.setSectionId(sectionIdNew);
            }
            if (creatorIdNew != null) {
                creatorIdNew = em.getReference(creatorIdNew.getClass(), creatorIdNew.getId());
                assignments.setCreatorId(creatorIdNew);
            }
            List<McqQuestions> attachedMcqQuestionsListNew = new ArrayList<McqQuestions>();
            for (McqQuestions mcqQuestionsListNewMcqQuestionsToAttach : mcqQuestionsListNew) {
                mcqQuestionsListNewMcqQuestionsToAttach = em.getReference(mcqQuestionsListNewMcqQuestionsToAttach.getClass(), mcqQuestionsListNewMcqQuestionsToAttach.getId());
                attachedMcqQuestionsListNew.add(mcqQuestionsListNewMcqQuestionsToAttach);
            }
            mcqQuestionsListNew = attachedMcqQuestionsListNew;
            assignments.setMcqQuestionsList(mcqQuestionsListNew);
            List<Submissions> attachedSubmissionsListNew = new ArrayList<Submissions>();
            for (Submissions submissionsListNewSubmissionsToAttach : submissionsListNew) {
                submissionsListNewSubmissionsToAttach = em.getReference(submissionsListNewSubmissionsToAttach.getClass(), submissionsListNewSubmissionsToAttach.getId());
                attachedSubmissionsListNew.add(submissionsListNewSubmissionsToAttach);
            }
            submissionsListNew = attachedSubmissionsListNew;
            assignments.setSubmissionsList(submissionsListNew);
            assignments = em.merge(assignments);
            if (sectionIdOld != null && !sectionIdOld.equals(sectionIdNew)) {
                sectionIdOld.getAssignmentsList().remove(assignments);
                sectionIdOld = em.merge(sectionIdOld);
            }
            if (sectionIdNew != null && !sectionIdNew.equals(sectionIdOld)) {
                sectionIdNew.getAssignmentsList().add(assignments);
                sectionIdNew = em.merge(sectionIdNew);
            }
            if (creatorIdOld != null && !creatorIdOld.equals(creatorIdNew)) {
                creatorIdOld.getAssignmentsList().remove(assignments);
                creatorIdOld = em.merge(creatorIdOld);
            }
            if (creatorIdNew != null && !creatorIdNew.equals(creatorIdOld)) {
                creatorIdNew.getAssignmentsList().add(assignments);
                creatorIdNew = em.merge(creatorIdNew);
            }
            for (McqQuestions mcqQuestionsListNewMcqQuestions : mcqQuestionsListNew) {
                if (!mcqQuestionsListOld.contains(mcqQuestionsListNewMcqQuestions)) {
                    Assignments oldAssignmentIdOfMcqQuestionsListNewMcqQuestions = mcqQuestionsListNewMcqQuestions.getAssignmentId();
                    mcqQuestionsListNewMcqQuestions.setAssignmentId(assignments);
                    mcqQuestionsListNewMcqQuestions = em.merge(mcqQuestionsListNewMcqQuestions);
                    if (oldAssignmentIdOfMcqQuestionsListNewMcqQuestions != null && !oldAssignmentIdOfMcqQuestionsListNewMcqQuestions.equals(assignments)) {
                        oldAssignmentIdOfMcqQuestionsListNewMcqQuestions.getMcqQuestionsList().remove(mcqQuestionsListNewMcqQuestions);
                        oldAssignmentIdOfMcqQuestionsListNewMcqQuestions = em.merge(oldAssignmentIdOfMcqQuestionsListNewMcqQuestions);
                    }
                }
            }
            for (Submissions submissionsListNewSubmissions : submissionsListNew) {
                if (!submissionsListOld.contains(submissionsListNewSubmissions)) {
                    Assignments oldAssignmentIdOfSubmissionsListNewSubmissions = submissionsListNewSubmissions.getAssignmentId();
                    submissionsListNewSubmissions.setAssignmentId(assignments);
                    submissionsListNewSubmissions = em.merge(submissionsListNewSubmissions);
                    if (oldAssignmentIdOfSubmissionsListNewSubmissions != null && !oldAssignmentIdOfSubmissionsListNewSubmissions.equals(assignments)) {
                        oldAssignmentIdOfSubmissionsListNewSubmissions.getSubmissionsList().remove(submissionsListNewSubmissions);
                        oldAssignmentIdOfSubmissionsListNewSubmissions = em.merge(oldAssignmentIdOfSubmissionsListNewSubmissions);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = assignments.getId();
                if (findAssignments(id) == null) {
                    throw new NonexistentEntityException("The assignments with id " + id + " no longer exists.");
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
            Assignments assignments;
            try {
                assignments = em.getReference(Assignments.class, id);
                assignments.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The assignments with id " + id + " no longer exists.", enfe);
            }
            List<String> illegalOrphanMessages = null;
            List<McqQuestions> mcqQuestionsListOrphanCheck = assignments.getMcqQuestionsList();
            for (McqQuestions mcqQuestionsListOrphanCheckMcqQuestions : mcqQuestionsListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Assignments (" + assignments + ") cannot be destroyed since the McqQuestions " + mcqQuestionsListOrphanCheckMcqQuestions + " in its mcqQuestionsList field has a non-nullable assignmentId field.");
            }
            List<Submissions> submissionsListOrphanCheck = assignments.getSubmissionsList();
            for (Submissions submissionsListOrphanCheckSubmissions : submissionsListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Assignments (" + assignments + ") cannot be destroyed since the Submissions " + submissionsListOrphanCheckSubmissions + " in its submissionsList field has a non-nullable assignmentId field.");
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            Sections sectionId = assignments.getSectionId();
            if (sectionId != null) {
                sectionId.getAssignmentsList().remove(assignments);
                sectionId = em.merge(sectionId);
            }
            Users creatorId = assignments.getCreatorId();
            if (creatorId != null) {
                creatorId.getAssignmentsList().remove(assignments);
                creatorId = em.merge(creatorId);
            }
            em.remove(assignments);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Assignments> findAssignmentsEntities() {
        return findAssignmentsEntities(true, -1, -1);
    }

    public List<Assignments> findAssignmentsEntities(int maxResults, int firstResult) {
        return findAssignmentsEntities(false, maxResults, firstResult);
    }

    private List<Assignments> findAssignmentsEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Assignments.class));
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

    public Assignments findAssignments(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Assignments.class, id);
        } finally {
            em.close();
        }
    }

    public int getAssignmentsCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Assignments> rt = cq.from(Assignments.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
