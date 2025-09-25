/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import controller.exceptions.NonexistentEntityException;
import controller.exceptions.PreexistingEntityException;
import java.io.Serializable;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import model.McqQuestions;
import model.Submissions;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.McqChoices;

/**
 *
 * @author LP
 */
public class McqChoicesJpaController implements Serializable {

    public McqChoicesJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(McqChoices mcqChoices) throws PreexistingEntityException, Exception {
        if (mcqChoices.getSubmissionsList() == null) {
            mcqChoices.setSubmissionsList(new ArrayList<Submissions>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            McqQuestions mcqQuestionId = mcqChoices.getMcqQuestionId();
            if (mcqQuestionId != null) {
                mcqQuestionId = em.getReference(mcqQuestionId.getClass(), mcqQuestionId.getId());
                mcqChoices.setMcqQuestionId(mcqQuestionId);
            }
            List<Submissions> attachedSubmissionsList = new ArrayList<Submissions>();
            for (Submissions submissionsListSubmissionsToAttach : mcqChoices.getSubmissionsList()) {
                submissionsListSubmissionsToAttach = em.getReference(submissionsListSubmissionsToAttach.getClass(), submissionsListSubmissionsToAttach.getId());
                attachedSubmissionsList.add(submissionsListSubmissionsToAttach);
            }
            mcqChoices.setSubmissionsList(attachedSubmissionsList);
            em.persist(mcqChoices);
            if (mcqQuestionId != null) {
                mcqQuestionId.getMcqChoicesList().add(mcqChoices);
                mcqQuestionId = em.merge(mcqQuestionId);
            }
            for (Submissions submissionsListSubmissions : mcqChoices.getSubmissionsList()) {
                submissionsListSubmissions.getMcqChoicesList().add(mcqChoices);
                submissionsListSubmissions = em.merge(submissionsListSubmissions);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findMcqChoices(mcqChoices.getId()) != null) {
                throw new PreexistingEntityException("McqChoices " + mcqChoices + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(McqChoices mcqChoices) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            McqChoices persistentMcqChoices = em.find(McqChoices.class, mcqChoices.getId());
            McqQuestions mcqQuestionIdOld = persistentMcqChoices.getMcqQuestionId();
            McqQuestions mcqQuestionIdNew = mcqChoices.getMcqQuestionId();
            List<Submissions> submissionsListOld = persistentMcqChoices.getSubmissionsList();
            List<Submissions> submissionsListNew = mcqChoices.getSubmissionsList();
            if (mcqQuestionIdNew != null) {
                mcqQuestionIdNew = em.getReference(mcqQuestionIdNew.getClass(), mcqQuestionIdNew.getId());
                mcqChoices.setMcqQuestionId(mcqQuestionIdNew);
            }
            List<Submissions> attachedSubmissionsListNew = new ArrayList<Submissions>();
            for (Submissions submissionsListNewSubmissionsToAttach : submissionsListNew) {
                submissionsListNewSubmissionsToAttach = em.getReference(submissionsListNewSubmissionsToAttach.getClass(), submissionsListNewSubmissionsToAttach.getId());
                attachedSubmissionsListNew.add(submissionsListNewSubmissionsToAttach);
            }
            submissionsListNew = attachedSubmissionsListNew;
            mcqChoices.setSubmissionsList(submissionsListNew);
            mcqChoices = em.merge(mcqChoices);
            if (mcqQuestionIdOld != null && !mcqQuestionIdOld.equals(mcqQuestionIdNew)) {
                mcqQuestionIdOld.getMcqChoicesList().remove(mcqChoices);
                mcqQuestionIdOld = em.merge(mcqQuestionIdOld);
            }
            if (mcqQuestionIdNew != null && !mcqQuestionIdNew.equals(mcqQuestionIdOld)) {
                mcqQuestionIdNew.getMcqChoicesList().add(mcqChoices);
                mcqQuestionIdNew = em.merge(mcqQuestionIdNew);
            }
            for (Submissions submissionsListOldSubmissions : submissionsListOld) {
                if (!submissionsListNew.contains(submissionsListOldSubmissions)) {
                    submissionsListOldSubmissions.getMcqChoicesList().remove(mcqChoices);
                    submissionsListOldSubmissions = em.merge(submissionsListOldSubmissions);
                }
            }
            for (Submissions submissionsListNewSubmissions : submissionsListNew) {
                if (!submissionsListOld.contains(submissionsListNewSubmissions)) {
                    submissionsListNewSubmissions.getMcqChoicesList().add(mcqChoices);
                    submissionsListNewSubmissions = em.merge(submissionsListNewSubmissions);
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = mcqChoices.getId();
                if (findMcqChoices(id) == null) {
                    throw new NonexistentEntityException("The mcqChoices with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(String id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            McqChoices mcqChoices;
            try {
                mcqChoices = em.getReference(McqChoices.class, id);
                mcqChoices.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The mcqChoices with id " + id + " no longer exists.", enfe);
            }
            McqQuestions mcqQuestionId = mcqChoices.getMcqQuestionId();
            if (mcqQuestionId != null) {
                mcqQuestionId.getMcqChoicesList().remove(mcqChoices);
                mcqQuestionId = em.merge(mcqQuestionId);
            }
            List<Submissions> submissionsList = mcqChoices.getSubmissionsList();
            for (Submissions submissionsListSubmissions : submissionsList) {
                submissionsListSubmissions.getMcqChoicesList().remove(mcqChoices);
                submissionsListSubmissions = em.merge(submissionsListSubmissions);
            }
            em.remove(mcqChoices);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<McqChoices> findMcqChoicesEntities() {
        return findMcqChoicesEntities(true, -1, -1);
    }

    public List<McqChoices> findMcqChoicesEntities(int maxResults, int firstResult) {
        return findMcqChoicesEntities(false, maxResults, firstResult);
    }

    private List<McqChoices> findMcqChoicesEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(McqChoices.class));
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

    public McqChoices findMcqChoices(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(McqChoices.class, id);
        } finally {
            em.close();
        }
    }

    public int getMcqChoicesCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<McqChoices> rt = cq.from(McqChoices.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
