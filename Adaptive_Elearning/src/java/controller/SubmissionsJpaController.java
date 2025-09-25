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
import model.Assignments;
import model.Users;
import model.McqChoices;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.Submissions;

/**
 *
 * @author LP
 */
public class SubmissionsJpaController implements Serializable {

    public SubmissionsJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Submissions submissions) throws PreexistingEntityException, Exception {
        if (submissions.getMcqChoicesList() == null) {
            submissions.setMcqChoicesList(new ArrayList<McqChoices>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Assignments assignmentId = submissions.getAssignmentId();
            if (assignmentId != null) {
                assignmentId = em.getReference(assignmentId.getClass(), assignmentId.getId());
                submissions.setAssignmentId(assignmentId);
            }
            Users creatorId = submissions.getCreatorId();
            if (creatorId != null) {
                creatorId = em.getReference(creatorId.getClass(), creatorId.getId());
                submissions.setCreatorId(creatorId);
            }
            List<McqChoices> attachedMcqChoicesList = new ArrayList<McqChoices>();
            for (McqChoices mcqChoicesListMcqChoicesToAttach : submissions.getMcqChoicesList()) {
                mcqChoicesListMcqChoicesToAttach = em.getReference(mcqChoicesListMcqChoicesToAttach.getClass(), mcqChoicesListMcqChoicesToAttach.getId());
                attachedMcqChoicesList.add(mcqChoicesListMcqChoicesToAttach);
            }
            submissions.setMcqChoicesList(attachedMcqChoicesList);
            em.persist(submissions);
            if (assignmentId != null) {
                assignmentId.getSubmissionsList().add(submissions);
                assignmentId = em.merge(assignmentId);
            }
            if (creatorId != null) {
                creatorId.getSubmissionsList().add(submissions);
                creatorId = em.merge(creatorId);
            }
            for (McqChoices mcqChoicesListMcqChoices : submissions.getMcqChoicesList()) {
                mcqChoicesListMcqChoices.getSubmissionsList().add(submissions);
                mcqChoicesListMcqChoices = em.merge(mcqChoicesListMcqChoices);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findSubmissions(submissions.getId()) != null) {
                throw new PreexistingEntityException("Submissions " + submissions + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Submissions submissions) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Submissions persistentSubmissions = em.find(Submissions.class, submissions.getId());
            Assignments assignmentIdOld = persistentSubmissions.getAssignmentId();
            Assignments assignmentIdNew = submissions.getAssignmentId();
            Users creatorIdOld = persistentSubmissions.getCreatorId();
            Users creatorIdNew = submissions.getCreatorId();
            List<McqChoices> mcqChoicesListOld = persistentSubmissions.getMcqChoicesList();
            List<McqChoices> mcqChoicesListNew = submissions.getMcqChoicesList();
            if (assignmentIdNew != null) {
                assignmentIdNew = em.getReference(assignmentIdNew.getClass(), assignmentIdNew.getId());
                submissions.setAssignmentId(assignmentIdNew);
            }
            if (creatorIdNew != null) {
                creatorIdNew = em.getReference(creatorIdNew.getClass(), creatorIdNew.getId());
                submissions.setCreatorId(creatorIdNew);
            }
            List<McqChoices> attachedMcqChoicesListNew = new ArrayList<McqChoices>();
            for (McqChoices mcqChoicesListNewMcqChoicesToAttach : mcqChoicesListNew) {
                mcqChoicesListNewMcqChoicesToAttach = em.getReference(mcqChoicesListNewMcqChoicesToAttach.getClass(), mcqChoicesListNewMcqChoicesToAttach.getId());
                attachedMcqChoicesListNew.add(mcqChoicesListNewMcqChoicesToAttach);
            }
            mcqChoicesListNew = attachedMcqChoicesListNew;
            submissions.setMcqChoicesList(mcqChoicesListNew);
            submissions = em.merge(submissions);
            if (assignmentIdOld != null && !assignmentIdOld.equals(assignmentIdNew)) {
                assignmentIdOld.getSubmissionsList().remove(submissions);
                assignmentIdOld = em.merge(assignmentIdOld);
            }
            if (assignmentIdNew != null && !assignmentIdNew.equals(assignmentIdOld)) {
                assignmentIdNew.getSubmissionsList().add(submissions);
                assignmentIdNew = em.merge(assignmentIdNew);
            }
            if (creatorIdOld != null && !creatorIdOld.equals(creatorIdNew)) {
                creatorIdOld.getSubmissionsList().remove(submissions);
                creatorIdOld = em.merge(creatorIdOld);
            }
            if (creatorIdNew != null && !creatorIdNew.equals(creatorIdOld)) {
                creatorIdNew.getSubmissionsList().add(submissions);
                creatorIdNew = em.merge(creatorIdNew);
            }
            for (McqChoices mcqChoicesListOldMcqChoices : mcqChoicesListOld) {
                if (!mcqChoicesListNew.contains(mcqChoicesListOldMcqChoices)) {
                    mcqChoicesListOldMcqChoices.getSubmissionsList().remove(submissions);
                    mcqChoicesListOldMcqChoices = em.merge(mcqChoicesListOldMcqChoices);
                }
            }
            for (McqChoices mcqChoicesListNewMcqChoices : mcqChoicesListNew) {
                if (!mcqChoicesListOld.contains(mcqChoicesListNewMcqChoices)) {
                    mcqChoicesListNewMcqChoices.getSubmissionsList().add(submissions);
                    mcqChoicesListNewMcqChoices = em.merge(mcqChoicesListNewMcqChoices);
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = submissions.getId();
                if (findSubmissions(id) == null) {
                    throw new NonexistentEntityException("The submissions with id " + id + " no longer exists.");
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
            Submissions submissions;
            try {
                submissions = em.getReference(Submissions.class, id);
                submissions.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The submissions with id " + id + " no longer exists.", enfe);
            }
            Assignments assignmentId = submissions.getAssignmentId();
            if (assignmentId != null) {
                assignmentId.getSubmissionsList().remove(submissions);
                assignmentId = em.merge(assignmentId);
            }
            Users creatorId = submissions.getCreatorId();
            if (creatorId != null) {
                creatorId.getSubmissionsList().remove(submissions);
                creatorId = em.merge(creatorId);
            }
            List<McqChoices> mcqChoicesList = submissions.getMcqChoicesList();
            for (McqChoices mcqChoicesListMcqChoices : mcqChoicesList) {
                mcqChoicesListMcqChoices.getSubmissionsList().remove(submissions);
                mcqChoicesListMcqChoices = em.merge(mcqChoicesListMcqChoices);
            }
            em.remove(submissions);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Submissions> findSubmissionsEntities() {
        return findSubmissionsEntities(true, -1, -1);
    }

    public List<Submissions> findSubmissionsEntities(int maxResults, int firstResult) {
        return findSubmissionsEntities(false, maxResults, firstResult);
    }

    private List<Submissions> findSubmissionsEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Submissions.class));
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

    public Submissions findSubmissions(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Submissions.class, id);
        } finally {
            em.close();
        }
    }

    public int getSubmissionsCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Submissions> rt = cq.from(Submissions.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
